//
//  MapView.swift
//  Venues - Social Venue Discovery
//
//  Created by Claude on 12/09/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        NavigationStack {
            MapViewContent()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HamburgerMenuButton()
                    }

                    ToolbarItem(placement: .principal) {
                        Text("RAVE")
                            .font(AppleFont.raveTitleHero)
                            .foregroundStyle(Color.neonPurple.gradient)
                            .kerning(-2)
                    }
                }
        }
    }
}

struct HamburgerMenuButton: View {
    @State private var showingMenu = false

    var body: some View {
        Button(action: { showingMenu = true }) {
            Image(systemName: "line.3.horizontal")
                .font(.title3)
                .foregroundStyle(Color.neonPurple)
        }
        .sheet(isPresented: $showingMenu) {
            HamburgerMenuView()
        }
    }
}

struct MapViewContent: View {
    @StateObject private var locationManager = LocationManager()
    @State private var venues: [Venue] = []
    @State private var selectedVenue: Venue?
    @State private var showVenueDetail = false

    var body: some View {
        ZStack {
            // Apple Standard Map
            Map(bounds: MapCameraBounds(centerCoordinateBounds: locationManager.region)) {
                UserAnnotation()

                ForEach(venues) { venue in
                    Annotation(venue.name, coordinate: venue.coordinate) {
                        AppleVenueAnnotation(venue: venue)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedVenue = venue
                                    showVenueDetail = true
                                }
                            }
                    }
                }
            }
            .mapStyle(.standard)
            .ignoresSafeArea(edges: .bottom)

            // Apple Location Button
            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            locationManager.requestLocation()
                        }
                    }) {
                        Image(systemName: "location")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.appPrimary)
                            .frame(width: 44, height: 44)
                            .background(Color.appSecondaryBackground)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.appSeparator, lineWidth: 0.5)
                            )
                    }
                    .appleAccessibility(
                        label: "Center map on current location",
                        traits: .isButton
                    )
                }
                .padding(.trailing, AppleSpacing.standardPadding)

                Spacer()
            }
            .padding(.top, AppleSpacing.standardPadding + 16)

            // Apple Location Permission View
            if !locationManager.isLocationEnabled {
                AppleLocationPermissionView(locationManager: locationManager)
            }

            // Apple Venue Detail Sheet
            if let selectedVenue = selectedVenue {
                VStack {
                    Spacer()
                    AppleVenueCardView(venue: selectedVenue) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.selectedVenue = nil
                        }
                    }
                    .padding(.horizontal, AppleSpacing.standardPadding)
                    .padding(.bottom, AppleSpacing.standardPadding)
                }
                .background(
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.selectedVenue = nil
                            }
                        }
                )
            }
        }
        .background(Color.appBackground)
        .preferredColorScheme(.dark)
        .onAppear {
            setupMockData()
            locationManager.requestLocationPermission()
        }
    }

    private func setupMockData() {
        venues = LocationManager.createMockVenues()
    }
}

// MARK: - Apple-Compliant Venue Annotation
struct AppleVenueAnnotation: View {
    let venue: Venue

    var body: some View {
        VStack(spacing: AppleSpacing.xs) {
            // Apple Standard Map Pin
            Image(systemName: venue.category.systemImage)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(Color.appPrimary)
                .cornerRadius(16)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )

            // Venue Name
            Text(venue.name)
                .font(AppleFont.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .padding(.horizontal, AppleSpacing.small)
                .padding(.vertical, AppleSpacing.xs)
                .background(Color.appSecondaryBackground)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.appSeparator, lineWidth: 0.5)
                )
        }
        .appleAccessibility(
            label: "\(venue.name), \(venue.category.rawValue)",
            hint: "Tap to view venue details",
            traits: .isButton
        )
    }
}

// MARK: - Apple Location Permission View
struct AppleLocationPermissionView: View {
    let locationManager: LocationManager

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: AppleSpacing.large) {
                Image(systemName: "location.slash")
                    .font(.system(size: 48))
                    .foregroundColor(.appSecondary)

                VStack(spacing: AppleSpacing.small) {
                    Text("Location Access Needed")
                        .font(AppleFont.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text("Enable location access to discover venues around you")
                        .font(AppleFont.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Button("Enable Location") {
                    locationManager.requestLocationPermission()
                }
                .applePrimaryButton()
            }
            .padding(AppleSpacing.modalPadding)
            .background(Color.appSecondaryBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.appSeparator, lineWidth: 0.5)
            )
            .padding(.horizontal, AppleSpacing.standardPadding)

            Spacer()
        }
        .background(Color.black.opacity(0.3))
    }
}

// MARK: - Apple Venue Card
struct AppleVenueCardView: View {
    let venue: Venue
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppleSpacing.medium) {
            // Header with close button
            HStack {
                VStack(alignment: .leading, spacing: AppleSpacing.xs) {
                    Text(venue.name)
                        .font(AppleFont.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(venue.location)
                        .font(AppleFont.body)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.appSecondary)
                }
                .appleAccessibility(label: "Close venue details", traits: .isButton)
            }

            // Venue Details
            HStack(spacing: AppleSpacing.large) {
                HStack(spacing: AppleSpacing.xs) {
                    Image(systemName: "person.2")
                        .font(.caption)
                        .foregroundColor(.appSecondary)
                    Text("\(venue.checkInCount)")
                        .font(AppleFont.footnote)
                        .foregroundColor(.secondary)
                }

                HStack(spacing: AppleSpacing.xs) {
                    Image(systemName: venue.category.systemImage)
                        .font(.caption)
                        .foregroundColor(.appSecondary)
                    Text(venue.category.rawValue.capitalized)
                        .font(AppleFont.footnote)
                        .foregroundColor(.secondary)
                }
            }

            // Action Buttons
            HStack(spacing: AppleSpacing.medium) {
                Button("View Details") {
                    // View details action
                }
                .applePrimaryButton()

                Button("Get Directions") {
                    // Directions action
                }
                .appleSecondaryButton()
            }
        }
        .padding(AppleSpacing.standardPadding)
        .background(Color.appSecondaryBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.appSeparator, lineWidth: 0.5)
        )
    }
}

#Preview("Map View") {
    MapView()
        .preferredColorScheme(.dark)
}