//
//  ViewController.swift
//
//  The ViewController for the Scribe app.
//

import UIKit



// Use arrow.up.right.square or an svg of it for links



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
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }

  @IBOutlet weak var privacyPolicyBtn: UIButton!
  var displayPrivacyPolicy = false

  /// Sets the functionality of the privacy policy button.
  func setPrivacyPolicyBtn() {
    if displayPrivacyPolicy == false {
      privacyPolicyBtn.setTitle("View Privacy Policy", for: .normal)
    } else if displayPrivacyPolicy == true {
      privacyPolicyBtn.setTitle("View Installation", for: .normal)
    }
    privacyPolicyBtn.setTitleColor(UIColor.keyCharColorLight, for: .normal)
    privacyPolicyBtn.backgroundColor = UIColor.link
    privacyPolicyBtn.addTarget(self, action: #selector(showHidePrivacyPolicy), for: .touchUpInside)
    privacyPolicyBtn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
  }

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
      if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
        fontSize = UIScreen.main.bounds.width / 50
      } else {
        fontSize = UIScreen.main.bounds.width / 40
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setFontSize()
    setPrivacyPolicyBtn()
    setUI()
  }

  /// Creates the full text for the app UI that comes from two NSAttributedStrings and also adds attributes.
  func setUI() {
    if displayPrivacyPolicy == false {
      setAttributedInfoText()
    } else {
      setAttributedPrivacyPolicy()
    }

    appTextView.isEditable = false
    appTextView.linkTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.previewBlueLight,
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    appTextView.font = .systemFont(ofSize: fontSize)
    appTextView.textColor = UIColor.keyCharColorLight
    appTextView.backgroundColor = .white
  }

  /// The text for ViewController that includes the globe character.
  func setAttributedInfoText() {
    // The down right arrow character as a text attachment.
    let arrowAttachment = NSTextAttachment()
    let selectArrowIconConfig = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium, scale: .medium)
    arrowAttachment.image = UIImage(systemName: "arrow.turn.down.right", withConfiguration: selectArrowIconConfig)?.withTintColor(.scribeGrey)

    // Wrap the attachment in its own attributed string so we can append it.
    let arrowString = NSAttributedString(attachment: arrowAttachment)

    // The globe character as a text attachment.
    let globeAttachment = NSTextAttachment()
    let selectGlobeIconConfig = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium, scale: .medium)
    globeAttachment.image = UIImage(systemName: "globe", withConfiguration: selectGlobeIconConfig)?.withTintColor(.scribeGrey)

    // Wrap the attachment in its own attributed string so we can append it.
    let globeString = NSAttributedString(attachment: globeAttachment)

    // Create an NSMutableAttributedString that we'll append everything to.
    let fullString = NSMutableAttributedString(string: """
     Keyboard Installation:

     1. Open Settings

     2. In General do the following:

          Keyboard

    """)
    fullString.append(NSAttributedString(string: "\n         "))
    fullString.append(arrowString)
    fullString.append(NSAttributedString(string: """
     \u{0020} Keyboards

    """))
    fullString.append(NSAttributedString(string: "\n                    "))
    fullString.append(arrowString)
    fullString.append(NSAttributedString(string: """
      \u{0020} Add New Keyboard

     3. Select Scribe and then activate keyboards

     4. When typing press\u{0020}
     """
    )
    )

    // Add the NSTextAttachment wrapper to our full string, then add some more text.
    fullString.append(globeString)
    fullString.append(NSAttributedString(string: """
    \u{0020}to select keyboards
    """)
    )
    appTextView.attributedText = NSMutableAttributedString(attributedString: fullString)

    let githubString = NSMutableAttributedString(string: """


    Scribe is fully open-source. To report issues or contribute please visit us at\u{0020}
    """)
    let fullInfoText = concatAttributedStrings(left: appTextView.attributedText, right: githubString)
    appTextView.attributedText = NSMutableAttributedString(attributedString: githubString)

    // A second NSAttributedString that includes a link to the GitHub.
    let ghLink = addHyperLinksToText(originalText: "github.com/scribe-org.", hyperLinks: ["github.com/scribe-org": "https://github.com/scribe-org"])
    let fullFullInfoText = concatAttributedStrings(left: fullInfoText, right: ghLink)

    appTextView.attributedText = fullFullInfoText
  }

  /// Formats and returns Scribe privacy policy.
  func setAttributedPrivacyPolicy() {
    // PRIVACY.txt is formatted for GitHub, and this is formatted for modular sizing.

    let privacyPolicyTextWithLinks = addHyperLinksToText(originalText: privacyPolicyText, hyperLinks: ["https://www.wikidata.org/wiki/Wikidata:Licensing": "https://www.wikidata.org/wiki/Wikidata:Licensing", "https://github.com/huggingface/transformers/blob/master/LICENSE": "https://github.com/huggingface/transformers/blob/master/LICENSE", "https://github.com/scribe-org": "https://github.com/scribe-org", "scribe.langauge@gmail.com": "mailto:scribe.langauge@gmail.com"])

    appTextView.attributedText = privacyPolicyTextWithLinks
  }

  @objc func showHidePrivacyPolicy() {
    if displayPrivacyPolicy == false {
      displayPrivacyPolicy = true
    } else {
      displayPrivacyPolicy = false
    }
    setPrivacyPolicyBtn()
    setUI()
  }

  @objc func keyTouchDown(_ sender: UIButton) {
    sender.alpha = 0.5
    // Bring sender's opacity back up to fully opaque
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
        sender.alpha = 1.0
    }
  }
}
