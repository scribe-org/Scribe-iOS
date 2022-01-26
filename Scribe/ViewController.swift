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
    return .lightContent
  }

  @IBOutlet weak var switchView: UIButton!
  let switchViewColor = UIColor(red: 241.0/255.0, green: 204.0/255.0, blue: 131.0/255.0, alpha: 1.0)
  var displayPrivacyPolicy = false

  /// Styles a button's appearance including it's shape and text.
  ///
  /// - Parameters
  ///  - btn: the button to be styled.
  ///  - title: the title to be assigned.
  ///  - radius: the corner radius of the button.
  func styleBtn(btn: UIButton, title: String, radius: CGFloat) {
    btn.clipsToBounds = true
    btn.layer.masksToBounds = false
    btn.layer.cornerRadius = radius
    btn.setTitle(title, for: .normal)
    btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    btn.setTitleColor(keyCharColor, for: .normal)

    btn.layer.shadowColor = UIColor.keyShadowColorLight
    btn.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
    btn.layer.shadowOpacity = 1.0
    btn.layer.shadowRadius = 3.0
  }

  /// Sets the functionality of the privacy policy button.
  func setPrivacyPolicyBtn() {
    switchView.titleLabel?.font = .systemFont(ofSize: switchView.frame.height * 0.35)
    if displayPrivacyPolicy == false {
      styleBtn(btn: switchView, title: "View Privacy Policy", radius: switchView.frame.width / 20)
    } else if displayPrivacyPolicy == true {
      styleBtn(btn: switchView, title: "View Installation", radius: switchView.frame.width / 20)
    }
    switchView.setTitleColor(UIColor.keyCharColorLight, for: .normal)
    switchView.backgroundColor = switchViewColor
    switchView.addTarget(self, action: #selector(showHidePrivacyPolicy), for: .touchUpInside)
    switchView.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
  }

  @IBOutlet weak var appTextView: UITextView!
  @IBOutlet weak var appTextTitle: UITextView!
  @IBOutlet weak var appTextBackground: UIView!
  @IBOutlet weak var appTextBtn: UIButton!

  @IBOutlet weak var GHTextView: UITextView!
  @IBOutlet weak var GHTextBackground: UIView!
  @IBOutlet weak var GHTextBtn: UIButton!

  @IBOutlet weak var privacyTextBackground: UIView!
  @IBOutlet weak var privacyTextView: UITextView!
  @IBOutlet weak var privacyTextTitle: UITextView!
  @IBOutlet weak var privacyScroll: UIImageView!

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
    checkDarkModeSetColors()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    checkDarkModeSetColors()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setFontSize()
    setPrivacyPolicyBtn()
    setUI()
  }

  /// Creates the full text for the app UI that comes from two NSAttributedStrings and also adds attributes.
  func setUI() {
    let scrollbarAppearance = UINavigationBarAppearance()
    scrollbarAppearance.configureWithOpaqueBackground()

    appTextView.isEditable = false
    appTextView.isUserInteractionEnabled = false
    appTextView.backgroundColor = .clear
    appTextTitle.isEditable = false
    appTextTitle.isUserInteractionEnabled = false
    appTextTitle.backgroundColor = .clear
    appTextBackground.clipsToBounds = true
    appTextBackground.layer.masksToBounds = false
    appTextBackground.layer.cornerRadius = appTextBackground.frame.width / 15

    GHTextView.isEditable = false
    GHTextView.isUserInteractionEnabled = false
    GHTextView.backgroundColor = .clear
    GHTextBackground.clipsToBounds = true
    GHTextBackground.layer.masksToBounds = false
    GHTextBackground.layer.cornerRadius = GHTextBackground.frame.width / 15

    privacyTextView.isEditable = false
    privacyTextView.backgroundColor = .clear
    privacyTextTitle.isEditable = false
    privacyTextTitle.backgroundColor = .clear
    privacyTextBackground.clipsToBounds = true
    privacyTextBackground.layer.masksToBounds = false
    privacyTextBackground.layer.cornerRadius = privacyTextBackground.frame.width / 15
    privacyScroll.isUserInteractionEnabled = false

    if displayPrivacyPolicy == false {
      appTextBtn.isUserInteractionEnabled = true
      appTextView.font = .systemFont(ofSize: fontSize)
      appTextView.textColor = UIColor.keyCharColorLight
      appTextBackground.backgroundColor = .white
      appTextBackground.layer.shadowColor = UIColor.keyShadowColorLight
      appTextBackground.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
      appTextBackground.layer.shadowOpacity = 1.0
      appTextBackground.layer.shadowRadius = 3.0

      appTextTitle.font = .boldSystemFont(ofSize: fontSize * 1.5)
      appTextTitle.textColor = UIColor.keyCharColorLight

      GHTextBtn.isUserInteractionEnabled = true
      GHTextView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.scribeBlueDark,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
      GHTextView.font = .systemFont(ofSize: fontSize)
      GHTextView.textColor = UIColor.keyCharColorLight
      GHTextBackground.backgroundColor = .white
      GHTextBackground.layer.shadowColor = UIColor.keyShadowColorLight
      GHTextBackground.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
      GHTextBackground.layer.shadowOpacity = 1.0
      GHTextBackground.layer.shadowRadius = 3.0

      privacyTextBackground.backgroundColor = .clear
      privacyTextView.backgroundColor = .clear
      privacyTextView.text = ""
      privacyTextTitle.backgroundColor = .clear
      privacyTextTitle.text = ""

      privacyScroll.isHidden = true
      
      setAttributedInfoText()
    } else {
      appTextBtn.isUserInteractionEnabled = false
      appTextView.backgroundColor = .clear
      appTextView.text = ""
      appTextTitle.text = ""
      appTextBackground.backgroundColor = .clear
      appTextBackground.isUserInteractionEnabled = false

      GHTextBtn.isUserInteractionEnabled = false
      GHTextView.text = ""
      GHTextBackground.backgroundColor = .clear
      GHTextBackground.isUserInteractionEnabled = false

      privacyTextBackground.backgroundColor = .white
      privacyTextBackground.layer.shadowColor = UIColor.keyShadowColorLight
      privacyTextBackground.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
      privacyTextBackground.layer.shadowOpacity = 1.0
      privacyTextBackground.layer.shadowRadius = 3.0

      privacyTextView.font = .systemFont(ofSize: fontSize)
      privacyTextView.textColor = UIColor.keyCharColorLight

      privacyTextTitle.font = .boldSystemFont(ofSize: fontSize * 1.5)
      privacyTextTitle.textColor = UIColor.keyCharColorLight

      privacyScroll.isHidden = false

      setAttributedPrivacyPolicy()
    }
  }

  /// The text for ViewController that includes the globe character.
  func setAttributedInfoText() {
    let installationTitle = "Keyboard Installation"
    appTextTitle.text = installationTitle

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

    let GHInfoText = NSMutableAttributedString(string: """
    Scribe is fully open-source. To report issues or contribute please visit us at\u{0020}
    """)
    // A second NSAttributedString that includes a link to the GitHub.
    let ghLink = addHyperLinksToText(originalText: "github.com/scribe-org.", hyperLinks: ["github.com/scribe-org": "https://github.com/scribe-org"])
    let fullGHInfoText = concatAttributedStrings(left: GHInfoText, right: ghLink)

    GHTextView.attributedText = fullGHInfoText
  }

  /// Formats and returns Scribe privacy policy.
  func setAttributedPrivacyPolicy() {
    let privacyPolicyTitle = "Privacy Policy"
    privacyTextTitle.text = privacyPolicyTitle
    
    let privacyPolicyTextWithLinks = addHyperLinksToText(originalText: privacyPolicyText, hyperLinks: ["https://www.wikidata.org/wiki/Wikidata:Licensing": "https://www.wikidata.org/wiki/Wikidata:Licensing", "https://github.com/huggingface/transformers/blob/master/LICENSE": "https://github.com/huggingface/transformers/blob/master/LICENSE", "https://github.com/scribe-org": "https://github.com/scribe-org", "scribe.langauge@gmail.com": "mailto:scribe.langauge@gmail.com"])

    privacyTextView.attributedText = privacyPolicyTextWithLinks
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
