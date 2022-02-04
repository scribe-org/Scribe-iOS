//
//  ENAppText.swift
//
//  The English app text for the Scribe app.
//

import UIKit

/// Formats and returns the text for the installation guidelines.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func setAttributedInstallation(fontSize: CGFloat) -> NSMutableAttributedString {
  // The down right arrow character as a text attachment.
  let arrowAttachment = NSTextAttachment()
  let selectArrowIconConfig = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium, scale: .medium)
  arrowAttachment.image = UIImage(
    systemName: "arrow.turn.down.right",
    withConfiguration: selectArrowIconConfig
  )?.withTintColor(.scribeGrey)

  // The globe character as a text attachment.
  let globeAttachment = NSTextAttachment()
  let selectGlobeIconConfig = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium, scale: .medium)
  globeAttachment.image = UIImage(
    systemName: "globe",
    withConfiguration: selectGlobeIconConfig
  )?.withTintColor(.scribeGrey)

  // Wrap the attachments in their own attributed strings so we can append them.
  let arrowString = NSAttributedString(attachment: arrowAttachment)
  let globeString = NSAttributedString(attachment: globeAttachment)

  // Create components of the installation text, format their font sizes and add them step by step.
  let installationTextTitle = NSMutableAttributedString(string: """
  Keyboard Installation
  """, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.5)])

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

  let installFullDirections = concatAttributedStrings(left: installStart, right: installDirections)

  return concatAttributedStrings(
    left: installationTextTitle,
    right: installFullDirections
  ) as! NSMutableAttributedString
}

/// Formats and returns the text for a notice about Scribe's GitHub.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func setAttributedGitHubText(fontSize: CGFloat) -> NSMutableAttributedString {
  let GHTextTitle = NSMutableAttributedString(string: """
  Community
  """, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.5)])

  // Initialize the main body of the text.
  let GHInfoText = NSMutableAttributedString(string: """
  \n
  Scribe is fully open-source. To report issues or contribute please visit us at\u{0020}
  """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

  // A second NSAttributedString that includes a link to the GitHub.
  let ghLink = addHyperLinks(
    originalText: "github.com/scribe-org.",
    links: ["github.com/scribe-org": "https://github.com/scribe-org"],
    fontSize: fontSize
  )

  let GHInfoTextToLink = concatAttributedStrings(left: GHTextTitle, right: GHInfoText)

  return concatAttributedStrings(
    left: GHInfoTextToLink,
    right: ghLink
  ) as! NSMutableAttributedString
}
