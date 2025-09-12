//
//  GroupsView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct GroupsView: View {
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
            NavigationStack {
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
                }
            }
            .navigationTitle("Crew")
            .navigationBarTitleDisplayMode(.large)
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
            
            // Header Gradient Fade
            VStack {
                LinearGradient(
                    colors: [.black, .black.opacity(0.4), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                .allowsHitTesting(false)
                
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
        }
    }
    
    private func setupMockData() {
        let mockUser1 = User(username: "alex_nightlife", displayName: "Alex Chen")
        let mockUser2 = User(username: "party_sarah", displayName: "Sarah K")
        let mockUser3 = User(username: "dj_mike", displayName: "Mike DJ")
        
        let venue = LocationManager.createMockVenues().first!
        
        partyGroups = [
            PartyGroup(
                name: "Friday Night Crew",
                members: [mockUser1, mockUser2, mockUser3],
                venue: venue,
                chatMessages: [
                    ChatMessage(content: "Let's meet at the bar!", sender: mockUser1),
                    ChatMessage(content: "I'm here already 🔥", sender: mockUser2)
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
                
                // Quick Chat (Placeholder)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Chat")
                        .font(RAVEFont.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 8) {
                        ForEach(group.chatMessages) { message in
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

#Preview {
    GroupsView()
        .preferredColorScheme(.dark)
}