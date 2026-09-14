// SPDX-License-Identifier: GPL-3.0-or-later

/*
 * Data used for tooltips.
 */

import Foundation
import UIKit

enum InformationToolTipData {
    static let wikiDataExplanation = NSMutableAttributedString(
        string: invalidCommandTextWikidata1,
        attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(
                ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
            )
        ]
    )

    static let wikiDataContationOrigin = NSMutableAttributedString(
        string: invalidCommandTextWikidata2,
        attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(
                ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
            )
        ]
    )
    static let howToContribute = NSMutableAttributedString(
        string: invalidCommandTextWikidata3,
        attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(
                ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
            )
        ]
    )

    static let wiktionaryExplanation = NSMutableAttributedString(
        string: invalidCommandTextWiktionary1,
        attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(
                ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
            )
        ]
    )

    static let wiktionaryTranslationOrigin = NSMutableAttributedString(
        string: invalidCommandTextWiktionary2,
        attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(
                ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
            )
        ]
    )

    static let howToContributeWiktionary = NSMutableAttributedString(
        string: invalidCommandTextWiktionary3,
        attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(
                ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
            )
        ]
    )

    static func getContent() -> [NSMutableAttributedString] {
        [wikiDataExplanation, wikiDataContationOrigin, howToContribute]
    }

    static func getWiktionaryContent() -> [NSMutableAttributedString] {
        [wiktionaryExplanation, wiktionaryTranslationOrigin, howToContributeWiktionary]
    }
}
