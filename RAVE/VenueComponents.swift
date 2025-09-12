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
    
    var body: some View {
        ZStack {
            // Pulsing Background
            Circle()
                .fill(Color.ravePurple.opacity(0.3))
                .frame(width: 60, height: 60)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            // Main Pin
            VStack(spacing: 2) {
                Text(venue.primaryEmoji)
                    .font(.title2)
                
                Text(venue.name.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .padding(8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.ravePurple, lineWidth: 2)
            )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct VenueCardView: View {
    let venue: Venue
    let onDismiss: () -> Void
    @State private var isJoining = false
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with dismiss button
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(venue.name)
                        .font(RAVEFont.headline)
                        .foregroundColor(.primary)
                    
                    Text(venue.location)
                        .font(RAVEFont.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .scaleOnTap()
            }
            
            // Vibe Emojis and Status
            HStack {
                // Vibe Emojis
                HStack(spacing: 4) {
                    ForEach(venue.vibeEmojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.title2)
                    }
                }
                
                Spacer()
                
                VibeBadge(status: venue.vibeStatus)
            }
            
            // Stats Row
            HStack(spacing: 20) {
                // Check-in Count
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                        .foregroundColor(.secondary)
                        .font(.callout)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(venue.checkInCount)")
                            .font(RAVEFont.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("checked in")
                            .font(RAVEFont.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Distance (if location available)
                if locationManager.isLocationEnabled {
                    HStack(spacing: 6) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.secondary)
                            .font(.callout)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(locationManager.formattedDistance(from: venue.coordinate))
                                .font(RAVEFont.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("away")
                                .font(RAVEFont.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                // Category Icon
                Image(systemName: venue.category.icon)
                    .font(.title2)
                    .foregroundColor(.ravePurple)
            }
            
            // Action Buttons
            HStack(spacing: 12) {
                // Join Party Group Button
                Button(action: joinPartyGroup) {
                    HStack(spacing: 8) {
                        if isJoining {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "person.2.badge.plus")
                                .font(.callout)
                        }
                        
                        Text(isJoining ? "Joining..." : "Join Party")
                            .font(RAVEFont.callout)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.ravePurple)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(isJoining)
                .scaleOnTap()
                
                // More Options Button
                Button(action: showVenueDetails) {
                    Image(systemName: "ellipsis")
                        .font(.callout)
                        .foregroundColor(.ravePurple)
                        .frame(width: 44, height: 44)
                        .background(Color.ravePurple.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .scaleOnTap()
            }
        }
        .padding(20)
        .background(Color.cardBackground.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.ravePurple.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
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
                .padding(.horizontal)
                
                // Map Section
                Map(coordinateRegion: .constant(
                    MKCoordinateRegion(
                        center: venue.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                ), annotationItems: [venue]) { venue in
                    MapPin(coordinate: venue.coordinate, tint: .ravePurple)
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                
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
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(venue.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.darkBackground.ignoresSafeArea())
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

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.ravePurple)
            
            Text(value)
                .font(RAVEFont.headline)
                .foregroundColor(.primary)
            
            Text(label)
                .font(RAVEFont.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .raveCard()
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
        .background(Color.darkBackground)
}

#Preview("Venue Card") {
    let venue = LocationManager.createMockVenues().first!
    VenueCardView(venue: venue) {}
        .preferredColorScheme(.dark)
        .background(Color.darkBackground)
        .padding()
}

#Preview("Venue Detail") {
    let venue = LocationManager.createMockVenues().first!
    NavigationStack {
        VenueDetailView(venue: venue)
    }
    .preferredColorScheme(.dark)
}