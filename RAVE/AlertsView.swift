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
        ZStack {
            // Background Layer
            Color.deepBackground
                .ignoresSafeArea(.all)
            
            if PerformanceOptimizer.shouldShowParticles() {
                ParticleView(
                    count: PerformanceOptimizer.particleCount(defaultCount: 20), 
                    color: .ravePurple.opacity(0.2)
                )
                .ignoresSafeArea(.all)
                .allowsHitTesting(false)
            }
            
            // Content Layer
            NavigationStack {
                if alerts.isEmpty {
                    RAVEEmptyStateView(
                        title: "No Alerts",
                        subtitle: notificationsEnabled ? "We'll notify you when the nightlife heats up!" : "Enable notifications to get venue alerts",
                        systemImage: "bell"
                    )
                } else {
                    VStack(spacing: 0) {
                        List(alerts) { alert in
                            AlertRowView(alert: alert)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        
                        // Clear All Button at Bottom
                        VStack(spacing: 16) {
                            Rectangle()
                                .fill(.white.opacity(0.1))
                                .frame(height: 0.5)
                                .padding(.horizontal)
                            
                            Button(action: clearAllNotifications) {
                                HStack(spacing: 12) {
                                    Image(systemName: "trash.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                    Text("Clear All Alerts")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.red.opacity(0.1))
                                        
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(.regularMaterial.opacity(0.3))
                                        
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.red.opacity(0.3), lineWidth: 1)
                                    }
                                )
                                .foregroundColor(.red)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 30)
                        }
                        .background(Color.deepBackground)
                    }
                }
            }
            .navigationTitle("Alerts")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: toggleNotifications) {
                            Label(notificationsEnabled ? "Disable Notifications" : "Enable Notifications", 
                                  systemImage: notificationsEnabled ? "bell.slash" : "bell.fill")
                        }
                        
                        if !alerts.isEmpty {
                            Button(action: clearAllNotifications) {
                                Label("Clear All", systemImage: "trash")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.ravePurple)
                    }
                }
            }
            .onAppear {
                setupMockData()
                checkNotificationPermissions()
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
            ),
            RaveAlert(
                id: UUID(),
                title: "🎉 Weekend Special Event",
                message: "Electric Lounge is hosting a special DJ set tonight starting at 10 PM!",
                venue: LocationManager.createMockVenues()[3],
                timestamp: Date().addingTimeInterval(-7200), // 2 hours ago
                type: .venueActivity,
                isRead: false
            ),
            RaveAlert(
                id: UUID(),
                title: "👥 Crew Update",
                message: "Sarah left your crew 'Night Owls' and sent a message",
                venue: LocationManager.createMockVenues()[0],
                timestamp: Date().addingTimeInterval(-10800), // 3 hours ago
                type: .groupInvite,
                isRead: true
            ),
            RaveAlert(
                id: UUID(),
                title: "⏰ Last Call Warning",
                message: "Midnight Club will close in 30 minutes - wrap up your night!",
                venue: LocationManager.createMockVenues()[4],
                timestamp: Date().addingTimeInterval(-14400), // 4 hours ago
                type: .venueAlert,
                isRead: true
            ),
            RaveAlert(
                id: UUID(),
                title: "🎵 New Playlist Alert",
                message: "Rhythm Rooftop just updated their weekend playlist with fresh beats",
                venue: LocationManager.createMockVenues()[1],
                timestamp: Date().addingTimeInterval(-18000), // 5 hours ago
                type: .systemAlert,
                isRead: false
            ),
            RaveAlert(
                id: UUID(),
                title: "💫 VIP Access Available",
                message: "Upgrade to VIP access at Starlight Lounge - limited spots remaining!",
                venue: LocationManager.createMockVenues()[2],
                timestamp: Date().addingTimeInterval(-21600), // 6 hours ago
                type: .venueActivity,
                isRead: true
            ),
            RaveAlert(
                id: UUID(),
                title: "🍸 Happy Hour Extended",
                message: "Sky Bar extended happy hour until 8 PM - don't miss out on half-price cocktails!",
                venue: LocationManager.createMockVenues()[3],
                timestamp: Date().addingTimeInterval(-25200), // 7 hours ago
                type: .venueAlert,
                isRead: false
            ),
            RaveAlert(
                id: UUID(),
                title: "🌟 New Venue Opening",
                message: "Cosmic Club is opening tonight! Be among the first to experience the newest hotspot",
                venue: LocationManager.createMockVenues()[4],
                timestamp: Date().addingTimeInterval(-28800), // 8 hours ago
                type: .systemAlert,
                isRead: true
            ),
            RaveAlert(
                id: UUID(),
                title: "🎭 Theme Night Alert",
                message: "Retro Night at Groove Palace - dress code: 80s style! Prize for best outfit",
                venue: LocationManager.createMockVenues()[0],
                timestamp: Date().addingTimeInterval(-32400), // 9 hours ago
                type: .venueActivity,
                isRead: false
            ),
            RaveAlert(
                id: UUID(),
                title: "🔊 Sound System Upgrade",
                message: "Bass Temple just installed new speakers - experience the ultimate sound quality!",
                venue: LocationManager.createMockVenues()[1],
                timestamp: Date().addingTimeInterval(-36000), // 10 hours ago
                type: .systemAlert,
                isRead: true
            ),
            RaveAlert(
                id: UUID(),
                title: "💎 Member Benefits",
                message: "You've earned premium status! Enjoy skip-the-line access at participating venues",
                venue: nil,
                timestamp: Date().addingTimeInterval(-39600), // 11 hours ago
                type: .systemAlert,
                isRead: false
            ),
            RaveAlert(
                id: UUID(),
                title: "🚨 Weather Alert",
                message: "Outdoor venues may close early due to incoming rain - check with venues directly",
                venue: nil,
                timestamp: Date().addingTimeInterval(-43200), // 12 hours ago
                type: .systemAlert,
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
    
    private func clearAllNotifications() {
        withAnimation(.easeInOut(duration: 0.3)) {
            alerts.removeAll()
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
                .background(
                    ZStack {
                        Circle().fill(alert.type.iconColor.opacity(0.2))
                        Circle().fill(.thinMaterial.opacity(0.3))
                        Circle().stroke(.white.opacity(0.1), lineWidth: 0.5)
                    }
                )
            
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
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(alert.isRead ? Color.cardBackground.opacity(0.6) : Color.cardBackground)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial.opacity(alert.isRead ? 0.3 : 0.5))
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }
        )
        .padding(.horizontal, 10)
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