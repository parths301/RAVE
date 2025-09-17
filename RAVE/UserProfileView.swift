//
//  UserProfileView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct UserProfileView: View {
    @State private var displayName = "John Doe"
    @State private var username = "johndoe_rave"
    @State private var bio = "Living for the nightlife 🌙 | EDM enthusiast | Always down to RAVE"
    @State private var location = "San Francisco, CA"
    @State private var isEditing = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 16) {
                    // Profile Image
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.appPrimary.opacity(0.3), .appSecondary.opacity(0.2)],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .stroke(.white.opacity(0.3), lineWidth: 2)
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.appPrimary)
                        
                        // Edit button overlay
                        if isEditing {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        // Change photo functionality
                                    }) {
                                        Circle()
                                            .fill(Color.appPrimary)
                                            .frame(width: 32, height: 32)
                                            .overlay(
                                                Image(systemName: "camera.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.white)
                                            )
                                    }
                                    .offset(x: -8, y: -8)
                                }
                            }
                            .frame(width: 120, height: 120)
                        }
                    }
                    
                    // Name and Username
                    VStack(spacing: 8) {
                        if isEditing {
                            TextField("Display Name", text: $displayName)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.center)
                        } else {
                            Text(displayName)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        if isEditing {
                            HStack {
                                Text("@")
                                    .foregroundColor(.secondary)
                                TextField("username", text: $username)
                                    .textFieldStyle(.roundedBorder)
                            }
                        } else {
                            Text("@\(username)")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Stats Cards
                HStack(spacing: 16) {
                    StatCardView(title: "Venues Visited", value: "47", icon: "location.fill")
                    StatCardView(title: "Events Attended", value: "23", icon: "calendar.badge.clock")
                    StatCardView(title: "Crew Members", value: "156", icon: "person.2.fill")
                }
                
                // Profile Info Section
                VStack(alignment: .leading, spacing: 20) {
                    ProfileSectionView(
                        title: "Bio",
                        content: bio,
                        isEditing: isEditing,
                        binding: $bio
                    )
                    
                    ProfileSectionView(
                        title: "Location",
                        content: location,
                        isEditing: isEditing,
                        binding: $location
                    )
                    
                    // Preferences Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Music Preferences")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            PreferenceChip(title: "Electronic", isSelected: true)
                            PreferenceChip(title: "House", isSelected: true)
                            PreferenceChip(title: "Techno", isSelected: false)
                            PreferenceChip(title: "Trance", isSelected: true)
                            PreferenceChip(title: "Dubstep", isSelected: false)
                            PreferenceChip(title: "Progressive", isSelected: true)
                        }
                    }
                    .padding()
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.appSecondaryBackground)
                            
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.regularMaterial.opacity(0.5))
                            
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        }
                    )
                }
                
                // Recent Activity
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Activity")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        ActivityItemView(
                            icon: "location.fill",
                            title: "Checked in at Neon Nights",
                            time: "2 hours ago",
                            iconColor: .appPrimary
                        )
                        
                        ActivityItemView(
                            icon: "person.2.fill",
                            title: "Joined Friday Night Crew",
                            time: "1 day ago",
                            iconColor: .blue
                        )
                        
                        ActivityItemView(
                            icon: "star.fill",
                            title: "Rated Bass Drop 5 stars",
                            time: "3 days ago",
                            iconColor: .yellow
                        )
                    }
                }
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.appSecondaryBackground)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial.opacity(0.5))
                        
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                )
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.appBackground)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.easeInOut) {
                        isEditing.toggle()
                    }
                }) {
                    Text(isEditing ? "Save" : "Edit")
                        .foregroundColor(.appPrimary)
                }
            }
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.appPrimary)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appSecondaryBackground)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial.opacity(0.5))
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }
        )
    }
}

struct ProfileSectionView: View {
    let title: String
    let content: String
    let isEditing: Bool
    @Binding var binding: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            if isEditing {
                TextField(title, text: $binding, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
            } else {
                Text(content)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
            }
        }
        .padding()
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appSecondaryBackground)
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial.opacity(0.5))
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }
        )
    }
}

struct PreferenceChip: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(isSelected ? .white : .secondary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.appPrimary : .clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

struct ActivityItemView: View {
    let icon: String
    let title: String
    let time: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial.opacity(0.3))
        )
    }
}

#Preview("User Profile View") {
    NavigationStack {
        UserProfileView()
    }
    .preferredColorScheme(.dark)
}