//
//  MapView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        NavigationStack {
            MapViewContent()
        }
    }
}

struct MapViewContent: View {
    @StateObject private var locationManager = LocationManager()
    @State private var venues: [Venue] = []
    @State private var selectedVenue: Venue?
    @State private var showVenueDetail = false
    @State private var mapLoaded = false
    @State private var showLocationButton = false
    @State private var showSideMenu = false
    
    var body: some View {
            ZStack {
                // Premium Background Gradient
                Color.deepBackground
                    .ignoresSafeArea()
                
                // Ambient Particle Effects
                ParticleView(count: 20, color: .ravePurple.opacity(0.2))
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                // Enhanced MapKit Integration
                Map(bounds: MapCameraBounds(centerCoordinateBounds: locationManager.region)) {
                    UserAnnotation()
                    
                    ForEach(venues) { venue in
                        Annotation(venue.name, coordinate: venue.coordinate) {
                            VenueAnnotation(venue: venue)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        selectedVenue = venue
                                        showVenueDetail = true
                                    }
                                    
                                    // Premium haptic feedback
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                    impactFeedback.impactOccurred()
                                }
                        }
                    }
                }
                .mapStyle(.standard(emphasis: .muted))
                .preferredColorScheme(.dark)
                .clipShape(RoundedRectangle(cornerRadius: 0))
                .opacity(mapLoaded ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 1.0), value: mapLoaded)
                .ignoresSafeArea(edges: .bottom)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        mapLoaded = true
                    }
                }
                
                // Premium Location Button
                VStack {
                    HStack {
                        Spacer()
                        
                        if showLocationButton {
                            Button(action: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    locationManager.requestLocation()
                                }
                                
                                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                impactFeedback.impactOccurred()
                            }) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.ravePurple)
                                    .frame(width: 48, height: 48)
                                    .background(
                                        ZStack {
                                            Circle()
                                                .fill(.ultraThinMaterial)
                                            
                                            Circle()
                                                .fill(Color.ravePurple.opacity(0.1))
                                            
                                            Circle()
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [.white.opacity(0.4), .clear, Color.ravePurple.opacity(0.4)],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1
                                                )
                                        }
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                    .shadow(color: .ravePurple.opacity(0.3), radius: 15, x: 0, y: 8)
                            }
                            .scaleOnTap()
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                    
                    Spacer()
                }
                
                // Enhanced Location Permission Overlay
                if !locationManager.isLocationEnabled {
                    VStack {
                        Spacer()
                        LocationPermissionView(locationManager: locationManager)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding()
                    }
                }
                
                // Premium Bottom Sheet for Selected Venue
                if let selectedVenue = selectedVenue {
                    VStack {
                        Spacer()
                        VenueCardView(venue: selectedVenue) {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                self.selectedVenue = nil
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 34)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.95)),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                    }
                    .background(
                        // Subtle backdrop blur
                        Color.black.opacity(0.1)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                                    self.selectedVenue = nil
                                }
                            }
                    )
                }
                
                // Hamburger Menu in top left
                VStack {
                    HStack {
                        VStack {
                            HStack {
                                Button(action: {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        showSideMenu = true
                                    }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.ultraThinMaterial)
                                            .frame(width: 40, height: 40)

                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.white.opacity(0.3), lineWidth: 1)
                                            .frame(width: 40, height: 40)

                                        Image(systemName: "line.3.horizontal")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.ravePurple)
                                    }
                                }
                                .padding(.leading, 20)
                                Spacer()
                            }
                            .padding(.top, 50)
                            Spacer()
                        }
                    }

                    Spacer()
                }

                // Custom RAVE Title Overlay (Layer 1)
                VStack {
                    HStack {
                        Spacer()
                        Text("RAVE")
                            .font(.system(size: 46, weight: .medium, design: .rounded))
                            .foregroundColor(.ravePurple)
                            .kerning(4.0)
                        Spacer()
                    }
                    .padding(.top, 50)
                    Spacer()
                }
                .zIndex(50)

                // Side Menu Overlay (Layer 2 - Top Layer)
                if showSideMenu {
                    SideMenuView(isShowing: $showSideMenu)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
                        .zIndex(100)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .overlay(alignment: .top) {
                LinearGradient(
                    colors: [.black.opacity(0.8), .black.opacity(0.6), .black.opacity(0.4), .black.opacity(0.2), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                .ignoresSafeArea(edges: .top)
                .allowsHitTesting(false)
            }
        .onAppear {
            setupMockData()
            locationManager.requestLocationPermission()
            
            // Show location button after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    showLocationButton = true
                }
            }
        }
    }
    
    private func setupMockData() {
        venues = LocationManager.createMockVenues()
    }
}

struct LocationPermissionView: View {
    let locationManager: LocationManager
    @State private var iconPulse = false
    @State private var cardScale: CGFloat = 0.9
    
    var body: some View {
        VStack(spacing: 24) {
            // Premium Location Icon with Glow
            ZStack {
                // Pulsing background
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.ravePurple.opacity(0.4), .raveNeon.opacity(0.2), .clear],
                            center: .center,
                            startRadius: 5,
                            endRadius: 40
                        )
                    )
                    .frame(width: 80, height: 80)
                    .scaleEffect(iconPulse ? 1.2 : 1.0)
                    .opacity(iconPulse ? 0.6 : 0.9)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: iconPulse)
                
                // Main icon
                Image(systemName: "location.slash")
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundColor(.ravePurple)
                    .shadow(color: .ravePurple.opacity(0.8), radius: 8, x: 0, y: 0)
                    .shadow(color: .raveNeon.opacity(0.4), radius: 12, x: 0, y: 0)
                    .scaleEffect(iconPulse ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: iconPulse)
            }
            
            // Enhanced Text Content
            VStack(spacing: 12) {
                Text("Location Access Needed")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Enable location access to discover the hottest venues and connect with the nightlife scene around you")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .glassText()
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            
            // Premium Action Button
            Button(action: {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    locationManager.requestLocationPermission()
                }
                
                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                impactFeedback.impactOccurred()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .shadow(color: .white.opacity(0.8), radius: 2, x: 0, y: 0)
                    
                    Text("Enable Location")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.ravePurple, .ravePink.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white.opacity(0.15))
                        
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.6), .clear, .white.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    }
                )
                .foregroundColor(.white)
                .shadow(color: .ravePurple.opacity(0.4), radius: 15, x: 0, y: 8)
                .shadow(color: .ravePink.opacity(0.3), radius: 25, x: 0, y: 12)
            }
            .scaleOnTap()
        }
        .padding(32)
        .background(
            ZStack {
                // Main glassmorphism background
                RoundedRectangle(cornerRadius: 32)
                    .fill(.ultraThinMaterial)
                
                // Gradient overlay
                RoundedRectangle(cornerRadius: 32)
                    .fill(
                        LinearGradient(
                            colors: [
                                .ravePurple.opacity(0.12),
                                .raveNeon.opacity(0.08),
                                .ravePink.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Premium border
                RoundedRectangle(cornerRadius: 32)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.4),
                                .ravePurple.opacity(0.3),
                                .raveNeon.opacity(0.2),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
        )
        .scaleEffect(cardScale)
        .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 15)
        .shadow(color: .ravePurple.opacity(0.2), radius: 50, x: 0, y: 25)
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.7)) {
                cardScale = 1.0
                iconPulse = true
            }
        }
    }
}

// MARK: - Side Menu View
struct SideMenuView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background overlay
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isShowing = false
                    }
                }
            
            // Side menu panel
            VStack(alignment: .leading, spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                isShowing = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.top, 50)
                    
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.ravePurple.opacity(0.3))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.ravePurple)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("John Doe")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("@johndoe_rave")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                // Menu Items
                ScrollView {
                    LazyVStack(spacing: 0) {
                        MenuItemView(icon: "person.fill", title: "Profile", destination: AnyView(UserProfileView()))
                        MenuItemView(icon: "gearshape.fill", title: "Settings", destination: AnyView(SettingsView()))
                        MenuItemView(icon: "lock.fill", title: "Privacy", destination: AnyView(PrivacyView()))
                        MenuItemView(icon: "person.2.fill", title: "Friends", destination: AnyView(FriendsView()))
                        MenuItemView(icon: "chart.bar.fill", title: "Statistics", destination: AnyView(UserStatsView()))
                        MenuItemView(icon: "calendar.badge.clock", title: "Event History", destination: AnyView(EventHistoryView()))
                        MenuItemView(icon: "questionmark.circle.fill", title: "Help & Support", destination: AnyView(HelpView()))
                        MenuItemView(icon: "star.fill", title: "Premium", destination: AnyView(PremiumView()))
                        
                        Divider()
                            .background(.white.opacity(0.2))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                        
                        Button(action: {
                            // Share app functionality
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 20))
                                    .foregroundColor(.ravePurple)
                                    .frame(width: 24, height: 24)
                                
                                Text("Share App")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                        }
                        
                        Button(action: {
                            // Sign out functionality
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.red)
                                    .frame(width: 24, height: 24)
                                
                                Text("Sign Out")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.red)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                        }
                    }
                }
                
                Spacer()
            }
            .frame(width: 300)
            .background(
                ZStack {
                    Color.deepBackground
                    
                    // Glassmorphism overlay
                    Rectangle()
                        .fill(.regularMaterial.opacity(0.8))
                    
                    // Particle effects
                    if PerformanceOptimizer.shouldShowParticles() {
                        ParticleView(
                            count: PerformanceOptimizer.particleCount(defaultCount: 15), 
                            color: .ravePurple.opacity(0.2)
                        )
                        .allowsHitTesting(false)
                    }
                }
            )
            .ignoresSafeArea()
        }
    }
}

struct MenuItemView: View {
    let icon: String
    let title: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.ravePurple)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MapView()
        .preferredColorScheme(.dark)
}
