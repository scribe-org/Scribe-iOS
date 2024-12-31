/**
 * Data used for tooltips.
 *
 * Copyright (C) 2024 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
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
