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
  @IBOutlet weak var appTextTitle: UITextView!
  @IBOutlet weak var appTextBackground: UIView!

  @IBOutlet weak var settingsBtn: UIButton!
  @IBOutlet weak var settingsIcon: UIImageView!
  @IBOutlet weak var settingsCorner: UIImageView!

  @IBOutlet weak var GHTextView: UITextView!
  @IBOutlet weak var GHTextTitle: UITextView!
  @IBOutlet weak var GHTextBackground: UIView!

  @IBOutlet weak var GHBtn: UIButton!
  @IBOutlet weak var GHCorner: UIImageView!

  @IBOutlet weak var privacyTextBackground: UIView!
  @IBOutlet weak var privacyTextView: UITextView!
  @IBOutlet weak var privacyTextTitle: UITextView!
  @IBOutlet weak var privacyScroll: UIImageView!

  @IBOutlet weak var switchView: UIButton!
  @IBOutlet weak var switchViewBackground: UIView!
  let switchViewColor = UIColor(red: 241.0/255.0, green: 204.0/255.0, blue: 131.0/255.0, alpha: 1.0)
  var displayPrivacyPolicy = false

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

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
  func setSwitchViewBtn() {
    switchView.titleLabel?.font = .systemFont(ofSize: switchView.frame.height * 0.35)
    if displayPrivacyPolicy == false {
      styleBtn(btn: switchView, title: "View Privacy Policy", radius: switchView.frame.width / 20)
    } else if displayPrivacyPolicy == true {
      styleBtn(btn: switchView, title: "View Installation", radius: switchView.frame.width / 20)
    }
    switchView.setTitleColor(UIColor.keyCharColorLight, for: .normal)
    switchView.backgroundColor = switchViewColor
    switchView.addTarget(self, action: #selector(switchAppView), for: .touchUpInside)
    switchView.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)

    switchViewBackground.backgroundColor = .white
    switchViewBackground.clipsToBounds = true
    switchViewBackground.layer.masksToBounds = false
    switchViewBackground.layer.cornerRadius = switchView.frame.width / 20
  }

  func setSettingsBtn() {
    settingsBtn.addTarget(self, action: #selector(openSettingsApp), for: .touchUpInside)
    settingsBtn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
  }

  func setGHBtn() {
    GHBtn.addTarget(self, action: #selector(openScribeGH), for: .touchUpInside)
    GHBtn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
  }

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
    setSwitchViewBtn()
    setSettingsBtn()
    setGHBtn()
    setUI()
  }

  /// Creates the full text for the app UI that comes from two NSAttributedStrings and also adds attributes.
  func setUI() {
    let scrollbarAppearance = UINavigationBarAppearance()
    scrollbarAppearance.configureWithOpaqueBackground()

    let settingsSymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.2, weight: .medium, scale: .medium)
    let settingsSymbol = UIImage(systemName: "gear", withConfiguration: settingsSymbolConfig)
    let privacySymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.25, weight: .medium, scale: .medium)
    let privacySymbol = UIImage(systemName: "lock.shield", withConfiguration: privacySymbolConfig)
    settingsIcon.tintColor = .white

    settingsCorner.layer.maskedCorners = .layerMaxXMinYCorner
    settingsCorner.layer.cornerRadius = appTextBackground.frame.width / 15
    GHCorner.layer.maskedCorners = .layerMaxXMinYCorner
    GHCorner.layer.cornerRadius = GHTextBackground.frame.width / 15

    settingsBtn.clipsToBounds = true
    settingsBtn.layer.masksToBounds = false
    settingsBtn.layer.cornerRadius = appTextBackground.frame.width / 15
    GHBtn.clipsToBounds = true
    GHBtn.layer.masksToBounds = false
    GHBtn.layer.cornerRadius = GHTextBackground.frame.width / 15

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
    GHTextTitle.isEditable = false
    GHTextTitle.isUserInteractionEnabled = false
    GHTextTitle.backgroundColor = .clear
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
      settingsBtn.isUserInteractionEnabled = true
      settingsIcon.isHidden = false
      settingsCorner.isHidden = false
      settingsIcon.image = settingsSymbol

      appTextView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.previewBlueLight,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
      appTextView.font = .systemFont(ofSize: fontSize)
      appTextView.textColor = UIColor.keyCharColorLight
      appTextBackground.backgroundColor = .white
      appTextBackground.layer.shadowColor = UIColor.keyShadowColorLight
      appTextBackground.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
      appTextBackground.layer.shadowOpacity = 1.0
      appTextBackground.layer.shadowRadius = 3.0

      appTextTitle.font = .boldSystemFont(ofSize: fontSize * 1.5)
      appTextTitle.textColor = UIColor.keyCharColorLight

      GHBtn.isUserInteractionEnabled = true
      GHCorner.isHidden = false

      GHTextView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.previewBlueLight,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
      GHTextView.font = .systemFont(ofSize: fontSize)
      GHTextView.textColor = UIColor.keyCharColorLight
      GHTextBackground.backgroundColor = .white
      GHTextBackground.layer.shadowColor = UIColor.keyShadowColorLight
      GHTextBackground.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
      GHTextBackground.layer.shadowOpacity = 1.0
      GHTextBackground.layer.shadowRadius = 3.0

      GHTextTitle.font = .boldSystemFont(ofSize: fontSize * 1.5)
      GHTextTitle.textColor = UIColor.keyCharColorLight

      privacyTextBackground.backgroundColor = .clear
      privacyTextView.backgroundColor = .clear
      privacyTextView.text = ""
      privacyTextTitle.backgroundColor = .clear
      privacyTextTitle.text = ""

      privacyScroll.isHidden = true
      
      setAttributedInfoText()
    } else {
      settingsBtn.isUserInteractionEnabled = false
      settingsIcon.image = privacySymbol
      appTextView.text = ""
      appTextTitle.text = ""
      appTextBackground.backgroundColor = .clear
      appTextBackground.isUserInteractionEnabled = false

      GHBtn.isUserInteractionEnabled = false
      GHCorner.isHidden = true
      GHTextView.text = ""
      GHTextTitle.text = ""
      GHTextBackground.backgroundColor = .clear
      GHTextBackground.isUserInteractionEnabled = false

      privacyTextBackground.backgroundColor = .white
      privacyTextBackground.layer.shadowColor = UIColor.keyShadowColorLight
      privacyTextBackground.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
      privacyTextBackground.layer.shadowOpacity = 1.0
      privacyTextBackground.layer.shadowRadius = 3.0

      privacyTextView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.previewBlueLight,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
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
    appTextTitle.text = "Keyboard Installation"

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
    let startOfString = NSMutableAttributedString(string: """
    1.\u{0020}
    """)

    let settingsLink = addHyperLinksToText(originalText: "Open Settings", hyperLinks: ["Open Settings": "<makeTextLink>"])

    let settingsText = concatAttributedStrings(left: startOfString, right: settingsLink)

    let fullString = NSMutableAttributedString(string: """


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

    let settingsAndFullString = concatAttributedStrings(left: settingsText, right: fullString)
    appTextView.attributedText = NSMutableAttributedString(attributedString: settingsAndFullString)

    GHTextTitle.text = "Community"

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
    
    let privacyPolicyTextWithLinks = addHyperLinksToText(originalText: privacyPolicyText, hyperLinks: ["https://www.wikidata.org/wiki/Wikidata:Licensing": "https://www.wikidata.org/wiki/Wikidata:Licensing", "https://github.com/huggingface/transformers/blob/master/LICENSE": "https://github.com/huggingface/transformers/blob/master/LICENSE", "https://github.com/scribe-org": "https://github.com/scribe-org", "scribe.langauge@gmail.com": "mailto:scribe.langauge@gmail.com", "https://github.com/logos": "https://github.com/logos"])

    privacyTextView.attributedText = privacyPolicyTextWithLinks
  }

  @objc func switchAppView() {
    if displayPrivacyPolicy == false {
      displayPrivacyPolicy = true
    } else {
      displayPrivacyPolicy = false
    }
    setSwitchViewBtn()
    setUI()
  }

  @objc func openSettingsApp() {
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
  }

  @objc func openScribeGH() {
    guard let url = URL(string: "https://github.com/scribe-org") else {
      return
    }

    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      UIApplication.shared.openURL(url)
    }
  }

  @objc func keyTouchDown(_ sender: UIButton) {
    let orginalBackgroundColor = sender.backgroundColor
    sender.backgroundColor = .black
    sender.alpha = 0.2
    // Bring sender's opacity back up to fully opaque
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
      sender.backgroundColor = orginalBackgroundColor
      sender.alpha = 1.0
    }
  }
}
