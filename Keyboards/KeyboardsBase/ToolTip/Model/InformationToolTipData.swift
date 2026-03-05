// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Data used for tooltips.
 */

import Foundation
import UIKit

enum InformationToolTipData {
  static let wikiDataExplanation = NSMutableAttributedString(
    string: NSLocalizedString("i18n.app.keyboard.not_in_wikidata.explanation_1",
                              value: "Wikidata is a collaboratively edited knowledge graph that's maintained by the Wikimedia Foundation. It serves as a source of open data for projects like Wikipedia and countless others.",
                              comment: ""),
    attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(
        ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
      )
    ]
  )

  static let wikiDataContationOrigin = NSMutableAttributedString(
    string: NSLocalizedString("i18n.app.keyboard.not_in_wikidata.explanation_2",
                              value: "Scribe uses Wikidata's language data for many of its core features. We get information like noun genders, verb conjugations and much more!",
                              comment: ""),
    attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(
        ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
      )
    ]
  )

  static let howToContribute = NSMutableAttributedString(
    string: NSLocalizedString("i18n.app.keyboard.not_in_wikidata.explanation_3",
                              value: "You can make an account at wikidata.org to join the community that's supporting Scribe and so many other projects. Help us bring free information to the world!",
                              comment: ""),
    attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(
        ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.75
      )
    ]
  )

  static let wiktionaryExplanation = NSMutableAttributedString(
    string: NSLocalizedString("i18n.app.keyboard.not_in_wiktionary.explanation_1",
                              value: "Wiktionary is a collaboratively edited dictionary in hundreds of different languages that's maintained by Wikimedia Foundation.",
                              comment: ""),
    attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(
      ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
        )
    ]
  )

  static let wiktionaryTranslationOrigin = NSMutableAttributedString(
    string: NSLocalizedString("i18n.app.keyboard.not_in_wiktionary.explanation_2",
                              value: "Scribe uses Wiktionary's translations for our translation functionality! You can choose from multiple translations per word based on the specific meaning.",
                              comment: ""),
    attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(
        ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
      )
    ]
  )

  static let howToContributeWiktionary = NSMutableAttributedString(
    string: NSLocalizedString("i18n.app.keyboard.not_in_wiktionary.explanation_3",
                              value: "You can make an account at wiktionary.org to join the community that's supporting Scribe and so many other projects. Help us bring free information to the world!",
                              comment: ""),
    attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(
      ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.75
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
