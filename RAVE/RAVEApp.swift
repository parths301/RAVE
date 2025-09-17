//
//  RAVEApp.swift
//  RAVE - Material Design 3 App Configuration
//
//  Created by Parth Sharma on 12/09/25.
//

import SwiftUI

@main
struct RAVEApp: App {
    init() {
        configureMaterialDesignTheme()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .tint(Color.materialPrimary)
                .background(Color.materialSurface)
                .materialThemeTransition(isDarkMode: true)
        }
    }

    private func configureMaterialDesignTheme() {
        // Configure navigation bar appearance for Material Design
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Color.materialSurface)
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color.materialOnSurface),
            .font: UIFont.systemFont(ofSize: 22, weight: .regular)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.materialOnSurface),
            .font: UIFont.systemFont(ofSize: 32, weight: .regular)
        ]
        navBarAppearance.shadowColor = UIColor(Color.materialOutlineVariant)

        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance

        // Configure tab bar appearance for Material Design
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.materialSurfaceContainer)
        tabBarAppearance.selectionIndicatorTintColor = UIColor(Color.materialPrimary)

        // Unselected tab items
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.materialOnSurfaceVariant)
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.materialOnSurfaceVariant),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]

        // Selected tab items
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.materialPrimary)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.materialPrimary),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        // Configure other UI elements for Material Design
        UITableView.appearance().backgroundColor = UIColor(Color.materialSurface)
        UITableView.appearance().separatorColor = UIColor(Color.materialOutlineVariant)

        // Configure search bar appearance
        UISearchBar.appearance().backgroundColor = UIColor(Color.materialSurfaceContainer)
        UISearchBar.appearance().barTintColor = UIColor(Color.materialSurfaceContainer)
        UISearchBar.appearance().tintColor = UIColor(Color.materialPrimary)

        // Configure alerts and action sheets
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color.materialPrimary)
    }
}

// Legacy alias for compatibility
typealias VenuesApp = RAVEApp
