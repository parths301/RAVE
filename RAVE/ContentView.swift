//
//  ContentView.swift
//  Venues - Social Venue Discovery
//
//  Created by Parth Sharma on 12/09/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: VenueTab = .map

    init() {
        // Configure tab bar appearance per Apple HIG
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground

        // Add subtle border for visual separation
        tabBarAppearance.shadowColor = UIColor.separator

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            MapView()
                .tabItem {
                    Label(VenueTab.map.rawValue, systemImage: VenueTab.map.systemImage)
                }
                .tag(VenueTab.map)

            TopClubsView()
                .tabItem {
                    Label(VenueTab.topClubs.rawValue, systemImage: VenueTab.topClubs.systemImage)
                }
                .tag(VenueTab.topClubs)

            CrewView()
                .tabItem {
                    Label(VenueTab.crew.rawValue, systemImage: VenueTab.crew.systemImage)
                }
                .tag(VenueTab.crew)

            CrewNotificationsView()
                .tabItem {
                    Label(VenueTab.crewNotifications.rawValue, systemImage: VenueTab.crewNotifications.systemImage)
                }
                .tag(VenueTab.crewNotifications)
        }
        .preferredColorScheme(.dark)
        .tint(Color.neonPurple)
        .background(Color.appBackground.ignoresSafeArea())
    }
}

// MARK: - RAVE Tab System
enum VenueTab: String, CaseIterable {
    case map = "Map"
    case topClubs = "Top Clubs"
    case crew = "Crew"
    case crewNotifications = "Notifications"

    var systemImage: String {
        switch self {
        case .map: return "house"
        case .topClubs: return "wineglass"
        case .crew: return "person.3"
        case .crewNotifications: return "bell"
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
