// SPDX-License-Identifier: GPL-3.0-or-later

// Recursive navigation structure for dynamic conjugation and declension views.
// Supports arbitrary depth navigation.

import Foundation

/// Represents a single option in the navigation.
enum NavigationNode {
    case nextLevel(NavigationLevel, displayValue: String?) // navigate deeper, with optional display value
    case finalValue(String) // terminal node, insert this text
}

/// Represents a level in the navigation hierarchy.
struct NavigationLevel {
    let title: String // title for command bar
    let options: [(label: String, node: NavigationNode)] // buttons to display
}

/// Builds navigation trees for conjugations and declensions.
enum NavigationBuilder {
    /// Builds the conjugation navigation levels for a given verb and language.
    /// - Parameters:
    ///   - verb: The verb to conjugate.
    ///   - language: The language code (e.g., "de", "ru").
    static func buildConjugationCases(
        verb: String,
        language: String
    ) -> [NavigationLevel]? {
        guard
            let conjugationData = ConjugationManager.shared.getConjugations(
                verb: verb,
                language: language
            )
        else {
            return nil
        }

        var tenseLevels: [NavigationLevel] = []

        for (tenseTitle, conjugationTypes) in conjugationData {
            if conjugationTypes.count == 1 {
                // Single type: show forms directly.
                let (_, forms) = conjugationTypes[0]
                let formOptions = forms.map { pronoun, conjugatedForm in
                    (label: pronoun, node: NavigationNode.finalValue(conjugatedForm))
                }

                tenseLevels.append(
                    NavigationLevel(
                        title: "\(tenseTitle): \(verb)",
                        options: formOptions
                    )
                )
            } else {
                // Multiple types: create type selection buttons with display values.
                var typeOptions: [(label: String, node: NavigationNode)] = []

                for (typeTitle, forms) in conjugationTypes {
                    // Create display value from first 2-3 forms.
                    let displayValue = forms.prefix(3).map { $0.1 }.joined(separator: "/")

                    let formOptions = forms.map { pronoun, conjugatedForm in
                        (label: pronoun, node: NavigationNode.finalValue(conjugatedForm))
                    }
                    let formLevel = NavigationLevel(
                        title: "\(tenseTitle) - \(typeTitle): \(verb)",
                        options: formOptions
                    )
                    typeOptions.append(
                        (label: typeTitle, node: .nextLevel(formLevel, displayValue: displayValue))
                    )
                }

                tenseLevels.append(
                    NavigationLevel(
                        title: "\(tenseTitle): \(verb)",
                        options: typeOptions
                    )
                )
            }
        }

        return tenseLevels
    }

    /// Loads declension cases for a given language.
    /// - Parameters:
    ///   -language: The language code (e.g., "de", "ru").
    static func getDeclensionCases(language: String) -> [NavigationLevel]? {
        return DeclensionManager.shared.loadDeclensions(language: language)
    }

    /// Finds the starting index for a declension case based on prep form.
    static func findStartingCaseIndex(prepForm: String, language: String) -> Int {
        if language == "de" {
            if prepForm.contains("Acc") {
                return 0 // Akkusativ Definitpronomen
            } else if prepForm.contains("Dat") {
                return 5 // Dativ Definitpronomen
            } else {
                return 10 // Genitiv Definitpronomen
            }
        } else if language == "ru" {
            if prepForm.contains("Acc") {
                return 0
            } else if prepForm.contains("Dat") {
                return 1
            } else if prepForm.contains("Gen") {
                return 2
            } else if prepForm.contains("Ins") {
                return 3
            } else {
                return 4
            }
        }
        return 0
    }
}
