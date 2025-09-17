//
//  HelpView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct HelpView: View {
    @State private var searchText = ""
    @State private var expandedSections: Set<String> = []
    
    var filteredFAQs: [FAQSection] {
        if searchText.isEmpty {
            return FAQSection.allSections
        } else {
            return FAQSection.allSections.compactMap { section in
                let filteredItems = section.items.filter { item in
                    item.question.localizedCaseInsensitiveContains(searchText) ||
                    item.answer.localizedCaseInsensitiveContains(searchText)
                }
                
                if !filteredItems.isEmpty {
                    return FAQSection(title: section.title, icon: section.icon, items: filteredItems)
                } else if section.title.localizedCaseInsensitiveContains(searchText) {
                    return section
                } else {
                    return nil
                }
            }
        }
    }
    
    var body: some View {
        List {
            // Quick Actions Section
            Section {
                QuickActionRow(
                    title: "Contact Support",
                    subtitle: "Get help from our team",
                    icon: "message.circle.fill",
                    iconColor: .appPrimary
                ) {
                    // Contact support action
                }
                
                QuickActionRow(
                    title: "Report a Bug",
                    subtitle: "Help us improve the app",
                    icon: "ladybug.fill",
                    iconColor: .red
                ) {
                    // Report bug action
                }
                
                QuickActionRow(
                    title: "Feature Request",
                    subtitle: "Suggest new features",
                    icon: "lightbulb.fill",
                    iconColor: .yellow
                ) {
                    // Feature request action
                }
                
                QuickActionRow(
                    title: "App Tutorial",
                    subtitle: "Learn how to use RAVE",
                    icon: "play.circle.fill",
                    iconColor: .blue
                ) {
                    // Tutorial action
                }
            }
            
            // FAQ Sections
            ForEach(filteredFAQs, id: \.title) { section in
                Section {
                    ForEach(section.items, id: \.question) { item in
                        FAQItemView(
                            item: item,
                            isExpanded: expandedSections.contains(item.question)
                        ) {
                            toggleExpansion(for: item.question)
                        }
                    }
                } header: {
                    HStack(spacing: 8) {
                        Image(systemName: section.icon)
                            .foregroundColor(.appPrimary)
                        
                        Text(section.title)
                            .foregroundColor(.white)
                    }
                }
            }
            
            // Additional Resources
            Section("Additional Resources") {
                NavigationLink(destination: Text("Community Guidelines").navigationTitle("Guidelines")) {
                    HelpResourceRow(
                        title: "Community Guidelines",
                        subtitle: "Rules and best practices",
                        icon: "doc.text.fill"
                    )
                }
                
                NavigationLink(destination: Text("Safety Tips").navigationTitle("Safety")) {
                    HelpResourceRow(
                        title: "Safety Tips",
                        subtitle: "Stay safe while using RAVE",
                        icon: "shield.fill"
                    )
                }
                
                NavigationLink(destination: Text("Terms of Service").navigationTitle("Terms")) {
                    HelpResourceRow(
                        title: "Terms of Service",
                        subtitle: "Legal terms and conditions",
                        icon: "doc.badge.gearshape.fill"
                    )
                }
            }
            
            // App Information
            Section("App Information") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Build")
                    Spacer()
                    Text("2025.1")
                        .foregroundColor(.secondary)
                }
                
                Button("Reset App Tutorial") {
                    // Reset tutorial
                }
                .foregroundColor(.appPrimary)
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search help topics...")
        .background(Color.appBackground)
    }
    
    private func toggleExpansion(for question: String) {
        withAnimation(.easeInOut) {
            if expandedSections.contains(question) {
                expandedSections.remove(question)
            } else {
                expandedSections.insert(question)
            }
        }
    }
}

struct QuickActionRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FAQItemView: View {
    let item: FAQItem
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack {
                    Text(item.question)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(item.answer)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

struct HelpResourceRow: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.appPrimary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Data Models

struct FAQSection {
    let title: String
    let icon: String
    let items: [FAQItem]
    
    static let allSections: [FAQSection] = [
        FAQSection(
            title: "Getting Started",
            icon: "play.circle.fill",
            items: [
                FAQItem(
                    question: "How do I create an account?",
                    answer: "You can create an account using Sign in with Apple, or by providing an email and password. We recommend using Sign in with Apple for enhanced security and privacy."
                ),
                FAQItem(
                    question: "How do I find venues near me?",
                    answer: "RAVE uses your location to show nearby venues on the map. Make sure location services are enabled in your device settings and in the RAVE app permissions."
                ),
                FAQItem(
                    question: "What is a crew and how do I join one?",
                    answer: "A crew is a group of friends who go to venues together. You can join crews by accepting invitations from friends, or create your own crew and invite others."
                )
            ]
        ),
        FAQSection(
            title: "Privacy & Safety",
            icon: "shield.fill",
            items: [
                FAQItem(
                    question: "How is my location data used?",
                    answer: "Your location is only used to show nearby venues and help you connect with friends at the same location. You can control location sharing in Privacy Settings."
                ),
                FAQItem(
                    question: "Can I control who sees my activity?",
                    answer: "Yes! You can adjust your privacy settings to control who can see your check-ins, online status, and other activity. Go to Settings > Privacy to customize these options."
                ),
                FAQItem(
                    question: "How do I report inappropriate behavior?",
                    answer: "You can report users or content by tapping the menu (⋯) on any profile or message and selecting 'Report'. Our moderation team reviews all reports promptly."
                )
            ]
        ),
        FAQSection(
            title: "Features & Usage",
            icon: "star.fill",
            items: [
                FAQItem(
                    question: "What are alerts and how do I manage them?",
                    answer: "Alerts notify you about venue activity, crew invitations, and other social updates. You can customize which alerts you receive in Settings > Notifications."
                ),
                FAQItem(
                    question: "How do venue check-ins work?",
                    answer: "When you're at a venue, you can check in to let friends know where you are and connect with other RAVE users at the same location. Check-ins are automatic when location services are enabled."
                ),
                FAQItem(
                    question: "What is RAVE Premium?",
                    answer: "RAVE Premium offers enhanced features like advanced venue insights, priority support, exclusive events access, and enhanced privacy controls."
                )
            ]
        ),
        FAQSection(
            title: "Troubleshooting",
            icon: "wrench.fill",
            items: [
                FAQItem(
                    question: "The app is running slowly. What can I do?",
                    answer: "Try closing and reopening the app, ensure you have a stable internet connection, and check that you have the latest version installed. You can also disable particle effects in Settings for better performance."
                ),
                FAQItem(
                    question: "I'm not receiving notifications. How do I fix this?",
                    answer: "Check that notifications are enabled in your device Settings > Notifications > RAVE, and verify your notification preferences in the app's Settings > Notifications."
                ),
                FAQItem(
                    question: "My location isn't working properly.",
                    answer: "Ensure location services are enabled for RAVE in your device Settings > Privacy > Location Services. Also check that you've granted location permission when prompted by the app."
                )
            ]
        )
    ]
}

struct FAQItem {
    let question: String
    let answer: String
}

#Preview("Help View") {
    NavigationStack {
        HelpView()
    }
    .preferredColorScheme(.dark)
}