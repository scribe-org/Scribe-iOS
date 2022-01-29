//
//  ViewController.swift
//
//  The ViewController for the Scribe app.
//

import UIKit

/// Concatenates attributed strings.
///
/// - Parameters
///  - left: the left attributed string to concatenate.
///  - right: the right attributed string to concatenate.
func concatAttributedStrings (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
  let result = NSMutableAttributedString()
  result.append(left)
  result.append(right)
  return result
}

/// Returns an attributed text that hyperlinked.
///
/// - Parameters
///  - originalText: the original text that hyperlinks will be added to.
///  - hyperLinks: a dictionary of strings and the link to which they should link.
func addHyperLinksToText(originalText: String, hyperLinks: [String: String], fontSize: CGFloat) -> NSMutableAttributedString {
  let style = NSMutableParagraphStyle()
  style.alignment = .left
  let attributedOriginalText = NSMutableAttributedString(string: originalText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])
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
  // Variables linked to elements in AppScreen.storyboard.
  @IBOutlet weak var appTextView: UITextView!
  @IBOutlet weak var appTextBackground: UIView!

  @IBOutlet weak var settingsBtn: UIButton!
  @IBOutlet weak var topIconPhone: UIImageView!
  @IBOutlet weak var topIconPad: UIImageView!
  @IBOutlet weak var settingsCorner: UIImageView!

  @IBOutlet weak var GHTextView: UITextView!
  @IBOutlet weak var GHTextBackground: UIView!

  @IBOutlet weak var GHBtn: UIButton!
  @IBOutlet weak var GHCorner: UIImageView!

  @IBOutlet weak var privacyTextBackground: UIView!
  @IBOutlet weak var privacyTextView: UITextView!
  @IBOutlet weak var privacyScroll: UIImageView!

  @IBOutlet weak var switchView: UIButton!
  @IBOutlet weak var switchViewBackground: UIView!
  var displayPrivacyPolicy = false

  // Spacing views to size app screen proportionally.
  @IBOutlet weak var topSpace: UIView!
  @IBOutlet weak var logoSpace: UIView!
  @IBOutlet weak var svSpace: UIView!
  @IBOutlet weak var bottomSpace: UIView!

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func viewDidLoad() {
    super.viewDidLoad()
    checkDarkModeSetColors()
    setUI()
  }

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    checkDarkModeSetColors()
    setUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUI()
  }

  // Lock the device into portrait mode to avoid resizing issues.
  var orientations = UIInterfaceOrientationMask.portrait
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    get { return self.orientations }
    set { self.orientations = newValue }
  }

  // The app screen is white content on blue, so match the status bar.
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  var fontSize = CGFloat(0)
  /// Sets the font size for the text in the app screen and corresponding UIImage icons.
  func setFontSize() {
    if UIDevice.current.userInterfaceIdiom == .phone {
      fontSize = UIScreen.main.bounds.width / 30
    } else if UIDevice.current.userInterfaceIdiom == .pad {
      fontSize = UIScreen.main.bounds.width / 45
    }
  }

  /// Sets the top icon for the app screen given the device to assure that it's oriented correctly to its background.
  func setTopIcon() {
    if UIDevice.current.userInterfaceIdiom == .phone {
      topIconPhone.isHidden = false
      topIconPad.isHidden = true
    } else if UIDevice.current.userInterfaceIdiom == .pad {
      topIconPhone.isHidden = true
      topIconPad.isHidden = false
    }
  }

  /// Applies a shadow to a given element.
  ///
  /// - Parameters
  ///  - elem: the element to have shadows added to.
  func applyShadowEffects(elem: AnyObject) {
    elem.layer.shadowColor = UIColor.keyShadowColorLight
    elem.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
    elem.layer.shadowOpacity = 1.0
    elem.layer.shadowRadius = 3.0
  }

  /// Applies a corner radius to a given element.
  ///
  /// - Parameters
  ///  - elem: the element to have shadows added to.
  func applyCornerRadius(elem: AnyObject, radius: CGFloat) {
    elem.layer.masksToBounds = false
    elem.layer.cornerRadius = radius
  }

  /// Sets the functionality of the button that switches between installation instructions and the privacy policy.
  func setSwitchViewBtn() {
    switchView.titleLabel?.font = .systemFont(ofSize: switchView.frame.height * 0.35)
    if displayPrivacyPolicy == false {
      switchView.setTitle("View Privacy Policy", for: .normal)
    } else if displayPrivacyPolicy == true {
      switchView.setTitle("View Installation", for: .normal)
    }
    switchView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    switchView.setTitleColor(UIColor.keyCharColorLight, for: .normal)

    switchView.clipsToBounds = true
    switchView.backgroundColor = UIColor(red: 241.0/255.0, green: 204.0/255.0, blue: 131.0/255.0, alpha: 1.0)
    applyCornerRadius(elem: switchView, radius: switchView.frame.height * 0.35)
    applyShadowEffects(elem: switchView)

    switchView.addTarget(self, action: #selector(switchAppView), for: .touchUpInside)
    switchView.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)

    // Add a white background so that the key press doesn't show the blue app screen background.
    switchViewBackground.backgroundColor = .white
    switchViewBackground.clipsToBounds = true
    applyCornerRadius(elem: switchViewBackground, radius: switchView.frame.height * 0.35)
  }

  /// Sets the functionality of the button over the keyboard installation guide that opens Settings.
  func setSettingsBtn() {
    settingsBtn.addTarget(self, action: #selector(openSettingsApp), for: .touchUpInside)
    settingsBtn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
  }

  /// Sets the functionality of the button over the keyboard installtion guide that links to Scribe's GitHub.
  func setGHBtn() {
    GHBtn.addTarget(self, action: #selector(openScribeGH), for: .touchUpInside)
    GHBtn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
  }

  /// Creates the full app UI by applying contraints and calling text generation functions.
  func setUI() {
    // Set the font size and all button elements.
    setFontSize()
    setTopIcon()
    setSwitchViewBtn()
    setSettingsBtn()
    setGHBtn()

    // Height ratios to set corner radii exactly.
    let installTextToSwitchBtnHeightRatio = appTextBackground.frame.height / switchViewBackground.frame.height
    let GHTextToSwitchBtnHeightRatio = GHTextBackground.frame.height / switchViewBackground.frame.height
    let privacyTextToSwitchBtnHeightRatio = privacyTextBackground.frame.height / switchViewBackground.frame.height

    // Set the scroll bar so that it appears on a white background regardless of light or dark mode.
    let scrollbarAppearance = UINavigationBarAppearance()
    scrollbarAppearance.configureWithOpaqueBackground()

    // Disable spacing views.
    for elem in [topSpace, logoSpace, svSpace, bottomSpace] {
      elem?.isUserInteractionEnabled = false
      elem?.backgroundColor = .clear
    }

    // Set configurations for corner icons.
    var settingsSymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.2, weight: .medium, scale: .medium)
    var privacySymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.25, weight: .medium, scale: .medium)
    if UIDevice.current.userInterfaceIdiom == .pad {
      settingsSymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.15, weight: .medium, scale: .medium)
      privacySymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.2, weight: .medium, scale: .medium)
    }
    let settingsSymbol = UIImage(systemName: "gear", withConfiguration: settingsSymbolConfig)
    let privacySymbol = UIImage(systemName: "lock.shield", withConfiguration: privacySymbolConfig)
    topIconPhone.tintColor = .white
    topIconPad.tintColor = .white

    settingsCorner.layer.maskedCorners = .layerMaxXMinYCorner
    settingsCorner.layer.cornerRadius = appTextBackground.frame.height * 0.4 / installTextToSwitchBtnHeightRatio
    settingsCorner.alpha = 0.9
    GHCorner.layer.maskedCorners = .layerMaxXMinYCorner
    GHCorner.layer.cornerRadius = GHTextBackground.frame.height * 0.4 / GHTextToSwitchBtnHeightRatio
    GHCorner.alpha = 0.9

    settingsBtn.clipsToBounds = true
    settingsBtn.layer.masksToBounds = false
    settingsBtn.layer.cornerRadius = appTextBackground.frame.height * 0.4 / installTextToSwitchBtnHeightRatio
    GHBtn.clipsToBounds = true
    GHBtn.layer.masksToBounds = false
    GHBtn.layer.cornerRadius = GHTextBackground.frame.height * 0.4 / GHTextToSwitchBtnHeightRatio

    // Disable text views.
    for elem in [appTextView, GHTextView, privacyTextView] {
      elem?.isUserInteractionEnabled = false
      elem?.isEditable = false
      elem?.backgroundColor = .clear
    }

    // Set backgrounds and corner radii.
    appTextView.isUserInteractionEnabled = false
    appTextBackground.isUserInteractionEnabled = false
    appTextBackground.clipsToBounds = true
    applyCornerRadius(elem: appTextBackground, radius: appTextBackground.frame.height * 0.4 / installTextToSwitchBtnHeightRatio)

    GHTextView.isUserInteractionEnabled = false
    GHTextBackground.isUserInteractionEnabled = false
    GHTextBackground.clipsToBounds = true
    applyCornerRadius(elem: GHTextBackground, radius: GHTextBackground.frame.height * 0.4 / GHTextToSwitchBtnHeightRatio)

    // Privacy text allows for user interactions so that the links in the policy can be pressed.
    privacyTextView.backgroundColor = .clear
    applyCornerRadius(elem: privacyTextBackground, radius: privacyTextBackground.frame.height * 0.4 / privacyTextToSwitchBtnHeightRatio)
    privacyScroll.isUserInteractionEnabled = false

    if displayPrivacyPolicy == false {
      topIconPhone.image = settingsSymbol
      topIconPad.image = settingsSymbol

      // Enable installation directions and GitHub notice elements.
      settingsBtn.isUserInteractionEnabled = true
      appTextView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.previewBlueLight,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
      appTextBackground.backgroundColor = .white
      applyShadowEffects(elem: appTextBackground)

      GHBtn.isUserInteractionEnabled = true
      GHCorner.isHidden = false
      GHTextView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.previewBlueLight,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
      GHTextBackground.backgroundColor = .white
      applyShadowEffects(elem: GHTextBackground)

      // Disable the privacy policy elements.
      privacyTextView.isUserInteractionEnabled = false
      privacyTextView.backgroundColor = .clear
      privacyTextView.text = ""
      privacyTextBackground.backgroundColor = .clear

      privacyScroll.isHidden = true

      // Set the texts for the fields.
      setAttributedInstallation()
      setAttributedGitHubText()
    } else {
      topIconPhone.image = privacySymbol
      topIconPad.image = privacySymbol

      // Disable installation directions and GitHub notice elements.
      settingsBtn.isUserInteractionEnabled = false
      appTextView.text = ""
      appTextBackground.backgroundColor = .clear

      GHBtn.isUserInteractionEnabled = false
      GHCorner.isHidden = true
      GHTextView.text = ""
      GHTextBackground.backgroundColor = .clear

      // Enable the privacy policy elements.
      privacyTextView.isUserInteractionEnabled = true
      privacyTextView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.previewBlueLight,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
      privacyTextBackground.backgroundColor = .white
      applyShadowEffects(elem: privacyTextBackground)

      privacyScroll.isHidden = false

      setAttributedPrivacyPolicy()
    }
  }

  /// Formats and returns the text for the installtion guidelines.
  func setAttributedInstallation() {
    // The down right arrow character as a text attachment.
    let arrowAttachment = NSTextAttachment()
    let selectArrowIconConfig = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium, scale: .medium)
    arrowAttachment.image = UIImage(systemName: "arrow.turn.down.right", withConfiguration: selectArrowIconConfig)?.withTintColor(.scribeGrey)

    // The globe character as a text attachment.
    let globeAttachment = NSTextAttachment()
    let selectGlobeIconConfig = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium, scale: .medium)
    globeAttachment.image = UIImage(systemName: "globe", withConfiguration: selectGlobeIconConfig)?.withTintColor(.scribeGrey)

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

    let settingsLink = addHyperLinksToText(originalText: "Open Settings", hyperLinks: ["Open Settings": "<makeTextLink>"], fontSize: fontSize)

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

    installDirections.append(NSMutableAttributedString(string: "\n                    ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]))

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
    appTextView.attributedText = concatAttributedStrings(left: installationTextTitle, right: installFullDirections)
    appTextView.textColor = UIColor.keyCharColorLight
  }

  /// Formats and returns the text for a notice about Scribe's GitHub.
  func setAttributedGitHubText() {
    let GHTextTitle = NSMutableAttributedString(string: """
    Community
    """, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.5)])

    // Initialize the main body of the text.
    let GHInfoText = NSMutableAttributedString(string: """
    \n
    Scribe is fully open-source. To report issues or contribute please visit us at\u{0020}
    """, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])

    // A second NSAttributedString that includes a link to the GitHub.
    let ghLink = addHyperLinksToText(originalText: "github.com/scribe-org.", hyperLinks: ["github.com/scribe-org": "https://github.com/scribe-org"], fontSize: fontSize)

    let GHInfoTextToLink = concatAttributedStrings(left: GHTextTitle, right: GHInfoText)
    GHTextView.attributedText = concatAttributedStrings(left: GHInfoTextToLink, right: ghLink)
    GHTextView.textColor = UIColor.keyCharColorLight
  }

  /// Formats and returns the text of the Scribe privacy policy.
  func setAttributedPrivacyPolicy() {
    let privacyTextTitle = NSMutableAttributedString(string: """
    Privacy Policy
    """, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.5)])
    
    let privacyPolicyTextWithLinks = addHyperLinksToText(originalText: privacyPolicyText, hyperLinks: ["https://www.wikidata.org/wiki/Wikidata:Licensing": "https://www.wikidata.org/wiki/Wikidata:Licensing", "https://github.com/huggingface/transformers/blob/master/LICENSE": "https://github.com/huggingface/transformers/blob/master/LICENSE", "https://github.com/scribe-org": "https://github.com/scribe-org", "scribe.langauge@gmail.com": "mailto:scribe.langauge@gmail.com", "https://github.com/logos": "https://github.com/logos"], fontSize: fontSize)

    privacyTextView.attributedText = concatAttributedStrings(left: privacyTextTitle, right: privacyPolicyTextWithLinks)
    privacyTextView.textColor = UIColor.keyCharColorLight
  }

  /// Switches the view of the app based on the current view.
  @objc func switchAppView() {
    if displayPrivacyPolicy == false {
      displayPrivacyPolicy = true
    } else {
      displayPrivacyPolicy = false
    }
    setUI()
  }

  /// Function to open the settings app that is targeted by settingsBtn.
  @objc func openSettingsApp() {
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
  }

  /// Function to open Scribe's GitHub page that is targeted by GHBtn.
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

  /// Function to change the key coloration given a touch down.
  ///
  /// - Parameters
  ///  - sender: the button that has been pressed.
  @objc func keyTouchDown(_ sender: UIButton) {
    let orginalBackgroundColor = sender.backgroundColor
    sender.backgroundColor = .black
    sender.alpha = 0.2
    // Bring sender's opacity back up to fully opaque and replace the background color.
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
      sender.backgroundColor = orginalBackgroundColor
      sender.alpha = 1.0
    }
  }
}
