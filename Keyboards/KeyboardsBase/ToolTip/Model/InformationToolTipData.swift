// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Data used for tooltips.
 */

import Foundation
import UIKit

enum InformationToolTipData {
  static let wikiDataExplanation = NSMutableAttributedString(
    string: NSLocalizedString("keyboard.not_in_wikidata.explanation_1",
                              value: "Wikidata is a collaboratively edited knowledge graph that's maintained by the Wikimedia Foundation. It serves as a source of open data for projects like Wikipedia and countless others.",
                              comment: ""),
    attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(
        ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
      )
    ]
  )

  static let wikiDataContationOrigin = NSMutableAttributedString(
    string: NSLocalizedString("keyboard.not_in_wikidata.explanation_2",
                              value: "Scribe uses Wikidata's language data for many of its core features. We get information like noun genders, verb conjugations and much more!",
                              comment: ""),
    attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(
        ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
      )
    ]
  )

  static let howToContribute = NSMutableAttributedString(
    string: NSLocalizedString("keyboard.not_in_wikidata.explanation_3",
                              value: "You can make an account at wikidata.org to join the community that's supporting Scribe and so many other projects. Help us bring free information to the world!",
                              comment: ""),
    attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(
        ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.75
      )
    ]
  )

  static func getContent() -> [NSMutableAttributedString] {
    [
      InformationToolTipData.wikiDataExplanation,
      InformationToolTipData.wikiDataContationOrigin,
      InformationToolTipData.howToContribute
    ]
  }
}
