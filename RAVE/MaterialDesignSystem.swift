//
//  MaterialDesignSystem.swift
//  RAVE - Material Design 3 Implementation
//
//  Created by Claude on 12/09/25.
//

import SwiftUI
import UIKit

// MARK: - Material Design 3 Color System
extension Color {
    // MARK: - RAVE Material Design Color Tokens

    // Primary Colors - Based on Neon Purple (#A16EFF)
    static let materialPrimary = Color(red: 0.63, green: 0.43, blue: 1.0)
    static let materialOnPrimary = Color.white
    static let materialPrimaryContainer = Color(red: 0.85, green: 0.77, blue: 1.0)
    static let materialOnPrimaryContainer = Color(red: 0.25, green: 0.05, blue: 0.45)

    // Secondary Colors - Generated from Material algorithms
    static let materialSecondary = Color(red: 0.45, green: 0.39, blue: 0.65)
    static let materialOnSecondary = Color.white
    static let materialSecondaryContainer = Color(red: 0.77, green: 0.71, blue: 0.93)
    static let materialOnSecondaryContainer = Color(red: 0.15, green: 0.09, blue: 0.35)

    // Tertiary Colors - Nightlife complement
    static let materialTertiary = Color(red: 0.93, green: 0.35, blue: 0.65)
    static let materialOnTertiary = Color.white
    static let materialTertiaryContainer = Color(red: 1.0, green: 0.82, blue: 0.89)
    static let materialOnTertiaryContainer = Color(red: 0.35, green: 0.05, blue: 0.20)

    // Error Colors
    static let materialError = Color(red: 0.73, green: 0.11, blue: 0.14)
    static let materialOnError = Color.white
    static let materialErrorContainer = Color(red: 0.98, green: 0.86, blue: 0.86)
    static let materialOnErrorContainer = Color(red: 0.25, green: 0.00, blue: 0.02)

    // Surface Colors - Dark Theme Focus
    static let materialSurface = Color(red: 0.06, green: 0.05, blue: 0.09)
    static let materialOnSurface = Color(red: 0.90, green: 0.89, blue: 0.93)
    static let materialSurfaceVariant = Color(red: 0.28, green: 0.26, blue: 0.32)
    static let materialOnSurfaceVariant = Color(red: 0.78, green: 0.74, blue: 0.83)

    // Surface Containers
    static let materialSurfaceContainer = Color(red: 0.11, green: 0.10, blue: 0.14)
    static let materialSurfaceContainerLow = Color(red: 0.08, green: 0.07, blue: 0.11)
    static let materialSurfaceContainerHigh = Color(red: 0.15, green: 0.14, blue: 0.18)
    static let materialSurfaceContainerHighest = Color(red: 0.20, green: 0.19, blue: 0.23)

    // Outline Colors
    static let materialOutline = Color(red: 0.49, green: 0.46, blue: 0.54)
    static let materialOutlineVariant = Color(red: 0.28, green: 0.26, blue: 0.32)

    // Shadow and Scrim
    static let materialShadow = Color.black
    static let materialScrim = Color.black

    // Inverse Colors
    static let materialInverseSurface = Color(red: 0.90, green: 0.89, blue: 0.93)
    static let materialInverseOnSurface = Color(red: 0.19, green: 0.18, blue: 0.22)
    static let materialInversePrimary = Color(red: 0.43, green: 0.23, blue: 0.80)
}

// MARK: - Material Typography System
struct MaterialFont {
    // Display Typography
    static let displayLarge = Font.system(size: 57, weight: .regular, design: .default)
    static let displayMedium = Font.system(size: 45, weight: .regular, design: .default)
    static let displaySmall = Font.system(size: 36, weight: .regular, design: .default)

    // Headline Typography
    static let headlineLarge = Font.system(size: 32, weight: .regular, design: .default)
    static let headlineMedium = Font.system(size: 28, weight: .regular, design: .default)
    static let headlineSmall = Font.system(size: 24, weight: .regular, design: .default)

    // Title Typography
    static let titleLarge = Font.system(size: 22, weight: .regular, design: .default)
    static let titleMedium = Font.system(size: 16, weight: .medium, design: .default)
    static let titleSmall = Font.system(size: 14, weight: .medium, design: .default)

    // Body Typography
    static let bodyLarge = Font.system(size: 16, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 14, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 12, weight: .regular, design: .default)

    // Label Typography
    static let labelLarge = Font.system(size: 14, weight: .medium, design: .default)
    static let labelMedium = Font.system(size: 12, weight: .medium, design: .default)
    static let labelSmall = Font.system(size: 11, weight: .medium, design: .default)

    // RAVE Brand Typography - Material Sized
    static let raveDisplayLarge = Font.system(size: 57, weight: .bold, design: .default).width(.condensed)
    static let raveDisplayMedium = Font.system(size: 45, weight: .bold, design: .default).width(.condensed)
    static let raveHeadline = Font.system(size: 32, weight: .bold, design: .default).width(.condensed)
}

// MARK: - Material Spacing System
struct MaterialSpacing {
    // 4dp base unit system
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
    static let xxxxl: CGFloat = 40
    static let xxxxxl: CGFloat = 48
    static let xxxxxxl: CGFloat = 56
    static let xxxxxxxl: CGFloat = 64

    // Common Material spacing
    static let listItemPadding: CGFloat = 16
    static let cardPadding: CGFloat = 16
    static let screenPadding: CGFloat = 16
    static let componentSpacing: CGFloat = 8
}

// MARK: - Material Shape System
struct MaterialShape {
    static let small: CGFloat = 4
    static let medium: CGFloat = 8
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 28

    // Component-specific shapes
    static let buttonRadius: CGFloat = 20
    static let cardRadius: CGFloat = 12
    static let chipRadius: CGFloat = 8
    static let fabRadius: CGFloat = 16
}

// MARK: - Material Elevation System
struct MaterialElevation {
    static func shadow(level: Int) -> some View {
        Group {
            switch level {
            case 0:
                EmptyView()
            case 1:
                Color.clear.shadow(
                    color: Color.materialShadow.opacity(0.15),
                    radius: 1,
                    x: 0,
                    y: 1
                )
            case 2:
                Color.clear.shadow(
                    color: Color.materialShadow.opacity(0.15),
                    radius: 2,
                    x: 0,
                    y: 1
                )
            case 3:
                Color.clear.shadow(
                    color: Color.materialShadow.opacity(0.20),
                    radius: 4,
                    x: 0,
                    y: 2
                )
            case 4:
                Color.clear.shadow(
                    color: Color.materialShadow.opacity(0.25),
                    radius: 8,
                    x: 0,
                    y: 4
                )
            case 5:
                Color.clear.shadow(
                    color: Color.materialShadow.opacity(0.30),
                    radius: 12,
                    x: 0,
                    y: 6
                )
            default:
                Color.clear.shadow(
                    color: Color.materialShadow.opacity(0.30),
                    radius: 12,
                    x: 0,
                    y: 6
                )
            }
        }
    }
}

// MARK: - Material State Layer System
struct MaterialStateLayer {
    static let hover: Double = 0.08
    static let focus: Double = 0.12
    static let pressed: Double = 0.12
    static let dragged: Double = 0.16
    static let disabled: Double = 0.12
}

// MARK: - Material Motion System
struct MaterialMotion {
    // Duration tokens (milliseconds converted to seconds)
    static let duration50: Double = 0.05
    static let duration100: Double = 0.1
    static let duration150: Double = 0.15
    static let duration200: Double = 0.2
    static let duration250: Double = 0.25
    static let duration300: Double = 0.3
    static let duration350: Double = 0.35

    // Easing curves
    static let standard = Animation.easeInOut
    static let standardAccelerate = Animation.easeIn
    static let standardDecelerate = Animation.easeOut
    static let emphasized = Animation.spring(response: 0.6, dampingFraction: 0.8)

    // Common animations
    static let quickFade = Animation.easeInOut(duration: duration150)
    static let mediumSlide = Animation.easeInOut(duration: duration250)
    static let longTransform = Animation.easeInOut(duration: duration350)
}

// MARK: - Material Component Extensions
extension View {
    // Apply Material state layer
    func materialStateLayer(color: Color = Color.materialOnSurface, isPressed: Bool = false, isHovered: Bool = false) -> some View {
        self.overlay(
            Rectangle()
                .fill(color.opacity(isPressed ? MaterialStateLayer.pressed : (isHovered ? MaterialStateLayer.hover : 0)))
        )
    }

    // Apply Material elevation
    func materialElevation(_ level: Int) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: MaterialShape.medium)
                .fill(Color.materialSurface)
                .overlay(MaterialElevation.shadow(level: level))
        )
    }

    // Apply Material card styling
    func materialCard(elevation: Int = 1) -> some View {
        self
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

    // Apply Material list item styling
    func materialListItem() -> some View {
        self
            .padding(.horizontal, MaterialSpacing.listItemPadding)
            .padding(.vertical, MaterialSpacing.md)
            .background(Color.materialSurface)
    }
}

// MARK: - Material Icon System
struct MaterialIcon {
    // Navigation icons (24dp standard)
    static let home = "house"
    static let search = "magnifyingglass"
    static let menu = "line.horizontal.3"
    static let back = "chevron.left"
    static let close = "xmark"
    static let more = "ellipsis"

    // Action icons
    static let add = "plus"
    static let edit = "pencil"
    static let delete = "trash"
    static let share = "square.and.arrow.up"
    static let favorite = "heart"
    static let settings = "gearshape"

    // Content icons
    static let person = "person"
    static let group = "person.3"
    static let location = "location"
    static let notification = "bell"
    static let message = "message"

    // RAVE specific icons
    static let nightclub = "wineglass"
    static let crew = "person.3"
    static let party = "party.popper"
}

#Preview("Material Colors") {
    ScrollView {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: MaterialSpacing.md) {
            ColorSwatch(name: "Primary", color: .materialPrimary)
            ColorSwatch(name: "Secondary", color: .materialSecondary)
            ColorSwatch(name: "Tertiary", color: .materialTertiary)
            ColorSwatch(name: "Surface", color: .materialSurface)
            ColorSwatch(name: "Surface Container", color: .materialSurfaceContainer)
            ColorSwatch(name: "Error", color: .materialError)
        }
        .padding(MaterialSpacing.screenPadding)
    }
    .background(Color.materialSurface)
    .preferredColorScheme(.dark)
}

struct ColorSwatch: View {
    let name: String
    let color: Color

    var body: some View {
        VStack(spacing: MaterialSpacing.sm) {
            Rectangle()
                .fill(color)
                .frame(height: 60)
                .materialCard()

            Text(name)
                .font(MaterialFont.labelMedium)
                .foregroundColor(.materialOnSurface)
        }
    }
}