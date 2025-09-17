//
//  PrivacyView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct PrivacyView: View {
    @State private var profileVisibility = ProfileVisibility.friends
    @State private var showLocationToFriends = true
    @State private var showOnlineStatus = true
    @State private var allowFriendRequests = true
    @State private var shareActivityStatus = false
    @State private var dataCollection = true
    @State private var analyticsSharing = false
    @State private var marketingEmails = false
    
    var body: some View {
        List {
            // Profile Privacy Section
            Section("Profile Privacy") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Who can see your profile")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Picker("Profile Visibility", selection: $profileVisibility) {
                        Text("Everyone").tag(ProfileVisibility.everyone)
                        Text("Friends Only").tag(ProfileVisibility.friends)
                        Text("Private").tag(ProfileVisibility.private)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 8)
                
                PrivacyToggleRow(
                    title: "Show Location to Friends",
                    subtitle: "Let friends see your current venue",
                    icon: "location.fill",
                    iconColor: .blue,
                    isOn: $showLocationToFriends
                )
                
                PrivacyToggleRow(
                    title: "Show Online Status",
                    subtitle: "Display when you're active",
                    icon: "circle.fill",
                    iconColor: .green,
                    isOn: $showOnlineStatus
                )
                
                PrivacyToggleRow(
                    title: "Allow Friend Requests",
                    subtitle: "Others can send you friend requests",
                    icon: "person.badge.plus.fill",
                    iconColor: .appPrimary,
                    isOn: $allowFriendRequests
                )
            }
            
            // Activity Privacy Section
            Section("Activity Privacy") {
                PrivacyToggleRow(
                    title: "Share Activity Status",
                    subtitle: "Show when you check in at venues",
                    icon: "location.badge.gearshape.fill",
                    iconColor: .orange,
                    isOn: $shareActivityStatus
                )
                
                NavigationLink(destination: BlockedUsersView()) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.fill.xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Blocked Users")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Text("Manage blocked accounts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            // Data & Analytics Section
            Section("Data & Analytics") {
                PrivacyToggleRow(
                    title: "Data Collection",
                    subtitle: "Help improve app experience",
                    icon: "chart.bar.doc.horizontal.fill",
                    iconColor: .blue,
                    isOn: $dataCollection
                )
                
                PrivacyToggleRow(
                    title: "Analytics Sharing",
                    subtitle: "Share usage analytics",
                    icon: "chart.line.uptrend.xyaxis.circle.fill",
                    iconColor: .green,
                    isOn: $analyticsSharing
                )
                
                PrivacyToggleRow(
                    title: "Marketing Emails",
                    subtitle: "Receive promotional content",
                    icon: "envelope.fill",
                    iconColor: .orange,
                    isOn: $marketingEmails
                )
                
                NavigationLink(destination: DataManagementView()) {
                    HStack(spacing: 12) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundColor(.appPrimary)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Data Management")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Text("View and manage your data")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            // Legal Section
            Section("Legal") {
                NavigationLink(destination: Text("Privacy Policy").navigationTitle("Privacy Policy")) {
                    HStack(spacing: 12) {
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                            .frame(width: 24)
                        
                        Text("Privacy Policy")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                NavigationLink(destination: Text("Terms of Service").navigationTitle("Terms")) {
                    HStack(spacing: 12) {
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .frame(width: 24)
                        
                        Text("Terms of Service")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.large)
        .background(Color.appBackground)
    }
}

enum ProfileVisibility: String, CaseIterable {
    case everyone = "Everyone"
    case friends = "Friends Only"
    case `private` = "Private"
}

struct PrivacyToggleRow: View {
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

struct BlockedUsersView: View {
    @State private var blockedUsers = [
        "@toxic_user123",
        "@spam_account",
        "@inappropriate_user"
    ]
    
    var body: some View {
        List {
            if blockedUsers.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.fill.checkmark")
                        .font(.system(size: 48))
                        .foregroundColor(.green)
                    
                    Text("No Blocked Users")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("You haven't blocked anyone yet")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ForEach(blockedUsers, id: \.self) { user in
                    HStack {
                        Circle()
                            .fill(.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                            )

                        Text(user)
                            .font(.system(size: 16, weight: .medium))

                        Spacer()

                        Button("Unblock") {
                            if let index = blockedUsers.firstIndex(of: user) {
                                blockedUsers.remove(at: index)
                            }
                        }
                        .foregroundColor(.appPrimary)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteUser)
            }
        }
        .navigationTitle("Blocked Users")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func deleteUser(at offsets: IndexSet) {
        blockedUsers.remove(atOffsets: offsets)
    }
}

struct DataManagementView: View {
    var body: some View {
        List {
            Section("Your Data") {
                DataRowView(title: "Check-ins", value: "1,247", icon: "location.fill")
                DataRowView(title: "Photos Shared", value: "156", icon: "photo.fill")
                DataRowView(title: "Messages Sent", value: "3,891", icon: "message.fill")
                DataRowView(title: "Friends", value: "89", icon: "person.2.fill")
            }
            
            Section("Data Export") {
                Button(action: {
                    // Export functionality
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.blue)
                        Text("Download My Data")
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
                
                Text("Export includes all your data in JSON format")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section("Data Deletion") {
                Button(action: {
                    // Delete functionality
                }) {
                    HStack {
                        Image(systemName: "trash.circle.fill")
                            .foregroundColor(.red)
                        Text("Delete All Data")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                
                Text("This action cannot be undone")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Data Management")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataRowView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.appPrimary)
                .frame(width: 20)
            
            Text(title)
                .font(.system(size: 16))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview("Privacy View") {
    NavigationStack {
        PrivacyView()
    }
    .preferredColorScheme(.dark)
}