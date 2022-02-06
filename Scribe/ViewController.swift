//
//  ViewController.swift
//
//  The ViewController for the Scribe app.
//

import UIKit

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
    setCurrentUI()
  }

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    checkDarkModeSetColors()
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    setCurrentUI()
  }

  // Lock the device into portrait mode to avoid resizing issues.
  var orientations = UIInterfaceOrientationMask.portrait
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    get { return self.orientations }
    set { self.orientations = newValue }
  }

  // The app screen is white content on blue, so match the status bar.
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  /// Sets the top icon for the app screen given the device to assure that it's oriented correctly to its background.
  func setTopIcon() {
    if DeviceType.isPhone {
      topIconPhone.isHidden = false
      topIconPad.isHidden = true
    } else if DeviceType.isPad {
      topIconPhone.isHidden = true
      topIconPad.isHidden = false
    }
  }

  let switchViewColor = UIColor(red: 241.0/255.0, green: 204.0/255.0, blue: 131.0/255.0, alpha: 1.0)
  /// Sets the functionality of the button that switches between installation instructions and the privacy policy.
  func setSwitchViewBtn() {
    if displayPrivacyPolicy == false {
      switchView.setTitle("View Privacy Policy", for: .normal)
    } else if displayPrivacyPolicy == true {
      switchView.setTitle("View Installation", for: .normal)
    }
    switchView.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    switchView.setTitleColor(UIColor.keyCharColorLight, for: .normal)
    switchView.titleLabel?.font = .systemFont(ofSize: fontSize * 1.5)

    switchView.clipsToBounds = true
    switchView.backgroundColor = switchViewColor
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

  /// Sets the functionality of the button over the keyboard installation guide that links to Scribe's GitHub.
  func setGHBtn() {
    GHBtn.addTarget(self, action: #selector(openScribeGH), for: .touchUpInside)
    GHBtn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
  }

  /// Sets constant properties for the app screen.
  func setUIConstantProperties() {
    // Set the scroll bar so that it appears on a white background regardless of light or dark mode.
    let scrollbarAppearance = UINavigationBarAppearance()
    scrollbarAppearance.configureWithOpaqueBackground()
    privacyScroll.isUserInteractionEnabled = false

    // Disable spacing views.
    let allSpacingViews: [UIView] = [topSpace, logoSpace, svSpace, bottomSpace]
    for view in allSpacingViews {
      view.isUserInteractionEnabled = false
      view.backgroundColor = .clear
    }

    topIconPhone.tintColor = .white
    topIconPad.tintColor = .white
  }

  /// Sets properties for the app screen given the current device.
  func setUIDeviceProperties() {
    // Height ratios to set corner radii exactly.
    let installTextToSwitchBtnHeightRatio = appTextBackground.frame.height / switchViewBackground.frame.height
    let GHTextToSwitchBtnHeightRatio = GHTextBackground.frame.height / switchViewBackground.frame.height
    let privacyTextToSwitchBtnHeightRatio = privacyTextBackground.frame.height / switchViewBackground.frame.height

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

    let allTextViews: [UITextView] = [appTextView, GHTextView, privacyTextView]

    // Disable text views.
    for textView in allTextViews {
      textView.isUserInteractionEnabled = false
      textView.backgroundColor = .clear
      textView.isEditable = false
    }

    // Set backgrounds and corner radii.
    appTextBackground.isUserInteractionEnabled = false
    appTextBackground.clipsToBounds = true
    applyCornerRadius(
      elem: appTextBackground,
      radius: appTextBackground.frame.height * 0.4 / installTextToSwitchBtnHeightRatio
    )

    GHTextBackground.isUserInteractionEnabled = false
    GHTextBackground.clipsToBounds = true
    applyCornerRadius(
      elem: GHTextBackground,
      radius: GHTextBackground.frame.height * 0.4 / GHTextToSwitchBtnHeightRatio
    )

    privacyTextView.backgroundColor = .clear
    applyCornerRadius(
      elem: privacyTextBackground,
      radius: privacyTextBackground.frame.height * 0.4 / privacyTextToSwitchBtnHeightRatio
    )

    // Set link attributes for all textViews.
    for textView in allTextViews {
      textView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.annotateBlueLight,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
    }
  }

  /// Sets the necessary properties for the installation UI including calling text generation functions.
  func setInstallationUI() {
    let settingsSymbol: UIImage = getSettingsSymbol(fontSize: fontSize)
    topIconPhone.image = settingsSymbol
    topIconPad.image = settingsSymbol

    // Enable installation directions and GitHub notice elements.
    settingsBtn.isUserInteractionEnabled = true
    appTextBackground.backgroundColor = .white
    applyShadowEffects(elem: appTextBackground)

    GHBtn.isUserInteractionEnabled = true
    GHCorner.isHidden = false
    GHTextBackground.backgroundColor = .white
    applyShadowEffects(elem: GHTextBackground)

    // Disable the privacy policy elements.
    privacyTextView.isUserInteractionEnabled = false
    privacyTextView.backgroundColor = .clear
    privacyTextView.text = ""
    privacyTextBackground.backgroundColor = .clear

    privacyScroll.isHidden = true

    // Set the texts for the fields.
    appTextView.attributedText = setENInstallation(fontSize: fontSize)
    appTextView.textColor = UIColor.keyCharColorLight

    GHTextView.attributedText = setENGitHubText(fontSize: fontSize)
    GHTextView.textColor = UIColor.keyCharColorLight
  }

  /// Sets the necessary properties for the privacy policy UI including calling the text generation function.
  func setPrivacyUI() {
    let privacySymbol: UIImage = getPrivacySymbol(fontSize: fontSize)
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
    privacyTextBackground.backgroundColor = .white
    applyShadowEffects(elem: privacyTextBackground)

    privacyScroll.isHidden = false

    privacyTextView.attributedText = setENPrivacyPolicy(fontSize: fontSize)
    privacyTextView.textColor = UIColor.keyCharColorLight
  }

  /// Creates the current app UI by applying constraints and calling child UI functions.
  func setCurrentUI() {
    // Set the font size and all button elements.
    setFontSize()
    setTopIcon()
    setSwitchViewBtn()
    setSettingsBtn()
    setGHBtn()
    setUIConstantProperties()
    setUIDeviceProperties()

    if displayPrivacyPolicy == false {
      setInstallationUI()
    } else {
      setPrivacyUI()
    }
  }

  /// Switches the view of the app based on the current view.
  @objc func switchAppView() {
    if displayPrivacyPolicy == false {
      displayPrivacyPolicy = true
    } else {
      displayPrivacyPolicy = false
    }
    setCurrentUI()
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
    if sender == switchView {
      sender.backgroundColor = .clear
      sender.setTitleColor(switchViewColor, for: .normal)

      // Bring sender's background and text colors back to their original values.
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [self] in
        sender.backgroundColor = switchViewColor
        sender.setTitleColor(UIColor.keyCharColorLight, for: .normal)
      }
    } else {
      sender.backgroundColor = .black
      sender.alpha = 0.2

      // Bring sender's opacity back up to fully opaque and replace the background color.
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
        sender.backgroundColor = .clear
        sender.alpha = 1.0
      }
    }
  }
}
