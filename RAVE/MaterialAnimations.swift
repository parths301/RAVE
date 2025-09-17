//
//  MaterialAnimations.swift
//  RAVE - Material Design 3 Animation System
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

// MARK: - Material Motion Advanced System

extension MaterialMotion {
    // MARK: - Advanced Easing Functions

    static let expressiveEasing = Animation.timingCurve(0.2, 0.0, 0.0, 1.0)
    static let productiveEasing = Animation.timingCurve(0.0, 0.0, 0.2, 1.0)
    static let standardEasing = Animation.timingCurve(0.2, 0.0, 0.2, 1.0)

    // MARK: - Complex Animations

    static let heroTransition = Animation.spring(
        response: 0.8,
        dampingFraction: 0.8,
        blendDuration: 0.3
    )

    static let sharedElementTransition = Animation.interpolatingSpring(
        mass: 1.0,
        stiffness: 100.0,
        damping: 15.0,
        initialVelocity: 0.0
    )

    static let bottomSheetPresentation = Animation.interpolatingSpring(
        mass: 1.0,
        stiffness: 200.0,
        damping: 20.0,
        initialVelocity: 0.0
    )

    // MARK: - Micro-interactions

    static let pressAnimation = Animation.easeInOut(duration: 0.1)
    static let hoverAnimation = Animation.easeInOut(duration: 0.15)
    static let focusAnimation = Animation.easeInOut(duration: 0.2)

    // MARK: - Navigation Animations

    static let navigationPush = Animation.timingCurve(0.2, 0.0, 0.0, 1.0, duration: 0.3)
    static let navigationPop = Animation.timingCurve(0.0, 0.0, 0.2, 1.0, duration: 0.25)
    static let modalPresentation = Animation.timingCurve(0.0, 0.0, 0.2, 1.0, duration: 0.4)
    static let modalDismissal = Animation.timingCurve(0.2, 0.0, 1.0, 1.0, duration: 0.25)

    // MARK: - List Animations

    static let listItemInsert = Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let listItemRemove = Animation.easeInOut(duration: 0.25)
    static let listItemMove = Animation.spring(response: 0.4, dampingFraction: 0.9)

    // MARK: - Loading Animations

    static let loadingPulse = Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)
    static let loadingRotation = Animation.linear(duration: 1.0).repeatForever(autoreverses: false)
    static let shimmerAnimation = Animation.linear(duration: 1.5).repeatForever(autoreverses: false)
}

// MARK: - Material Transition Effects

struct MaterialSlideTransition: ViewModifier {
    let isActive: Bool
    let edge: Edge

    func body(content: Content) -> some View {
        content
            .transition(.asymmetric(
                insertion: .move(edge: edge).combined(with: .opacity),
                removal: .move(edge: edge).combined(with: .opacity)
            ))
            .animation(MaterialMotion.mediumSlide, value: isActive)
    }
}

struct MaterialScaleTransition: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive ? 1.0 : 0.8)
            .opacity(isActive ? 1.0 : 0.0)
            .animation(MaterialMotion.emphasized, value: isActive)
    }
}

struct MaterialFadeTransition: ViewModifier {
    let isActive: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isActive ? 1.0 : 0.0)
            .animation(MaterialMotion.quickFade, value: isActive)
    }
}

// MARK: - Material Loading Animations

struct MaterialShimmerEffect: ViewModifier {
    @State private var shimmerPhase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.materialOnSurface.opacity(0.1),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .mask(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, Color.black, Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .rotationEffect(.degrees(30))
                        .offset(x: shimmerPhase)
                )
            )
            .onAppear {
                withAnimation(MaterialMotion.shimmerAnimation) {
                    shimmerPhase = 200
                }
            }
    }
}

struct MaterialPulseEffect: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .opacity(isPulsing ? 0.8 : 1.0)
            .onAppear {
                withAnimation(MaterialMotion.loadingPulse) {
                    isPulsing.toggle()
                }
            }
    }
}

struct MaterialLoadingSpinner: View {
    @State private var rotation: Double = 0

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(
                AngularGradient(
                    colors: [
                        Color.materialPrimary.opacity(0.2),
                        Color.materialPrimary
                    ],
                    center: .center
                ),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
            .frame(width: 24, height: 24)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(MaterialMotion.loadingRotation) {
                    rotation = 360
                }
            }
    }
}

// MARK: - Material Interactive Animations

struct MaterialPressableScale: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) {
                withAnimation(MaterialMotion.pressAnimation) {
                    isPressed = true
                }
            } onPressingChanged: { pressing in
                withAnimation(MaterialMotion.pressAnimation) {
                    isPressed = pressing
                }
            }
    }
}

struct MaterialHoverEffect: ViewModifier {
    @State private var isHovered = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .brightness(isHovered ? 0.05 : 0.0)
            .animation(MaterialMotion.hoverAnimation, value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

// MARK: - Material Page Transitions

struct MaterialPageTransition: ViewModifier {
    let direction: PageDirection

    enum PageDirection {
        case forward, backward
    }

    func body(content: Content) -> some View {
        content
            .transition(.asymmetric(
                insertion: .move(edge: direction == .forward ? .trailing : .leading)
                    .combined(with: .opacity),
                removal: .move(edge: direction == .forward ? .leading : .trailing)
                    .combined(with: .opacity)
            ))
    }
}

// MARK: - Material Floating Action Button Animations

struct MaterialFABTransition: ViewModifier {
    let isVisible: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(isVisible ? 1.0 : 0.0)
            .opacity(isVisible ? 1.0 : 0.0)
            .rotation3DEffect(
                .degrees(isVisible ? 0 : 180),
                axis: (x: 0, y: 1, z: 0)
            )
            .animation(MaterialMotion.emphasized, value: isVisible)
    }
}

// MARK: - Material Snackbar Animations

struct MaterialSnackbarTransition: ViewModifier {
    let isPresented: Bool

    func body(content: Content) -> some View {
        content
            .offset(y: isPresented ? 0 : 100)
            .opacity(isPresented ? 1.0 : 0.0)
            .animation(MaterialMotion.bottomSheetPresentation, value: isPresented)
    }
}

// MARK: - View Extensions for Material Animations

extension View {
    func materialSlideTransition(isActive: Bool, edge: Edge = .bottom) -> some View {
        modifier(MaterialSlideTransition(isActive: isActive, edge: edge))
    }

    func materialScaleTransition(isActive: Bool) -> some View {
        modifier(MaterialScaleTransition(isActive: isActive))
    }

    func materialFadeTransition(isActive: Bool) -> some View {
        modifier(MaterialFadeTransition(isActive: isActive))
    }

    func materialShimmer() -> some View {
        modifier(MaterialShimmerEffect())
    }

    func materialPulse() -> some View {
        modifier(MaterialPulseEffect())
    }

    func materialPressable() -> some View {
        modifier(MaterialPressableScale())
    }

    func materialHover() -> some View {
        modifier(MaterialHoverEffect())
    }

    func materialPageTransition(direction: MaterialPageTransition.PageDirection) -> some View {
        modifier(MaterialPageTransition(direction: direction))
    }

    func materialFABTransition(isVisible: Bool) -> some View {
        modifier(MaterialFABTransition(isVisible: isVisible))
    }

    func materialSnackbarTransition(isPresented: Bool) -> some View {
        modifier(MaterialSnackbarTransition(isPresented: isPresented))
    }
}

// MARK: - Material Staggered Animations

struct MaterialStaggeredAnimation {
    static func staggeredDelay(for index: Int, baseDelay: Double = 0.1) -> Double {
        return baseDelay * Double(index)
    }

    static func staggeredAnimation(for index: Int, animation: Animation = MaterialMotion.quickFade) -> Animation {
        return animation.delay(staggeredDelay(for: index))
    }
}

// MARK: - Material Theme Transition

struct MaterialThemeTransition: ViewModifier {
    let isDarkMode: Bool

    func body(content: Content) -> some View {
        content
            .animation(MaterialMotion.longTransform, value: isDarkMode)
    }
}

extension View {
    func materialThemeTransition(isDarkMode: Bool) -> some View {
        modifier(MaterialThemeTransition(isDarkMode: isDarkMode))
    }
}

#Preview("Material Animations") {
    VStack(spacing: MaterialSpacing.xxl) {
        MaterialLoadingSpinner()

        Text("Shimmer Effect")
            .materialShimmer()

        MaterialButton(text: "Pressable Button", style: .filled) {}
            .materialPressable()

        Text("Pulsing Text")
            .materialPulse()
    }
    .padding(MaterialSpacing.screenPadding)
    .background(Color.materialSurface)
    .preferredColorScheme(.dark)
}