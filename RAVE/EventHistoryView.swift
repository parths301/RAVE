//
//  EventHistoryView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct EventHistoryView: View {
    @State private var events: [EventHistory] = []
    @State private var selectedFilter = EventFilter.all
    
    var filteredEvents: [EventHistory] {
        switch selectedFilter {
        case .all:
            return events
        case .thisMonth:
            return events.filter { Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month) }
        case .thisYear:
            return events.filter { Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .year) }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter Picker
            Picker("Event Filter", selection: $selectedFilter) {
                Text("All Time").tag(EventFilter.all)
                Text("This Month").tag(EventFilter.thisMonth)
                Text("This Year").tag(EventFilter.thisYear)
            }
            .pickerStyle(.segmented)
            .padding()
            
            if filteredEvents.isEmpty {
                // Empty State
                VStack(spacing: 20) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("No Events Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Your event history will appear here as you start attending venues")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                // Event History List
                List(filteredEvents) { event in
                    EventHistoryRowView(event: event)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("Event History")
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
        .onAppear {
            setupMockData()
        }
    }
    
    private func setupMockData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        events = [
            EventHistory(
                venueName: "Neon Nights",
                eventName: "Friday Night Fever",
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                duration: "4h 30m",
                crewMembers: ["Alex Chen", "Sarah K", "Mike DJ"],
                photos: 12,
                memories: "Amazing night with incredible beats! The DJ set was fire 🔥"
            ),
            EventHistory(
                venueName: "Bass Drop",
                eventName: "Underground Sessions",
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                duration: "6h 15m",
                crewMembers: ["Emma B", "Carlos R"],
                photos: 8,
                memories: "Deep house vibes all night. Met some cool new people!"
            ),
            EventHistory(
                venueName: "The Purple Room",
                eventName: "Techno Thursday",
                date: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date(),
                duration: "5h 45m",
                crewMembers: ["Nina D", "Tyler N", "Zoe M", "Alex Chen"],
                photos: 24,
                memories: "Epic techno sets. Danced until sunrise! Best crew ever 💜"
            ),
            EventHistory(
                venueName: "Rooftop Lounge",
                eventName: "Summer Sunset Sessions",
                date: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(),
                duration: "3h 20m",
                crewMembers: ["Sarah K"],
                photos: 6,
                memories: "Beautiful sunset views with chill house music"
            )
        ]
    }
}

struct EventHistoryRowView: View {
    let event: EventHistory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Event Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.eventName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("at \(event.venueName)")
                        .font(.system(size: 16))
                        .foregroundColor(.ravePurple)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(event.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(event.duration)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Stats Row
            HStack(spacing: 20) {
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("\(event.crewMembers.count) crew")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "photo.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("\(event.photos) photos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Crew Members
            if !event.crewMembers.isEmpty {
                HStack {
                    Text("With:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(Array(event.crewMembers.prefix(3)).joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.ravePurple)
                    
                    if event.crewMembers.count > 3 {
                        Text("and \(event.crewMembers.count - 3) more")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
            
            // Memory Note
            if !event.memories.isEmpty {
                Text("\"\(event.memories)\"")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(.top, 4)
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
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
    }
}

enum EventFilter: String, CaseIterable {
    case all = "All Time"
    case thisMonth = "This Month"
    case thisYear = "This Year"
}

struct EventHistory: Identifiable {
    let id = UUID()
    let venueName: String
    let eventName: String
    let date: Date
    let duration: String
    let crewMembers: [String]
    let photos: Int
    let memories: String
}

#Preview {
    NavigationStack {
        EventHistoryView()
    }
    .preferredColorScheme(.dark)
}