//
//  VenueComponents.swift
//  Venues - Social Venue Discovery
//
//  Created by Claude on 12/09/25.
//

import SwiftUI
import MapKit
import UIKit

// MARK: - Apple Venue Detail View
struct VenueDetailView: View {
    let venue: Venue
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                AppleFormSection(title: "Venue Information") {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(venue.name)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Location")
                        Spacer()
                        Text(venue.location)
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Category")
                        Spacer()
                        HStack(spacing: AppleSpacing.xs) {
                            Image(systemName: venue.category.systemImage)
                                .font(.caption)
                            Text(venue.category.rawValue.capitalized)
                        }
                        .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Current Activity")
                        Spacer()
                        Text("\(venue.checkInCount) people")
                            .foregroundColor(.secondary)
                    }
                }

                AppleFormSection(title: "Actions") {
                    Button("Get Directions") {
                        // Directions action
                    }
                    .applePrimaryButton()

                    Button("Share Venue") {
                        // Share action
                    }
                    .appleSecondaryButton()

                    Button("Report Issue") {
                        // Report action
                    }
                    .appleTertiaryButton()
                }
            }
            .appleListStyle()
            .navigationTitle(venue.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .applePlainButton()
                }
            }
        }
    }
}

// MARK: - Apple Statistics Card
struct AppleStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: AppleSpacing.small) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(AppleFont.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            Text(label)
                .font(AppleFont.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(AppleSpacing.standardPadding)
        .background(Color.appSecondaryBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appSeparator, lineWidth: 0.5)
        )
    }
}


// MARK: - Apple Empty State View Alias
typealias RAVEEmptyStateView = AppleEmptyStateView

// MARK: - Apple Badge Component
struct VibeBadge: View {
    let status: VibeStatus

    var body: some View {
        HStack(spacing: AppleSpacing.xs) {
            Circle()
                .fill(status.color)
                .frame(width: 6, height: 6)

            Text(status.displayName)
                .font(AppleFont.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, AppleSpacing.small)
        .padding(.vertical, AppleSpacing.xs)
        .background(Color.appTertiaryBackground)
        .cornerRadius(8)
        .foregroundColor(status.color)
    }
}

enum VibeStatus: String, CaseIterable {
    case quiet = "quiet"
    case moderate = "moderate"
    case busy = "busy"
    case packed = "packed"

    var displayName: String {
        switch self {
        case .quiet: return "Quiet"
        case .moderate: return "Moderate"
        case .busy: return "Busy"
        case .packed: return "Packed"
        }
    }

    var color: Color {
        switch self {
        case .quiet: return .appGreen
        case .moderate: return .appYellow
        case .busy: return .appOrange
        case .packed: return .appRed
        }
    }
}

// MARK: - Apple Chart Component
struct AppleChartView: View {
    let data: [ChartDataPoint]
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppleSpacing.medium) {
            Text(title)
                .font(AppleFont.headline)
                .foregroundColor(.primary)

            // Simple bar chart representation
            HStack(alignment: .bottom, spacing: AppleSpacing.xs) {
                ForEach(data, id: \.label) { point in
                    VStack(spacing: AppleSpacing.xs) {
                        Rectangle()
                            .fill(Color.appPrimary)
                            .frame(width: 24, height: CGFloat(point.value) * 2)

                        Text(point.label)
                            .font(AppleFont.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 120)
        }
        .padding(AppleSpacing.standardPadding)
        .background(Color.appSecondaryBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appSeparator, lineWidth: 0.5)
        )
    }
}

struct ChartDataPoint {
    let label: String
    let value: Double
}

#Preview("Venue Detail") {
    VenueDetailView(venue: LocationManager.createMockVenues().first!)
}

#Preview("Statistics Card") {
    AppleStatCard(
        icon: "location.fill",
        value: "42",
        label: "Venues Visited",
        color: .appPrimary
    )
}

#Preview("Vibe Badge") {
    VibeBadge(status: .busy)
}