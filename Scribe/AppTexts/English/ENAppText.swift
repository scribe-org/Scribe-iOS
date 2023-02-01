//
//  ENAppText.swift
//
//  The English app text for the Scribe app.
//

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

  let settingsLink = addHyperLinks(
    originalText: "Open Settings",
    links: ["Open Settings": "<makeTextLink>"], // placeholder as there's a button over it
    fontSize: fontSize
  )

  let installStart = concatAttributedStrings(left: startOfBody, right: settingsLink)

  let installDirections = NSMutableAttributedString(string: """
  \n
  2. In General do the following:

        Keyboard

  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  installDirections.append(NSAttributedString(string: "\n         "))

  installDirections.append(arrowString)

  installDirections.append(NSMutableAttributedString(string: """
  \u{0020} Keyboards

  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]))

  installDirections.append(NSMutableAttributedString(
      string: "\n                    ",
      attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
    )
  )

  installDirections.append(arrowString)

  installDirections.append(NSMutableAttributedString(string: """
  \u{0020} Add New Keyboard

  3. Select Scribe and then activate keyboards

  4. When typing press\u{0020}
  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]))

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
  let installTitle = getENInstallationTitle(fontSize: fontSize)
  let installDirections = getENInstallationDirections(fontSize: fontSize)

  return concatAttributedStrings(
    left: installTitle,
    right: installDirections
  )
}

/// Formats and returns the title of the GitHub information.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func getENGitHubTitle(fontSize: CGFloat) -> NSMutableAttributedString {
  return NSMutableAttributedString(string: """
  Community
  """, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.5)])
}

/// Formats and returns the text of the GitHub information.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func getENGitHubText(fontSize: CGFloat) -> NSMutableAttributedString {
  // Initialize the main body of the text.
  let ghInfoText = NSMutableAttributedString(string: """
  \n
  Scribe is fully open-source. To report issues or contribute please visit us at\u{0020}
  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  // A second NSAttributedString that includes a link to the GitHub.
  let ghLink = addHyperLinks(
    originalText: "github.com/scribe-org.",
    links: ["github.com/scribe-org": "https://github.com/scribe-org/Scribe-iOS"],
    fontSize: fontSize
  )

  return concatAttributedStrings(left: ghInfoText, right: ghLink)
}

/// Formats and returns the text for a notice about Scribe's GitHub.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func setENGitHubText(fontSize: CGFloat) -> NSMutableAttributedString {
  let ghTextTitle = getENGitHubTitle(fontSize: fontSize)
  let ghInfoTextAndLink = getENGitHubText(fontSize: fontSize)

  return concatAttributedStrings(
    left: ghTextTitle,
    right: ghInfoTextAndLink
  )
}
