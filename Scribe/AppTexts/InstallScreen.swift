// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * The app text for the Scribe app's keyboard installation screen.
 */

import UIKit

let firstLineNumber = preferredLanguage.prefix(2) == "ar" ? "١. " : "1. "
let secondLineNumber = preferredLanguage.prefix(2) == "ar" ? "\n\n٢. " : "\n\n2. "
let thirdLineNumber = preferredLanguage.prefix(2) == "ar" ? "\n\n٣. " : "\n\n3. "
let fourthLineNumber = preferredLanguage.prefix(2) == "ar" ? "\n\n٤. " : "\n\n4. "

/// Formats and returns the directions of the installation guidelines.
func getInstallationDirections(fontSize: CGFloat) -> NSMutableAttributedString {
  let globeString = getGlobeIcon(fontSize: fontSize)

  let startOfBody = NSMutableAttributedString(string: firstLineNumber, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  var settingsLink = NSMutableAttributedString()
  let linkText = NSLocalizedString("app.installation.keyboard.scribe_settings", value: "Open Scribe settings", comment: "")
  settingsLink = addHyperLinks(
    originalText: linkText,
    links: [linkText: "MakeTextLink"], // placeholder as there's a button over it
    fontSize: fontSize
  )

  let installStart = concatAttributedStrings(left: startOfBody, right: settingsLink)

  let installDirections = NSMutableAttributedString(string: secondLineNumber + NSLocalizedString("app.installation.keyboard.text_1", value: "Select", comment: "") + " ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  let boldText = NSMutableAttributedString(string: NSLocalizedString("app.installation.keyboard.keyboards_bold", value: "Keyboards", comment: ""), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])
  boldText.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: NSRange(location: 0, length: boldText.length))
  installDirections.append(boldText)

  installDirections.append(NSMutableAttributedString(string: thirdLineNumber + NSLocalizedString("app.installation.keyboard.text_2", value: "Activate keyboards that you want to use", comment: "") + fourthLineNumber + NSLocalizedString("app.installation.keyboard.text_3", value: "When typing, press", comment: "") + " ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]))

  installDirections.append(globeString)

  installDirections.append(NSMutableAttributedString(string: " " + NSLocalizedString("app.installation.keyboard.text_4", value: "to select keyboards", comment: ""), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]))

  return concatAttributedStrings(left: installStart, right: installDirections)
}

/// Formats and returns the full text for the installation guidelines.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func setInstallation(fontSize: CGFloat) -> NSMutableAttributedString {
  return getInstallationDirections(fontSize: fontSize)
}
