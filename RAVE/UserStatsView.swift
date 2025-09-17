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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Period Selector
                Picker("Stats Period", selection: $selectedPeriod) {
                    Text("This Week").tag(StatsPeriod.thisWeek)
                    Text("This Month").tag(StatsPeriod.thisMonth)
                    Text("This Year").tag(StatsPeriod.thisYear)
                    Text("All Time").tag(StatsPeriod.allTime)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Main Stats Cards
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    StatsCardView(
                        title: "Venues Visited",
                        value: "\(stats.venuesVisited)",
                        icon: "location.fill",
                        iconColor: .ravePurple,
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
                
                // Top Venues Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Top Venues")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button("View All") {
                            // Show all venues
                        }
                        .foregroundColor(.ravePurple)
                    }
                    
                    VStack(spacing: 12) {
                        ForEach(Array(stats.topVenues.enumerated()), id: \.offset) { index, venue in
                            TopVenueRowView(venue: venue, rank: index + 1)
                        }
                    }
                }
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial.opacity(0.5))
                        
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                )
                .padding(.horizontal)
                
                // Activity Timeline
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Activity")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 16) {
                        ForEach(stats.recentActivities) { activity in
                            ActivityTimelineView(activity: activity)
                        }
                    }
                }
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial.opacity(0.5))
                        
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                )
                .padding(.horizontal)
                
                // Achievement Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Achievements")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(stats.achievements) { achievement in
                            AchievementBadgeView(achievement: achievement)
                        }
                    }
                }
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial.opacity(0.5))
                        
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                )
                .padding(.horizontal)
                
                // Music Preferences Chart
                VStack(alignment: .leading, spacing: 16) {
                    Text("Music Preferences")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        ForEach(stats.musicPreferences) { preference in
                            MusicPreferenceBarView(preference: preference)
                        }
                    }
                }
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cardBackground)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial.opacity(0.5))
                        
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    }
                )
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.large)
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
        .onChange(of: selectedPeriod) {
            // Update stats based on period
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
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(iconColor)
                
                Spacer()
                
                TrendIndicatorView(trend: trend)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(value)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                HStack {
                    Text(title)
                        .font(.caption)
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
}

struct TrendIndicatorView: View {
    let trend: StatsTrend
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: trend.icon)
                .font(.caption)
                .foregroundColor(trend.color)
            
            Text(trend.text)
                .font(.caption2)
                .foregroundColor(trend.color)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(trend.color.opacity(0.2))
        )
    }
}

struct TopVenueRowView: View {
    let venue: TopVenue
    let rank: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // Rank Badge
            ZStack {
                Circle()
                    .fill(rankColor)
                    .frame(width: 32, height: 32)
                
                Text("\(rank)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Venue Info
            VStack(alignment: .leading, spacing: 2) {
                Text(venue.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text("\(venue.visits) visits")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Visit Progress Bar
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(venue.percentage))%")
                    .font(.caption)
                    .foregroundColor(.ravePurple)
                
                ProgressView(value: venue.percentage / 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .ravePurple))
                    .frame(width: 60)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.regularMaterial.opacity(0.3))
        )
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .ravePurple
        }
    }
}

struct ActivityTimelineView: View {
    let activity: ActivityItem
    
    var body: some View {
        HStack(spacing: 12) {
            // Activity Icon
            Circle()
                .fill(activity.type.color.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: activity.type.icon)
                        .font(.system(size: 16))
                        .foregroundColor(activity.type.color)
                )
            
            // Activity Details
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(activity.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(activity.timeAgo)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct AchievementBadgeView: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [achievement.color.opacity(0.3), achievement.color.opacity(0.1)],
                            center: .center,
                            startRadius: 10,
                            endRadius: 30
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 24))
                    .foregroundColor(achievement.color)
            }
            
            Text(achievement.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial.opacity(0.3))
        )
    }
}

struct MusicPreferenceBarView: View {
    let preference: MusicPreference
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(preference.genre)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(Int(preference.percentage))%")
                    .font(.caption)
                    .foregroundColor(.ravePurple)
            }
            
            ProgressView(value: preference.percentage / 100)
                .progressViewStyle(LinearProgressViewStyle(tint: .ravePurple))
                .background(Color.gray.opacity(0.2))
        }
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
            case .checkin: return .ravePurple
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

#Preview {
    NavigationStack {
        UserStatsView()
    }
    .preferredColorScheme(.dark)
}