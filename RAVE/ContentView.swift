//
//  ContentView.swift  
//  RAVE - Premium Nightlife Social Experience
//
//  Created by Parth Sharma on 12/09/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: RAVETab = .map
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                                showSplash = false
                            }
                        }
                    }
            } else {
                PremiumTabView(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Premium Tab System
enum RAVETab: String, CaseIterable {
    case map = "Map"
    case topClubs = "Top Clubs" 
    case crew = "Crew"
    case alerts = "Alerts"
    
    var icon: String {
        switch self {
        case .map: return "map.fill"
        case .topClubs: return "crown.fill"
        case .crew: return "person.3.fill"
        case .alerts: return "bell.fill"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .map: return "map.fill"
        case .topClubs: return "crown.fill"
        case .crew: return "person.3.fill"
        case .alerts: return "bell.fill"
        }
    }
}

struct PremiumTabView: View {
    @Binding var selectedTab: RAVETab
    @Namespace private var tabAnimation
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Background with Particles
                ZStack {
                    Color.deepBackground
                        .ignoresSafeArea()
                    
                    if PerformanceOptimizer.shouldShowParticles() {
                        ParticleView(
                            count: PerformanceOptimizer.particleCount(defaultCount: 30), 
                            color: .ravePurple.opacity(0.3)
                        )
                        .ignoresSafeArea()
                        .allowsHitTesting(false)
                    }
                }
                
                // Main Content
                Group {
                    switch selectedTab {
                    case .map:
                        MapViewContent()
                    case .topClubs:
                        TopClubsViewContent()
                    case .crew:
                        GroupsViewContent()
                    case .alerts:
                        AlertsView()
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                
                // Native Tab Bar
                NativeTabBar(selectedTab: $selectedTab, namespace: tabAnimation)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

struct NativeTabBar: View {
    @Binding var selectedTab: RAVETab
    let namespace: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(RAVETab.allCases, id: \.self) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    namespace: namespace
                ) {
                    withAnimation(PerformanceOptimizer.optimizedSpringAnimation(value: selectedTab)) {
                        selectedTab = tab
                    }
                    
                    // Optimized haptic feedback
                    if !PerformanceOptimizer.isVoiceOverRunning() {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                    }
                }
                .accessibleTabItem(tabName: tab.rawValue, isSelected: selectedTab == tab)
            }
        }
        .padding(.horizontal, 0)
        .padding(.vertical, 8)
        .background(.regularMaterial)
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct TabBarItem: View {
    let tab: RAVETab
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(isSelected ? .ravePurple : .white.opacity(0.6))
                .scaleEffect(isSelected ? 1.0 : 0.9)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .contentShape(Rectangle())
    }
}

// MARK: - Splash Screen
struct SplashScreen: View {
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0
    @State private var particleOpacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.deepBackground
                .ignoresSafeArea()
            
            if PerformanceOptimizer.shouldShowParticles() {
                ParticleView(
                    count: PerformanceOptimizer.particleCount(defaultCount: 50),
                    color: .ravePurple.opacity(0.4)
                )
                .opacity(particleOpacity)
                .optimizedAnimation(.easeInOut(duration: 1.5).delay(0.5), value: particleOpacity)
                .allowsHitTesting(false)
            }
            
            // Main Logo Only
            Text("RAVE")
                .font(.system(size: 72, weight: .black, design: .rounded))
                .foregroundColor(.ravePurple)
                .kerning(4.0)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .animation(.interactiveSpring(response: 1.2, dampingFraction: 0.6), value: logoScale)
                .animation(.easeInOut(duration: 1), value: logoOpacity)
        }
        .onAppear {
            logoScale = 1.0
            logoOpacity = 1.0
            particleOpacity = 1.0
        }
    }
}

#Preview {
    ContentView()
}
