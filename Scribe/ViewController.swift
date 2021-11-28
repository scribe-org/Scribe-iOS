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
  @IBOutlet weak var privacyPolicyBtn: UIButton!
  var displayPrivacyPolicy = false

  /// Sets the functionality of the privacy policy button.
  func setPrivacyPolicyBtn() {
    if displayPrivacyPolicy == false {
      privacyPolicyBtn.setTitle("View Privacy Policy", for: .normal)
    } else if displayPrivacyPolicy == true {
      privacyPolicyBtn.setTitle("View Installation", for: .normal)
    }
    privacyPolicyBtn.setTitleColor(.black, for: .normal)
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
      fontSize = UIScreen.main.bounds.width / 50
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
      NSAttributedString.Key.foregroundColor: UIColor.blue,
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    appTextView.font = .systemFont(ofSize: fontSize)
  }

  /// The text for ViewController that includes the globe character.
  func setAttributedInfoText() {
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
    appTextView.attributedText = NSMutableAttributedString(attributedString: fullString)

    // A second NSAttributedString that includes a link to the GitHub.
    let ghLink = addHyperLinksToText(originalText: "github.com/scribe-org.", hyperLinks: ["github.com/scribe-org": "https://github.com/scribe-org"])
    let fullInfoText = concatAttributedStrings(left: appTextView.attributedText, right: ghLink)
    appTextView.attributedText = fullInfoText
  }

  /// Formats and returns Scribe privacy policy.
  func setAttributedPrivacyPolicy() {
    // PRIVACY.txt is formatted for GitHub, and this is formatted for modular sizing.
    let privacyPolicyText = """
    Privacy Policy

    The Scribe developers (SCRIBE) built the iOS application "Scribe - Language Keyboards" (SERVICE) as an open-source application. This SERVICE is provided by SCRIBE at no cost and is intended for use as is.

    This privacy policy (POLICY) is used to inform the reader of the policies for the access, tracking, collection, retention, use, and disclosure of personal information (USER INFORMATION) and usage data (USER DATA) for all individuals who make use of this SERVICE (USERS).

    USER INFORMATION is specifically defined as any information related to the USERS themselves or the devices they use to access the SERVICE.

    USER DATA is specifically defined as any text that is typed or actions that are done by the USERS while using the SERVICE.

    1. Policy Statement

    This SERVICE does not access, track, collect, retain, use, or disclose any USER INFORMATION or USER DATA.

    2. Do Not Track

    USERS contacting SCRIBE to ask that their USER INFORMATION and USER DATA not be tracked will be provided with a copy of this POLICY as well as a link to all source codes as proof that they are not being tracked.

    3. Third-Party Data

    This SERVICE makes use of third-party data. All data used in the creation of this SERVICE comes from sources that allow its full use in the manner done so by the SERVICE. Specifically, the data for this SERVICE comes from Wikidata, which states that, "All structured data in the main, property and lexeme namespaces is made available under the Creative Commons CC0 License; text in other namespaces is made available under the Creative Commons Attribution-ShareAlike License." The policy in regards to the third-party data used can be found at https://www.wikidata.org/wiki/Wikidata:Licensing.

    4. Third-Party Services

    This SERVICE makes use of third-party services to manipulate some of the third-party data. Specifically, data has been translated using models from Hugging Face transformers. This service is covered by a Apache License 2.0, which states that it is available for commercial use, modification, distribution, patent use, and private use. The license for the aforementioned service can be found at https://github.com/huggingface/transformers/blob/master/LICENSE.

    5. Third-Party Links

    This SERVICE contains links to external websites. If USERS click on a third-party link, they will be directed to a website. Note that these external websites are not operated by this SERVICE. Therefore, USERS are strongly advised to review the privacy policy of these websites. This SERVICE has no control over and assumes no responsibility for the content, privacy policies, or practices of any third-party sites or services.

    6. Content Notice

    This SERVICE allows USERS to access linguistic content (CONTENT). Some of this CONTENT could be deemed inappropriate for children and legal minors. Accessing CONTENT using the SERVICE is done in a way that the information is unavailable unless explicitly known. Specifically, USERS "can" translate words, conjugate verbs, and access other grammatical features of CONTENT that may be sexual, violent, or otherwise inappropriate in nature. USERS "cannot" translate words, conjugate verbs, and access other grammatical features of CONTENT that may be sexual, violent, or otherwise inappropriate in nature if they do not already know about the nature of this CONTENT. SCRIBE takes no responsibility for the access of such CONTENT.

    7. Changes

    This POLICY is subject to change. Updates to this POLICY will replace all prior instances, and if deemed material will further be clearly stated in the next applicable update to the SERVICE. SCRIBE encourages the USERS to familiarize themselves with any changes to this POLICY.

    8. Contact

    If you have any questions, concerns, or suggestions about this POLICY, do not hesitate to visit https://github.com/scribe-org or contact SCRIBE at scribe.langauge@gmail.com. The person responsible for such inquiries is Andrew Tavis McAllister.

    9. Effective Date

    This POLICY is effective as of the 22nd of November, 2021.
    """

    let privacyPolicyTextWithLinks = addHyperLinksToText(originalText: privacyPolicyText, hyperLinks: ["https://www.wikidata.org/wiki/Wikidata:Licensing": "https://www.wikidata.org/wiki/Wikidata:Licensing",  "https://github.com/huggingface/transformers/blob/master/LICENSE": "https://github.com/huggingface/transformers/blob/master/LICENSE", "https://github.com/scribe-org": "https://github.com/scribe-org", "scribe.langauge@gmail.com": "mailto:scribe.langauge@gmail.com"])

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
