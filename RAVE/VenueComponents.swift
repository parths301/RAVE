//
//  VenueComponents.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI
import MapKit
import UIKit

struct VenueAnnotation: View {
    let venue: Venue
    @State private var isAnimating = false
    @State private var glowIntensity: Double = 0.5
    
    var body: some View {
        ZStack {
            // Outer Glow Ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [.ravePurple.opacity(0.8), .raveNeon.opacity(0.6), .ravePurple.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .frame(width: 70, height: 70)
                .scaleEffect(isAnimating ? 1.3 : 1.0)
                .opacity(isAnimating ? 0.3 : 0.8)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
            
            // Pulsing Aura
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.ravePurple.opacity(0.4), .raveNeon.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 5,
                        endRadius: 35
                    )
                )
                .frame(width: 60, height: 60)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .opacity(glowIntensity)
                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isAnimating)
            
            // Premium Glass Pin Container
            VStack(spacing: 3) {
                // Venue Emoji with Glow
                ZStack {
                    Text(venue.primaryEmoji)
                        .font(.title)
                        .shadow(color: .raveNeon.opacity(0.8), radius: 8, x: 0, y: 0)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isAnimating)
                }
                
                // Venue Name 
                Text(venue.name.uppercased())
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    // Card Background
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardBackground)
                    
                    // Frosted Glass Overlay
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial.opacity(0.8))
                    
                    // Simple Border
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                }
            )
            .shadow(color: .ravePurple.opacity(0.4), radius: 12, x: 0, y: 6)
            .shadow(color: .raveNeon.opacity(0.2), radius: 20, x: 0, y: 10)
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }
            // Randomize glow intensity for variety
            withAnimation(.easeInOut(duration: Double.random(in: 1.0...2.5)).repeatForever(autoreverses: true)) {
                glowIntensity = Double.random(in: 0.3...0.8)
            }
        }
    }
}

struct VenueCardView: View {
    let venue: Venue
    let onDismiss: () -> Void
    @State private var isJoining = false
    @State private var cardScale: CGFloat = 0.95
    @State private var glowOpacity: Double = 0.3
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Premium Header with Floating Dismiss
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    // Venue Name
                    Text(venue.name)
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    // Location with Glass Text Effect
                    Text(venue.location)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .glassText()
                }
                
                Spacer()
                
                // Floating Glass Dismiss Button
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        onDismiss()
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [.white.opacity(0.4), .clear],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            }
                        )
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .scaleOnTap()
            }
            
            // Vibe Section with Enhanced Glass Effects
            HStack {
                // Premium Vibe Emojis Container
                HStack(spacing: 8) {
                    ForEach(venue.vibeEmojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: 20))
                            .shadow(color: .raveNeon.opacity(0.6), radius: 4, x: 0, y: 0)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.3), .clear, .ravePurple.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
                .shadow(color: .ravePurple.opacity(0.2), radius: 8, x: 0, y: 4)
                
                Spacer()
                
                // Enhanced Vibe Badge
                VibeBadge(status: venue.vibeStatus)
            }
            
            // Premium Stats with Glass Cards
            HStack(spacing: 16) {
                // Check-in Stat
                StatGlassCard(
                    icon: "person.2.fill",
                    value: "\(venue.checkInCount)",
                    label: "checked in",
                    color: .raveNeon
                )
                
                // Distance Stat (if available)
                if locationManager.isLocationEnabled {
                    StatGlassCard(
                        icon: "location.fill",
                        value: locationManager.formattedDistance(from: venue.coordinate),
                        label: "away",
                        color: .ravePurple
                    )
                }
                
                Spacer()
                
                // Category with Enhanced Icon
                VStack(spacing: 4) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.ravePurple.opacity(0.3), .clear],
                                    center: .center,
                                    startRadius: 2,
                                    endRadius: 20
                                )
                            )
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: venue.category.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.ravePurple)
                            .shadow(color: .ravePurple.opacity(0.8), radius: 4, x: 0, y: 0)
                    }
                    
                    Text(venue.category.rawValue.uppercased())
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .glassText()
                }
            }
            
            // Premium Action Buttons
            HStack(spacing: 14) {
                // Join Party Button with Enhanced Glass Effect
                Button(action: joinPartyGroup) {
                    HStack(spacing: 10) {
                        if isJoining {
                            PulsingLoader(color: .white)
                                .frame(width: 16, height: 16)
                        } else {
                            Image(systemName: "person.2.badge.plus")
                                .font(.system(size: 16, weight: .semibold))
                                .shadow(color: .white.opacity(0.8), radius: 2, x: 0, y: 0)
                        }
                        
                        Text(isJoining ? "Joining..." : "Join Party")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        ZStack {
                            // Main gradient background
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [.ravePurple, .ravePink.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            // Glass overlay
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white.opacity(0.1))
                            
                            // Premium border
                            RoundedRectangle(cornerRadius: 16)
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
                    .shadow(color: .ravePurple.opacity(0.4), radius: 12, x: 0, y: 6)
                    .shadow(color: .ravePink.opacity(0.3), radius: 20, x: 0, y: 10)
                }
                .disabled(isJoining)
                .scaleOnTap()
                
                // More Options Button with Glass Effect
                Button(action: showVenueDetails) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.ravePurple)
                        .frame(width: 52, height: 52)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.ravePurple.opacity(0.1))
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.white.opacity(0.4), .clear, .ravePurple.opacity(0.4)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            }
                        )
                        .shadow(color: .ravePurple.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .scaleOnTap()
            }
        }
        .padding(24)
        .background(
            ZStack {
                // Card Background
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color.cardBackground)
                
                // Frosted Glass Overlay
                RoundedRectangle(cornerRadius: 28)
                    .fill(.regularMaterial.opacity(0.6))
                
                // Simple Border
                RoundedRectangle(cornerRadius: 28)
                    .stroke(.white.opacity(0.3), lineWidth: 1.5)
            }
        )
        .scaleEffect(cardScale)
        .shadow(color: .black.opacity(0.3), radius: 25, x: 0, y: 15)
        .shadow(color: .ravePurple.opacity(0.2), radius: 40, x: 0, y: 20)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                cardScale = 1.0
            }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                glowOpacity = 0.8
            }
        }
    }
    
    private func joinPartyGroup() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isJoining = true
        }
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isJoining = false
            }
            
            // Show success feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }
    }
    
    private func showVenueDetails() {
        // TODO: Navigate to venue detail view
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}

struct VenueDetailView: View {
    let venue: Venue
    @StateObject private var locationManager = LocationManager()
    @State private var showShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(venue.primaryEmoji)
                            .font(.system(size: 64))
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            VibeBadge(status: venue.vibeStatus)
                            
                            HStack(spacing: 4) {
                                ForEach(venue.vibeEmojis, id: \.self) { emoji in
                                    Text(emoji)
                                        .font(.title3)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(venue.name)
                            .font(RAVEFont.largeTitle)
                            .foregroundColor(.primary)
                        
                        Text(venue.location)
                            .font(RAVEFont.title2)
                            .foregroundColor(.secondary)
                        
                        if !venue.description.isEmpty {
                            Text(venue.description)
                                .font(RAVEFont.body)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                        }
                    }
                }
                .padding()
                .raveCard()
                
                // Stats Section
                HStack(spacing: 20) {
                    StatItem(
                        icon: "person.2.fill",
                        value: "\(venue.checkInCount)",
                        label: "Checked In"
                    )
                    
                    if locationManager.isLocationEnabled {
                        StatItem(
                            icon: "location.fill",
                            value: locationManager.formattedDistance(from: venue.coordinate),
                            label: "Distance"
                        )
                    }
                    
                    StatItem(
                        icon: venue.category.icon,
                        value: venue.category.rawValue,
                        label: "Category"
                    )
                    
                    StatItem(
                        icon: "dollarsign.circle.fill",
                        value: venue.priceRange.rawValue,
                        label: "Price"
                    )
                }
                .padding(.horizontal, 10)
                
                // Map Section
                Map(bounds: MapCameraBounds(
                    centerCoordinateBounds: MKCoordinateRegion(
                        center: venue.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )) {
                    Marker(venue.name, coordinate: venue.coordinate)
                        .tint(Color.ravePurple)
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 10)
                
                // Action Section
                VStack(spacing: 12) {
                    Button("Join Party Group") {
                        // TODO: Join party group
                    }
                    .ravePrimaryButton()
                    
                    HStack(spacing: 12) {
                        Button("Get Directions") {
                            openInMaps()
                        }
                        .raveSecondaryButton()
                        
                        Button("Share Venue") {
                            showShareSheet = true
                        }
                        .raveSecondaryButton()
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical)
        }
        .navigationTitle(venue.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(
            ZStack {
                Color.deepBackground.ignoresSafeArea()
                ParticleView(count: 25, color: .ravePurple.opacity(0.2))
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            }
        )
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [venue.name, venue.location])
        }
    }
    
    private func openInMaps() {
        let placemark = MKPlacemark(coordinate: venue.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = venue.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

// Legacy StatItem for backward compatibility
struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        PremiumStatCard(icon: icon, value: value, label: label, color: .ravePurple)
    }
}

// New Premium Stat Cards
struct StatGlassCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .shadow(color: color.opacity(0.6), radius: 2, x: 0, y: 0)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.3), .clear, color.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .shadow(color: color.opacity(0.2), radius: 6, x: 0, y: 3)
    }
}

struct PremiumStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon with Glow Effect
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color.opacity(0.3), .clear],
                            center: .center,
                            startRadius: 2,
                            endRadius: 25
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
                    .shadow(color: color.opacity(0.8), radius: 4, x: 0, y: 0)
            }
            
            // Value and Label
            VStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.3), radius: 1, x: 0, y: 0)
                
                Text(label.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.1), .clear, color.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.4), .clear, color.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        .shadow(color: color.opacity(0.1), radius: 15, x: 0, y: 8)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview("Venue Annotation") {
    let venue = LocationManager.createMockVenues().first!
    VenueAnnotation(venue: venue)
        .preferredColorScheme(.dark)
        .background(Color.deepBackground)
}

#Preview("Venue Card") {
    let venue = LocationManager.createMockVenues().first!
    VenueCardView(venue: venue) {}
        .preferredColorScheme(.dark)
        .background(Color.deepBackground)
        .padding()
}

#Preview("Venue Detail") {
    let venue = LocationManager.createMockVenues().first!
    NavigationStack {
        VenueDetailView(venue: venue)
    }
    .preferredColorScheme(.dark)
}