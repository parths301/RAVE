//
//  MaterialNavigationDrawer.swift
//  RAVE - Material Design 3 Navigation Drawer
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct MaterialNavigationDrawerView: View {
    @Binding var isOpen: Bool
    @State private var showingProfile = false
    @State private var showingSettings = false
    @State private var showingFriends = false
    @State private var showingPremium = false
    @State private var showingHelp = false
    @State private var showingPrivacy = false

    var body: some View {
        MaterialNavigationDrawer(isOpen: $isOpen) {
            VStack(spacing: 0) {
                // Material Design Header
                VStack(spacing: MaterialSpacing.lg) {
                    Text("RAVE")
                        .font(MaterialFont.raveDisplayMedium)
                        .foregroundColor(.materialPrimary)
                        .kerning(-2)

                    Text("Navigate Your Nightlife")
                        .font(MaterialFont.bodyMedium)
                        .foregroundColor(.materialOnSurfaceVariant)
                }
                .padding(.top, MaterialSpacing.xxxxl)
                .padding(.bottom, MaterialSpacing.xxxl)
                .padding(.horizontal, MaterialSpacing.listItemPadding)

                // Material List Items
                VStack(spacing: 0) {
                    MaterialDrawerItem(
                        icon: MaterialIcon.person,
                        title: "Profile",
                        action: {
                            showingProfile = true
                            withAnimation(MaterialMotion.mediumSlide) {
                                isOpen = false
                            }
                        }
                    )

                    MaterialDrawerItem(
                        icon: MaterialIcon.group,
                        title: "Friends",
                        action: {
                            showingFriends = true
                            withAnimation(MaterialMotion.mediumSlide) {
                                isOpen = false
                            }
                        }
                    )

                    MaterialDrawerItem(
                        icon: "crown",
                        title: "Premium",
                        action: {
                            showingPremium = true
                            withAnimation(MaterialMotion.mediumSlide) {
                                isOpen = false
                            }
                        }
                    )

                    MaterialDrawerItem(
                        icon: MaterialIcon.settings,
                        title: "Settings",
                        action: {
                            showingSettings = true
                            withAnimation(MaterialMotion.mediumSlide) {
                                isOpen = false
                            }
                        }
                    )

                    MaterialDrawerItem(
                        icon: "questionmark.circle",
                        title: "Help",
                        action: {
                            showingHelp = true
                            withAnimation(MaterialMotion.mediumSlide) {
                                isOpen = false
                            }
                        }
                    )

                    MaterialDrawerItem(
                        icon: "hand.raised",
                        title: "Privacy",
                        action: {
                            showingPrivacy = true
                            withAnimation(MaterialMotion.mediumSlide) {
                                isOpen = false
                            }
                        }
                    )
                }

                Spacer()

                // Material Footer
                VStack(spacing: MaterialSpacing.sm) {
                    Text("RAVE v1.0")
                        .font(MaterialFont.labelMedium)
                        .foregroundColor(.materialOnSurfaceVariant)

                    Text("Your Nightlife, Amplified")
                        .font(MaterialFont.labelSmall)
                        .foregroundColor(.materialOutline)
                }
                .padding(.bottom, MaterialSpacing.xxxxl)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingProfile) {
            UserProfileView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingFriends) {
            FriendsView()
        }
        .sheet(isPresented: $showingPremium) {
            PremiumView()
        }
        .sheet(isPresented: $showingHelp) {
            HelpView()
        }
        .sheet(isPresented: $showingPrivacy) {
            PrivacyView()
        }
    }
}

struct MaterialDrawerItem: View {
    let icon: String
    let title: String
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        MaterialListItem(action: action) {
            HStack(spacing: MaterialSpacing.lg) {
                Image(systemName: icon)
                    .font(MaterialFont.titleMedium)
                    .foregroundColor(.materialPrimary)
                    .symbolRenderingMode(.hierarchical)
                    .frame(width: 24, height: 24)

                Text(title)
                    .font(MaterialFont.bodyLarge)
                    .foregroundColor(.materialOnSurface)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(MaterialFont.labelMedium)
                    .foregroundColor(.materialOnSurfaceVariant)
            }
        }
    }
}

// Legacy HamburgerMenuView for backward compatibility
typealias HamburgerMenuView = MaterialNavigationDrawerWrapper

struct MaterialNavigationDrawerWrapper: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isOpen = true

    var body: some View {
        MaterialNavigationDrawerView(isOpen: $isOpen)
            .onReceive(NotificationCenter.default.publisher(for: .init("CloseDrawer"))) { _ in
                dismiss()
            }
    }
}

#Preview("Material Navigation Drawer") {
    ZStack {
        Color.materialSurface.ignoresSafeArea()
        MaterialNavigationDrawerView(isOpen: .constant(true))
    }
    .preferredColorScheme(.dark)
}