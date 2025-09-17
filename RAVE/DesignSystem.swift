//
//  DesignSystem.swift
//  RAVE - Material Design 3 Transition System
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

// MARK: - Material Design Compatibility Layer
// This file provides compatibility between old Apple HIG components and new Material Design
// It allows for gradual migration while maintaining existing functionality

extension Color {
    // MARK: - Legacy to Material Color Mapping
    // These map old Apple HIG colors to Material Design equivalents

    // Primary Colors - Now Material Design
    static let appAccent = Color.materialPrimary
    static let appPrimary = Color.materialPrimary
    static let appSecondary = Color.materialSecondary
    static let appTertiary = Color.materialTertiary

    // Background Colors - Now Material Design
    static let appBackground = Color.materialSurface
    static let appSecondaryBackground = Color.materialSurfaceContainer
    static let appTertiaryBackground = Color.materialSurfaceContainerHigh
    static let appGroupedBackground = Color.materialSurface

    // Semantic Colors - Material Design
    static let appRed = Color.materialError
    static let appGreen = Color(red: 0.0, green: 0.6, blue: 0.3) // Material Green
    static let appBlue = Color.materialPrimary
    static let appOrange = Color(red: 1.0, green: 0.6, blue: 0.0) // Material Orange
    static let appYellow = Color(red: 1.0, green: 0.9, blue: 0.0) // Material Yellow
    static let appPink = Color.materialTertiary
    static let appPurple = Color.materialPrimary
    static let appIndigo = Color.materialSecondary
    static let appTeal = Color(red: 0.0, green: 0.7, blue: 0.6) // Material Teal
    static let appCyan = Color(red: 0.0, green: 0.7, blue: 0.8) // Material Cyan
    static let appMint = Color(red: 0.0, green: 0.8, blue: 0.7) // Material Mint

    // Fill Colors - Material Design
    static let appFill = Color.materialSurfaceContainer
    static let appSecondaryFill = Color.materialSurfaceContainerHigh
    static let appTertiaryFill = Color.materialSurfaceContainerHighest
    static let appQuaternaryFill = Color.materialSurfaceVariant

    // Outline and Separator Colors - Material Design
    static let appSeparator = Color.materialOutlineVariant
    static let appOpaqueSeparator = Color.materialOutline

    // RAVE Dark Theme Specific Colors
    static let nightBackground = Color(red: 0.05, green: 0.05, blue: 0.1) // Deep dark blue
    static let cardDark = Color(red: 0.1, green: 0.1, blue: 0.15) // Dark card background
    static let neonPurple = Color(red: 0.63, green: 0.43, blue: 1.0) // Neon purple accent
    static let dimWhite = Color(red: 0.9, green: 0.9, blue: 0.95) // Slightly dimmed white
}

// MARK: - Material Typography System (Compatibility Layer)
struct AppleFont {
    // Material Design Typography mapped to legacy names
    static let largeTitle = MaterialFont.displayMedium
    static let title = MaterialFont.headlineMedium
    static let title2 = MaterialFont.titleLarge
    static let title3 = MaterialFont.titleMedium
    static let headline = MaterialFont.titleMedium
    static let body = MaterialFont.bodyLarge
    static let callout = MaterialFont.bodyMedium
    static let subheadline = MaterialFont.bodyMedium
    static let footnote = MaterialFont.bodySmall
    static let caption = MaterialFont.labelMedium
    static let caption2 = MaterialFont.labelSmall

    // Dynamic Type Support (now using Material principles)
    static func customFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        return Font.system(size: size, weight: weight, design: design)
    }

    // RAVE Brand Typography - Material Design Sizes
    static let raveTitle = MaterialFont.raveHeadline
    static let raveTitleLarge = MaterialFont.raveDisplayMedium
    static let raveTitleBold = MaterialFont.raveDisplayMedium
    static let raveTitleHero = MaterialFont.raveDisplayLarge
}


// MARK: - Apple Standard Button Styles
struct AppleButtonStyle: ButtonStyle {
    let variant: Variant

    enum Variant {
        case primary, secondary, tertiary, plain
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppleFont.body)
            .fontWeight(.medium)
            .foregroundColor(foregroundColor)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundView)
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch variant {
        case .primary:
            Color.appPrimary
        case .secondary:
            Color.appSecondaryBackground
        case .tertiary:
            Color.appTertiaryBackground
        case .plain:
            Color.clear
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary:
            return .white
        case .secondary, .tertiary:
            return .appPrimary
        case .plain:
            return .appPrimary
        }
    }

    private var horizontalPadding: CGFloat {
        switch variant {
        case .primary, .secondary, .tertiary:
            return 16
        case .plain:
            return 8
        }
    }

    private var verticalPadding: CGFloat {
        switch variant {
        case .primary, .secondary, .tertiary:
            return 12
        case .plain:
            return 8
        }
    }

    private var cornerRadius: CGFloat {
        return 8
    }
}

// MARK: - Apple Standard List Components
struct AppleListRow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.appBackground)
            .listRowInsets(EdgeInsets())
    }
}

struct AppleCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color.appSecondaryBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appSeparator, lineWidth: 0.5)
            )
    }
}

// MARK: - Apple Navigation Components
struct AppleNavigationStyle: ViewModifier {
    let title: String

    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

// MARK: - Apple Standard Components
struct AppleToggle: View {
    @Binding var isOn: Bool
    let title: String
    let subtitle: String?

    init(_ title: String, subtitle: String? = nil, isOn: Binding<Bool>) {
        self.title = title
        self.subtitle = subtitle
        self._isOn = isOn
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppleFont.body)
                    .foregroundColor(.primary)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppleFont.footnote)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 8)
    }
}

struct AppleSegmentedPicker<SelectionValue: Hashable>: View {
    @Binding var selection: SelectionValue
    let options: [(SelectionValue, String)]

    var body: some View {
        Picker("Options", selection: $selection) {
            ForEach(options, id: \.0) { option in
                Text(option.1).tag(option.0)
            }
        }
        .pickerStyle(.segmented)
    }
}

// MARK: - Apple Standard Empty State
struct AppleEmptyStateView: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let action: (() -> Void)?
    let actionTitle: String?

    init(title: String, subtitle: String, systemImage: String, action: (() -> Void)? = nil, actionTitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.action = action
        self.actionTitle = actionTitle
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundColor(.appSecondary)

            VStack(spacing: 8) {
                Text(title)
                    .font(AppleFont.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(AppleFont.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let action = action, let actionTitle = actionTitle {
                Button(actionTitle, action: action)
                    .buttonStyle(AppleButtonStyle(variant: .primary))
            }
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Apple Loading States
struct AppleActivityIndicator: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .appPrimary))
            .scaleEffect(1.2)
    }
}

struct AppleLoadingView: View {
    let message: String

    init(message: String = "Loading...") {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 16) {
            AppleActivityIndicator()

            Text(message)
                .font(AppleFont.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}

// MARK: - Apple Tab Bar Components
struct AppleTabView<Content: View>: View {
    @Binding var selection: Int
    let content: Content

    init(selection: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }

    var body: some View {
        TabView(selection: $selection) {
            content
        }
        .accentColor(.appPrimary)
    }
}

// MARK: - Apple Form Components
struct AppleFormSection<Content: View>: View {
    let title: String?
    let footer: String?
    let content: Content

    init(title: String? = nil, footer: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.footer = footer
        self.content = content()
    }

    var body: some View {
        Section {
            content
        } header: {
            if let title = title {
                Text(title)
                    .font(AppleFont.footnote)
                    .foregroundColor(.secondary)
                    .textCase(nil)
            }
        } footer: {
            if let footer = footer {
                Text(footer)
                    .font(AppleFont.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct AppleTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(AppleFont.footnote)
                .foregroundColor(.secondary)

            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .frame(minHeight: 44)
        }
    }
}

// MARK: - Apple Alert Components
struct AppleAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
    let primaryTitle: String
    let secondaryTitle: String?

    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                Button(primaryTitle, action: primaryAction)

                if let secondaryAction = secondaryAction, let secondaryTitle = secondaryTitle {
                    Button(secondaryTitle, role: .cancel, action: secondaryAction)
                }
            } message: {
                if let message = message {
                    Text(message)
                }
            }
    }
}

// MARK: - View Extensions for Apple Standards
extension View {
    // Apple Standard Modifiers
    func appleCard() -> some View {
        self.modifier(AppleCard())
    }

    func appleListRow() -> some View {
        self.modifier(AppleListRow())
    }

    func appleNavigation(title: String) -> some View {
        self.modifier(AppleNavigationStyle(title: title))
    }

    // Apple Button Styles
    func applePrimaryButton() -> some View {
        self.buttonStyle(AppleButtonStyle(variant: .primary))
    }

    func appleSecondaryButton() -> some View {
        self.buttonStyle(AppleButtonStyle(variant: .secondary))
    }

    func appleTertiaryButton() -> some View {
        self.buttonStyle(AppleButtonStyle(variant: .tertiary))
    }

    func applePlainButton() -> some View {
        self.buttonStyle(AppleButtonStyle(variant: .plain))
    }

    // Apple Alert
    func appleAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        primaryAction: @escaping () -> Void,
        primaryTitle: String = "OK",
        secondaryAction: (() -> Void)? = nil,
        secondaryTitle: String? = nil
    ) -> some View {
        self.modifier(AppleAlertModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            primaryTitle: primaryTitle,
            secondaryTitle: secondaryTitle
        ))
    }

    // Apple Accessibility
    func appleAccessibility(label: String, hint: String? = nil, traits: AccessibilityTraits = []) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
    }

    // Apple Hit Testing
    func appleMinimumTapTarget() -> some View {
        self.frame(minWidth: 44, minHeight: 44)
    }
}

// MARK: - Apple Filter Components
struct AppleFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppleFont.footnote)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.appPrimary : Color.appSecondaryBackground)
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.appSeparator, lineWidth: isSelected ? 0 : 0.5)
                )
        }
        .appleAccessibility(
            label: title,
            hint: isSelected ? "Selected filter" : "Tap to select filter",
            traits: .isButton
        )
    }
}

// MARK: - Apple Standard Layout
struct AppleListStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.appGroupedBackground)
    }
}

extension View {
    func appleListStyle() -> some View {
        self.modifier(AppleListStyle())
    }
}

// MARK: - Apple Spacing Standards (8pt Grid)
struct AppleSpacing {
    static let xs: CGFloat = 4      // 0.5 * 8pt
    static let small: CGFloat = 8   // 1 * 8pt
    static let medium: CGFloat = 16 // 2 * 8pt
    static let large: CGFloat = 24  // 3 * 8pt
    static let xl: CGFloat = 32     // 4 * 8pt
    static let xxl: CGFloat = 40    // 5 * 8pt

    // Apple Standard Padding
    static let standardPadding: CGFloat = 16
    static let modalPadding: CGFloat = 20
    static let minimumSpacing: CGFloat = 8
}

// MARK: - Apple Accessibility Helpers
struct AppleAccessibility {
    static func enhanceButton<T: View>(_ view: T, label: String, hint: String = "Double tap to activate") -> some View {
        view
            .accessibilityLabel(label)
            .accessibilityHint(hint)
            .accessibilityAddTraits(.isButton)
            .frame(minWidth: 44, minHeight: 44)
    }

    static func enhanceNavigationItem<T: View>(_ view: T, label: String) -> some View {
        view
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isHeader)
    }

    static func enhanceListItem<T: View>(_ view: T, label: String, hint: String? = nil) -> some View {
        view
            .accessibilityElement(children: .contain)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }
}

// MARK: - Performance and Accessibility Optimization
struct ApplePerformance {
    static func reduceMotionCheck() -> Bool {
        UIAccessibility.isReduceMotionEnabled
    }

    static func voiceOverCheck() -> Bool {
        UIAccessibility.isVoiceOverRunning
    }

    static func standardAnimation<T: Equatable>(value: T) -> Animation? {
        if UIAccessibility.isReduceMotionEnabled {
            return nil
        } else {
            return .easeInOut(duration: 0.3)
        }
    }

    static func contrastCheck() -> Bool {
        UIAccessibility.isDarkerSystemColorsEnabled
    }
}

// MARK: - Apple Standard Preview
#Preview("Apple Design System") {
    NavigationView {
        List {
            AppleFormSection(title: "Buttons") {
                VStack(spacing: AppleSpacing.medium) {
                    Button("Primary Action") {}
                        .applePrimaryButton()

                    Button("Secondary Action") {}
                        .appleSecondaryButton()

                    Button("Tertiary Action") {}
                        .appleTertiaryButton()
                }
                .padding(.vertical, AppleSpacing.small)
            }

            AppleFormSection(title: "Toggles") {
                AppleToggle("Notifications", subtitle: "Receive updates about venues", isOn: .constant(true))
                AppleToggle("Location Services", isOn: .constant(false))
            }

            AppleFormSection(title: "Filter Chips") {
                HStack {
                    AppleFilterChip(title: "All", isSelected: true) {}
                    AppleFilterChip(title: "Nearby", isSelected: false) {}
                    AppleFilterChip(title: "Popular", isSelected: false) {}
                }
            }
        }
        .appleListStyle()
        .appleNavigation(title: "Venues")
    }
}