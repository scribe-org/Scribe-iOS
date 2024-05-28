/**
 * Data used for tooltips.
 *
 * Copyright (C) 2023 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import Foundation
import UIKit

enum InformationToolTipData {
  static let wikiDataExplanation = NSMutableAttributedString(
    string: NSLocalizedString("wikidataExplanation1", comment: "First page of the wikidata explanation for missing words/conjugations"),
    attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(
        ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
      )
    ]
  )

  static let wikiDataContationOrigin = NSMutableAttributedString(
    string: NSLocalizedString("wikidataExplanation2", comment: "Second page of the wikidata explanation for missing words/conjugations"),
    attributes: [
      NSAttributedString.Key.font: UIFont.systemFont(
        ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.5
      )
    ]
  )

  static let howToContribute = NSMutableAttributedString(
    string: NSLocalizedString("wikidataExplanation3", comment: "Last page of the wikidata explanation for missing words/conjugations"),
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
