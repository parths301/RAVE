//
//  SettingsView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var locationServicesEnabled = true
    @State private var darkModeEnabled = true
    @State private var particleEffectsEnabled = true
    @State private var hapticFeedbackEnabled = true
    @State private var autoCheckInEnabled = false
    @State private var showOnlineStatus = true
    @State private var allowCrewInvites = true
    @State private var shareLocationWithCrew = true
    @State private var selectedRadius: Double = 5.0
    
    var body: some View {
        List {
            // Notifications Section
            Section("Notifications") {
                SettingToggleRow(
                    title: "Push Notifications",
                    subtitle: "Receive alerts and updates",
                    icon: "bell.fill",
                    iconColor: .appPrimary,
                    isOn: $notificationsEnabled
                )
                
                NavigationLink(destination: AppleNotificationSettingsView()) {
                    SettingRow(
                        title: "Notification Preferences",
                        subtitle: "Customize what you receive",
                        icon: "bell.badge.fill",
                        iconColor: .orange
                    )
                }
            }
            
            // Location & Privacy Section
            Section("Location & Privacy") {
                SettingToggleRow(
                    title: "Location Services",
                    subtitle: "Find nearby venues and events",
                    icon: "location.fill",
                    iconColor: .blue,
                    isOn: $locationServicesEnabled
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "map.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.green)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Discovery Radius")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Text("\(Int(selectedRadius)) km")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    Slider(value: $selectedRadius, in: 1...25, step: 1)
                        .tint(.appPrimary)
                        .padding(.leading, 32)
                }
                .padding(.vertical, 4)
                
                NavigationLink(destination: PrivacyView()) {
                    SettingRow(
                        title: "Privacy Settings",
                        subtitle: "Control your data and visibility",
                        icon: "lock.shield.fill",
                        iconColor: .red
                    )
                }
            }
            
            // App Experience Section
            Section("App Experience") {
                SettingToggleRow(
                    title: "Dark Mode",
                    subtitle: "Always use dark theme",
                    icon: "moon.fill",
                    iconColor: .indigo,
                    isOn: $darkModeEnabled
                )
                
                SettingToggleRow(
                    title: "Particle Effects",
                    subtitle: "Visual effects and animations",
                    icon: "sparkles",
                    iconColor: .appPrimary,
                    isOn: $particleEffectsEnabled
                )
                
                SettingToggleRow(
                    title: "Haptic Feedback",
                    subtitle: "Touch vibrations",
                    icon: "hand.tap.fill",
                    iconColor: .pink,
                    isOn: $hapticFeedbackEnabled
                )
            }
            
            // Social Features Section
            Section("Social Features") {
                SettingToggleRow(
                    title: "Auto Check-In",
                    subtitle: "Automatically check in at venues",
                    icon: "checkmark.circle.fill",
                    iconColor: .green,
                    isOn: $autoCheckInEnabled
                )
                
                SettingToggleRow(
                    title: "Show Online Status",
                    subtitle: "Let others see when you're active",
                    icon: "circle.fill",
                    iconColor: .green,
                    isOn: $showOnlineStatus
                )
                
                SettingToggleRow(
                    title: "Allow Crew Invites",
                    subtitle: "Receive invitations to join crews",
                    icon: "person.2.badge.plus.fill",
                    iconColor: .blue,
                    isOn: $allowCrewInvites
                )
                
                SettingToggleRow(
                    title: "Share Location with Crew",
                    subtitle: "Let crew members see your location",
                    icon: "location.circle.fill",
                    iconColor: .orange,
                    isOn: $shareLocationWithCrew
                )
            }
            
            // Account Section
            Section("Account") {
                NavigationLink(destination: AccountSettingsView()) {
                    SettingRow(
                        title: "Account Settings",
                        subtitle: "Manage your account",
                        icon: "person.crop.circle.fill",
                        iconColor: .gray
                    )
                }
                
                Button(action: {
                    // Export data functionality
                }) {
                    SettingRow(
                        title: "Export Data",
                        subtitle: "Download your information",
                        icon: "arrow.down.doc.fill",
                        iconColor: .blue,
                        showChevron: false
                    )
                }
                
                Button(action: {
                    // Delete account functionality
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Delete Account")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.red)
                            
                            Text("Permanently remove your account")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            
            // About Section
            Section("About") {
                SettingRow(
                    title: "Version",
                    subtitle: "1.0.0 (Build 1)",
                    icon: "info.circle.fill",
                    iconColor: .blue,
                    showChevron: false
                )
                
                NavigationLink(destination: Text("Terms of Service").navigationTitle("Terms")) {
                    SettingRow(
                        title: "Terms of Service",
                        subtitle: "Legal terms and conditions",
                        icon: "doc.text.fill",
                        iconColor: .gray
                    )
                }
                
                NavigationLink(destination: Text("Privacy Policy").navigationTitle("Privacy")) {
                    SettingRow(
                        title: "Privacy Policy",
                        subtitle: "How we handle your data",
                        icon: "hand.raised.fill",
                        iconColor: .orange
                    )
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .background(Color.appBackground)
    }
}

struct SettingRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let showChevron: Bool
    
    init(title: String, subtitle: String, icon: String, iconColor: Color, showChevron: Bool = true) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.showChevron = showChevron
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct SettingToggleRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(.appPrimary)
        }
        .padding(.vertical, 4)
    }
}

struct AccountSettingsView: View {
    @State private var email = "john@example.com"
    @State private var phone = "+1 (555) 123-4567"
    @State private var isVerified = true
    
    var body: some View {
        List {
            Section("Account Information") {
                HStack {
                    Text("Email")
                    Spacer()
                    Text(email)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Phone")
                    Spacer()
                    HStack(spacing: 4) {
                        Text(phone)
                            .foregroundColor(.secondary)
                        if isVerified {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                }
            }
            
            Section("Security") {
                NavigationLink(destination: Text("Change Password").navigationTitle("Password")) {
                    Text("Change Password")
                }
                
                NavigationLink(destination: Text("Two-Factor Auth").navigationTitle("2FA")) {
                    Text("Two-Factor Authentication")
                }
                
                NavigationLink(destination: Text("Connected Accounts").navigationTitle("Accounts")) {
                    Text("Connected Accounts")
                }
            }
            
            Section("Data Management") {
                Button("Clear Cache") {
                    // Clear cache functionality
                }
                
                Button("Reset All Settings") {
                    // Reset settings functionality
                }
                .foregroundColor(.orange)
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Settings View") {
    NavigationStack {
        SettingsView()
    }
    .preferredColorScheme(.dark)
}