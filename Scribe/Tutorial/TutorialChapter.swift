// SPDX-License-Identifier: GPL-3.0-or-later

import Foundation

enum TutorialChapter: String, CaseIterable, Identifiable, Hashable {
    case nounAnnotation
    case wordTranslation
    case verbConjugation
    case nounPlurals

    var id: String { rawValue }

    var title: String {
        switch self {
        case .nounAnnotation:
            return NSLocalizedString("i18n.app.tutorial.noun_annotation", value: "Noun annotation", comment: "")
        case .wordTranslation:
            return NSLocalizedString("i18n.app.tutorial.word_translation", value: "Word translation", comment: "")
        case .verbConjugation:
            return NSLocalizedString("i18n.app.tutorial.verb_conjugation", value: "Verb conjugation", comment: "")
        case .nounPlurals:
            return NSLocalizedString("i18n.app.tutorial.noun_plurals", value: "Noun plurals", comment: "")
        }
    }

    var isLast: Bool { self == .nounPlurals }

    func next() -> TutorialChapter? {
        let all = TutorialChapter.allCases
        guard let idx = all.firstIndex(of: self), idx + 1 < all.count else { return nil }
        return all[idx + 1]
    }
}
