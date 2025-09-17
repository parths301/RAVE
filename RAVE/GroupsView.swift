//
//  GroupsView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct GroupsView: View {
    var body: some View {
        NavigationStack {
            GroupsViewContent()
        }
    }
}

struct GroupsViewContent: View {
    @State private var partyGroups: [PartyGroup] = []
    @State private var showCreateCrew = false
    
    var body: some View {
        ZStack {
            // Background Layer
            Color.deepBackground
                .ignoresSafeArea(.all)
            
            if PerformanceOptimizer.shouldShowParticles() {
                ParticleView(
                    count: PerformanceOptimizer.particleCount(defaultCount: 15), 
                    color: .ravePurple.opacity(0.2)
                )
                .ignoresSafeArea(.all)
                .allowsHitTesting(false)
            }
            
            // Content Layer
            if partyGroups.isEmpty {
                RAVEEmptyStateView(
                    title: "No Party Crews",
                    subtitle: "Join or create a crew to start connecting with people at venues",
                    systemImage: "person.3"
                )
            } else {
                List(partyGroups) { group in
                    NavigationLink(destination: CrewDetailView(group: group)) {
                        PartyGroupRowView(group: group)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 100)
                }
            }
            
            // Header Gradient Fade
            VStack {
                LinearGradient(
                    colors: [.black.opacity(0.8), .black.opacity(0.6), .black.opacity(0.4), .black.opacity(0.2), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 80)
                .allowsHitTesting(false)

                Spacer()
            }
            .ignoresSafeArea(edges: .top)
        }
        .navigationTitle("Crew")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showCreateCrew = true }) {
                    Image(systemName: "plus")
                        .foregroundColor(.ravePurple)
                }
            }
        }
        .sheet(isPresented: $showCreateCrew) {
            CreateCrewView()
        }
        .onAppear {
            setupMockData()
        }
    }
    
    private func setupMockData() {
        let mockUser1 = User(username: "alex_nightlife", displayName: "Alex Chen")
        let mockUser2 = User(username: "party_sarah", displayName: "Sarah K")
        let mockUser3 = User(username: "dj_mike", displayName: "Mike DJ")
        let mockUser4 = User(username: "emma_beats", displayName: "Emma B")
        let mockUser5 = User(username: "carlos_rave", displayName: "Carlos R")
        let mockUser6 = User(username: "nina_dance", displayName: "Nina D")
        let mockUser7 = User(username: "tyler_night", displayName: "Tyler N")
        let mockUser8 = User(username: "zoe_music", displayName: "Zoe M")
        
        let venues = LocationManager.createMockVenues()
        
        partyGroups = [
            PartyGroup(
                name: "Friday Night Crew",
                members: [mockUser1, mockUser2, mockUser3],
                venue: venues[0],
                chatMessages: [
                    ChatMessage(content: "Let's meet at the bar!", sender: mockUser1),
                    ChatMessage(content: "I'm here already 🔥", sender: mockUser2),
                    ChatMessage(content: "Save me a spot!", sender: mockUser3)
                ]
            ),
            PartyGroup(
                name: "Weekend Warriors",
                members: [mockUser4, mockUser5, mockUser6, mockUser7],
                venue: venues[1],
                chatMessages: [
                    ChatMessage(content: "This DJ is amazing! 🎵", sender: mockUser4),
                    ChatMessage(content: "Dancing on the rooftop!", sender: mockUser5),
                    ChatMessage(content: "Best night ever!", sender: mockUser6)
                ]
            ),
            PartyGroup(
                name: "Night Owls",
                members: [mockUser8, mockUser1, mockUser4],
                venue: venues[2],
                chatMessages: [
                    ChatMessage(content: "Late night vibes ✨", sender: mockUser8),
                    ChatMessage(content: "Who's ready for round 2?", sender: mockUser1)
                ]
            ),
            PartyGroup(
                name: "Techno Lovers",
                members: [mockUser2, mockUser3, mockUser5, mockUser6, mockUser7],
                venue: venues[3],
                chatMessages: [
                    ChatMessage(content: "This beat is insane! 🔊", sender: mockUser2),
                    ChatMessage(content: "Underground vibes", sender: mockUser3),
                    ChatMessage(content: "Found the perfect spot", sender: mockUser5)
                ]
            ),
            PartyGroup(
                name: "Rooftop Squad",
                members: [mockUser4, mockUser8],
                venue: venues[4],
                chatMessages: [
                    ChatMessage(content: "City lights are beautiful", sender: mockUser4),
                    ChatMessage(content: "Perfect weather tonight!", sender: mockUser8)
                ]
            )
        ]
    }
}

struct PartyGroupRowView: View {
    let group: PartyGroup
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(group.name)
                        .font(RAVEFont.headline)
                        .foregroundColor(.primary)
                    
                    Text(group.venue.name)
                        .font(RAVEFont.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(group.venue.primaryEmoji)
                    .font(.title2)
            }
            
            HStack {
                // Member avatars
                HStack(spacing: -8) {
                    ForEach(Array(group.members.prefix(3).enumerated()), id: \.element.id) { index, member in
                        Circle()
                            .fill(Color.ravePurple.opacity(0.3))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text(String(member.displayName.first ?? "?"))
                                    .font(RAVEFont.callout)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.deepBackground.opacity(0.6), lineWidth: 2)
                            )
                            .zIndex(Double(3 - index))
                    }
                    
                    if group.members.count > 3 {
                        Circle()
                            .fill(Color.cardBackground)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text("+\(group.members.count - 3)")
                                    .font(RAVEFont.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            )
                    }
                }
                
                Text("\(group.members.count) members")
                    .font(RAVEFont.footnote)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let lastMessage = group.chatMessages.last {
                    Text(lastMessage.content)
                        .font(RAVEFont.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
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

struct CreateCrewView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var crewName = ""
    @State private var selectedVenue: Venue?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Crew Name")
                        .font(RAVEFont.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter crew name", text: $crewName)
                        .font(RAVEFont.body)
                        .padding()
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.cardBackground)
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.thinMaterial.opacity(0.4))
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            }
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Venue")
                        .font(RAVEFont.headline)
                        .foregroundColor(.primary)
                    
                    if let venue = selectedVenue {
                        HStack {
                            Text(venue.primaryEmoji)
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(venue.name)
                                    .font(RAVEFont.callout)
                                    .foregroundColor(.primary)
                                
                                Text(venue.location)
                                    .font(RAVEFont.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button("Change") {
                                // TODO: Show venue picker
                            }
                            .raveGhostButton()
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
                    } else {
                        Button("Select Venue") {
                            selectedVenue = LocationManager.createMockVenues().first
                        }
                        .raveSecondaryButton()
                    }
                }
                
                Spacer()
                
                Button("Create Crew") {
                    dismiss()
                }
                .ravePrimaryButton()
                .disabled(crewName.isEmpty || selectedVenue == nil)
            }
            .padding(.horizontal, 10)
            .padding(.vertical)
            .navigationTitle("New Crew")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
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
        }
        .preferredColorScheme(.dark)
    }
}

struct CrewDetailView: View {
    let group: PartyGroup
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Crew Header
                VStack(alignment: .leading, spacing: 12) {
                    Text(group.name)
                        .font(RAVEFont.title)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(group.venue.primaryEmoji)
                            .font(.title)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(group.venue.name)
                                .font(RAVEFont.headline)
                                .foregroundColor(.primary)
                            
                            Text(group.venue.location)
                                .font(RAVEFont.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VibeBadge(status: group.venue.vibeStatus)
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
                
                // Members Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Members (\(group.members.count))")
                        .font(RAVEFont.headline)
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(group.members) { member in
                            HStack {
                                Circle()
                                    .fill(Color.ravePurple.opacity(0.3))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text(String(member.displayName.first ?? "?"))
                                            .font(RAVEFont.callout)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                    )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(member.displayName)
                                        .font(RAVEFont.callout)
                                        .foregroundColor(.primary)
                                    
                                    Text("@\(member.username)")
                                        .font(RAVEFont.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(8)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.cardBackground)
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.thinMaterial.opacity(0.4))
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.white.opacity(0.2), lineWidth: 0.5)
                                }
                            )
                        }
                    }
                }
                
                // Quick Chat (Clickable)
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Quick Chat")
                            .font(RAVEFont.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        NavigationLink(destination: CrewChatView(group: group)) {
                            HStack(spacing: 4) {
                                Text("View All")
                                    .font(RAVEFont.caption)
                                    .foregroundColor(.ravePurple)
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption2)
                                    .foregroundColor(.ravePurple)
                            }
                        }
                    }
                    
                    Button(action: {
                        // Navigation handled by NavigationLink above
                    }) {
                        VStack(spacing: 8) {
                            ForEach(group.chatMessages.prefix(2)) { message in
                                HStack {
                                    Text("@\(message.sender.username):")
                                        .font(RAVEFont.caption)
                                        .foregroundColor(.ravePurple)
                                    
                                    Text(message.content)
                                        .font(RAVEFont.caption)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                            }
                            
                            if group.chatMessages.count > 2 {
                                HStack {
                                    Text("+ \(group.chatMessages.count - 2) more messages")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    Spacer()
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
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle("Crew Details")
        .navigationBarTitleDisplayMode(.inline)
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
    }
}

struct CrewChatView: View {
    let group: PartyGroup
    @State private var messageText = ""
    @State private var messages: [ChatMessage]
    
    init(group: PartyGroup) {
        self.group = group
        self._messages = State(initialValue: group.chatMessages)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages List
            ScrollViewReader { proxy in
                List(messages) { message in
                    ChatBubbleView(message: message)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .onAppear {
                    if let lastMessage = messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            
            // Message Input
            HStack(spacing: 12) {
                TextField("Type a message...", text: $messageText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...4)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.ravePurple)
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
            }
            .padding()
            .background(Color.deepBackground)
        }
        .navigationTitle(group.name)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {}) {
                        Label("Add Members", systemImage: "person.badge.plus")
                    }
                    
                    Button(action: {}) {
                        Label("Plan RAVE", systemImage: "calendar.badge.plus")
                    }
                    
                    Button(action: {}) {
                        Label("Crew Settings", systemImage: "gearshape")
                    }
                    
                    Divider()
                    
                    Button(role: .destructive, action: {}) {
                        Label("Leave Crew", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.ravePurple)
                }
            }
        }
    }
    
    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }
        
        // Create a mock current user for demo
        let currentUser = User(username: "you", displayName: "You")
        let newMessage = ChatMessage(content: trimmedMessage, sender: currentUser)
        
        withAnimation(.easeInOut) {
            messages.append(newMessage)
        }
        
        messageText = ""
    }
}

struct ChatBubbleView: View {
    let message: ChatMessage
    
    // Mock current user check
    var isCurrentUser: Bool {
        message.sender.username == "you"
    }
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isCurrentUser {
                    Text("@\(message.sender.username)")
                        .font(.caption2)
                        .foregroundColor(.ravePurple)
                }
                
                Text(message.content)
                    .font(RAVEFont.body)
                    .foregroundColor(isCurrentUser ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(isCurrentUser ? .ravePurple : Color.cardBackground)
                    )
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !isCurrentUser {
                Spacer(minLength: 50)
            }
        }
    }
}

#Preview {
    GroupsView()
        .preferredColorScheme(.dark)
}