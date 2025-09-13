//
//  TopClubsView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct TopClubsView: View {
    var body: some View {
        NavigationStack {
            TopClubsViewContent()
        }
    }
}

struct TopClubsViewContent: View {
    @State private var searchText = ""
    @State private var selectedFilters: Set<VenueFilter> = [.all]
    @State private var venues: [Venue] = []
    @StateObject private var locationManager = LocationManager()
    
    var filteredVenues: [Venue] {
        var filtered = venues
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { venue in
                venue.name.localizedCaseInsensitiveContains(searchText) ||
                venue.location.localizedCaseInsensitiveContains(searchText) ||
                venue.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply category filters
        for filter in selectedFilters {
            switch filter {
            case .all:
                break // Show all venues
            case .nearby:
                if locationManager.isLocationEnabled {
                    filtered = filtered.filter { venue in
                        guard let distance = locationManager.distance(from: venue.coordinate) else { return false }
                        return distance < 1000 // Within 1km
                    }
                }
            case .popular:
                filtered = filtered.filter { $0.checkInCount > 30 }
            case .openNow:
                // For now, assume all venues are open (could add hours logic)
                break
            }
        }
        
        // Sort by popularity (check-in count)
        return filtered.sorted { $0.checkInCount > $1.checkInCount }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            SearchBar(text: $searchText)
            
            // Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(VenueFilter.allCases, id: \.self) { filter in
                        FilterChip(
                            filter: filter,
                            isSelected: selectedFilters.contains(filter)
                        ) {
                            toggleFilter(filter)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            // Results List
            if filteredVenues.isEmpty {
                RAVEEmptyStateView(
                    title: "No venues found",
                    subtitle: searchText.isEmpty ? "Try adjusting your filters" : "Try a different search term",
                    systemImage: "magnifyingglass"
                )
            } else {
                List(filteredVenues) { venue in
                    NavigationLink(destination: VenueDetailView(venue: venue)) {
                        VenueRowView(venue: venue, locationManager: locationManager)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Top Clubs")
        .navigationBarTitleDisplayMode(.large)
        .background(
        ZStack {
            Color.deepBackground.ignoresSafeArea()
            if PerformanceOptimizer.shouldShowParticles() {
                ParticleView(
                    count: PerformanceOptimizer.particleCount(defaultCount: 18), 
                    color: .ravePurple.opacity(0.2)
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }
            
            // Header Gradient Fade
            VStack {
                LinearGradient(
                    colors: [.black, .black.opacity(0.4), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                .allowsHitTesting(false)
                
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
        }
    )
        .onAppear {
            setupMockData()
        }
    }
    
    private func setupMockData() {
        venues = LocationManager.createMockVenues()
    }
    
    private func toggleFilter(_ filter: VenueFilter) {
        if filter == .all {
            selectedFilters = [.all]
        } else {
            selectedFilters.remove(.all)
            if selectedFilters.contains(filter) {
                selectedFilters.remove(filter)
                if selectedFilters.isEmpty {
                    selectedFilters.insert(.all)
                }
            } else {
                selectedFilters.insert(filter)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search venues, locations...", text: $text)
                .font(RAVEFont.body)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial.opacity(0.6))
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }
        )
        .padding(.horizontal)
    }
}

struct VenueRowView: View {
    let venue: Venue
    let locationManager: LocationManager
    
    var body: some View {
        HStack(spacing: 12) {
            // Venue Emoji
            Text(venue.primaryEmoji)
                .font(.system(size: 32))
                .frame(width: 44, height: 44)
                .background(
                    ZStack {
                        Circle().fill(Color.cardBackground)
                        Circle().fill(.thinMaterial.opacity(0.4))
                        Circle().stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(venue.name)
                    .font(RAVEFont.headline)
                    .foregroundColor(.primary)
                
                Text(venue.location)
                    .font(RAVEFont.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.caption)
                        Text("\(venue.checkInCount)")
                            .font(RAVEFont.footnote)
                    }
                    .foregroundColor(.secondary)
                    
                    if locationManager.isLocationEnabled {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.caption)
                            Text(locationManager.formattedDistance(from: venue.coordinate))
                                .font(RAVEFont.footnote)
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                VibeBadge(status: venue.vibeStatus)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial.opacity(0.5))
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }
        )
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

#Preview {
    TopClubsView()
        .preferredColorScheme(.dark)
}