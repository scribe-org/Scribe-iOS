// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Content definitions for each tutorial chapter.
 * Noun annotation has two steps (Vater → Mutter).
 * Other chapters are single-step.
 */

import Foundation

private let languageNote = NSLocalizedString(
    "i18n.app.tutorial.language_note",
    value: "If your second language is not German, change the language in your keyboard.",
    comment: ""
)

extension TutorialChapter {
    var steps: [TutorialStep] {
        switch self {
        case .nounAnnotation:
            return [
                TutorialStep(
                    instructions: NSLocalizedString(
                        "i18n.app.tutorial.noun_annotation.step1",
                        value: "Write the word \"Vater\". Notice the word suggestions that appear on the keyboard's top bar.\n\nThen, press space. You will see the word's gender tag on the keyboard's top bar — in this case, \"M\" for Maskulin.",
                        comment: ""
                    ),
                    languageNote: languageNote,
                    expectedInput: "Vater",
                    incorrectFeedback: NSLocalizedString(
                        "i18n.app.tutorial.noun_annotation.step1.incorrect",
                        value: "Not quite! Try writing Vater.",
                        comment: ""
                    )
                ),
                TutorialStep(
                    instructions: NSLocalizedString(
                        "i18n.app.tutorial.noun_annotation.step2",
                        value: "Now write the word \"Mutter\" and then press space. The gender tag will be \"F\", for Feminin.",
                        comment: ""
                    ),
                    languageNote: languageNote,
                    expectedInput: "Mutter",
                    incorrectFeedback: NSLocalizedString(
                        "i18n.app.tutorial.noun_annotation.step2.incorrect",
                        value: "Not quite! Try writing Mutter.",
                        comment: ""
                    )
                )
            ]

        case .wordTranslation:
            return [
                TutorialStep(
                    instructions: NSLocalizedString(
                        "i18n.app.tutorial.word_translation.instructions",
                        value: "Let's translate! Tap the ⌨ Scribe key on the top-left corner of your keyboard, and select Übersetzen.\n\nThen write the word you want to translate, press ▶, and the translation will be returned to you.",
                        comment: ""
                    ),
                    languageNote: languageNote,
                    expectedInput: nil,
                    incorrectFeedback: ""
                )
            ]

        case .verbConjugation:
            return [
                TutorialStep(
                    instructions: NSLocalizedString(
                        "i18n.app.tutorial.verb_conjugation.instructions",
                        value: "On to the verbs. Tap the ⌨ Scribe key on the top-left corner of your keyboard, and select Konjugieren.\n\nWrite the verb you want to conjugate, press ▶, and you will see a table with all the verb tenses. Select the one you need and it will be inserted!",
                        comment: ""
                    ),
                    languageNote: languageNote,
                    expectedInput: nil,
                    incorrectFeedback: ""
                )
            ]

        case .nounPlurals:
            return [
                TutorialStep(
                    instructions: NSLocalizedString(
                        "i18n.app.tutorial.noun_plurals.instructions",
                        value: "Finding the plural of a noun with Scribe is easy. Tap the ⌨ Scribe key on the top-left corner of your keyboard, and select Plural.\n\nThen write the noun you want the plural for, press ▶, and the plural will be returned to you.",
                        comment: ""
                    ),
                    languageNote: languageNote,
                    expectedInput: nil,
                    incorrectFeedback: ""
                )
            ]
        }
    }
}
