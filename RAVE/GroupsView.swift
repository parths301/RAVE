//
//  GroupsView.swift
//  Venues - Social Venue Discovery
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct GroupsView: View {
    var body: some View {
        NavigationStack {
            GroupsViewContent()
                .appleNavigation(title: "Groups")
        }
    }
}

struct GroupsViewContent: View {
    @State private var groups: [VenueGroup] = []
    @State private var showingCreateGroup = false

    var body: some View {
        Group {
            if groups.isEmpty {
                AppleEmptyStateView(
                    title: "No groups",
                    subtitle: "Create or join groups to connect with others",
                    systemImage: "person.3",
                    action: { showingCreateGroup = true },
                    actionTitle: "Create Group"
                )
            } else {
                List(groups) { group in
                    NavigationLink(destination: AppleGroupDetailView(group: group)) {
                        AppleGroupRowView(group: group)
                    }
                }
                .appleListStyle()
            }
        }
        .background(Color.appBackground)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingCreateGroup = true }) {
                    Image(systemName: "plus")
                }
                .appleAccessibility(label: "Create group", traits: .isButton)
            }
        }
        .sheet(isPresented: $showingCreateGroup) {
            AppleCreateGroupView()
        }
        .onAppear {
            setupMockData()
        }
    }

    private func setupMockData() {
        groups = [
            VenueGroup(
                id: UUID(),
                name: "Friday Night Crew",
                description: "Regular group for Friday night venues",
                memberCount: 8,
                isActive: true,
                category: .social
            ),
            VenueGroup(
                id: UUID(),
                name: "Music Lovers",
                description: "For those who love live music venues",
                memberCount: 15,
                isActive: false,
                category: .music
            )
        ]
    }
}

// MARK: - Apple-Compliant Group Row
struct AppleGroupRowView: View {
    let group: VenueGroup

    var body: some View {
        HStack(spacing: AppleSpacing.medium) {
            // Group Category Icon
            Image(systemName: group.category.systemImage)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(group.category.color)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: AppleSpacing.xs) {
                Text(group.name)
                    .font(AppleFont.headline)
                    .foregroundColor(.primary)

                Text(group.description)
                    .font(AppleFont.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack(spacing: AppleSpacing.medium) {
                    HStack(spacing: AppleSpacing.xs) {
                        Image(systemName: "person.2")
                            .font(.caption)
                        Text("\(group.memberCount) members")
                            .font(AppleFont.footnote)
                    }
                    .foregroundColor(.secondary)

                    if group.isActive {
                        HStack(spacing: AppleSpacing.xs) {
                            Circle()
                                .fill(Color.appGreen)
                                .frame(width: 6, height: 6)
                            Text("Active")
                                .font(AppleFont.footnote)
                        }
                        .foregroundColor(.appGreen)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, AppleSpacing.small)
        .appleAccessibility(
            label: "\(group.name), \(group.memberCount) members",
            hint: "Tap to view group details"
        )
    }
}

// MARK: - Apple Group Detail View
struct AppleGroupDetailView: View {
    let group: VenueGroup
    @State private var showingChat = false

    var body: some View {
        List {
            AppleFormSection(title: "Group Info") {
                HStack {
                    Text("Description")
                    Spacer()
                    Text(group.description)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Members")
                    Spacer()
                    Text("\(group.memberCount)")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Status")
                    Spacer()
                    Text(group.isActive ? "Active" : "Inactive")
                        .foregroundColor(group.isActive ? .appGreen : .secondary)
                }
            }

            AppleFormSection(title: "Actions") {
                Button("Open Chat") {
                    showingChat = true
                }
                .applePrimaryButton()

                Button("Invite Members") {
                    // Invite members action
                }
                .appleSecondaryButton()
            }
        }
        .appleListStyle()
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingChat) {
            AppleGroupChatView(group: group)
        }
    }
}

// MARK: - Apple Create Group View
struct AppleCreateGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var groupName = ""
    @State private var groupDescription = ""
    @State private var selectedCategory: GroupCategory = .social

    var body: some View {
        NavigationStack {
            List {
                AppleFormSection(title: "Group Details") {
                    AppleTextField(title: "Name", text: $groupName, placeholder: "Enter group name")
                    AppleTextField(title: "Description", text: $groupDescription, placeholder: "Enter group description")
                }

                AppleFormSection(title: "Category") {
                    AppleSegmentedPicker(
                        selection: $selectedCategory,
                        options: GroupCategory.allCases.map { ($0, $0.displayName) }
                    )
                }
            }
            .appleListStyle()
            .navigationTitle("Create Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .applePlainButton()
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        // Create group action
                        dismiss()
                    }
                    .applePrimaryButton()
                    .disabled(groupName.isEmpty)
                }
            }
        }
    }
}

// MARK: - Apple Group Chat View
struct AppleGroupChatView: View {
    let group: VenueGroup
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Messages List
                List(messages) { message in
                    AppleChatMessageView(message: message)
                        .listRowSeparator(.hidden)
                }
                .appleListStyle()

                // Message Input
                HStack(spacing: AppleSpacing.small) {
                    TextField("Message", text: $messageText)
                        .textFieldStyle(.roundedBorder)

                    Button("Send") {
                        sendMessage()
                    }
                    .applePrimaryButton()
                    .disabled(messageText.isEmpty)
                }
                .padding(AppleSpacing.standardPadding)
                .background(Color.appSecondaryBackground)
            }
            .navigationTitle(group.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .applePlainButton()
                }
            }
        }
        .onAppear {
            setupMockMessages()
        }
    }

    private func sendMessage() {
        let newMessage = ChatMessage(
            id: UUID(),
            text: messageText,
            sender: "You",
            timestamp: Date(),
            isFromCurrentUser: true
        )
        messages.append(newMessage)
        messageText = ""
    }

    private func setupMockMessages() {
        messages = [
            ChatMessage(
                id: UUID(),
                text: "Anyone going out tonight?",
                sender: "Alex",
                timestamp: Date().addingTimeInterval(-3600),
                isFromCurrentUser: false
            ),
            ChatMessage(
                id: UUID(),
                text: "I'm thinking of checking out the new venue downtown",
                sender: "Sarah",
                timestamp: Date().addingTimeInterval(-1800),
                isFromCurrentUser: false
            )
        ]
    }
}

// MARK: - Apple Chat Message View
struct AppleChatMessageView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
            }

            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: AppleSpacing.xs) {
                if !message.isFromCurrentUser {
                    Text(message.sender)
                        .font(AppleFont.footnote)
                        .foregroundColor(.secondary)
                }

                Text(message.text)
                    .font(AppleFont.body)
                    .foregroundColor(message.isFromCurrentUser ? .white : .primary)
                    .padding(AppleSpacing.small)
                    .background(message.isFromCurrentUser ? Color.appPrimary : Color.appTertiaryBackground)
                    .cornerRadius(12)

                Text(message.timestamp, style: .time)
                    .font(AppleFont.caption2)
                    .foregroundColor(.secondary)
            }

            if !message.isFromCurrentUser {
                Spacer()
            }
        }
        .padding(.vertical, AppleSpacing.xs)
    }
}

// MARK: - Data Models
struct VenueGroup: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let memberCount: Int
    let isActive: Bool
    let category: GroupCategory
}

enum GroupCategory: String, CaseIterable {
    case social = "social"
    case music = "music"
    case dining = "dining"
    case nightlife = "nightlife"

    var displayName: String {
        switch self {
        case .social: return "Social"
        case .music: return "Music"
        case .dining: return "Dining"
        case .nightlife: return "Nightlife"
        }
    }

    var systemImage: String {
        switch self {
        case .social: return "person.3"
        case .music: return "music.note"
        case .dining: return "fork.knife"
        case .nightlife: return "moon.stars"
        }
    }

    var color: Color {
        switch self {
        case .social: return .appPrimary
        case .music: return .appPurple
        case .dining: return .appOrange
        case .nightlife: return .appIndigo
        }
    }
}


#Preview("Groups View") {
    GroupsView()
        .preferredColorScheme(.dark)
}