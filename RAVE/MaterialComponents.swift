//
//  MaterialComponents.swift
//  RAVE - Material Design 3 Components
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

// MARK: - Material Button Components

struct MaterialButton: View {
    let text: String
    let style: MaterialButtonStyle
    let action: () -> Void

    enum MaterialButtonStyle {
        case filled
        case filledTonal
        case outlined
        case text
        case elevated

        var backgroundColor: Color {
            switch self {
            case .filled: return .materialPrimary
            case .filledTonal: return .materialSecondaryContainer
            case .outlined, .text: return .clear
            case .elevated: return .materialSurfaceContainerLow
            }
        }

        var foregroundColor: Color {
            switch self {
            case .filled: return .materialOnPrimary
            case .filledTonal: return .materialOnSecondaryContainer
            case .outlined, .text: return .materialPrimary
            case .elevated: return .materialPrimary
            }
        }

        var borderColor: Color? {
            switch self {
            case .outlined: return .materialOutline
            default: return nil
            }
        }

        var elevation: Int {
            switch self {
            case .elevated: return 1
            default: return 0
            }
        }
    }

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(MaterialFont.labelLarge)
                .foregroundColor(style.foregroundColor)
                .padding(.horizontal, MaterialSpacing.xxl)
                .padding(.vertical, MaterialSpacing.lg)
                .frame(minHeight: 40)
                .background(
                    RoundedRectangle(cornerRadius: MaterialShape.buttonRadius, style: .continuous)
                        .fill(style.backgroundColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: MaterialShape.buttonRadius, style: .continuous)
                                .stroke(style.borderColor ?? .clear, lineWidth: 1)
                        )
                )
                .materialStateLayer(color: style.foregroundColor, isPressed: isPressed)
                .materialElevation(style.elevation)
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(MaterialMotion.quickFade, value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
            withAnimation(MaterialMotion.quickFade) {
                isPressed = true
            }
        } onPressingChanged: { pressing in
            withAnimation(MaterialMotion.quickFade) {
                isPressed = pressing
            }
        }
    }
}

// MARK: - Material Card Component

struct MaterialCard<Content: View>: View {
    let content: Content
    let elevation: Int
    let action: (() -> Void)?

    init(elevation: Int = 1, action: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.elevation = elevation
        self.action = action
        self.content = content()
    }

    @State private var isPressed = false

    var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
                .materialStateLayer(color: .materialOnSurface, isPressed: isPressed)
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
                    withAnimation(MaterialMotion.quickFade) {
                        isPressed = true
                    }
                } onPressingChanged: { pressing in
                    withAnimation(MaterialMotion.quickFade) {
                        isPressed = pressing
                    }
                }
            } else {
                cardContent
            }
        }
    }

    private var cardContent: some View {
        content
            .padding(MaterialSpacing.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: MaterialShape.cardRadius, style: .continuous)
                    .fill(Color.materialSurfaceContainer)
            )
            .overlay(
                RoundedRectangle(cornerRadius: MaterialShape.cardRadius, style: .continuous)
                    .stroke(Color.materialOutlineVariant, lineWidth: 0.5)
            )
            .materialElevation(elevation)
    }
}

// MARK: - Material List Item

struct MaterialListItem<Content: View>: View {
    let content: Content
    let action: (() -> Void)?

    init(action: (() -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }

    @State private var isPressed = false

    var body: some View {
        Group {
            if let action = action {
                Button(action: action) {
                    listContent
                }
                .buttonStyle(PlainButtonStyle())
                .materialStateLayer(color: .materialOnSurface, isPressed: isPressed)
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
                    withAnimation(MaterialMotion.quickFade) {
                        isPressed = true
                    }
                } onPressingChanged: { pressing in
                    withAnimation(MaterialMotion.quickFade) {
                        isPressed = pressing
                    }
                }
            } else {
                listContent
            }
        }
    }

    private var listContent: some View {
        content
            .padding(.horizontal, MaterialSpacing.listItemPadding)
            .padding(.vertical, MaterialSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.materialSurface)
    }
}

// MARK: - Material Top App Bar

struct MaterialTopAppBar: View {
    let title: String
    let leadingAction: (() -> Void)?
    let trailingActions: [MaterialAppBarAction]

    struct MaterialAppBarAction {
        let icon: String
        let action: () -> Void
    }

    var body: some View {
        HStack(spacing: MaterialSpacing.lg) {
            // Leading action
            if let leadingAction = leadingAction {
                Button(action: leadingAction) {
                    Image(systemName: MaterialIcon.menu)
                        .font(.title3)
                        .foregroundColor(.materialOnSurface)
                        .frame(width: 24, height: 24)
                }
                .materialStateLayer(color: .materialOnSurface)
            }

            // Title
            Text(title)
                .font(MaterialFont.titleLarge)
                .foregroundColor(.materialOnSurface)
                .frame(maxWidth: .infinity, alignment: leadingAction != nil ? .leading : .center)

            // Trailing actions
            HStack(spacing: MaterialSpacing.sm) {
                ForEach(Array(trailingActions.enumerated()), id: \.offset) { _, action in
                    Button(action: action.action) {
                        Image(systemName: action.icon)
                            .font(.title3)
                            .foregroundColor(.materialOnSurface)
                            .frame(width: 24, height: 24)
                    }
                    .materialStateLayer(color: .materialOnSurface)
                }
            }
        }
        .padding(.horizontal, MaterialSpacing.screenPadding)
        .padding(.vertical, MaterialSpacing.md)
        .background(Color.materialSurface)
    }
}

// MARK: - Material Bottom Navigation

struct MaterialBottomNavigation: View {
    @Binding var selectedTab: Int
    let tabs: [MaterialBottomNavTab]

    struct MaterialBottomNavTab {
        let icon: String
        let activeIcon: String
        let label: String
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button(action: {
                    withAnimation(MaterialMotion.quickFade) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: MaterialSpacing.xs) {
                        Image(systemName: selectedTab == index ? tab.activeIcon : tab.icon)
                            .font(.title3)
                            .foregroundColor(selectedTab == index ? .materialPrimary : .materialOnSurfaceVariant)
                            .frame(height: 24)

                        Text(tab.label)
                            .font(MaterialFont.labelMedium)
                            .foregroundColor(selectedTab == index ? .materialPrimary : .materialOnSurfaceVariant)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, MaterialSpacing.md)
                    .materialStateLayer(color: .materialOnSurface)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(Color.materialSurfaceContainer)
        .overlay(
            Rectangle()
                .fill(Color.materialOutlineVariant)
                .frame(height: 0.5),
            alignment: .top
        )
    }
}

// MARK: - Material FAB (Floating Action Button)

struct MaterialFAB: View {
    let icon: String
    let action: () -> Void
    let size: FABSize

    enum FABSize {
        case small, normal, large

        var dimension: CGFloat {
            switch self {
            case .small: return 40
            case .normal: return 56
            case .large: return 96
            }
        }

        var iconSize: Font {
            switch self {
            case .small: return .title3
            case .normal: return .title2
            case .large: return .largeTitle
            }
        }
    }

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(size.iconSize)
                .foregroundColor(.materialOnPrimaryContainer)
                .frame(width: size.dimension, height: size.dimension)
                .background(
                    Circle()
                        .fill(Color.materialPrimaryContainer)
                )
                .materialStateLayer(color: .materialOnPrimaryContainer, isPressed: isPressed)
                .materialElevation(3)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(MaterialMotion.emphasized, value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
            withAnimation(MaterialMotion.quickFade) {
                isPressed = true
            }
        } onPressingChanged: { pressing in
            withAnimation(MaterialMotion.quickFade) {
                isPressed = pressing
            }
        }
    }
}

// MARK: - Material Chip

struct MaterialChip: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(MaterialFont.labelLarge)
                .foregroundColor(isSelected ? .materialOnSecondaryContainer : .materialOnSurfaceVariant)
                .padding(.horizontal, MaterialSpacing.lg)
                .padding(.vertical, MaterialSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: MaterialShape.chipRadius, style: .continuous)
                        .fill(isSelected ? Color.materialSecondaryContainer : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: MaterialShape.chipRadius, style: .continuous)
                                .stroke(Color.materialOutline, lineWidth: isSelected ? 0 : 1)
                        )
                )
                .materialStateLayer(color: isSelected ? .materialOnSecondaryContainer : .materialOnSurface, isPressed: isPressed)
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(MaterialMotion.quickFade, value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
            withAnimation(MaterialMotion.quickFade) {
                isPressed = true
            }
        } onPressingChanged: { pressing in
            withAnimation(MaterialMotion.quickFade) {
                isPressed = pressing
            }
        }
    }
}

// MARK: - Material Search Bar

struct MaterialSearchBar: View {
    @Binding var text: String
    let placeholder: String

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: MaterialSpacing.md) {
            Image(systemName: MaterialIcon.search)
                .font(.title3)
                .foregroundColor(.materialOnSurfaceVariant)

            TextField(placeholder, text: $text)
                .font(MaterialFont.bodyLarge)
                .foregroundColor(.materialOnSurface)
                .focused($isFocused)

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: MaterialIcon.close)
                        .font(.title3)
                        .foregroundColor(.materialOnSurfaceVariant)
                }
                .materialStateLayer(color: .materialOnSurface)
            }
        }
        .padding(.horizontal, MaterialSpacing.lg)
        .padding(.vertical, MaterialSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: MaterialShape.extraLarge, style: .continuous)
                .fill(Color.materialSurfaceContainerHigh)
                .overlay(
                    RoundedRectangle(cornerRadius: MaterialShape.extraLarge, style: .continuous)
                        .stroke(isFocused ? Color.materialPrimary : Color.materialOutline, lineWidth: isFocused ? 2 : 1)
                )
        )
        .animation(MaterialMotion.quickFade, value: isFocused)
    }
}

// MARK: - Material Navigation Drawer

struct MaterialNavigationDrawer<Content: View>: View {
    @Binding var isOpen: Bool
    let content: Content

    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isOpen = isOpen
        self.content = content()
    }

    var body: some View {
        ZStack {
            // Scrim
            if isOpen {
                Color.materialScrim
                    .opacity(0.32)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(MaterialMotion.mediumSlide) {
                            isOpen = false
                        }
                    }
            }

            // Drawer
            HStack {
                if isOpen {
                    VStack {
                        content
                    }
                    .frame(width: 280)
                    .background(Color.materialSurfaceContainerLow)
                    .materialElevation(1)
                    .transition(.move(edge: .leading))
                }

                Spacer()
            }
        }
        .animation(MaterialMotion.mediumSlide, value: isOpen)
    }
}

// MARK: - Material Dialog

struct MaterialDialog<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        ZStack {
            if isPresented {
                // Scrim
                Color.materialScrim
                    .opacity(0.32)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(MaterialMotion.quickFade) {
                            isPresented = false
                        }
                    }

                // Dialog
                VStack {
                    content
                }
                .padding(MaterialSpacing.xxl)
                .background(
                    RoundedRectangle(cornerRadius: MaterialShape.extraLarge, style: .continuous)
                        .fill(Color.materialSurfaceContainerHigh)
                )
                .materialElevation(3)
                .frame(maxWidth: 280)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(MaterialMotion.emphasized, value: isPresented)
    }
}

#Preview("Material Components") {
    ScrollView {
        VStack(spacing: MaterialSpacing.xxl) {
            // Buttons
            VStack(spacing: MaterialSpacing.md) {
                MaterialButton(text: "Filled Button", style: .filled) {}
                MaterialButton(text: "Outlined Button", style: .outlined) {}
                MaterialButton(text: "Text Button", style: .text) {}
            }

            // Cards
            MaterialCard(elevation: 2) {
                VStack(alignment: .leading, spacing: MaterialSpacing.md) {
                    Text("Material Card")
                        .font(MaterialFont.titleMedium)
                        .foregroundColor(.materialOnSurface)

                    Text("This is a Material Design card with proper elevation and styling.")
                        .font(MaterialFont.bodyMedium)
                        .foregroundColor(.materialOnSurfaceVariant)
                }
            }

            // FAB
            HStack {
                MaterialFAB(icon: MaterialIcon.add, action: {}, size: .normal)
                Spacer()
            }

            // Search Bar
            MaterialSearchBar(text: .constant(""), placeholder: "Search...")

            Spacer()
        }
        .padding(MaterialSpacing.screenPadding)
    }
    .background(Color.materialSurface)
    .preferredColorScheme(.dark)
}