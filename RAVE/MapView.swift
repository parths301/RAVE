//
//  MapView.swift
//  RAVE - Material Design 3 Map View
//
//  Created by Claude on 12/09/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var isDrawerOpen = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Material Top App Bar
                MaterialTopAppBar(
                    title: "RAVE",
                    leadingAction: {
                        withAnimation(MaterialMotion.mediumSlide) {
                            isDrawerOpen = true
                        }
                    },
                    trailingActions: [
                        MaterialTopAppBar.MaterialAppBarAction(
                            icon: MaterialIcon.search,
                            action: {
                                // Search action
                            }
                        ),
                        MaterialTopAppBar.MaterialAppBarAction(
                            icon: MaterialIcon.more,
                            action: {
                                // More options action
                            }
                        )
                    ]
                )

                // Map Content
                MapViewContent()
            }
            .background(Color.materialSurface)

            // Material Navigation Drawer
            MaterialNavigationDrawerView(isOpen: $isDrawerOpen)
        }
    }
}

// Legacy component - now handled by MaterialTopAppBar

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
                        MaterialVenueAnnotation(venue: venue)
                            .onTapGesture {
                                withAnimation(MaterialMotion.quickFade) {
                                    selectedVenue = venue
                                    showVenueDetail = true
                                }
                            }
                    }
                }
            }
            .mapStyle(.standard)
            .ignoresSafeArea(edges: .bottom)

            // Material FAB for Location
            VStack {
                HStack {
                    Spacer()

                    MaterialFAB(
                        icon: MaterialIcon.location,
                        action: {
                            withAnimation(MaterialMotion.emphasized) {
                                locationManager.requestLocation()
                            }
                        },
                        size: .normal
                    )
                }
                .padding(.trailing, MaterialSpacing.screenPadding)

                Spacer()
            }
            .padding(.top, MaterialSpacing.lg)

            // Material Location Permission View
            if !locationManager.isLocationEnabled {
                MaterialLocationPermissionView(locationManager: locationManager)
            }

            // Material Venue Detail Sheet
            if let selectedVenue = selectedVenue {
                VStack {
                    Spacer()
                    MaterialVenueCardView(venue: selectedVenue) {
                        withAnimation(MaterialMotion.quickFade) {
                            self.selectedVenue = nil
                        }
                    }
                    .padding(.horizontal, MaterialSpacing.screenPadding)
                    .padding(.bottom, MaterialSpacing.screenPadding)
                }
                .background(
                    Color.materialScrim.opacity(0.32)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(MaterialMotion.quickFade) {
                                self.selectedVenue = nil
                            }
                        }
                )
            }
        }
        .background(Color.materialSurface)
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

// MARK: - Material Venue Annotation
struct MaterialVenueAnnotation: View {
    let venue: Venue

    var body: some View {
        VStack(spacing: MaterialSpacing.xs) {
            // Material Map Pin
            Image(systemName: venue.category.systemImage)
                .font(MaterialFont.labelLarge)
                .foregroundColor(.materialOnPrimary)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color.materialPrimary)
                )
                .overlay(
                    Circle()
                        .stroke(Color.materialOnPrimary.opacity(0.2), lineWidth: 2)
                )
                .materialElevation(2)

            // Material Venue Label
            Text(venue.name)
                .font(MaterialFont.labelMedium)
                .foregroundColor(.materialOnSurface)
                .padding(.horizontal, MaterialSpacing.sm)
                .padding(.vertical, MaterialSpacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: MaterialShape.small, style: .continuous)
                        .fill(Color.materialSurfaceContainerHigh)
                )
                .materialElevation(1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(venue.name), \(venue.category.rawValue)")
        .accessibilityHint("Tap to view venue details")
        .accessibilityAddTraits(.isButton)
    }
}

// Legacy alias for compatibility
typealias AppleVenueAnnotation = MaterialVenueAnnotation

// MARK: - Material Location Permission View
struct MaterialLocationPermissionView: View {
    let locationManager: LocationManager

    var body: some View {
        VStack {
            Spacer()

            MaterialCard(elevation: 3) {
                VStack(spacing: MaterialSpacing.xxl) {
                    Image(systemName: "location.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.materialOnSurfaceVariant)

                    VStack(spacing: MaterialSpacing.md) {
                        Text("Location Access Needed")
                            .font(MaterialFont.headlineSmall)
                            .foregroundColor(.materialOnSurface)
                            .multilineTextAlignment(.center)

                        Text("Enable location access to discover venues around you")
                            .font(MaterialFont.bodyMedium)
                            .foregroundColor(.materialOnSurfaceVariant)
                            .multilineTextAlignment(.center)
                    }

                    MaterialButton(
                        text: "Enable Location",
                        style: .filled
                    ) {
                        locationManager.requestLocationPermission()
                    }
                }
            }
            .padding(.horizontal, MaterialSpacing.screenPadding)

            Spacer()
        }
        .background(Color.materialScrim.opacity(0.32))
    }
}

// Legacy alias for compatibility
typealias AppleLocationPermissionView = MaterialLocationPermissionView

// MARK: - Material Venue Card
struct MaterialVenueCardView: View {
    let venue: Venue
    let onClose: () -> Void

    var body: some View {
        MaterialCard(elevation: 3) {
            VStack(alignment: .leading, spacing: MaterialSpacing.lg) {
                // Header with close button
                HStack {
                    VStack(alignment: .leading, spacing: MaterialSpacing.xs) {
                        Text(venue.name)
                            .font(MaterialFont.titleLarge)
                            .foregroundColor(.materialOnSurface)

                        Text(venue.location)
                            .font(MaterialFont.bodyMedium)
                            .foregroundColor(.materialOnSurfaceVariant)
                    }

                    Spacer()

                    Button(action: onClose) {
                        Image(systemName: MaterialIcon.close)
                            .font(MaterialFont.titleMedium)
                            .foregroundColor(.materialOnSurfaceVariant)
                    }
                    .materialStateLayer(color: .materialOnSurface)
                    .accessibilityLabel("Close venue details")
                    .accessibilityAddTraits(.isButton)
                }

                // Venue Details
                HStack(spacing: MaterialSpacing.xl) {
                    HStack(spacing: MaterialSpacing.xs) {
                        Image(systemName: MaterialIcon.group)
                            .font(MaterialFont.labelMedium)
                            .foregroundColor(.materialOnSurfaceVariant)
                        Text("\(venue.checkInCount)")
                            .font(MaterialFont.bodySmall)
                            .foregroundColor(.materialOnSurfaceVariant)
                    }

                    HStack(spacing: MaterialSpacing.xs) {
                        Image(systemName: venue.category.systemImage)
                            .font(MaterialFont.labelMedium)
                            .foregroundColor(.materialOnSurfaceVariant)
                        Text(venue.category.rawValue.capitalized)
                            .font(MaterialFont.bodySmall)
                            .foregroundColor(.materialOnSurfaceVariant)
                    }
                }

                // Action Buttons
                HStack(spacing: MaterialSpacing.md) {
                    MaterialButton(
                        text: "View Details",
                        style: .filled
                    ) {
                        // View details action
                    }

                    MaterialButton(
                        text: "Directions",
                        style: .outlined
                    ) {
                        // Directions action
                    }
                }
            }
        }
    }
}

// Legacy alias for compatibility
typealias AppleVenueCardView = MaterialVenueCardView

#Preview("Material Map View") {
    MapView()
        .preferredColorScheme(.dark)
}