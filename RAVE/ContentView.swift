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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
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
    case groups = "Groups"
    case alerts = "Alerts"
    
    var icon: String {
        switch self {
        case .map: return "map.fill"
        case .topClubs: return "crown.fill"
        case .groups: return "person.3.fill"
        case .alerts: return "bell.fill"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .map: return "map.circle.fill"
        case .topClubs: return "crown.circle.fill"
        case .groups: return "person.3.circle.fill"
        case .alerts: return "bell.circle.fill"
        }
    }
}

struct PremiumTabView: View {
    @Binding var selectedTab: RAVETab
    @Namespace private var tabAnimation
    
    var body: some View {
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
                    MapView()
                case .topClubs:
                    TopClubsView()
                case .groups:
                    GroupsView()
                case .alerts:
                    AlertsView()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
            
            // Floating Tab Bar
            FloatingTabBar(selectedTab: $selectedTab, namespace: tabAnimation)
        }
    }
}

struct FloatingTabBar: View {
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
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.3), .clear, .white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: .ravePurple.opacity(0.2), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 32)
        .padding(.bottom, 34)
    }
}

struct TabBarItem: View {
    let tab: RAVETab
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.ravePurple)
                            .frame(width: 32, height: 32)
                            .matchedGeometryEffect(id: "selectedTab", in: namespace)
                            .shadow(color: .ravePurple.opacity(0.6), radius: 8, x: 0, y: 2)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .white.opacity(0.6))
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.7), value: isSelected)
                }
                
                Text(tab.rawValue)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.5))
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
        }
        .frame(maxWidth: .infinity)
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
            }
            
            VStack(spacing: 24) {
                // Main Logo
                Text("RAVE")
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .neonText()
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .animation(.interactiveSpring(response: 1.2, dampingFraction: 0.6), value: logoScale)
                    .animation(.easeInOut(duration: 1), value: logoOpacity)
                
                // Subtitle
                Text("Premium Nightlife Experience")
                    .font(RAVEFont.title2)
                    .glassText()
                    .opacity(logoOpacity)
                    .animation(.easeInOut(duration: 1).delay(0.3), value: logoOpacity)
                
                // Pulsing Loader
                PulsingLoader(color: .ravePurple)
                    .opacity(logoOpacity)
                    .animation(.easeInOut(duration: 1).delay(0.6), value: logoOpacity)
            }
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
