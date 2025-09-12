//
//  AlertsView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI
import UserNotifications

struct AlertsView: View {
    @State private var alerts: [RaveAlert] = []
    @State private var notificationsEnabled = false
    
    var body: some View {
        NavigationStack {
            if alerts.isEmpty {
                RAVEEmptyStateView(
                    title: "No Alerts",
                    subtitle: notificationsEnabled ? "We'll notify you when the nightlife heats up!" : "Enable notifications to get venue alerts",
                    systemImage: "bell"
                )
                .background(Color.darkBackground.ignoresSafeArea())
            } else {
                List(alerts) { alert in
                    AlertRowView(alert: alert)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.darkBackground.ignoresSafeArea())
            }
        }
        .navigationTitle("Alerts")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleNotifications) {
                    Image(systemName: notificationsEnabled ? "bell.fill" : "bell.slash")
                        .foregroundColor(.ravePurple)
                }
            }
        }
        .onAppear {
            setupMockData()
            checkNotificationPermissions()
        }
    }
    
    private func setupMockData() {
        let venue = LocationManager.createMockVenues().first!
        
        alerts = [
            RaveAlert(
                id: UUID(),
                title: "🔥 Venue Heating Up",
                message: "Neon Nights just got 15 new check-ins in the last hour!",
                venue: venue,
                timestamp: Date().addingTimeInterval(-300), // 5 minutes ago
                type: .venueActivity,
                isRead: false
            ),
            RaveAlert(
                id: UUID(),
                title: "💃 New Group Invite",
                message: "Alex invited you to join 'Friday Night Crew' at The Purple Room",
                venue: LocationManager.createMockVenues()[1],
                timestamp: Date().addingTimeInterval(-1800), // 30 minutes ago
                type: .groupInvite,
                isRead: true
            ),
            RaveAlert(
                id: UUID(),
                title: "⚡ Venue Peak Hours",
                message: "Bass Drop is approaching peak capacity - arrive soon!",
                venue: LocationManager.createMockVenues()[2],
                timestamp: Date().addingTimeInterval(-3600), // 1 hour ago
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
    
    private func toggleNotifications() {
        if notificationsEnabled {
            // Show settings alert to disable
        } else {
            requestNotificationPermission()
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                notificationsEnabled = granted
            }
        }
    }
}

struct RaveAlert: Identifiable {
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
        case systemAlert
        
        var icon: String {
            switch self {
            case .venueActivity:
                return "flame.fill"
            case .groupInvite:
                return "person.2.fill"
            case .venueAlert:
                return "exclamationmark.triangle.fill"
            case .systemAlert:
                return "info.circle.fill"
            }
        }
        
        var iconColor: Color {
            switch self {
            case .venueActivity:
                return .orange
            case .groupInvite:
                return .ravePurple
            case .venueAlert:
                return .yellow
            case .systemAlert:
                return .blue
            }
        }
    }
}

struct AlertRowView: View {
    @State var alert: RaveAlert
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: alert.timestamp, relativeTo: Date())
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Alert Icon
            Image(systemName: alert.type.icon)
                .font(.title3)
                .foregroundColor(alert.type.iconColor)
                .frame(width: 32, height: 32)
                .background(alert.type.iconColor.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(alert.title)
                        .font(RAVEFont.callout)
                        .fontWeight(alert.isRead ? .medium : .semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if !alert.isRead {
                        Circle()
                            .fill(Color.ravePurple)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Text(alert.message)
                    .font(RAVEFont.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                HStack {
                    if let venue = alert.venue {
                        HStack(spacing: 4) {
                            Text(venue.primaryEmoji)
                                .font(.caption)
                            
                            Text(venue.name)
                                .font(RAVEFont.caption)
                                .foregroundColor(.ravePurple)
                        }
                    }
                    
                    Spacer()
                    
                    Text(timeAgo)
                        .font(RAVEFont.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(alert.isRead ? Color.cardBackground.opacity(0.6) : Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
        .padding(.vertical, 4)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                alert.isRead = true
            }
        }
        .contextMenu {
            Button(action: {
                alert.isRead.toggle()
            }) {
                Label(alert.isRead ? "Mark as Unread" : "Mark as Read", 
                      systemImage: alert.isRead ? "envelope.badge" : "envelope.open")
            }
            
            if alert.venue != nil {
                Button(action: {
                    // TODO: Navigate to venue
                }) {
                    Label("View Venue", systemImage: "location")
                }
            }
            
            Button(role: .destructive, action: {
                // TODO: Delete alert
            }) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct NotificationSettingsView: View {
    @State private var venueActivityEnabled = true
    @State private var groupInvitesEnabled = true
    @State private var venueAlertsEnabled = true
    @State private var systemAlertsEnabled = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Notification Types") {
                    NotificationToggle(
                        title: "Venue Activity",
                        subtitle: "Get notified when venues are heating up",
                        icon: "flame.fill",
                        iconColor: .orange,
                        isEnabled: $venueActivityEnabled
                    )
                    
                    NotificationToggle(
                        title: "Group Invites",
                        subtitle: "Receive invitations to party groups",
                        icon: "person.2.fill",
                        iconColor: .ravePurple,
                        isEnabled: $groupInvitesEnabled
                    )
                    
                    NotificationToggle(
                        title: "Venue Alerts",
                        subtitle: "Important venue updates and capacity warnings",
                        icon: "exclamationmark.triangle.fill",
                        iconColor: .yellow,
                        isEnabled: $venueAlertsEnabled
                    )
                    
                    NotificationToggle(
                        title: "System Updates",
                        subtitle: "App updates and maintenance notifications",
                        icon: "info.circle.fill",
                        iconColor: .blue,
                        isEnabled: $systemAlertsEnabled
                    )
                }
                
                Section("Quiet Hours") {
                    HStack {
                        Text("Enable Quiet Hours")
                        Spacer()
                        Toggle("", isOn: .constant(false))
                            .tint(.ravePurple)
                    }
                    
                    HStack {
                        Text("From")
                        Spacer()
                        Text("2:00 AM")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("To")
                        Spacer()
                        Text("9:00 AM")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Notification Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NotificationToggle: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    @Binding var isEnabled: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(RAVEFont.callout)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(RAVEFont.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .tint(.ravePurple)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AlertsView()
        .preferredColorScheme(.dark)
}