/**
 * The English app text for the Scribe app.
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
func getENInstallationDirections(fontSize: CGFloat) -> NSMutableAttributedString {
  let globeString = getGlobeIcon(fontSize: fontSize)

  let startOfBody = NSMutableAttributedString(string: """
  1.\u{0020}
  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  var settingsLink = NSMutableAttributedString()
  settingsLink = addHyperLinks(
    originalText: "Open Scribe settings",
    links: ["Open Scribe settings": "MakeTextLink"], // placeholder as there's a button over it
    fontSize: fontSize
  )

  let installStart = concatAttributedStrings(left: startOfBody, right: settingsLink)

  let installDirections = NSMutableAttributedString(string: """
  \n
  2. Select Keyboards
  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  installDirections.addAttribute(
    NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize),
    range: NSRange(location: 12, length: "Keyboards".count)
  )

  let finalSteps = NSMutableAttributedString(string: """
  \n
  3. Activate keyboards that you want to use

  4. When typing press\u{0020}
  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  installDirections.append(finalSteps)

  installDirections.append(globeString)

  installDirections.append(NSMutableAttributedString(string: """
  \u{0020}to select keyboards
  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]))

  return concatAttributedStrings(left: installStart, right: installDirections)
}

/// Formats and returns the full text for the installation guidelines.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func setENInstallation(fontSize: CGFloat) -> NSMutableAttributedString {
  let installDirections = getENInstallationDirections(fontSize: fontSize)
  return installDirections
}
