//
//  TopClubsView.swift
//  Venues - Social Venue Discovery
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct TopClubsView: View {
    var body: some View {
        NavigationStack {
            TopClubsViewContent()
                .appleNavigation(title: "Top Clubs")
        }
    }
}

struct TopClubsViewContent: View {
    @State private var searchText = ""
    @State private var selectedFilter: VenueFilter = .all
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
        switch selectedFilter {
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

        // Sort by popularity (check-in count)
        return filtered.sorted { $0.checkInCount > $1.checkInCount }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Apple Standard Filter Section
            VStack(spacing: AppleSpacing.small) {
                AppleSegmentedPicker(
                    selection: $selectedFilter,
                    options: VenueFilter.allCases.map { ($0, $0.displayName) }
                )
                .padding(.horizontal, AppleSpacing.standardPadding)
            }
            .padding(.vertical, AppleSpacing.small)
            .background(Color.appSecondaryBackground)

            // Results List
            if filteredVenues.isEmpty {
                AppleEmptyStateView(
                    title: "No top clubs found",
                    subtitle: searchText.isEmpty ? "Try adjusting your filters" : "Try a different search term",
                    systemImage: "magnifyingglass"
                )
            } else {
                List(filteredVenues) { club in
                    NavigationLink(destination: VenueDetailView(venue: club)) {
                        AppleTopClubRowView(venue: club, locationManager: locationManager)
                    }
                }
                .appleListStyle()
            }
        }
        .searchable(text: $searchText, prompt: "Search top clubs")
        .background(Color.appBackground)
        .onAppear {
            setupMockData()
        }
    }

    private func setupMockData() {
        venues = LocationManager.createMockVenues()
    }
}

// MARK: - Apple-Compliant Top Club Row
struct AppleTopClubRowView: View {
    let venue: Venue
    let locationManager: LocationManager

    var body: some View {
        HStack(spacing: AppleSpacing.medium) {
            // Top Club Category Icon
            Image(systemName: venue.category.systemImage)
                .font(.title2)
                .foregroundColor(.appPrimary)
                .frame(width: 32, height: 32)
                .background(Color.appTertiaryBackground)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: AppleSpacing.xs) {
                Text(venue.name)
                    .font(AppleFont.headline)
                    .foregroundColor(.primary)

                Text(venue.location)
                    .font(AppleFont.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: AppleSpacing.medium) {
                    HStack(spacing: AppleSpacing.xs) {
                        Image(systemName: "person.2")
                            .font(.caption)
                        Text("\(venue.checkInCount)")
                            .font(AppleFont.footnote)
                    }
                    .foregroundColor(.secondary)

                    if locationManager.isLocationEnabled {
                        HStack(spacing: AppleSpacing.xs) {
                            Image(systemName: "location")
                                .font(.caption)
                            Text(locationManager.formattedDistance(from: venue.coordinate))
                                .font(AppleFont.footnote)
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            // Apple-standard disclosure indicator
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, AppleSpacing.small)
        .appleAccessibility(
            label: "\(venue.name) in \(venue.location), \(venue.checkInCount) people",
            hint: "Tap to view venue details"
        )
    }
}


#Preview("Top Clubs View") {
    TopClubsView()
        .preferredColorScheme(.dark)
}