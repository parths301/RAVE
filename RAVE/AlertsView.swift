//
//  AlertsView.swift
//  Venues - Social Venue Discovery
//
//  Created by Claude on 12/09/25.
//

import SwiftUI
import UserNotifications

struct AlertsView: View {
    var body: some View {
        NavigationStack {
            AlertsViewContent()
                .appleNavigation(title: "Notifications")
        }
    }
}

struct AlertsViewContent: View {
    @State private var alerts: [VenueAlert] = []
    @State private var notificationsEnabled = false
    @State private var showingNotificationSettings = false

    var body: some View {
        Group {
            if alerts.isEmpty {
                AppleEmptyStateView(
                    title: "No notifications",
                    subtitle: notificationsEnabled ? "You'll see notifications about venues and groups here" : "Enable notifications to stay updated",
                    systemImage: "bell",
                    action: notificationsEnabled ? nil : enableNotifications,
                    actionTitle: notificationsEnabled ? nil : "Enable Notifications"
                )
            } else {
                List {
                    ForEach(alerts) { alert in
                        AppleAlertRowView(alert: alert)
                            .onTapGesture {
                                markAsRead(alert)
                            }
                    }
                    .onDelete(perform: deleteAlerts)
                }
                .appleListStyle()
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
            setupMockData()
            checkNotificationPermissions()
        }
    }

    private func setupMockData() {
        let venue = LocationManager.createMockVenues().first!

        alerts = [
            VenueAlert(
                id: UUID(),
                title: "Venue Activity",
                message: "Neon Nights has high activity right now",
                venue: venue,
                timestamp: Date().addingTimeInterval(-300),
                type: .venueActivity,
                isRead: false
            ),
            VenueAlert(
                id: UUID(),
                title: "Group Invitation",
                message: "Alex invited you to join Friday Night Crew",
                venue: LocationManager.createMockVenues()[1],
                timestamp: Date().addingTimeInterval(-1800),
                type: .groupInvite,
                isRead: true
            ),
            VenueAlert(
                id: UUID(),
                title: "Venue Update",
                message: "Bass Drop is approaching peak capacity",
                venue: LocationManager.createMockVenues()[2],
                timestamp: Date().addingTimeInterval(-3600),
                type: .venueAlert,
                isRead: true
            )
        ]
    }

    private func checkNotificationPermissions() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationsEnabled = settings.authorizationStatus == .authorized
            }
        }
    }

    private func enableNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                notificationsEnabled = granted
            }
        }
    }

    private func markAsRead(_ alert: VenueAlert) {
        if let index = alerts.firstIndex(where: { $0.id == alert.id }) {
            alerts[index].isRead = true
        }
    }

    private func deleteAlerts(at offsets: IndexSet) {
        alerts.remove(atOffsets: offsets)
    }

    private func clearAllAlerts() {
        alerts.removeAll()
    }
}

// MARK: - Apple-Compliant Alert Row
struct AppleAlertRowView: View {
    let alert: VenueAlert

    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: alert.timestamp, relativeTo: Date())
    }

    var body: some View {
        HStack(spacing: AppleSpacing.medium) {
            // Alert Type Icon
            Image(systemName: alert.type.systemImage)
                .font(.title3)
                .foregroundColor(alert.type.color)
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: AppleSpacing.xs) {
                HStack {
                    Text(alert.title)
                        .font(AppleFont.headline)
                        .fontWeight(alert.isRead ? .regular : .semibold)
                        .foregroundColor(.primary)

                    Spacer()

                    if !alert.isRead {
                        Circle()
                            .fill(Color.appPrimary)
                            .frame(width: 8, height: 8)
                    }
                }

                Text(alert.message)
                    .font(AppleFont.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)

                HStack {
                    if let venue = alert.venue {
                        Text(venue.name)
                            .font(AppleFont.footnote)
                            .foregroundColor(.appPrimary)
                    }

                    Spacer()

                    Text(timeAgo)
                        .font(AppleFont.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, AppleSpacing.xs)
        .appleAccessibility(
            label: "\(alert.title): \(alert.message)",
            hint: alert.isRead ? "Alert" : "Unread alert, tap to mark as read"
        )
    }
}

// MARK: - Apple Notification Settings
struct AppleNotificationSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var venueActivityEnabled = true
    @State private var groupInvitesEnabled = true
    @State private var venueAlertsEnabled = true

    var body: some View {
        NavigationStack {
            List {
                AppleFormSection(
                    title: "Notification Types",
                    footer: "Choose which types of notifications you want to receive"
                ) {
                    AppleToggle(
                        "Venue Activity",
                        subtitle: "Get notified when venues are busy",
                        isOn: $venueActivityEnabled
                    )

                    AppleToggle(
                        "Group Invitations",
                        subtitle: "Receive invitations to join groups",
                        isOn: $groupInvitesEnabled
                    )

                    AppleToggle(
                        "Venue Alerts",
                        subtitle: "Important venue updates and capacity warnings",
                        isOn: $venueAlertsEnabled
                    )
                }
            }
            .appleListStyle()
            .navigationTitle("Notification Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .applePrimaryButton()
                }
            }
        }
    }
}

// MARK: - Data Models
struct VenueAlert: Identifiable {
    let id: UUID
    let title: String
    let message: String
    let venue: Venue?
    let timestamp: Date
    let type: AlertType
    var isRead: Bool

    enum AlertType {
        case venueActivity
        case groupInvite
        case venueAlert

        var systemImage: String {
            switch self {
            case .venueActivity: return "flame"
            case .groupInvite: return "person.2"
            case .venueAlert: return "exclamationmark.triangle"
            }
        }

        var color: Color {
            switch self {
            case .venueActivity: return .appOrange
            case .groupInvite: return .appPrimary
            case .venueAlert: return .appYellow
            }
        }
    }
}

#Preview("Alerts View") {
    AlertsView()
        .preferredColorScheme(.dark)
}