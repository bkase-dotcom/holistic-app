import SwiftUI

enum HTheme {
    // ── Adaptive Colors (dark = original palette, light = sepia) ──

    static let bg = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.024, green: 0.024, blue: 0.039, alpha: 1)     // #06060A near-black
            : UIColor(red: 0.965, green: 0.945, blue: 0.910, alpha: 1)     // #F6F1E8 warm parchment
    })

    static let fg = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.91, green: 0.88, blue: 0.84, alpha: 1)        // #E8E1D5 warm white
            : UIColor(red: 0.18, green: 0.15, blue: 0.12, alpha: 1)        // #2E261F dark brown
    })

    static let dim = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.37, green: 0.345, blue: 0.31, alpha: 1)       // #5E584F muted
            : UIColor(red: 0.55, green: 0.49, blue: 0.42, alpha: 1)        // #8C7D6B medium brown
    })

    static let warm = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.769, green: 0.584, blue: 0.416, alpha: 1)     // #C4956A warm amber
            : UIColor(red: 0.68, green: 0.48, blue: 0.30, alpha: 1)        // #AD7A4D darker amber
    })

    static let copper = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.722, green: 0.451, blue: 0.2, alpha: 1)       // #B87333 copper
            : UIColor(red: 0.62, green: 0.38, blue: 0.15, alpha: 1)        // #9E6126 deep copper
    })

    static let rust = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.659, green: 0.353, blue: 0.227, alpha: 1)     // #A85A3A rust
            : UIColor(red: 0.58, green: 0.28, blue: 0.16, alpha: 1)        // #944729 deep rust
    })

    static let teal = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.239, green: 0.545, blue: 0.545, alpha: 1)     // #3D8B8B teal
            : UIColor(red: 0.18, green: 0.46, blue: 0.46, alpha: 1)        // #2E7575 deep teal
    })

    static let gold = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.788, green: 0.659, blue: 0.298, alpha: 1)     // #C9A84C gold
            : UIColor(red: 0.65, green: 0.53, blue: 0.20, alpha: 1)        // #A68733 deep gold
    })

    static let violet = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.42, green: 0.365, blue: 0.6, alpha: 1)        // #6B5D99 violet
            : UIColor(red: 0.35, green: 0.29, blue: 0.52, alpha: 1)        // #594A85 deep violet
    })

    static let cardBg = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.035)                        // glass card dark
            : UIColor(red: 0.42, green: 0.36, blue: 0.28, alpha: 0.06)     // sepia card tint
    })

    static let borderColor = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.04)                         // subtle border dark
            : UIColor(red: 0.42, green: 0.36, blue: 0.28, alpha: 0.10)     // sepia border
    })

    // ── Typography ──
    static func display(_ size: CGFloat) -> Font { .system(size: size, weight: .light, design: .serif) }
    static func displayItalic(_ size: CGFloat) -> Font { .system(size: size, weight: .light, design: .serif).italic() }
    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font { .system(size: size, weight: weight, design: .rounded) }
    static func label() -> Font { .system(size: 10, weight: .medium, design: .rounded) }

    // ── Spacing ──
    static let pagePadding: CGFloat = 18
    static let cardRadius: CGFloat = 14
    static let cardPadding: CGFloat = 14
    static let gridSpacing: CGFloat = 10

    // ── Haptics ──
    static func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

// MARK: - Pressable Card Style
struct PressableCardStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.96 : 1)
            .brightness(configuration.isPressed ? -0.02 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, pressed in
                if pressed { HTheme.haptic(.soft) }
            }
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
