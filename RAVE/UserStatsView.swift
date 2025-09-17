//
//  UserStatsView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct UserStatsView: View {
    @State private var selectedPeriod = StatsPeriod.thisMonth
    @State private var stats: UserStats = UserStats.mock()
    @State private var showingSettings = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Modern Period Selector with improved styling
                VStack(spacing: 16) {
                    HStack {
                        Text("Your Activity")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.primary)

                        Spacer()

                        Button(action: { showingSettings = true }) {
                            Image(systemName: "gearshape.fill")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                                .symbolRenderingMode(.hierarchical)
                        }
                        .accessibilityLabel("Settings")
                    }
                    .padding(.horizontal)

                    Picker("Stats Period", selection: $selectedPeriod) {
                        ForEach(StatsPeriod.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
                
                // Modern Stats Cards with iOS 17+ styling
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    StatsCardView(
                        title: "Venues Visited",
                        value: "\(stats.venuesVisited)",
                        icon: "location.fill",
                        iconColor: .appPrimary,
                        trend: stats.venuesTrend
                    )
                    
                    StatsCardView(
                        title: "Events Attended",
                        value: "\(stats.eventsAttended)",
                        icon: "calendar.badge.clock",
                        iconColor: .blue,
                        trend: stats.eventsTrend
                    )
                    
                    StatsCardView(
                        title: "Hours Out",
                        value: "\(stats.hoursOut)",
                        icon: "clock.fill",
                        iconColor: .orange,
                        trend: stats.hoursTrend
                    )
                    
                    StatsCardView(
                        title: "Crew Size",
                        value: "\(stats.crewSize)",
                        icon: "person.2.fill",
                        iconColor: .green,
                        trend: stats.crewTrend
                    )
                }
                .padding(.horizontal)
                
                // Modern Top Venues Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Top Venues")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary)

                        Spacer()

                        Button("View All") {
                            // Show all venues
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.blue)
                    }

                    VStack(spacing: 8) {
                        ForEach(Array(stats.topVenues.enumerated()), id: \.offset) { index, venue in
                            TopVenueRowView(venue: venue, rank: index + 1)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.quaternary, lineWidth: 0.5)
                )
                .padding(.horizontal)
                
                // Modern Activity Timeline
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Activity")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)

                    VStack(spacing: 12) {
                        ForEach(stats.recentActivities) { activity in
                            ActivityTimelineView(activity: activity)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.quaternary, lineWidth: 0.5)
                )
                .padding(.horizontal)
                
                // Modern Achievement Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Achievements")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(stats.achievements) { achievement in
                            AchievementBadgeView(achievement: achievement)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.quaternary, lineWidth: 0.5)
                )
                .padding(.horizontal)
                
                // Modern Music Preferences Chart
                VStack(alignment: .leading, spacing: 16) {
                    Text("Music Preferences")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)

                    VStack(spacing: 12) {
                        ForEach(stats.musicPreferences) { preference in
                            MusicPreferenceBarView(preference: preference)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.quaternary, lineWidth: 0.5)
                )
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingSettings) {
            StatsSettingsView()
        }
        .onChange(of: selectedPeriod) {
            updateStats()
        }
    }
    
    private func updateStats() {
        // Mock function to update stats based on selected period
        withAnimation(.easeInOut) {
            stats = UserStats.mock(for: selectedPeriod)
        }
    }
}

struct StatsCardView: View {
    let title: String
    let value: String
    let icon: String
    let iconColor: Color
    let trend: StatsTrend

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(iconColor.gradient)
                    .symbolRenderingMode(.hierarchical)

                Spacer()

                TrendIndicatorView(trend: trend)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(value)
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText())

                    Spacer()
                }

                HStack {
                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.quaternary, lineWidth: 0.5)
        )
    }
}

struct TrendIndicatorView: View {
    let trend: StatsTrend

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: trend.icon)
                .font(.caption)
                .foregroundStyle(trend.color)
                .symbolRenderingMode(.hierarchical)

            Text(trend.text)
                .font(.caption.weight(.medium))
                .foregroundStyle(trend.color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(trend.color.opacity(0.15))
        )
        .overlay(
            Capsule()
                .stroke(trend.color.opacity(0.3), lineWidth: 0.5)
        )
    }
}

struct TopVenueRowView: View {
    let venue: TopVenue
    let rank: Int

    var body: some View {
        HStack(spacing: 16) {
            // Modern Rank Badge
            ZStack {
                Circle()
                    .fill(rankColor.gradient)
                    .frame(width: 36, height: 36)
                    .shadow(color: rankColor.opacity(0.3), radius: 2, x: 0, y: 1)

                Text("\(rank)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
            }

            // Venue Info
            VStack(alignment: .leading, spacing: 4) {
                Text(venue.name)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)

                Text("\(venue.visits) visits")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Modern Progress Indicator
            VStack(alignment: .trailing, spacing: 6) {
                Text("\(Int(venue.percentage))%")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.blue)

                ProgressView(value: venue.percentage / 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .frame(width: 60)
                    .scaleEffect(y: 1.2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.quaternary.opacity(0.5))
        )
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .appPrimary
        }
    }
}

struct ActivityTimelineView: View {
    let activity: ActivityItem

    var body: some View {
        HStack(spacing: 16) {
            // Modern Activity Icon
            Circle()
                .fill(activity.type.color.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: activity.type.icon)
                        .font(.title3)
                        .foregroundStyle(activity.type.color.gradient)
                        .symbolRenderingMode(.hierarchical)
                )

            // Activity Details
            VStack(alignment: .leading, spacing: 6) {
                Text(activity.title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)

                Text(activity.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(activity.timeAgo)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.tertiary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct AchievementBadgeView: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.color.gradient.opacity(0.2))
                    .frame(width: 64, height: 64)
                    .overlay(
                        Circle()
                            .stroke(achievement.color.opacity(0.3), lineWidth: 1)
                    )

                Image(systemName: achievement.icon)
                    .font(.title2)
                    .foregroundStyle(achievement.color.gradient)
                    .symbolRenderingMode(.hierarchical)
            }

            Text(achievement.title)
                .font(.caption.weight(.medium))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.quaternary.opacity(0.5))
        )
    }
}

struct MusicPreferenceBarView: View {
    let preference: MusicPreference

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(preference.genre)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)

                Spacer()

                Text("\(Int(preference.percentage))%")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.blue)
            }

            ProgressView(value: preference.percentage / 100)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .background(.quaternary, in: Capsule())
                .scaleEffect(y: 1.5)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Models and Data

enum StatsPeriod: String, CaseIterable {
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case thisYear = "This Year"
    case allTime = "All Time"
}

struct UserStats {
    let venuesVisited: Int
    let eventsAttended: Int
    let hoursOut: Int
    let crewSize: Int
    let venuesTrend: StatsTrend
    let eventsTrend: StatsTrend
    let hoursTrend: StatsTrend
    let crewTrend: StatsTrend
    let topVenues: [TopVenue]
    let recentActivities: [ActivityItem]
    let achievements: [Achievement]
    let musicPreferences: [MusicPreference]
    
    static func mock(for period: StatsPeriod = .thisMonth) -> UserStats {
        let multiplier: Double = {
            switch period {
            case .thisWeek: return 0.25
            case .thisMonth: return 1.0
            case .thisYear: return 12.0
            case .allTime: return 24.0
            }
        }()
        
        return UserStats(
            venuesVisited: Int(47 * multiplier),
            eventsAttended: Int(23 * multiplier),
            hoursOut: Int(156 * multiplier),
            crewSize: Int(89 * multiplier),
            venuesTrend: .up(15),
            eventsTrend: .up(8),
            hoursTrend: .down(5),
            crewTrend: .up(12),
            topVenues: TopVenue.mockData(),
            recentActivities: ActivityItem.mockData(),
            achievements: Achievement.mockData(),
            musicPreferences: MusicPreference.mockData()
        )
    }
}

struct StatsTrend {
    let type: TrendType
    let value: Int
    
    enum TrendType {
        case up, down, neutral
    }
    
    var icon: String {
        switch type {
        case .up: return "arrow.up"
        case .down: return "arrow.down" 
        case .neutral: return "minus"
        }
    }
    
    var color: Color {
        switch type {
        case .up: return .green
        case .down: return .red
        case .neutral: return .gray
        }
    }
    
    var text: String {
        switch type {
        case .up: return "+\(value)%"
        case .down: return "-\(value)%"
        case .neutral: return "\(value)%"
        }
    }
    
    static func up(_ value: Int) -> StatsTrend {
        StatsTrend(type: .up, value: value)
    }
    
    static func down(_ value: Int) -> StatsTrend {
        StatsTrend(type: .down, value: value)
    }
    
    static func neutral(_ value: Int) -> StatsTrend {
        StatsTrend(type: .neutral, value: value)
    }
}

struct TopVenue: Identifiable {
    let id = UUID()
    let name: String
    let visits: Int
    let percentage: Double
    
    static func mockData() -> [TopVenue] {
        [
            TopVenue(name: "Neon Nights", visits: 24, percentage: 100),
            TopVenue(name: "Bass Drop", visits: 18, percentage: 75),
            TopVenue(name: "Underground", visits: 12, percentage: 50),
            TopVenue(name: "The Purple Room", visits: 8, percentage: 33),
            TopVenue(name: "Rooftop Lounge", visits: 6, percentage: 25)
        ]
    }
}

struct ActivityItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let timeAgo: String
    let type: ActivityType
    
    enum ActivityType {
        case checkin, event, achievement, social
        
        var icon: String {
            switch self {
            case .checkin: return "location.fill"
            case .event: return "calendar.badge.clock"
            case .achievement: return "trophy.fill"
            case .social: return "person.2.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .checkin: return .appPrimary
            case .event: return .blue
            case .achievement: return .yellow
            case .social: return .green
            }
        }
    }
    
    static func mockData() -> [ActivityItem] {
        [
            ActivityItem(title: "Checked in at Neon Nights", subtitle: "Friday night with the crew", timeAgo: "2 hours ago", type: .checkin),
            ActivityItem(title: "Unlocked 'Night Owl' badge", subtitle: "Stayed out past 3 AM for 10 nights", timeAgo: "1 day ago", type: .achievement),
            ActivityItem(title: "Joined Weekend Warriors crew", subtitle: "Invited by Alex Chen", timeAgo: "3 days ago", type: .social),
            ActivityItem(title: "Attended EDM Festival", subtitle: "Bass Drop presents: Electric Dreams", timeAgo: "1 week ago", type: .event)
        ]
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    
    static func mockData() -> [Achievement] {
        [
            Achievement(title: "Social Butterfly", icon: "person.2.fill", color: .blue),
            Achievement(title: "Night Owl", icon: "moon.fill", color: .indigo),
            Achievement(title: "Explorer", icon: "map.fill", color: .green),
            Achievement(title: "VIP Status", icon: "crown.fill", color: .yellow),
            Achievement(title: "Music Lover", icon: "music.note", color: .pink),
            Achievement(title: "Party Starter", icon: "party.popper.fill", color: .orange)
        ]
    }
}

struct MusicPreference: Identifiable {
    let id = UUID()
    let genre: String
    let percentage: Double
    
    static func mockData() -> [MusicPreference] {
        [
            MusicPreference(genre: "Electronic", percentage: 85),
            MusicPreference(genre: "House", percentage: 72),
            MusicPreference(genre: "Techno", percentage: 68),
            MusicPreference(genre: "Trance", percentage: 45),
            MusicPreference(genre: "Dubstep", percentage: 32)
        ]
    }
}

// MARK: - Stats Settings View

struct StatsSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPersonalData = true
    @State private var shareAnalytics = false
    @State private var weeklyReports = true
    @State private var pushNotifications = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Privacy") {
                    Toggle("Show Personal Data", isOn: $showPersonalData)
                    Toggle("Share Analytics", isOn: $shareAnalytics)
                }

                Section("Notifications") {
                    Toggle("Weekly Reports", isOn: $weeklyReports)
                    Toggle("Push Notifications", isOn: $pushNotifications)
                }

                Section("Data") {
                    Button("Export Data") {
                        // Export functionality
                    }

                    Button("Reset Statistics") {
                        // Reset functionality
                    }
                    .foregroundStyle(.red)
                }
            }
            .navigationTitle("Statistics Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview("User Stats View") {
    NavigationStack {
        UserStatsView()
    }
    .preferredColorScheme(.dark)
}

#Preview("Stats Settings") {
    StatsSettingsView()
        .preferredColorScheme(.dark)
}
