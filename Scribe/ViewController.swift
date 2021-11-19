//
//  ViewController.swift
//
//  The ViewController for the Scribe app.
//

import UIKit

/// Concatenates attributed strings.
func concatAttributedStrings (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
  let result = NSMutableAttributedString()
  result.append(left)
  result.append(right)
  return result
}

/// Returns an attributed text that hyperlinked.
func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) -> NSMutableAttributedString {
  let style = NSMutableParagraphStyle()
  style.alignment = .left
  let attributedOriginalText = NSMutableAttributedString(string: originalText)
  for (hyperLink, urlString) in hyperLinks {
    let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
    let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
    attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
    attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
  }

  return attributedOriginalText
}

/// A UIViewController that provides instructions on how to install Keyboards as well as information about Scribe.
class ViewController: UIViewController {
  @IBOutlet weak var appTextView: UITextView!

  /// Sets the font size for the text in the app screen and corresponding UIImage icons.
  var fontSize = CGFloat(0)
  func setFontSize() {
    if UIDevice.current.userInterfaceIdiom == .phone {
      if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
        fontSize = UIScreen.main.bounds.width / 60
      } else {
        fontSize = UIScreen.main.bounds.width / 30
      }
    } else if UIDevice.current.userInterfaceIdiom == .pad {
      fontSize = UIScreen.main.bounds.width / 50
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setFontSize()
    createUI()
  }

  /// The text for ViewController that includes the globe character.
  func infoTextWithChar() -> NSMutableAttributedString {
    // Create an NSMutableAttributedString that we'll append everything to.
    let fullString = NSMutableAttributedString(string: """
     Keyboard Installation:

     • Open Settings

     • In General do the following:

      Keyboard \u{21e8} Keyboards \u{21e8} Add New Keyboard

     • Select Scribe and then activate keyboards

     • When typing press\u{0020}
     """
    )
    // The globe character as a text attachment.
    let globeAttachment = NSTextAttachment()
    let selectKeyboardIconConfig = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .light, scale: .medium)
    globeAttachment.image = UIImage(systemName: "globe", withConfiguration: selectKeyboardIconConfig)

    // Wrap the attachment in its own attributed string so we can append it.
    let globeString = NSAttributedString(attachment: globeAttachment)

    // Add the NSTextAttachment wrapper to our full string, then add some more text.
    fullString.append(globeString)
    fullString.append(NSAttributedString(string: """
    \u{0020}to select keyboards

    Scribe is a fully open-source app. To report issues or contribute please visit us at\u{0020}
    """
                                        )
    )
    return NSMutableAttributedString(attributedString: fullString)
  }

  /// Creates the full text for the app UI that comes from two NSAttributedStrings and also adds attributes.
  func createUI() {
    appTextView.attributedText = infoTextWithChar()

    // A second NSAttributedString that includes a link to the GitHub.
    let ghLink = addHyperLinksToText(originalText: "github.com/scribe-org.", hyperLinks: ["github.com/scribe-org": "https://github.com/scribe-org"])
    let fullInfoText = concatAttributedStrings(left: appTextView.attributedText, right: ghLink)
    appTextView.attributedText = fullInfoText

    appTextView.isEditable = false
    appTextView.linkTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.blue,
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    appTextView.font = .systemFont(ofSize: fontSize)
  }
}
