//
//  MapView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var venues: [Venue] = []
    @State private var selectedVenue: Venue?
    @State private var showVenueDetail = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MapKit Integration
                Map(coordinateRegion: $locationManager.region, 
                    showsUserLocation: true,
                    annotationItems: venues) { venue in
                    MapAnnotation(coordinate: venue.coordinate) {
                        VenueAnnotation(venue: venue)
                            .onTapGesture {
                                selectedVenue = venue
                                showVenueDetail = true
                            }
                    }
                }
                .mapStyle(.standard(emphasis: .muted))
                .preferredColorScheme(.dark)
                .ignoresSafeArea(edges: .bottom)
                
                // Location Permission Overlay
                if !locationManager.isLocationEnabled {
                    VStack {
                        Spacer()
                        LocationPermissionView(locationManager: locationManager)
                            .raveCard()
                            .padding()
                    }
                }
                
                // Bottom Sheet for Selected Venue
                if let selectedVenue = selectedVenue {
                    VStack {
                        Spacer()
                        VenueCardView(venue: selectedVenue) {
                            self.selectedVenue = nil
                        }
                        .raveCard()
                        .padding()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .navigationTitle("RAVE")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        locationManager.requestLocation()
                    }) {
                        Image(systemName: "location")
                            .foregroundColor(.ravePurple)
                    }
                }
            }
        }
        .onAppear {
            setupMockData()
            locationManager.requestLocationPermission()
        }
    }
    
    private func setupMockData() {
        venues = LocationManager.createMockVenues()
    }
}

struct LocationPermissionView: View {
    let locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "location.slash")
                .font(.system(size: 48))
                .foregroundColor(.ravePurple)
            
            VStack(spacing: 8) {
                Text("Location Access Needed")
                    .font(RAVEFont.headline)
                    .foregroundColor(.primary)
                
                Text("Enable location access to discover venues near you")
                    .font(RAVEFont.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("Enable Location") {
                locationManager.requestLocationPermission()
            }
            .ravePrimaryButton()
        }
        .padding()
    }
}

#Preview {
    MapView()
        .preferredColorScheme(.dark)
}