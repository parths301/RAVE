//
//  FriendsView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct FriendsView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var friends: [Friend] = []
    @State private var pendingRequests: [FriendRequest] = []
    @State private var suggestions: [Friend] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab Picker
            Picker("Friends Tab", selection: $selectedTab) {
                Text("Friends").tag(0)
                Text("Requests").tag(1) 
                Text("Discover").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Content based on selected tab
            TabView(selection: $selectedTab) {
                // Friends List
                FriendsListView(friends: friends, searchText: searchText)
                    .tag(0)
                
                // Friend Requests
                FriendRequestsView(requests: pendingRequests)
                    .tag(1)
                
                // Discover Friends
                DiscoverFriendsView(suggestions: suggestions)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search friends...")
        .background(
            ZStack {
                Color.deepBackground.ignoresSafeArea()
                if PerformanceOptimizer.shouldShowParticles() {
                    ParticleView(
                        count: PerformanceOptimizer.particleCount(defaultCount: 15), 
                        color: .ravePurple.opacity(0.2)
                    )
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                }
            }
        )
        .onAppear {
            setupMockData()
        }
    }
    
    private func setupMockData() {
        friends = [
            Friend(username: "alex_nightlife", displayName: "Alex Chen", isOnline: true, currentVenue: "Neon Nights"),
            Friend(username: "party_sarah", displayName: "Sarah K", isOnline: false, currentVenue: nil),
            Friend(username: "dj_mike", displayName: "Mike DJ", isOnline: true, currentVenue: "Bass Drop"),
            Friend(username: "emma_beats", displayName: "Emma B", isOnline: true, currentVenue: nil),
            Friend(username: "carlos_rave", displayName: "Carlos R", isOnline: false, currentVenue: nil)
        ]
        
        pendingRequests = [
            FriendRequest(username: "new_raver", displayName: "Jessica M", mutualFriends: 3),
            FriendRequest(username: "techno_lover", displayName: "David L", mutualFriends: 7)
        ]
        
        suggestions = [
            Friend(username: "music_lover", displayName: "Taylor S", isOnline: false, currentVenue: nil),
            Friend(username: "night_owl", displayName: "Jordan P", isOnline: true, currentVenue: "Underground"),
            Friend(username: "rave_queen", displayName: "Maya R", isOnline: false, currentVenue: nil)
        ]
    }
}

struct FriendsListView: View {
    let friends: [Friend]
    let searchText: String
    
    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter { friend in
                friend.displayName.localizedCaseInsensitiveContains(searchText) ||
                friend.username.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List(filteredFriends) { friend in
            NavigationLink(destination: FriendDetailView(friend: friend)) {
                FriendRowView(friend: friend)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

struct FriendRequestsView: View {
    @State var requests: [FriendRequest]
    
    var body: some View {
        if requests.isEmpty {
            VStack(spacing: 20) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                Text("No Friend Requests")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("When someone sends you a friend request, it will appear here")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(requests) { request in
                FriendRequestRowView(request: request) { action in
                    handleFriendRequest(request: request, action: action)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
    
    private func handleFriendRequest(request: FriendRequest, action: FriendRequestAction) {
        requests.removeAll { $0.id == request.id }
        // Handle accept/decline logic here
    }
}

struct DiscoverFriendsView: View {
    let suggestions: [Friend]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Invite Friends Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Invite Friends")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        // Share app functionality
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "square.and.arrow.up.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.ravePurple)
                            
                            Text("Share RAVE with Friends")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.cardBackground)
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.regularMaterial.opacity(0.5))
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            }
                        )
                    }
                }
                .padding(.horizontal)
                
                // Suggested Friends Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("People You May Know")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button("See All") {
                            // Show all suggestions
                        }
                        .foregroundColor(.ravePurple)
                    }
                    .padding(.horizontal)
                    
                    ForEach(suggestions) { friend in
                        SuggestionRowView(friend: friend)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

struct FriendRowView: View {
    let friend: Friend
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Picture
            ZStack {
                Circle()
                    .fill(Color.ravePurple.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.ravePurple)
                
                // Online status indicator
                if friend.isOnline {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Circle()
                                .fill(.green)
                                .frame(width: 12, height: 12)
                                .overlay(
                                    Circle()
                                        .stroke(Color.deepBackground, lineWidth: 2)
                                )
                        }
                    }
                    .frame(width: 50, height: 50)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.displayName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text("@\(friend.username)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let venue = friend.currentVenue {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption2)
                            .foregroundColor(.ravePurple)
                        
                        Text("at \(venue)")
                            .font(.caption)
                            .foregroundColor(.ravePurple)
                    }
                }
            }
            
            Spacer()
            
            // Status or action button
            if friend.isOnline {
                VStack(spacing: 4) {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                    
                    Text("Online")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial.opacity(0.5))
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }
        )
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
    }
}

struct FriendRequestRowView: View {
    let request: FriendRequest
    let onAction: (FriendRequestAction) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.ravePurple.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.ravePurple)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(request.displayName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("@\(request.username)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(request.mutualFriends) mutual friends")
                        .font(.caption)
                        .foregroundColor(.ravePurple)
                }
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                Button("Accept") {
                    onAction(.accept)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(Color.ravePurple)
                .cornerRadius(20)
                
                Button("Decline") {
                    onAction(.decline)
                }
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(.regularMaterial.opacity(0.3))
                .cornerRadius(20)
                
                Spacer()
            }
        }
        .padding()
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial.opacity(0.5))
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }
        )
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
    }
}

struct SuggestionRowView: View {
    let friend: Friend
    @State private var isRequested = false
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.ravePurple.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.ravePurple)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.displayName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text("@\(friend.username)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(isRequested ? "Requested" : "Add Friend") {
                if !isRequested {
                    withAnimation(.easeInOut) {
                        isRequested = true
                    }
                }
            }
            .foregroundColor(isRequested ? .secondary : .white)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(isRequested ? Color.gray.opacity(0.3) : Color.ravePurple)
            .cornerRadius(16)
            .disabled(isRequested)
        }
        .padding()
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardBackground)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial.opacity(0.5))
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }
        )
    }
}

struct FriendDetailView: View {
    let friend: Friend
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.ravePurple.opacity(0.3))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.ravePurple)
                        
                        if friend.isOnline {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.deepBackground, lineWidth: 3)
                                        )
                                }
                            }
                            .frame(width: 120, height: 120)
                        }
                    }
                    
                    VStack(spacing: 8) {
                        Text(friend.displayName)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("@\(friend.username)")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        
                        if let venue = friend.currentVenue {
                            HStack(spacing: 6) {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.ravePurple)
                                
                                Text("Currently at \(venue)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.ravePurple)
                            }
                        }
                    }
                }
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button("Message") {
                        // Open chat
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.ravePurple)
                    .cornerRadius(12)
                    
                    Button("View Profile") {
                        // View full profile
                    }
                    .foregroundColor(.ravePurple)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.regularMaterial.opacity(0.3))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            ZStack {
                Color.deepBackground.ignoresSafeArea()
                if PerformanceOptimizer.shouldShowParticles() {
                    ParticleView(
                        count: PerformanceOptimizer.particleCount(defaultCount: 10), 
                        color: .ravePurple.opacity(0.1)
                    )
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                }
            }
        )
    }
}

// MARK: - Models

struct Friend: Identifiable {
    let id = UUID()
    let username: String
    let displayName: String
    let isOnline: Bool
    let currentVenue: String?
}

struct FriendRequest: Identifiable {
    let id = UUID()
    let username: String
    let displayName: String
    let mutualFriends: Int
}

enum FriendRequestAction {
    case accept
    case decline
}

#Preview {
    NavigationStack {
        FriendsView()
    }
    .preferredColorScheme(.dark)
}