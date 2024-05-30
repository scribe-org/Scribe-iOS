/**
 * The German app text for the Scribe app.
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

import UIKit

/// Formats and returns the directions of the installation guidelines.
func getDEInstallationDirections(fontSize: CGFloat) -> NSMutableAttributedString {
  let arrowString = getArrowIcon(fontSize: fontSize)
  let globeString = getGlobeIcon(fontSize: fontSize)

  let startOfBody = NSMutableAttributedString(string: """
  1.\u{0020}
  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  let settingsLink = addHyperLinks(
    originalText: "Einstellungen öffnen",
    links: ["Einstellungen öffnen": "<makeTextLink>"], // placeholder as there's a button over it
    fontSize: fontSize
  )

  let installStart = concatAttributedStrings(left: startOfBody, right: settingsLink)

  let installDirections = NSMutableAttributedString(string: """
  \n
  2. Gehen Sie im Allgemein wie folgt vor:

        Tastatur

  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  installDirections.addAttribute(
    NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize),
    range: NSRange(location: 18, length: "Allgemein".count)
  )
  installDirections.addAttribute(
    NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize),
    range: NSRange(location: 50, length: "Tastatur".count)
  )

  installDirections.append(NSAttributedString(string: "\n         "))

  installDirections.append(arrowString)

  let keyboardsStep = NSMutableAttributedString(string: """
  \u{0020} Tastaturen

  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  keyboardsStep.addAttribute(
    NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize),
    range: NSRange(location: 2, length: "Tastaturen".count)
  )

  installDirections.append(keyboardsStep)

  installDirections.append(NSMutableAttributedString(
    string: "\n                    ",
    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
  )
  )

  installDirections.append(arrowString)

  let finalSteps = NSMutableAttributedString(string: """
  \u{0020} Neue Tastatur hinzufügen

  3. Wählen Sie Scribe und aktivieren Sie Tastaturen

  4. Drücken Sie \u{0020}
  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  finalSteps.addAttribute(
    NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize),
    range: NSRange(location: 2, length: "Neue Tastatur hinzufügen".count)
  )
  finalSteps.addAttribute(
    NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize),
    range: NSRange(location: 42, length: "Scribe".count)
  )

  installDirections.append(finalSteps)

  installDirections.append(globeString)

  installDirections.append(NSMutableAttributedString(string: """
  , um Tastaturen auszuwählen
  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]))

  return concatAttributedStrings(left: installStart, right: installDirections)
}

/// Formats and returns the full text for the installation guidelines.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func setDEInstallation(fontSize: CGFloat) -> NSMutableAttributedString {
  let installDirections = getDEInstallationDirections(fontSize: fontSize)
  return installDirections
}
