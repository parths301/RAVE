//
//  DesignSystem.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

extension Color {
    // RAVE Brand Colors
    static let ravePurple = Color(hex: "A16EFF")
    static let darkBackground = Color(hex: "0A0A0A")
    static let cardBackground = Color(hex: "1A1A1A")
    
    // Initialize from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// RAVE Typography System
struct RAVEFont {
    // Font Hierarchy using SF Pro
    static let largeTitle = Font.largeTitle.weight(.bold) // SF Pro Display Bold (34pt)
    static let title = Font.title.weight(.bold) // SF Pro Display Bold (28pt)
    static let title2 = Font.title2.weight(.bold) // SF Pro Display Bold (22pt)
    static let headline = Font.headline.weight(.semibold) // SF Pro Display Semibold (17pt)
    static let body = Font.body // SF Pro Text Regular (17pt)
    static let callout = Font.callout.weight(.medium) // SF Pro Text Medium (16pt)
    static let subheadline = Font.subheadline // SF Pro Text Regular (15pt)
    static let footnote = Font.footnote // SF Pro Text Regular (13pt)
    static let caption = Font.caption // SF Pro Text Regular (12pt)
}

// Custom Button Styles
struct RAVEButtonStyle: ButtonStyle {
    let variant: Variant
    
    enum Variant {
        case primary
        case secondary
        case ghost
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .font(RAVEFont.callout)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private var backgroundColor: Color {
        switch variant {
        case .primary:
            return .ravePurple
        case .secondary:
            return .cardBackground
        case .ghost:
            return .clear
        }
    }
    
    private var foregroundColor: Color {
        switch variant {
        case .primary:
            return .white
        case .secondary:
            return .primary
        case .ghost:
            return .ravePurple
        }
    }
}

// Scale Button Style for general interactions
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Custom Card Style
struct RAVECardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.ravePurple.opacity(0.2), lineWidth: 1)
            )
    }
}

extension View {
    func raveCard() -> some View {
        self.modifier(RAVECardStyle())
    }
    
    func ravePrimaryButton() -> some View {
        self.buttonStyle(RAVEButtonStyle(variant: .primary))
    }
    
    func raveSecondaryButton() -> some View {
        self.buttonStyle(RAVEButtonStyle(variant: .secondary))
    }
    
    func raveGhostButton() -> some View {
        self.buttonStyle(RAVEButtonStyle(variant: .ghost))
    }
    
    func scaleOnTap() -> some View {
        self.buttonStyle(ScaleButtonStyle())
    }
}

// Filter Chip Component
struct FilterChip: View {
    let filter: VenueFilter
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: filter.systemImage)
                    .font(.caption)
                Text(filter.rawValue)
                    .font(RAVEFont.caption)
                    .fontWeight(.medium)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                isSelected ? Color.ravePurple : Color.cardBackground,
                in: Capsule()
            )
            .foregroundColor(
                isSelected ? .white : .secondary
            )
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? Color.clear : Color.ravePurple.opacity(0.3),
                        lineWidth: 1
                    )
            )
        }
        .scaleOnTap()
    }
}

// Vibe Badge Component
struct VibeBadge: View {
    let status: String
    
    var body: some View {
        Text(status)
            .font(RAVEFont.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.ravePurple.opacity(0.2))
            .foregroundColor(.ravePurple)
            .clipShape(Capsule())
    }
}

// Loading State Component
struct RAVELoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .ravePurple))
                .scaleEffect(1.2)
            
            Text("Loading...")
                .font(RAVEFont.callout)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}

// Empty State Component
struct RAVEEmptyStateView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundColor(.ravePurple.opacity(0.6))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(RAVEFont.headline)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(RAVEFont.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    VStack(spacing: 20) {
        // Button Examples
        Button("Primary Button") {}
            .ravePrimaryButton()
        
        Button("Secondary Button") {}
            .raveSecondaryButton()
        
        Button("Ghost Button") {}
            .raveGhostButton()
        
        // Filter Chip Example
        FilterChip(filter: .popular, isSelected: true) {}
        
        // Vibe Badge Example
        VibeBadge(status: "🔥 Vibing")
        
        // Card Example
        VStack {
            Text("Card Content")
                .font(RAVEFont.headline)
                .padding()
        }
        .raveCard()
    }
    .padding()
    .background(Color.darkBackground)
    .preferredColorScheme(.dark)
}