// SPDX-License-Identifier: GPL-3.0-or-later

// Defines keyboard themes and the manager that applies them.

import UIKit

// MARK: - ThemeCategory

enum ThemeCategory: String, CaseIterable {
    case classic    = "Classic"
    case dark       = "Dark"
    case light      = "Light"
    case gradient   = "Gradient"
    case neon       = "Neon"
    case nature     = "Nature"
    case cultural   = "Cultural"
    case accessible = "Accessible"
}

// MARK: - KeyboardTheme

/// A complete color definition for a keyboard theme.
struct KeyboardTheme {
    let id: String
    let displayName: String
    let category: ThemeCategory
    let overridesSystemAppearance: Bool

    // Key colors
    let keyColor: UIColor
    let keyCharColor: UIColor
    let specialKeyColor: UIColor
    let keyPressedColor: UIColor
    let keyShadowColor: UIColor

    // Command / bar colors
    let commandKeyColor: UIColor
    let commandBarColor: UIColor
    let commandBarPlaceholderColor: UIColor

    // Background
    let keyboardBgColor: UIColor

    /// Optional gradient colors for the picker preview (start → end).
    /// When set, the preview renders a gradient background instead of a flat color.
    let gradientColors: (UIColor, UIColor)?

    init(
        id: String,
        displayName: String,
        category: ThemeCategory = .classic,
        overridesSystemAppearance: Bool = true,
        keyColor: UIColor,
        keyCharColor: UIColor,
        specialKeyColor: UIColor,
        keyPressedColor: UIColor,
        keyShadowColor: UIColor,
        commandKeyColor: UIColor,
        commandBarColor: UIColor,
        commandBarPlaceholderColor: UIColor,
        keyboardBgColor: UIColor,
        gradientColors: (UIColor, UIColor)? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.category = category
        self.overridesSystemAppearance = overridesSystemAppearance
        self.keyColor = keyColor
        self.keyCharColor = keyCharColor
        self.specialKeyColor = specialKeyColor
        self.keyPressedColor = keyPressedColor
        self.keyShadowColor = keyShadowColor
        self.commandKeyColor = commandKeyColor
        self.commandBarColor = commandBarColor
        self.commandBarPlaceholderColor = commandBarPlaceholderColor
        self.keyboardBgColor = keyboardBgColor
        self.gradientColors = gradientColors
    }
}

// MARK: - Built-in themes

extension KeyboardTheme {
    /// The default Scribe theme — respects system light/dark mode.
    static let `default` = KeyboardTheme(
        id: "default",
        displayName: "Default",
        category: .classic,
        overridesSystemAppearance: false,
        keyColor: UIColor(ScribeColor.key),
        keyCharColor: UIColor(ScribeColor.keyChar),
        specialKeyColor: UIColor(ScribeColor.keySpecial),
        keyPressedColor: UIColor(ScribeColor.keyPressed),
        keyShadowColor: UIColor(ScribeColor.keyShadow),
        commandKeyColor: UIColor(ScribeColor.commandKey),
        commandBarColor: UIColor(ScribeColor.commandBar),
        commandBarPlaceholderColor: UIColor(ScribeColor.commandBarPlaceholder),
        keyboardBgColor: UIColor(ScribeColor.keyboardBackground)
    )

    /// Deep ocean blue theme.
    static let ocean = KeyboardTheme(
        id: "ocean",
        displayName: "Ocean",
        category: .classic,
        keyColor: UIColor(red: 0.18, green: 0.38, blue: 0.60, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.10, green: 0.24, blue: 0.42, alpha: 1),
        keyPressedColor: UIColor(red: 0.30, green: 0.55, blue: 0.80, alpha: 1),
        keyShadowColor: UIColor(red: 0.05, green: 0.12, blue: 0.25, alpha: 1),
        commandKeyColor: UIColor(red: 0.10, green: 0.24, blue: 0.42, alpha: 1),
        commandBarColor: UIColor(red: 0.13, green: 0.29, blue: 0.49, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.08, green: 0.18, blue: 0.33, alpha: 1)
    )

    /// Midnight dark theme.
    static let midnight = KeyboardTheme(
        id: "midnight",
        displayName: "Midnight",
        category: .dark,
        keyColor: UIColor(red: 0.20, green: 0.20, blue: 0.22, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1),
        keyPressedColor: UIColor(red: 0.35, green: 0.35, blue: 0.38, alpha: 1),
        keyShadowColor: UIColor(red: 0.05, green: 0.05, blue: 0.06, alpha: 1),
        commandKeyColor: UIColor(red: 0.12, green: 0.12, blue: 0.14, alpha: 1),
        commandBarColor: UIColor(red: 0.16, green: 0.16, blue: 0.18, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.40),
        keyboardBgColor: UIColor(red: 0.09, green: 0.09, blue: 0.10, alpha: 1)
    )

    /// Forest green theme.
    static let forest = KeyboardTheme(
        id: "forest",
        displayName: "Forest",
        category: .nature,
        keyColor: UIColor(red: 0.22, green: 0.42, blue: 0.25, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.13, green: 0.27, blue: 0.16, alpha: 1),
        keyPressedColor: UIColor(red: 0.35, green: 0.60, blue: 0.38, alpha: 1),
        keyShadowColor: UIColor(red: 0.07, green: 0.15, blue: 0.08, alpha: 1),
        commandKeyColor: UIColor(red: 0.13, green: 0.27, blue: 0.16, alpha: 1),
        commandBarColor: UIColor(red: 0.17, green: 0.33, blue: 0.20, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.10, green: 0.20, blue: 0.12, alpha: 1)
    )

    /// Warm rose / pink theme.
    static let rose = KeyboardTheme(
        id: "rose",
        displayName: "Rose",
        category: .light,
        keyColor: UIColor(red: 0.90, green: 0.72, blue: 0.74, alpha: 1),
        keyCharColor: UIColor(red: 0.25, green: 0.10, blue: 0.12, alpha: 1),
        specialKeyColor: UIColor(red: 0.78, green: 0.55, blue: 0.58, alpha: 1),
        keyPressedColor: UIColor(red: 0.98, green: 0.85, blue: 0.87, alpha: 1),
        keyShadowColor: UIColor(red: 0.60, green: 0.35, blue: 0.38, alpha: 1),
        commandKeyColor: UIColor(red: 0.78, green: 0.55, blue: 0.58, alpha: 1),
        commandBarColor: UIColor(red: 0.85, green: 0.63, blue: 0.66, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.45, green: 0.20, blue: 0.23, alpha: 0.6),
        keyboardBgColor: UIColor(red: 0.96, green: 0.88, blue: 0.89, alpha: 1)
    )

    /// High-contrast pure white theme.
    static let snow = KeyboardTheme(
        id: "snow",
        displayName: "Snow",
        category: .light,
        keyColor: .white,
        keyCharColor: UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1),
        specialKeyColor: UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1),
        keyPressedColor: UIColor(red: 0.70, green: 0.70, blue: 0.72, alpha: 1),
        keyShadowColor: UIColor(red: 0.55, green: 0.55, blue: 0.57, alpha: 1),
        commandKeyColor: UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1),
        commandBarColor: UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.50, green: 0.50, blue: 0.52, alpha: 1),
        keyboardBgColor: UIColor(red: 0.88, green: 0.88, blue: 0.90, alpha: 1)
    )

    /// Warm amber / golden sand theme.
    static let sand = KeyboardTheme(
        id: "sand",
        displayName: "Sand",
        category: .light,
        keyColor: UIColor(red: 0.94, green: 0.84, blue: 0.62, alpha: 1),
        keyCharColor: UIColor(red: 0.28, green: 0.18, blue: 0.04, alpha: 1),
        specialKeyColor: UIColor(red: 0.80, green: 0.66, blue: 0.38, alpha: 1),
        keyPressedColor: UIColor(red: 1.00, green: 0.94, blue: 0.78, alpha: 1),
        keyShadowColor: UIColor(red: 0.55, green: 0.40, blue: 0.10, alpha: 1),
        commandKeyColor: UIColor(red: 0.80, green: 0.66, blue: 0.38, alpha: 1),
        commandBarColor: UIColor(red: 0.87, green: 0.75, blue: 0.50, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.40, green: 0.28, blue: 0.08, alpha: 0.6),
        keyboardBgColor: UIColor(red: 0.98, green: 0.92, blue: 0.76, alpha: 1)
    )

    /// Deep purple / violet theme.
    static let violet = KeyboardTheme(
        id: "violet",
        displayName: "Violet",
        category: .dark,
        keyColor: UIColor(red: 0.42, green: 0.22, blue: 0.68, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.28, green: 0.12, blue: 0.50, alpha: 1),
        keyPressedColor: UIColor(red: 0.60, green: 0.40, blue: 0.85, alpha: 1),
        keyShadowColor: UIColor(red: 0.15, green: 0.05, blue: 0.30, alpha: 1),
        commandKeyColor: UIColor(red: 0.28, green: 0.12, blue: 0.50, alpha: 1),
        commandBarColor: UIColor(red: 0.35, green: 0.17, blue: 0.58, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.18, green: 0.07, blue: 0.35, alpha: 1)
    )

    /// Soft lavender / lilac theme.
    static let lavender = KeyboardTheme(
        id: "lavender",
        displayName: "Lavender",
        category: .light,
        keyColor: UIColor(red: 0.82, green: 0.78, blue: 0.95, alpha: 1),
        keyCharColor: UIColor(red: 0.20, green: 0.12, blue: 0.40, alpha: 1),
        specialKeyColor: UIColor(red: 0.65, green: 0.60, blue: 0.85, alpha: 1),
        keyPressedColor: UIColor(red: 0.92, green: 0.90, blue: 0.99, alpha: 1),
        keyShadowColor: UIColor(red: 0.45, green: 0.38, blue: 0.65, alpha: 1),
        commandKeyColor: UIColor(red: 0.65, green: 0.60, blue: 0.85, alpha: 1),
        commandBarColor: UIColor(red: 0.73, green: 0.69, blue: 0.90, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.30, green: 0.22, blue: 0.55, alpha: 0.6),
        keyboardBgColor: UIColor(red: 0.91, green: 0.89, blue: 0.98, alpha: 1)
    )

    /// Burnt orange / terracotta theme.
    static let terracotta = KeyboardTheme(
        id: "terracotta",
        displayName: "Terracotta",
        category: .nature,
        keyColor: UIColor(red: 0.78, green: 0.40, blue: 0.25, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.58, green: 0.26, blue: 0.14, alpha: 1),
        keyPressedColor: UIColor(red: 0.92, green: 0.58, blue: 0.42, alpha: 1),
        keyShadowColor: UIColor(red: 0.35, green: 0.12, blue: 0.05, alpha: 1),
        commandKeyColor: UIColor(red: 0.58, green: 0.26, blue: 0.14, alpha: 1),
        commandBarColor: UIColor(red: 0.68, green: 0.33, blue: 0.19, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.96, green: 0.88, blue: 0.82, alpha: 1)
    )

    /// Teal / cyan theme.
    static let teal = KeyboardTheme(
        id: "teal",
        displayName: "Teal",
        category: .classic,
        keyColor: UIColor(red: 0.10, green: 0.60, blue: 0.60, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.05, green: 0.42, blue: 0.42, alpha: 1),
        keyPressedColor: UIColor(red: 0.22, green: 0.78, blue: 0.78, alpha: 1),
        keyShadowColor: UIColor(red: 0.02, green: 0.25, blue: 0.25, alpha: 1),
        commandKeyColor: UIColor(red: 0.05, green: 0.42, blue: 0.42, alpha: 1),
        commandBarColor: UIColor(red: 0.07, green: 0.50, blue: 0.50, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.03, green: 0.28, blue: 0.28, alpha: 1)
    )

    /// Slate blue-grey theme.
    static let slate = KeyboardTheme(
        id: "slate",
        displayName: "Slate",
        category: .dark,
        keyColor: UIColor(red: 0.38, green: 0.46, blue: 0.56, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.25, green: 0.32, blue: 0.40, alpha: 1),
        keyPressedColor: UIColor(red: 0.52, green: 0.60, blue: 0.70, alpha: 1),
        keyShadowColor: UIColor(red: 0.12, green: 0.17, blue: 0.22, alpha: 1),
        commandKeyColor: UIColor(red: 0.25, green: 0.32, blue: 0.40, alpha: 1),
        commandBarColor: UIColor(red: 0.30, green: 0.38, blue: 0.47, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.40),
        keyboardBgColor: UIColor(red: 0.16, green: 0.21, blue: 0.27, alpha: 1)
    )

    /// Mint / fresh green theme.
    static let mint = KeyboardTheme(
        id: "mint",
        displayName: "Mint",
        category: .light,
        keyColor: UIColor(red: 0.72, green: 0.94, blue: 0.84, alpha: 1),
        keyCharColor: UIColor(red: 0.05, green: 0.28, blue: 0.18, alpha: 1),
        specialKeyColor: UIColor(red: 0.50, green: 0.80, blue: 0.66, alpha: 1),
        keyPressedColor: UIColor(red: 0.88, green: 0.99, blue: 0.94, alpha: 1),
        keyShadowColor: UIColor(red: 0.25, green: 0.55, blue: 0.40, alpha: 1),
        commandKeyColor: UIColor(red: 0.50, green: 0.80, blue: 0.66, alpha: 1),
        commandBarColor: UIColor(red: 0.60, green: 0.87, blue: 0.75, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.08, green: 0.38, blue: 0.25, alpha: 0.6),
        keyboardBgColor: UIColor(red: 0.88, green: 0.98, blue: 0.93, alpha: 1)
    )

    /// Warm peach / apricot theme.
    static let peach = KeyboardTheme(
        id: "peach",
        displayName: "Peach",
        category: .light,
        keyColor: UIColor(red: 0.98, green: 0.78, blue: 0.64, alpha: 1),
        keyCharColor: UIColor(red: 0.35, green: 0.14, blue: 0.04, alpha: 1),
        specialKeyColor: UIColor(red: 0.88, green: 0.60, blue: 0.42, alpha: 1),
        keyPressedColor: UIColor(red: 1.00, green: 0.90, blue: 0.80, alpha: 1),
        keyShadowColor: UIColor(red: 0.65, green: 0.35, blue: 0.15, alpha: 1),
        commandKeyColor: UIColor(red: 0.88, green: 0.60, blue: 0.42, alpha: 1),
        commandBarColor: UIColor(red: 0.93, green: 0.69, blue: 0.53, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.45, green: 0.20, blue: 0.05, alpha: 0.6),
        keyboardBgColor: UIColor(red: 1.00, green: 0.93, blue: 0.86, alpha: 1)
    )

    /// Deep crimson / ruby theme.
    static let crimson = KeyboardTheme(
        id: "crimson",
        displayName: "Crimson",
        category: .dark,
        keyColor: UIColor(red: 0.65, green: 0.10, blue: 0.18, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.45, green: 0.05, blue: 0.10, alpha: 1),
        keyPressedColor: UIColor(red: 0.82, green: 0.25, blue: 0.32, alpha: 1),
        keyShadowColor: UIColor(red: 0.25, green: 0.02, blue: 0.05, alpha: 1),
        commandKeyColor: UIColor(red: 0.45, green: 0.05, blue: 0.10, alpha: 1),
        commandBarColor: UIColor(red: 0.55, green: 0.08, blue: 0.14, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.28, green: 0.02, blue: 0.06, alpha: 1)
    )

    /// Warm sepia / coffee theme.
    static let sepia = KeyboardTheme(
        id: "sepia",
        displayName: "Sepia",
        category: .classic,
        keyColor: UIColor(red: 0.72, green: 0.55, blue: 0.38, alpha: 1),
        keyCharColor: UIColor(red: 0.18, green: 0.10, blue: 0.02, alpha: 1),
        specialKeyColor: UIColor(red: 0.52, green: 0.36, blue: 0.20, alpha: 1),
        keyPressedColor: UIColor(red: 0.88, green: 0.72, blue: 0.55, alpha: 1),
        keyShadowColor: UIColor(red: 0.30, green: 0.18, blue: 0.06, alpha: 1),
        commandKeyColor: UIColor(red: 0.52, green: 0.36, blue: 0.20, alpha: 1),
        commandBarColor: UIColor(red: 0.62, green: 0.45, blue: 0.28, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.25, green: 0.14, blue: 0.04, alpha: 0.6),
        keyboardBgColor: UIColor(red: 0.95, green: 0.88, blue: 0.76, alpha: 1)
    )

    // MARK: - Dark Gradient themes

    /// Aurora — dark teal-to-purple gradient.
    static let aurora = KeyboardTheme(
        id: "aurora", displayName: "Aurora", category: .gradient,
        keyColor: UIColor(red: 0.15, green: 0.35, blue: 0.45, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.08, green: 0.20, blue: 0.30, alpha: 1),
        keyPressedColor: UIColor(red: 0.25, green: 0.55, blue: 0.65, alpha: 1),
        keyShadowColor: UIColor(red: 0.03, green: 0.08, blue: 0.15, alpha: 1),
        commandKeyColor: UIColor(red: 0.30, green: 0.12, blue: 0.45, alpha: 1),
        commandBarColor: UIColor(red: 0.20, green: 0.10, blue: 0.35, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.05, green: 0.12, blue: 0.22, alpha: 1),
        gradientColors: (UIColor(red: 0.05, green: 0.22, blue: 0.35, alpha: 1),
                         UIColor(red: 0.22, green: 0.05, blue: 0.38, alpha: 1))
    )

    /// Sunset — dark orange-to-deep-pink gradient.
    static let sunset = KeyboardTheme(
        id: "sunset", displayName: "Sunset", category: .gradient,
        keyColor: UIColor(red: 0.75, green: 0.32, blue: 0.18, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.55, green: 0.18, blue: 0.25, alpha: 1),
        keyPressedColor: UIColor(red: 0.90, green: 0.50, blue: 0.30, alpha: 1),
        keyShadowColor: UIColor(red: 0.30, green: 0.08, blue: 0.05, alpha: 1),
        commandKeyColor: UIColor(red: 0.55, green: 0.18, blue: 0.25, alpha: 1),
        commandBarColor: UIColor(red: 0.65, green: 0.25, blue: 0.20, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.35, green: 0.10, blue: 0.12, alpha: 1),
        gradientColors: (UIColor(red: 0.85, green: 0.35, blue: 0.10, alpha: 1),
                         UIColor(red: 0.45, green: 0.05, blue: 0.30, alpha: 1))
    )

    /// Galaxy — deep space blue-to-indigo gradient.
    static let galaxy = KeyboardTheme(
        id: "galaxy", displayName: "Galaxy", category: .gradient,
        keyColor: UIColor(red: 0.18, green: 0.18, blue: 0.45, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.10, green: 0.10, blue: 0.30, alpha: 1),
        keyPressedColor: UIColor(red: 0.30, green: 0.30, blue: 0.65, alpha: 1),
        keyShadowColor: UIColor(red: 0.04, green: 0.04, blue: 0.15, alpha: 1),
        commandKeyColor: UIColor(red: 0.10, green: 0.10, blue: 0.30, alpha: 1),
        commandBarColor: UIColor(red: 0.14, green: 0.14, blue: 0.38, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.40),
        keyboardBgColor: UIColor(red: 0.06, green: 0.06, blue: 0.18, alpha: 1),
        gradientColors: (UIColor(red: 0.06, green: 0.06, blue: 0.25, alpha: 1),
                         UIColor(red: 0.18, green: 0.06, blue: 0.35, alpha: 1))
    )

    /// Ember — dark charcoal-to-deep-red gradient.
    static let ember = KeyboardTheme(
        id: "ember", displayName: "Ember", category: .gradient,
        keyColor: UIColor(red: 0.35, green: 0.15, blue: 0.10, alpha: 1),
        keyCharColor: UIColor(red: 1.0, green: 0.75, blue: 0.55, alpha: 1),
        specialKeyColor: UIColor(red: 0.20, green: 0.08, blue: 0.05, alpha: 1),
        keyPressedColor: UIColor(red: 0.55, green: 0.25, blue: 0.15, alpha: 1),
        keyShadowColor: UIColor(red: 0.08, green: 0.02, blue: 0.01, alpha: 1),
        commandKeyColor: UIColor(red: 0.20, green: 0.08, blue: 0.05, alpha: 1),
        commandBarColor: UIColor(red: 0.28, green: 0.12, blue: 0.08, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 1.0, green: 0.75, blue: 0.55, alpha: 0.5),
        keyboardBgColor: UIColor(red: 0.12, green: 0.05, blue: 0.03, alpha: 1),
        gradientColors: (UIColor(red: 0.18, green: 0.06, blue: 0.03, alpha: 1),
                         UIColor(red: 0.06, green: 0.06, blue: 0.06, alpha: 1))
    )

    /// Cotton Candy — light pink-to-blue gradient.
    static let cottonCandy = KeyboardTheme(
        id: "cotton_candy", displayName: "Cotton Candy", category: .gradient,
        keyColor: UIColor(red: 0.98, green: 0.82, blue: 0.90, alpha: 1),
        keyCharColor: UIColor(red: 0.30, green: 0.10, blue: 0.25, alpha: 1),
        specialKeyColor: UIColor(red: 0.82, green: 0.72, blue: 0.92, alpha: 1),
        keyPressedColor: UIColor(red: 1.0, green: 0.92, blue: 0.96, alpha: 1),
        keyShadowColor: UIColor(red: 0.65, green: 0.45, blue: 0.70, alpha: 1),
        commandKeyColor: UIColor(red: 0.72, green: 0.62, blue: 0.90, alpha: 1),
        commandBarColor: UIColor(red: 0.88, green: 0.78, blue: 0.95, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.40, green: 0.20, blue: 0.50, alpha: 0.5),
        keyboardBgColor: UIColor(red: 0.96, green: 0.90, blue: 0.98, alpha: 1),
        gradientColors: (UIColor(red: 1.0, green: 0.85, blue: 0.92, alpha: 1),
                         UIColor(red: 0.85, green: 0.88, blue: 1.0, alpha: 1))
    )

    /// Citrus — light yellow-to-green gradient.
    static let citrus = KeyboardTheme(
        id: "citrus", displayName: "Citrus", category: .gradient,
        keyColor: UIColor(red: 0.98, green: 0.95, blue: 0.65, alpha: 1),
        keyCharColor: UIColor(red: 0.20, green: 0.28, blue: 0.05, alpha: 1),
        specialKeyColor: UIColor(red: 0.75, green: 0.90, blue: 0.55, alpha: 1),
        keyPressedColor: UIColor(red: 1.0, green: 0.98, blue: 0.80, alpha: 1),
        keyShadowColor: UIColor(red: 0.45, green: 0.55, blue: 0.15, alpha: 1),
        commandKeyColor: UIColor(red: 0.65, green: 0.82, blue: 0.40, alpha: 1),
        commandBarColor: UIColor(red: 0.80, green: 0.92, blue: 0.55, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.25, green: 0.38, blue: 0.08, alpha: 0.5),
        keyboardBgColor: UIColor(red: 0.96, green: 0.98, blue: 0.82, alpha: 1),
        gradientColors: (UIColor(red: 1.0, green: 0.97, blue: 0.60, alpha: 1),
                         UIColor(red: 0.75, green: 0.95, blue: 0.60, alpha: 1))
    )

    /// Arctic — light ice-blue-to-white gradient.
    static let arctic = KeyboardTheme(
        id: "arctic", displayName: "Arctic", category: .gradient,
        keyColor: UIColor(red: 0.88, green: 0.95, blue: 1.0, alpha: 1),
        keyCharColor: UIColor(red: 0.08, green: 0.22, blue: 0.38, alpha: 1),
        specialKeyColor: UIColor(red: 0.70, green: 0.85, blue: 0.96, alpha: 1),
        keyPressedColor: UIColor(red: 0.95, green: 0.98, blue: 1.0, alpha: 1),
        keyShadowColor: UIColor(red: 0.40, green: 0.60, blue: 0.78, alpha: 1),
        commandKeyColor: UIColor(red: 0.60, green: 0.78, blue: 0.92, alpha: 1),
        commandBarColor: UIColor(red: 0.75, green: 0.88, blue: 0.97, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.15, green: 0.35, blue: 0.55, alpha: 0.5),
        keyboardBgColor: UIColor(red: 0.93, green: 0.97, blue: 1.0, alpha: 1),
        gradientColors: (UIColor(red: 0.85, green: 0.95, blue: 1.0, alpha: 1),
                         UIColor(red: 0.97, green: 0.99, blue: 1.0, alpha: 1))
    )

    // MARK: - Neon themes

    /// Neon Cyber — black background with electric cyan keys.
    static let neonCyber = KeyboardTheme(
        id: "neon_cyber", displayName: "Neon Cyber", category: .neon,
        keyColor: UIColor(red: 0.0, green: 0.85, blue: 0.90, alpha: 1),
        keyCharColor: UIColor(red: 0.0, green: 0.05, blue: 0.08, alpha: 1),
        specialKeyColor: UIColor(red: 0.0, green: 0.55, blue: 0.60, alpha: 1),
        keyPressedColor: UIColor(red: 0.20, green: 1.0, blue: 1.0, alpha: 1),
        keyShadowColor: UIColor(red: 0.0, green: 0.80, blue: 0.85, alpha: 0.8),
        commandKeyColor: UIColor(red: 0.0, green: 0.55, blue: 0.60, alpha: 1),
        commandBarColor: UIColor(red: 0.0, green: 0.12, blue: 0.14, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.0, green: 0.85, blue: 0.90, alpha: 0.5),
        keyboardBgColor: UIColor(red: 0.02, green: 0.04, blue: 0.06, alpha: 1)
    )

    /// Neon Pulse — black with hot pink/magenta keys.
    static let neonPulse = KeyboardTheme(
        id: "neon_pulse", displayName: "Neon Pulse", category: .neon,
        keyColor: UIColor(red: 0.95, green: 0.05, blue: 0.65, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.65, green: 0.02, blue: 0.45, alpha: 1),
        keyPressedColor: UIColor(red: 1.0, green: 0.30, blue: 0.80, alpha: 1),
        keyShadowColor: UIColor(red: 0.90, green: 0.02, blue: 0.60, alpha: 0.8),
        commandKeyColor: UIColor(red: 0.65, green: 0.02, blue: 0.45, alpha: 1),
        commandBarColor: UIColor(red: 0.15, green: 0.02, blue: 0.10, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.95, green: 0.05, blue: 0.65, alpha: 0.5),
        keyboardBgColor: UIColor(red: 0.04, green: 0.02, blue: 0.04, alpha: 1)
    )

    /// Neon Lime — black with electric green keys.
    static let neonLime = KeyboardTheme(
        id: "neon_lime", displayName: "Neon Lime", category: .neon,
        keyColor: UIColor(red: 0.20, green: 0.95, blue: 0.10, alpha: 1),
        keyCharColor: UIColor(red: 0.02, green: 0.10, blue: 0.02, alpha: 1),
        specialKeyColor: UIColor(red: 0.10, green: 0.60, blue: 0.05, alpha: 1),
        keyPressedColor: UIColor(red: 0.40, green: 1.0, blue: 0.30, alpha: 1),
        keyShadowColor: UIColor(red: 0.15, green: 0.80, blue: 0.08, alpha: 0.8),
        commandKeyColor: UIColor(red: 0.10, green: 0.60, blue: 0.05, alpha: 1),
        commandBarColor: UIColor(red: 0.03, green: 0.12, blue: 0.02, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.20, green: 0.95, blue: 0.10, alpha: 0.5),
        keyboardBgColor: UIColor(red: 0.02, green: 0.05, blue: 0.02, alpha: 1)
    )

    // MARK: - Nature themes

    /// Sakura — Japanese cherry blossom pink.
    static let sakura = KeyboardTheme(
        id: "sakura", displayName: "Sakura", category: .nature,
        keyColor: UIColor(red: 0.98, green: 0.85, blue: 0.88, alpha: 1),
        keyCharColor: UIColor(red: 0.45, green: 0.15, blue: 0.22, alpha: 1),
        specialKeyColor: UIColor(red: 0.92, green: 0.70, blue: 0.76, alpha: 1),
        keyPressedColor: UIColor(red: 1.0, green: 0.93, blue: 0.95, alpha: 1),
        keyShadowColor: UIColor(red: 0.75, green: 0.45, blue: 0.52, alpha: 1),
        commandKeyColor: UIColor(red: 0.85, green: 0.55, blue: 0.65, alpha: 1),
        commandBarColor: UIColor(red: 0.92, green: 0.70, blue: 0.76, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.50, green: 0.20, blue: 0.28, alpha: 0.5),
        keyboardBgColor: UIColor(red: 0.99, green: 0.93, blue: 0.95, alpha: 1)
    )

    /// Deep Sea — dark aquamarine inspired by ocean depths.
    static let deepSea = KeyboardTheme(
        id: "deep_sea", displayName: "Deep Sea", category: .nature,
        keyColor: UIColor(red: 0.05, green: 0.38, blue: 0.45, alpha: 1),
        keyCharColor: UIColor(red: 0.75, green: 0.98, blue: 1.0, alpha: 1),
        specialKeyColor: UIColor(red: 0.02, green: 0.22, blue: 0.28, alpha: 1),
        keyPressedColor: UIColor(red: 0.10, green: 0.55, blue: 0.65, alpha: 1),
        keyShadowColor: UIColor(red: 0.01, green: 0.10, blue: 0.15, alpha: 1),
        commandKeyColor: UIColor(red: 0.02, green: 0.22, blue: 0.28, alpha: 1),
        commandBarColor: UIColor(red: 0.03, green: 0.28, blue: 0.35, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.75, green: 0.98, blue: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.02, green: 0.14, blue: 0.18, alpha: 1)
    )

    /// Autumn — warm red-orange-brown leaf palette.
    static let autumn = KeyboardTheme(
        id: "autumn", displayName: "Autumn", category: .nature,
        keyColor: UIColor(red: 0.85, green: 0.45, blue: 0.15, alpha: 1),
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.55, green: 0.22, blue: 0.05, alpha: 1),
        keyPressedColor: UIColor(red: 0.98, green: 0.62, blue: 0.28, alpha: 1),
        keyShadowColor: UIColor(red: 0.30, green: 0.10, blue: 0.02, alpha: 1),
        commandKeyColor: UIColor(red: 0.55, green: 0.22, blue: 0.05, alpha: 1),
        commandBarColor: UIColor(red: 0.68, green: 0.32, blue: 0.10, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.95, green: 0.85, blue: 0.70, alpha: 1)
    )

    // MARK: - Cultural themes (unique to Scribe)

    /// Berlin — inspired by German Bauhaus: grey, black, primary red accent.
    static let berlin = KeyboardTheme(
        id: "berlin", displayName: "Berlin", category: .cultural,
        keyColor: UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1),
        keyCharColor: UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1),
        specialKeyColor: UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1),
        keyPressedColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1),
        keyShadowColor: UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1),
        commandKeyColor: UIColor(red: 0.80, green: 0.08, blue: 0.08, alpha: 1),
        commandBarColor: UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    )

    /// Paris — inspired by French elegance: cream, gold, deep navy.
    static let paris = KeyboardTheme(
        id: "paris", displayName: "Paris", category: .cultural,
        keyColor: UIColor(red: 0.97, green: 0.95, blue: 0.88, alpha: 1),
        keyCharColor: UIColor(red: 0.08, green: 0.10, blue: 0.28, alpha: 1),
        specialKeyColor: UIColor(red: 0.82, green: 0.72, blue: 0.50, alpha: 1),
        keyPressedColor: UIColor(red: 1.0, green: 0.98, blue: 0.94, alpha: 1),
        keyShadowColor: UIColor(red: 0.55, green: 0.48, blue: 0.28, alpha: 1),
        commandKeyColor: UIColor(red: 0.08, green: 0.12, blue: 0.38, alpha: 1),
        commandBarColor: UIColor(red: 0.10, green: 0.14, blue: 0.42, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.97, green: 0.95, blue: 0.88, alpha: 0.6),
        keyboardBgColor: UIColor(red: 0.99, green: 0.97, blue: 0.92, alpha: 1)
    )

    /// Madrid — inspired by Spanish warmth: golden yellow, deep red.
    static let madrid = KeyboardTheme(
        id: "madrid", displayName: "Madrid", category: .cultural,
        keyColor: UIColor(red: 0.95, green: 0.78, blue: 0.35, alpha: 1),
        keyCharColor: UIColor(red: 0.28, green: 0.08, blue: 0.05, alpha: 1),
        specialKeyColor: UIColor(red: 0.75, green: 0.18, blue: 0.12, alpha: 1),
        keyPressedColor: UIColor(red: 1.0, green: 0.90, blue: 0.55, alpha: 1),
        keyShadowColor: UIColor(red: 0.50, green: 0.12, blue: 0.08, alpha: 1),
        commandKeyColor: UIColor(red: 0.75, green: 0.18, blue: 0.12, alpha: 1),
        commandBarColor: UIColor(red: 0.65, green: 0.14, blue: 0.10, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.45),
        keyboardBgColor: UIColor(red: 0.98, green: 0.92, blue: 0.72, alpha: 1)
    )

    /// Stockholm — inspired by Swedish minimalism: white, pale blue, clean grey.
    static let stockholm = KeyboardTheme(
        id: "stockholm", displayName: "Stockholm", category: .cultural,
        keyColor: UIColor(red: 0.96, green: 0.97, blue: 0.99, alpha: 1),
        keyCharColor: UIColor(red: 0.10, green: 0.18, blue: 0.35, alpha: 1),
        specialKeyColor: UIColor(red: 0.78, green: 0.85, blue: 0.95, alpha: 1),
        keyPressedColor: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1),
        keyShadowColor: UIColor(red: 0.55, green: 0.65, blue: 0.80, alpha: 1),
        commandKeyColor: UIColor(red: 0.10, green: 0.28, blue: 0.65, alpha: 1),
        commandBarColor: UIColor(red: 0.12, green: 0.30, blue: 0.68, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 1.0, alpha: 0.55),
        keyboardBgColor: UIColor(red: 0.90, green: 0.93, blue: 0.98, alpha: 1)
    )

    // MARK: - Accessible themes (unique to Scribe)

    /// High Contrast Dark — pure black bg, near-white keys, maximum readability.
    static let highContrastDark = KeyboardTheme(
        id: "hc_dark", displayName: "HC Dark", category: .accessible,
        keyColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1),
        keyCharColor: .black,
        specialKeyColor: UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1),
        keyPressedColor: .white,
        keyShadowColor: UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1),
        commandKeyColor: UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1),
        commandBarColor: UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 0.7, alpha: 1),
        keyboardBgColor: .black
    )

    /// High Contrast Light — pure white bg, pure black keys, maximum readability.
    static let highContrastLight = KeyboardTheme(
        id: "hc_light", displayName: "HC Light", category: .accessible,
        keyColor: .black,
        keyCharColor: .white,
        specialKeyColor: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1),
        keyPressedColor: UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1),
        keyShadowColor: UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1),
        commandKeyColor: UIColor(red: 0.0, green: 0.35, blue: 0.80, alpha: 1),
        commandBarColor: UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1),
        commandBarPlaceholderColor: UIColor(white: 0.3, alpha: 1),
        keyboardBgColor: .white
    )

    /// Warm Accessible — warm cream bg with dark brown keys, easy on eyes.
    static let warmAccessible = KeyboardTheme(
        id: "warm_accessible", displayName: "Warm AA", category: .accessible,
        keyColor: UIColor(red: 0.22, green: 0.14, blue: 0.08, alpha: 1),
        keyCharColor: UIColor(red: 0.98, green: 0.94, blue: 0.88, alpha: 1),
        specialKeyColor: UIColor(red: 0.38, green: 0.25, blue: 0.14, alpha: 1),
        keyPressedColor: UIColor(red: 0.32, green: 0.20, blue: 0.12, alpha: 1),
        keyShadowColor: UIColor(red: 0.10, green: 0.06, blue: 0.03, alpha: 1),
        commandKeyColor: UIColor(red: 0.55, green: 0.35, blue: 0.10, alpha: 1),
        commandBarColor: UIColor(red: 0.92, green: 0.85, blue: 0.72, alpha: 1),
        commandBarPlaceholderColor: UIColor(red: 0.22, green: 0.14, blue: 0.08, alpha: 0.5),
        keyboardBgColor: UIColor(red: 0.98, green: 0.94, blue: 0.86, alpha: 1)
    )

    // MARK: - All themes

    static let all: [KeyboardTheme] = [
        // Classic
        .default, .ocean, .teal, .sepia,
        // Dark
        .midnight, .violet, .slate, .crimson,
        // Light
        .snow, .rose, .lavender, .mint, .peach, .sand,
        // Gradient
        .aurora, .sunset, .galaxy, .ember, .cottonCandy, .citrus, .arctic,
        // Neon
        .neonCyber, .neonPulse, .neonLime,
        // Nature
        .forest, .terracotta, .sakura, .deepSea, .autumn,
        // Cultural (unique to Scribe)
        .berlin, .paris, .madrid, .stockholm,
        // Accessible
        .highContrastDark, .highContrastLight, .warmAccessible
    ]
}

// MARK: - ThemeManager

/// Applies a theme by mutating the global color variables used throughout the keyboard.
final class ThemeManager {
    static let shared = ThemeManager()
    private let defaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!
    private let themeKey = "selectedKeyboardTheme"

    private init() {}

    /// Applies the given theme to all global color variables.
    func apply(_ theme: KeyboardTheme) {
        keyColor = theme.keyColor
        keyCharColor = theme.keyCharColor
        specialKeyColor = theme.specialKeyColor
        keyPressedColor = theme.keyPressedColor
        keyShadowColor = theme.keyShadowColor.cgColor
        commandKeyColor = theme.commandKeyColor
        commandBarColor = theme.commandBarColor
        commandBarPlaceholderColor = theme.commandBarPlaceholderColor
        commandBarPlaceholderColorCG = theme.commandBarPlaceholderColor.cgColor
        keyboardBgColor = theme.keyboardBgColor
        defaults.set(theme.id, forKey: themeKey)
    }

    /// Loads and applies the previously saved theme, falling back to default.
    func loadSavedTheme() {
        let savedId = defaults.string(forKey: themeKey) ?? "default"

        // For the default theme, re-resolve from asset catalog so light/dark mode is respected.
        if savedId == "default" {
            apply(.default)
            return
        }

        let theme = KeyboardTheme.all.first { $0.id == savedId } ?? .default
        apply(theme)
    }

    /// Returns the currently active theme id.
    var currentThemeId: String {
        defaults.string(forKey: themeKey) ?? "default"
    }
}
