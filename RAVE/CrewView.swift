//
//  CrewView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct CrewView: View {
    var body: some View {
        NavigationStack {
            CrewViewContent()
                .appleNavigation(title: "Crew")
        }
    }
}

struct CrewNotificationsView: View {
    var body: some View {
        NavigationStack {
            CrewNotificationsContent()
                .navigationTitle("Crew")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CrewViewContent: View {
    @State private var crews: [VenueCrew] = []
    @State private var showingCreateCrew = false
    @State private var searchText = ""

    var filteredCrews: [VenueCrew] {
        if searchText.isEmpty {
            return crews
        } else {
            return crews.filter { crew in
                crew.name.localizedCaseInsensitiveContains(searchText) ||
                crew.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        Group {
                if filteredCrews.isEmpty {
                    if searchText.isEmpty {
                        AppleEmptyStateView(
                            title: "No crews",
                            subtitle: "Create or join crews to connect with others",
                            systemImage: "person.3",
                            action: { showingCreateCrew = true },
                            actionTitle: "Create Crew"
                        )
                    } else {
                        AppleEmptyStateView(
                            title: "No crews found",
                            subtitle: "Try adjusting your search terms",
                            systemImage: "magnifyingglass",
                            action: nil,
                            actionTitle: nil
                        )
                    }
                } else {
                    List(filteredCrews) { crew in
                        NavigationLink(destination: AppleCrewDetailView(crew: crew)) {
                            AppleCrewRowView(crew: crew)
                        }
                    }
                    .appleListStyle()
                }
            }
        .searchable(text: $searchText, prompt: "Search crews...")
        .background(Color.appBackground)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingCreateCrew = true }) {
                    Image(systemName: "plus")
                }
                .appleAccessibility(label: "Create crew", traits: .isButton)
            }
        }
        .sheet(isPresented: $showingCreateCrew) {
            AppleCreateCrewView()
        }
        .onAppear {
            setupMockData()
        }
    }

    private func setupMockData() {
        crews = [
            VenueCrew(
                id: UUID(),
                name: "Friday Night Crew",
                description: "Regular crew for Friday night venues",
                memberCount: 8,
                isActive: true,
                category: .social
            ),
            VenueCrew(
                id: UUID(),
                name: "Music Lovers",
                description: "For those who love live music venues",
                memberCount: 15,
                isActive: false,
                category: .music
            ),
            VenueCrew(
                id: UUID(),
                name: "Weekend Warriors",
                description: "Party crew for weekend adventures",
                memberCount: 12,
                isActive: true,
                category: .nightlife
            )
        ]
    }
}


// MARK: - Crew Notifications Content
struct CrewNotificationsContent: View {
    @State private var alerts: [CrewAlert] = []
    @State private var notificationsEnabled = false
    @State private var showingNotificationSettings = false

    var body: some View {
        VStack(spacing: 0) {
            // Buffer space for clean layout
            Rectangle()
                .fill(Color.clear)
                .frame(height: 20)

            Group {
                if alerts.isEmpty {
                    AppleEmptyStateView(
                        title: "No crew notifications",
                        subtitle: notificationsEnabled ? "You'll see crew updates and invites here" : "Enable notifications to stay updated",
                        systemImage: "bell",
                        action: notificationsEnabled ? nil : enableNotifications,
                        actionTitle: notificationsEnabled ? nil : "Enable Notifications"
                    )
                } else {
                    List {
                        ForEach(alerts) { alert in
                            AppleCrewAlertRowView(alert: alert)
                                .onTapGesture {
                                    markAsRead(alert)
                                }
                        }
                        .onDelete(perform: deleteAlerts)
                    }
                    .appleListStyle()
                }
            }
        }
        .background(Color.appBackground)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if !alerts.isEmpty {
                    Button("Clear All") {
                        clearAllAlerts()
                    }
                    .applePlainButton()
                }

                Button(action: { showingNotificationSettings = true }) {
                    Image(systemName: "gear")
                }
                .appleAccessibility(label: "Notification settings", traits: .isButton)
            }
        }
        .sheet(isPresented: $showingNotificationSettings) {
            AppleNotificationSettingsView()
        }
        .onAppear {
            setupMockAlerts()
            checkNotificationPermissions()
        }
    }

    private func enableNotifications() {
        // Implementation for enabling notifications
    }

    private func markAsRead(_ alert: CrewAlert) {
        // Implementation for marking as read
    }

    private func deleteAlerts(at offsets: IndexSet) {
        alerts.remove(atOffsets: offsets)
    }

    private func clearAllAlerts() {
        alerts.removeAll()
    }

    private func checkNotificationPermissions() {
        // Implementation for checking notification permissions
    }

    private func setupMockAlerts() {
        alerts = [
            CrewAlert(
                id: UUID(),
                title: "New Crew Invite",
                message: "Friday Night Crew invited you to join their crew",
                timestamp: Date().addingTimeInterval(-300),
                isRead: false,
                type: .crewInvite
            ),
            CrewAlert(
                id: UUID(),
                title: "Crew Activity",
                message: "Weekend Warriors are planning a venue visit tonight",
                timestamp: Date().addingTimeInterval(-1800),
                isRead: true,
                type: .crewActivity
            )
        ]
    }
}

// MARK: - Apple-Compliant Crew Row
struct AppleCrewRowView: View {
    let crew: VenueCrew

    var body: some View {
        HStack(spacing: AppleSpacing.medium) {
            // Crew Category Icon
            Image(systemName: crew.category.systemImage)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(crew.category.color)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: AppleSpacing.xs) {
                Text(crew.name)
                    .font(AppleFont.headline)
                    .foregroundColor(.primary)

                Text(crew.description)
                    .font(AppleFont.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack(spacing: AppleSpacing.medium) {
                    HStack(spacing: AppleSpacing.xs) {
                        Image(systemName: "person.2")
                            .font(.caption)
                        Text("\(crew.memberCount) members")
                            .font(AppleFont.footnote)
                    }
                    .foregroundColor(.secondary)

                    if crew.isActive {
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
            label: "\(crew.name), \(crew.memberCount) members",
            hint: "Tap to view crew details"
        )
    }
}

// MARK: - Apple Crew Detail View
struct AppleCrewDetailView: View {
    let crew: VenueCrew
    @State private var showingChat = false

    var body: some View {
        List {
            AppleFormSection(title: "Crew Info") {
                HStack {
                    Text("Description")
                    Spacer()
                    Text(crew.description)
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Members")
                    Spacer()
                    Text("\(crew.memberCount)")
                        .foregroundColor(.secondary)
                }

                HStack {
                    Text("Status")
                    Spacer()
                    Text(crew.isActive ? "Active" : "Inactive")
                        .foregroundColor(crew.isActive ? .appGreen : .secondary)
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
        .navigationTitle(crew.name)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingChat) {
            AppleCrewChatView(crew: crew)
        }
    }
}

// MARK: - Apple Create Crew View
struct AppleCreateCrewView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var crewName = ""
    @State private var crewDescription = ""
    @State private var selectedCategory: CrewCategory = .social
    @State private var showingFriendSelection = false
    @State private var selectedFriends: Set<CrewFriend> = []

    var body: some View {
        NavigationStack {
            List {
                AppleFormSection(title: "Crew Details") {
                    AppleTextField(title: "Name", text: $crewName, placeholder: "Enter crew name")
                    AppleTextField(title: "Description", text: $crewDescription, placeholder: "Enter crew description")
                }

                AppleFormSection(title: "Category") {
                    AppleSegmentedPicker(
                        selection: $selectedCategory,
                        options: CrewCategory.allCases.map { ($0, $0.displayName) }
                    )
                }

                AppleFormSection(title: "Members") {
                    Button(action: { showingFriendSelection = true }) {
                        HStack {
                            Text("Add Friends")
                            Spacer()
                            Text("\(selectedFriends.count) selected")
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .appleListStyle()
            .navigationTitle("Create Crew")
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
                        // Create crew action
                        dismiss()
                    }
                    .applePrimaryButton()
                    .disabled(crewName.isEmpty)
                }
            }
        }
        .sheet(isPresented: $showingFriendSelection) {
            FriendSelectionView(selectedFriends: $selectedFriends)
        }
    }
}

// MARK: - Friend Selection View
struct FriendSelectionView: View {
    @Binding var selectedFriends: Set<CrewFriend>
    @Environment(\.dismiss) private var dismiss
    @State private var friends: [CrewFriend] = []
    @State private var searchText = ""

    var filteredFriends: [CrewFriend] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredFriends) { friend in
                HStack {
                    AsyncImage(url: URL(string: friend.avatarURL)) { image in
                        image.resizable()
                    } placeholder: {
                        Circle()
                            .fill(.gray.opacity(0.3))
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())

                    Text(friend.name)
                        .font(.body)

                    Spacer()

                    if selectedFriends.contains(friend) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.neonPurple)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedFriends.contains(friend) {
                        selectedFriends.remove(friend)
                    } else {
                        selectedFriends.insert(friend)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search Friends")
            .navigationTitle("Select Friends")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            setupMockFriends()
        }
    }

    private func setupMockFriends() {
        friends = [
            CrewFriend(id: UUID(), name: "Alex Chen", username: "@alexc", avatarURL: ""),
            CrewFriend(id: UUID(), name: "Sarah Johnson", username: "@sarahj", avatarURL: ""),
            CrewFriend(id: UUID(), name: "Mike Torres", username: "@miket", avatarURL: ""),
            CrewFriend(id: UUID(), name: "Emma Wilson", username: "@emmaw", avatarURL: "")
        ]
    }
}

// MARK: - Apple Crew Chat View
struct AppleCrewChatView: View {
    let crew: VenueCrew
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Messages List
                List(messages) { message in
                    AppleCrewChatMessageView(message: message)
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
            .navigationTitle(crew.name)
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

// MARK: - Apple Crew Chat Message View
struct AppleCrewChatMessageView: View {
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

// MARK: - Crew Alert Row View
struct AppleCrewAlertRowView: View {
    let alert: CrewAlert

    var body: some View {
        HStack(spacing: 16) {
            // Alert Icon
            Image(systemName: alert.type.icon)
                .font(.title3)
                .foregroundStyle(alert.type.color)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(alert.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(alert.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(alert.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            if !alert.isRead {
                Circle()
                    .fill(Color.neonPurple)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Data Models
struct VenueCrew: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let memberCount: Int
    let isActive: Bool
    let category: CrewCategory
}

struct CrewFriend: Identifiable, Hashable {
    let id: UUID
    let name: String
    let username: String
    let avatarURL: String

    static func == (lhs: CrewFriend, rhs: CrewFriend) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CrewAlert: Identifiable {
    let id: UUID
    let title: String
    let message: String
    let timestamp: Date
    let isRead: Bool
    let type: CrewAlertType
}

enum CrewAlertType {
    case crewInvite
    case crewActivity
    case venueAlert

    var icon: String {
        switch self {
        case .crewInvite: return "person.badge.plus"
        case .crewActivity: return "person.3"
        case .venueAlert: return "location.badge.waveform"
        }
    }

    var color: Color {
        switch self {
        case .crewInvite: return Color.neonPurple
        case .crewActivity: return .blue
        case .venueAlert: return .orange
        }
    }
}

enum CrewCategory: String, CaseIterable {
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

#Preview("Crew View") {
    CrewView()
        .preferredColorScheme(.dark)
}

#Preview("Crew Notifications") {
    CrewNotificationsView()
        .preferredColorScheme(.dark)
}