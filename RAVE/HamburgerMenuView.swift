//
//  HamburgerMenuView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct HamburgerMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingProfile = false
    @State private var showingSettings = false
    @State private var showingFriends = false
    @State private var showingPremium = false
    @State private var showingHelp = false
    @State private var showingPrivacy = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with RAVE branding
                VStack(spacing: 16) {
                    Text("RAVE")
                        .font(AppleFont.raveTitleLarge)
                        .foregroundStyle(Color.neonPurple.gradient)
                        .kerning(-2)

                    Text("Navigate Your Nightlife")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 32)
                .padding(.bottom, 40)

                // Menu Items
                VStack(spacing: 0) {
                    HamburgerMenuItem(
                        icon: "person.circle",
                        title: "Profile",
                        action: { showingProfile = true }
                    )

                    HamburgerMenuItem(
                        icon: "person.2",
                        title: "Friends",
                        action: { showingFriends = true }
                    )

                    HamburgerMenuItem(
                        icon: "crown",
                        title: "Premium",
                        action: { showingPremium = true }
                    )

                    HamburgerMenuItem(
                        icon: "gearshape",
                        title: "Settings",
                        action: { showingSettings = true }
                    )

                    HamburgerMenuItem(
                        icon: "questionmark.circle",
                        title: "Help",
                        action: { showingHelp = true }
                    )

                    HamburgerMenuItem(
                        icon: "hand.raised",
                        title: "Privacy",
                        action: { showingPrivacy = true }
                    )
                }

                Spacer()

                // Footer
                VStack(spacing: 8) {
                    Text("RAVE v1.0")
                        .font(.caption)
                        .foregroundStyle(.tertiary)

                    Text("Your Nightlife, Amplified")
                        .font(.caption2)
                        .foregroundStyle(.quaternary)
                }
                .padding(.bottom, 40)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Color.neonPurple)
                }
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

struct HamburgerMenuItem: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(Color.neonPurple.gradient)
                    .symbolRenderingMode(.hierarchical)
                    .frame(width: 32)

                Text(title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            Rectangle()
                .fill(.quaternary.opacity(0.3))
                .frame(height: 0.5),
            alignment: .bottom
        )
    }
}

#Preview("Hamburger Menu") {
    HamburgerMenuView()
        .preferredColorScheme(.dark)
}