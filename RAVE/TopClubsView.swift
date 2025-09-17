//
//  TopClubsView.swift
//  RAVE - Material Design 3 Top Clubs View
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct TopClubsView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Material Top App Bar
            MaterialTopAppBar(
                title: "Top Clubs",
                leadingAction: nil,
                trailingActions: [
                    MaterialTopAppBar.MaterialAppBarAction(
                        icon: MaterialIcon.search,
                        action: {
                            // Search action will be handled by the search bar
                        }
                    )
                ]
            )

            // Content
            TopClubsViewContent()
        }
        .background(Color.materialSurface)
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
            // Material Filter Chips Section
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: MaterialSpacing.sm) {
                    ForEach(VenueFilter.allCases, id: \.self) { filter in
                        MaterialChip(
                            text: filter.displayName,
                            isSelected: selectedFilter == filter
                        ) {
                            withAnimation(MaterialMotion.quickFade) {
                                selectedFilter = filter
                            }
                        }
                    }
                }
                .padding(.horizontal, MaterialSpacing.screenPadding)
            }
            .padding(.vertical, MaterialSpacing.md)
            .background(Color.materialSurfaceContainer)

            // Material Results List
            if filteredVenues.isEmpty {
                RAVEEmptyStateView(
                    title: "No top clubs found",
                    subtitle: searchText.isEmpty ? "Try adjusting your filters" : "Try a different search term",
                    systemImage: MaterialIcon.search
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredVenues) { club in
                            NavigationLink(destination: VenueDetailView(venue: club)) {
                                MaterialTopClubRowView(venue: club, locationManager: locationManager)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        .background(Color.materialSurface)
        .safeAreaInset(edge: .top) {
            MaterialSearchBar(text: $searchText, placeholder: "Search top clubs")
                .padding(.horizontal, MaterialSpacing.screenPadding)
                .padding(.vertical, MaterialSpacing.sm)
                .background(Color.materialSurfaceContainer)
        }
        .onAppear {
            setupMockData()
        }
    }

    private func setupMockData() {
        venues = LocationManager.createMockVenues()
    }
}

// MARK: - Material Top Club Row
struct MaterialTopClubRowView: View {
    let venue: Venue
    let locationManager: LocationManager

    var body: some View {
        MaterialListItem {
            HStack(spacing: MaterialSpacing.lg) {
                // Material Club Icon
                Image(systemName: venue.category.systemImage)
                    .font(MaterialFont.titleMedium)
                    .foregroundColor(.materialPrimary)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.materialPrimaryContainer)
                    )

                VStack(alignment: .leading, spacing: MaterialSpacing.xs) {
                    Text(venue.name)
                        .font(MaterialFont.titleMedium)
                        .foregroundColor(.materialOnSurface)

                    Text(venue.location)
                        .font(MaterialFont.bodyMedium)
                        .foregroundColor(.materialOnSurfaceVariant)

                    HStack(spacing: MaterialSpacing.lg) {
                        HStack(spacing: MaterialSpacing.xs) {
                            Image(systemName: MaterialIcon.group)
                                .font(MaterialFont.labelMedium)
                            Text("\(venue.checkInCount)")
                                .font(MaterialFont.labelMedium)
                        }
                        .foregroundColor(.materialOnSurfaceVariant)

                        if locationManager.isLocationEnabled {
                            HStack(spacing: MaterialSpacing.xs) {
                                Image(systemName: MaterialIcon.location)
                                    .font(MaterialFont.labelMedium)
                                Text(locationManager.formattedDistance(from: venue.coordinate))
                                    .font(MaterialFont.labelMedium)
                            }
                            .foregroundColor(.materialOnSurfaceVariant)
                        }
                    }
                }

                Spacer()

                // Material disclosure indicator
                Image(systemName: "chevron.right")
                    .font(MaterialFont.labelMedium)
                    .foregroundColor(.materialOnSurfaceVariant)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(venue.name) in \(venue.location), \(venue.checkInCount) people")
        .accessibilityHint("Tap to view venue details")
    }
}

// Legacy alias for compatibility
typealias AppleTopClubRowView = MaterialTopClubRowView


#Preview("Material Top Clubs View") {
    TopClubsView()
        .preferredColorScheme(.dark)
}