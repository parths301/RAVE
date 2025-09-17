//
//  ContentView.swift
//  RAVE - Material Design 3 Navigation
//
//  Created by Parth Sharma on 12/09/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            // Main content area
            Group {
                switch selectedTab {
                case 0: MapView()
                case 1: TopClubsView()
                case 2: CrewView()
                case 3: CrewNotificationsView()
                default: MapView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.materialSurface)

            // Material Bottom Navigation
            MaterialBottomNavigation(
                selectedTab: $selectedTab,
                tabs: materialTabs
            )
        }
        .preferredColorScheme(.dark)
        .background(Color.materialSurface.ignoresSafeArea())
    }

    private var materialTabs: [MaterialBottomNavigation.MaterialBottomNavTab] {
        [
            MaterialBottomNavigation.MaterialBottomNavTab(
                icon: MaterialIcon.home,
                activeIcon: "house.fill",
                label: "Map"
            ),
            MaterialBottomNavigation.MaterialBottomNavTab(
                icon: MaterialIcon.nightclub,
                activeIcon: "wineglass.fill",
                label: "Top Clubs"
            ),
            MaterialBottomNavigation.MaterialBottomNavTab(
                icon: MaterialIcon.crew,
                activeIcon: "person.3.fill",
                label: "Crew"
            ),
            MaterialBottomNavigation.MaterialBottomNavTab(
                icon: MaterialIcon.notification,
                activeIcon: "bell.fill",
                label: "Notifications"
            )
        ]
    }
}

// MARK: - Legacy Tab System (keeping for compatibility)
enum VenueTab: String, CaseIterable {
    case map = "Map"
    case topClubs = "Top Clubs"
    case crew = "Crew"
    case crewNotifications = "Notifications"

    var systemImage: String {
        switch self {
        case .map: return MaterialIcon.home
        case .topClubs: return MaterialIcon.nightclub
        case .crew: return MaterialIcon.crew
        case .crewNotifications: return MaterialIcon.notification
        }
    }

    var selectedSystemImage: String {
        switch self {
        case .map: return "house.fill"
        case .topClubs: return "wineglass.fill"
        case .crew: return "person.3.fill"
        case .crewNotifications: return "bell.fill"
        }
    }
}

#Preview("Content View") {
    ContentView()
        .preferredColorScheme(.dark)
}
