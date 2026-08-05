// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Detects which Scribe keyboards are installed to determine
 * which tutorial chapters to show.
 * Per mentor guidance: if only English keyboard is installed,
 * hide the noun annotation chapter (English has no gender annotations).
 */

import Foundation

enum TutorialKeyboardDetector {
    /// Languages that support noun-gender annotations.
    private static let genderAnnotationLanguages: Set<String> = [
        "German", "Spanish", "French", "Portuguese", "Russian",
        "Italian", "Swedish", "Norwegian", "Danish", "Hebrew", "Indonesian"
    ]

    /// Returns the list of installed Scribe keyboard language names.
    static func installedScribeLanguages() -> [String] {
        guard let appBundleIdentifier = Bundle.main.bundleIdentifier,
              let keyboards = UserDefaults.standard.dictionaryRepresentation()["AppleKeyboards"] as? [String]
        else { return [] }

        let prefix = appBundleIdentifier + "."
        return keyboards
            .filter { $0.hasPrefix(prefix) }
            .map { $0.replacingOccurrences(of: prefix, with: "").capitalized }
    }

    /// Returns true if at least one installed Scribe keyboard supports noun-gender annotations.
    static func hasNounAnnotationKeyboard() -> Bool {
        let installed = installedScribeLanguages()
        // If no Scribe keyboards installed, show all chapters (user may install later).
        if installed.isEmpty { return true }
        return installed.contains { genderAnnotationLanguages.contains($0) }
    }

    /// Returns the tutorial chapters to display based on installed keyboards.
    static func availableChapters() -> [TutorialChapter] {
        if hasNounAnnotationKeyboard() {
            return TutorialChapter.allCases
        } else {
            // English-only: hide noun annotation chapter.
            return TutorialChapter.allCases.filter { $0 != .nounAnnotation }
        }
    }
}
