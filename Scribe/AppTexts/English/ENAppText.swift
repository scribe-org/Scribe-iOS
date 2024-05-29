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

/// Formats and returns the title of the installation guidelines.
func getENInstallationTitle(fontSize: CGFloat) -> NSMutableAttributedString {
  return NSMutableAttributedString(string: """
  Keyboard Installation
  """, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.5)])
}

/// Formats and returns the directions of the installation guidelines.
func getENInstallationDirections(fontSize: CGFloat) -> NSMutableAttributedString {
  let arrowString = getArrowIcon(fontSize: fontSize)
  let globeString = getGlobeIcon(fontSize: fontSize)

  let startOfBody = NSMutableAttributedString(string: """
  \n
  1.\u{0020}
  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  var settingsLink = NSMutableAttributedString()
  if #available(iOS 15.0, *) {
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
  } else {
    settingsLink = addHyperLinks(
      originalText: "Open Settings",
      links: ["Open Settings": "MakeTextLink"], // placeholder as there's a button over it
      fontSize: fontSize
    )

    let installStart = concatAttributedStrings(left: startOfBody, right: settingsLink)

    let installDirections = NSMutableAttributedString(string: """
    \n
    2. In General do the following:

          Keyboard

    """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

    installDirections.addAttribute(
      NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize),
      range: NSRange(location: 8, length: "General".count)
    )
    installDirections.addAttribute(
      NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize),
      range: NSRange(location: 41, length: "Keyboard".count)
    )

    installDirections.append(NSAttributedString(string: "\n         "))

    installDirections.append(arrowString)

    let keyboardsStep = NSMutableAttributedString(string: """
    \u{0020} Keyboards

    """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

    keyboardsStep.addAttribute(
      NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize),
      range: NSRange(location: 2, length: "Keyboards".count)
    )

    installDirections.append(keyboardsStep)

    installDirections.append(NSMutableAttributedString(
      string: "\n                    ",
      attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
    )
    )

    installDirections.append(arrowString)

    let finalSteps = NSMutableAttributedString(string: """
    \u{0020} Add New Keyboard

    3. Select Scribe and then activate keyboards

    4. When typing press\u{0020}
    """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

    finalSteps.addAttribute(
      NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize),
      range: NSRange(location: 2, length: "Add New Keyboard".count)
    )
    finalSteps.addAttribute(
      NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize),
      range: NSRange(location: 30, length: "Scribe".count)
    )

    installDirections.append(finalSteps)

    installDirections.append(globeString)

    installDirections.append(NSMutableAttributedString(string: """
    \u{0020}to select keyboards
    """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]))

    return concatAttributedStrings(left: installStart, right: installDirections)
  }
}

/// Formats and returns the full text for the installation guidelines.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func setENInstallation(fontSize: CGFloat) -> NSMutableAttributedString {
  let installTitle = getENInstallationTitle(fontSize: fontSize)
  let installDirections = getENInstallationDirections(fontSize: fontSize)

  return concatAttributedStrings(
    left: installTitle,
    right: installDirections
  )
}
