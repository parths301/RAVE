//
//  DesignSystem.swift
//  RAVE - Premium Nightlife Social Experience
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

// MARK: - Premium Color System
extension Color {
    // RAVE Neon Brand Palette
    static let ravePurple = Color(hex: "A16EFF")
    static let raveNeon = Color(hex: "00FFFF")
    static let ravePink = Color(hex: "FF1493")
    static let raveGold = Color(hex: "FFD700")
    
    // Glassmorphism Background System
    static let glassBackground = Color.black.opacity(0.05)
    static let cardBackground = Color.black.opacity(0.3)
    static let deepBackground = LinearGradient(
        colors: [Color(hex: "0A0A0A"), Color(hex: "1A0A2E"), Color(hex: "16213E")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Contextual Glass Colors
    static let nightGlass = Color.black.opacity(0.2)
    static let clubGlass = Color.purple.opacity(0.15)
    static let partyGlass = Color.pink.opacity(0.1)
    static let vipGlass = Color.yellow.opacity(0.08)
    
    // Semantic Colors with Transparency
    static let successGlass = Color.green.opacity(0.3)
    static let warningGlass = Color.orange.opacity(0.3)
    static let errorGlass = Color.red.opacity(0.3)
    static let infoGlass = Color.blue.opacity(0.3)
    
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
    
    // Gradient Builders
    static func neonGradient(_ colors: [Color] = [.ravePurple, .raveNeon, .ravePink]) -> LinearGradient {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static func vibeGradient(for vibe: VenueVibe) -> LinearGradient {
        switch vibe {
        case .electric:
            return neonGradient([.raveNeon, .ravePurple])
        case .fire:
            return neonGradient([.ravePink, .raveGold])
        case .chill:
            return neonGradient([.ravePurple, .blue])
        case .wild:
            return neonGradient([.ravePink, .red, .raveGold])
        }
    }
}

enum VenueVibe {
    case electric, fire, chill, wild
}

// MARK: - Premium Typography System
struct RAVEFont {
    // Brand Typography - SF Pro Rounded for Modern Feel
    static let hero = Font.system(size: 48, weight: .black, design: .rounded)
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let callout = Font.system(size: 16, weight: .medium, design: .default)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption = Font.system(size: 12, weight: .medium, design: .default)
    static let tiny = Font.system(size: 10, weight: .medium, design: .default)
}

// MARK: - Glassmorphism Material System
enum GlassMaterial {
    case ultra, thin, thick, custom(opacity: Double)
    
    var material: Material {
        switch self {
        case .ultra:
            return .ultraThinMaterial
        case .thin:
            return .thinMaterial  
        case .thick:
            return .thickMaterial
        case .custom(_):
            return .ultraThinMaterial // Base material for custom
        }
    }
    
    var opacity: Double {
        switch self {
        case .ultra:
            return 0.05
        case .thin:
            return 0.1
        case .thick:
            return 0.2
        case .custom(let opacity):
            return opacity
        }
    }
}

// MARK: - Premium Button System
struct RAVEButtonStyle: ButtonStyle {
    let variant: Variant
    
    enum Variant {
        case neon, glass, floating, pill
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, variant == .pill ? 8 : 16)
            .padding(.horizontal, variant == .pill ? 12 : 24)
            .font(RAVEFont.callout)
            .background(backgroundView)
            .foregroundColor(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: variant == .pill ? 20 : 16))
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .brightness(configuration.isPressed ? 0.1 : 0)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch variant {
        case .neon:
            Color.neonGradient()
        case .glass:
            Color.nightGlass
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        case .floating:
            Color.clubGlass
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        case .pill:
            Color.ravePurple.opacity(0.3)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        }
    }
    
    private var foregroundColor: Color {
        switch variant {
        case .neon:
            return .white
        case .glass, .floating:
            return .white.opacity(0.9)
        case .pill:
            return .white.opacity(0.8)
        }
    }
    
    private var shadowColor: Color {
        switch variant {
        case .neon:
            return .ravePurple.opacity(0.3)
        case .glass, .floating:
            return .black.opacity(0.2)
        case .pill:
            return .clear
        }
    }
}

// MARK: - Glassmorphism Components
struct GlassCard: ViewModifier {
    let material: GlassMaterial
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .fill(.clear)
                    .background(material.material, in: RoundedRectangle(cornerRadius: cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.2), .clear, .white.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct FloatingGlass: ViewModifier {
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .clear, .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: .ravePurple.opacity(0.1), radius: 20, x: 0, y: 10)
            .offset(y: offset)
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    offset = 2
                }
            }
    }
}

// MARK: - Advanced Interaction System
struct ElasticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct HapticButtonStyle: ButtonStyle {
    let intensity: UIImpactFeedbackGenerator.FeedbackStyle
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .brightness(configuration.isPressed ? 0.1 : 0)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    let impactFeedback = UIImpactFeedbackGenerator(style: intensity)
                    impactFeedback.impactOccurred()
                }
            }
    }
}

// MARK: - Particle System Components
struct ParticleView: View {
    @State private var particles: [Particle] = []
    let count: Int
    let color: Color
    
    var body: some View {
        ZStack {
            ForEach(particles, id: \.id) { particle in
                Circle()
                    .fill(color.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(x: particle.x, y: particle.y)
                    .blur(radius: particle.blur)
            }
        }
        .onAppear {
            generateParticles()
            startAnimation()
        }
    }
    
    private func generateParticles() {
        particles = (0..<count).map { _ in
            Particle(
                x: Double.random(in: 0...UIScreen.main.bounds.width),
                y: Double.random(in: 0...UIScreen.main.bounds.height),
                size: Double.random(in: 2...8),
                opacity: Double.random(in: 0.1...0.6),
                blur: Double.random(in: 0...3)
            )
        }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: Double.random(in: 10...20)).repeatForever(autoreverses: false)) {
            for i in particles.indices {
                particles[i].y -= Double.random(in: 100...300)
                particles[i].opacity = 0
            }
        }
    }
}

struct Particle {
    let id = UUID()
    var x: Double
    var y: Double
    let size: Double
    var opacity: Double
    let blur: Double
}

// MARK: - Premium Loading States
struct PulsingLoader: View {
    @State private var scale: CGFloat = 0.8
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 60, height: 60)
            .scaleEffect(scale)
            .opacity(2 - scale)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scale)
            .onAppear {
                scale = 1.2
            }
    }
}

struct ShimmerLoader: View {
    @State private var shimmerOffset: CGFloat = -200
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.4), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: shimmerOffset)
                    .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: shimmerOffset)
            )
            .onAppear {
                shimmerOffset = width + 200
            }
    }
}

// MARK: - View Extensions for Premium Experience
extension View {
    // Glassmorphism Modifiers
    func glassCard(material: GlassMaterial = .thin, cornerRadius: CGFloat = 16) -> some View {
        self.modifier(GlassCard(material: material, cornerRadius: cornerRadius))
    }
    
    func floatingGlass() -> some View {
        self.modifier(FloatingGlass())
    }
    
    func raveCard() -> some View {
        self.padding(20)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .clear, .ravePurple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
            .shadow(color: .ravePurple.opacity(0.1), radius: 20, x: 0, y: 10)
    }
    
    // Premium Button Styles
    func neonButton() -> some View {
        self.buttonStyle(RAVEButtonStyle(variant: .neon))
    }
    
    func glassButton() -> some View {
        self.buttonStyle(RAVEButtonStyle(variant: .glass))
    }
    
    func floatingButton() -> some View {
        self.buttonStyle(RAVEButtonStyle(variant: .floating))
    }
    
    func pillButton() -> some View {
        self.buttonStyle(RAVEButtonStyle(variant: .pill))
    }
    
    func raveGhostButton() -> some View {
        self
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .foregroundColor(.ravePurple)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        LinearGradient(
                            colors: [.ravePurple.opacity(0.6), .raveNeon.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .scaleOnTap()
    }
    
    func ravePrimaryButton() -> some View {
        self
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.ravePurple, .ravePink.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white.opacity(0.1))
                    
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.6), .clear, .white.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            )
            .shadow(color: .ravePurple.opacity(0.4), radius: 12, x: 0, y: 6)
            .shadow(color: .ravePink.opacity(0.3), radius: 20, x: 0, y: 10)
            .scaleOnTap()
    }
    
    func raveSecondaryButton() -> some View {
        self
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(.ravePurple)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.ravePurple.opacity(0.1))
                    
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.4), .clear, Color.ravePurple.opacity(0.4)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .shadow(color: .ravePurple.opacity(0.2), radius: 8, x: 0, y: 4)
            .scaleOnTap()
    }
    
    // Advanced Interactions
    func elasticPress() -> some View {
        self.buttonStyle(ElasticButtonStyle())
    }
    
    func hapticPress(_ intensity: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.buttonStyle(HapticButtonStyle(intensity: intensity))
    }
    
    func scaleOnTap() -> some View {
        self.scaleEffect(1.0)
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    // Animation handled by the spring animation
                }
            }
    }
    
    // Visual Effects
    func neonGlow(color: Color = .ravePurple, radius: CGFloat = 8) -> some View {
        self.shadow(color: color.opacity(0.6), radius: radius, x: 0, y: 0)
    }
    
    func breathingEffect(scale: CGFloat = 1.05, duration: Double = 2) -> some View {
        self.scaleEffect(1.0)
            .animation(.easeInOut(duration: duration).repeatForever(autoreverses: true), value: scale)
    }
    
    // Gradient Backgrounds
    func neonBackground() -> some View {
        self.background(Color.neonGradient().ignoresSafeArea())
    }
    
    func deepBackground() -> some View {
        self.background(Color.deepBackground.ignoresSafeArea())
    }
    
    // Text Effects
    func neonText(color: Color = .ravePurple, glowColor: Color? = nil) -> some View {
        let effectiveGlowColor = glowColor ?? color
        return self.foregroundColor(color)
            .shadow(color: effectiveGlowColor.opacity(0.8), radius: 2, x: 0, y: 0)
            .shadow(color: effectiveGlowColor.opacity(0.4), radius: 8, x: 0, y: 0)
    }
    
    func glassText() -> some View {
        self.foregroundColor(.white.opacity(0.9))
            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
    }
}

// MARK: - Legacy Component Updates
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
                Group {
                    if isSelected {
                        Color.neonGradient([.ravePurple, .raveNeon])
                    } else {
                        Color.nightGlass
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                }
            )
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? Color.clear : Color.white.opacity(0.2),
                        lineWidth: 1
                    )
            )
        }
        .hapticPress(.light)
    }
}

struct VibeBadge: View {
    let status: String
    
    var body: some View {
        Text(status)
            .font(RAVEFont.tiny)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Color.ravePurple.opacity(0.3)
                    .background(.ultraThinMaterial, in: Capsule())
            )
            .foregroundColor(.white)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.ravePurple.opacity(0.6), lineWidth: 1)
            )
            .neonGlow(color: .ravePurple, radius: 4)
    }
}

// MARK: - Premium Empty and Loading States
struct RAVELoadingView: View {
    var body: some View {
        VStack(spacing: 24) {
            PulsingLoader(color: .ravePurple)
            
            Text("Finding the vibe...")
                .font(RAVEFont.callout)
                .glassText()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .deepBackground()
    }
}

struct RAVEEmptyStateView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: systemImage)
                .font(.system(size: 64))
                .foregroundColor(.ravePurple.opacity(0.6))
                .neonGlow(color: .ravePurple, radius: 8)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(RAVEFont.title2)
                    .glassText()
                
                Text(subtitle)
                    .font(RAVEFont.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Premium Preview
#Preview("Premium Design System") {
    ScrollView {
        VStack(spacing: 32) {
            // Typography Showcase
            VStack(spacing: 16) {
                Text("RAVE")
                    .font(RAVEFont.hero)
                    .neonText()
                
                Text("Premium Nightlife Experience")
                    .font(RAVEFont.title2)
                    .glassText()
            }
            
            // Button Styles
            VStack(spacing: 16) {
                Button("Join the Party") {}
                    .neonButton()
                
                Button("Discover Venues") {}
                    .glassButton()
                
                Button("Create Group") {}
                    .floatingButton()
                
                HStack(spacing: 12) {
                    Button("🔥 Fire") {}
                        .pillButton()
                    
                    Button("⚡ Electric") {}
                        .pillButton()
                    
                    Button("✨ Chill") {}
                        .pillButton()
                }
            }
            
            // Glass Cards
            VStack(spacing: 16) {
                VStack {
                    Text("Premium Venue")
                        .font(RAVEFont.headline)
                        .glassText()
                    
                    Text("Experience the ultimate nightlife")
                        .font(RAVEFont.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(24)
                .glassCard(material: .thin)
                
                VStack {
                    Text("VIP Experience")
                        .font(RAVEFont.headline)
                        .neonText(color: .raveGold)
                    
                    HStack {
                        PulsingLoader(color: .raveGold)
                            .frame(width: 24, height: 24)
                        
                        Text("Exclusive Access")
                            .font(RAVEFont.callout)
                            .glassText()
                    }
                }
                .padding(24)
                .floatingGlass()
            }
            
            // Filter Chips
            HStack(spacing: 12) {
                FilterChip(filter: .all, isSelected: true) {}
                FilterChip(filter: .popular, isSelected: false) {}
                FilterChip(filter: .nearby, isSelected: false) {}
            }
            
            // Vibe Badges
            HStack(spacing: 12) {
                VibeBadge(status: "🔥 Fire")
                VibeBadge(status: "⚡ Electric")  
                VibeBadge(status: "✨ Magical")
            }
            
            // Particle Effect Preview
            ZStack {
                ParticleView(count: 20, color: .ravePurple)
                    .frame(height: 100)
                
                Text("Ambient Particles")
                    .font(RAVEFont.callout)
                    .glassText()
            }
            .glassCard()
        }
        .padding(24)
    }
    .deepBackground()
    .preferredColorScheme(.dark)
}

// MARK: - Performance Optimized Components
struct OptimizedGradient {
    static func neonGradient() -> LinearGradient {
        LinearGradient(
            colors: [.ravePurple, .raveNeon.opacity(0.8), .ravePink.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static func glassGradient() -> LinearGradient {
        LinearGradient(
            colors: [.white.opacity(0.2), .clear, .white.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static func deepBackground() -> LinearGradient {
        LinearGradient(
            colors: [Color(hex: "0A0A0A"), Color(hex: "1A0A2E"), Color(hex: "16213E")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Accessibility Helpers
struct AccessibilityModifiers {
    static func enhanceForVoiceOver<T: View>(_ view: T, label: String, hint: String? = nil) -> some View {
        view
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.allowsDirectInteraction)
    }
    
    static func enhanceButton<T: View>(_ view: T, label: String, hint: String = "Double tap to activate") -> some View {
        view
            .accessibilityLabel(label)
            .accessibilityHint(hint)
            .accessibilityAddTraits(.isButton)
    }
    
    static func enhanceNavigation<T: View>(_ view: T, label: String) -> some View {
        view
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isHeader)
    }
    
    static func enhanceCard<T: View>(_ view: T, label: String, hint: String? = nil) -> some View {
        view
            .accessibilityElement(children: .contain)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "Swipe to explore content")
    }
}

// MARK: - Performance Monitoring & Optimization
struct PerformanceOptimizer {
    static func reduceMotionIfNeeded() -> Bool {
        UIAccessibility.isReduceMotionEnabled
    }
    
    static func prefersCrossFadeTransitions() -> Bool {
        UIAccessibility.prefersCrossFadeTransitions
    }
    
    static func isVoiceOverRunning() -> Bool {
        UIAccessibility.isVoiceOverRunning
    }
    
    static func optimizedAnimation<T: Equatable>(duration: Double = 0.3, value: T) -> Animation {
        if UIAccessibility.isReduceMotionEnabled {
            return .linear(duration: 0.1)
        } else {
            return .easeInOut(duration: duration)
        }
    }
    
    static func optimizedSpringAnimation<T: Equatable>(value: T) -> Animation {
        if UIAccessibility.isReduceMotionEnabled {
            return .linear(duration: 0.2)
        } else {
            return .interactiveSpring(response: 0.6, dampingFraction: 0.8)
        }
    }
    
    static func shouldShowParticles() -> Bool {
        !UIAccessibility.isReduceMotionEnabled && !ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    static func particleCount(defaultCount: Int) -> Int {
        if ProcessInfo.processInfo.isLowPowerModeEnabled {
            return max(1, defaultCount / 4)
        } else if UIAccessibility.isReduceMotionEnabled {
            return max(1, defaultCount / 2)
        }
        return defaultCount
    }
}

// MARK: - Enhanced View Extensions with Accessibility
extension View {
    func accessibleVenueCard(venueName: String, location: String, checkInCount: Int) -> some View {
        self
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Venue card for \(venueName)")
            .accessibilityHint("Located at \(location) with \(checkInCount) people checked in. Double tap to view details.")
            .accessibilityAddTraits(.isButton)
    }
    
    func accessibleTabItem(tabName: String, isSelected: Bool) -> some View {
        self
            .accessibilityLabel(tabName)
            .accessibilityHint(isSelected ? "Currently selected tab" : "Double tap to switch to \(tabName) tab")
            .accessibilityAddTraits(.isButton)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    func accessibleMapAnnotation(venueName: String) -> some View {
        self
            .accessibilityLabel("Map pin for \(venueName)")
            .accessibilityHint("Double tap to view venue details")
            .accessibilityAddTraits(.isButton)
    }
    
    func optimizedAnimation<T: Equatable>(_ animation: Animation, value: T) -> some View {
        if UIAccessibility.isReduceMotionEnabled {
            return self.animation(.linear(duration: 0.1), value: value)
        } else {
            return self.animation(animation, value: value)
        }
    }
    
    func performanceOptimizedShadow(color: Color, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> some View {
        Group {
            if ProcessInfo.processInfo.isLowPowerModeEnabled {
                self.shadow(color: color.opacity(0.3), radius: radius * 0.5, x: x * 0.5, y: y * 0.5)
            } else {
                self.shadow(color: color, radius: radius, x: x, y: y)
            }
        }
    }
}