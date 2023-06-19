//
//  ViewController.swift
//
//  The ViewController for the Installation screen of the Scribe app.
//

import UIKit

/// A UIViewController that provides instructions on how to install Keyboards as well as information about Scribe.
class InstallationVC: UIViewController {
  // Variables linked to elements in AppScreen.storyboard.
  @IBOutlet var appTextView: UITextView!
  @IBOutlet var appTextBackground: UIView!

  @IBOutlet var settingsBtn: UIButton!
  @IBOutlet var topIconPhone: UIImageView!
  @IBOutlet var topIconPad: UIImageView!
  @IBOutlet var settingsCorner: UIImageView!

  @IBOutlet var GHTextView: UITextView!
  @IBOutlet var GHTextBackground: UIView!

  @IBOutlet var GHBtn: UIButton!
  @IBOutlet var GHCorner: UIImageView!

  // Spacing views to size app screen proportionally.
  @IBOutlet var topSpace: UIView!
  @IBOutlet var logoSpace: UIView!

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func viewDidLoad() {
    super.viewDidLoad()
    setCurrentUI()
  }

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
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

    // Disable spacing views.
    let allSpacingViews: [UIView] = [topSpace, logoSpace]
    for view in allSpacingViews {
      view.isUserInteractionEnabled = false
      view.backgroundColor = .clear
    }

    topIconPhone.tintColor = .white
    topIconPad.tintColor = .white
  }

  /// Sets properties for the app screen given the current device.
  func setUIDeviceProperties() {
    settingsCorner.layer.maskedCorners = .layerMaxXMinYCorner
    settingsCorner.layer.cornerRadius = appTextBackground.frame.width * 0.05
    settingsCorner.alpha = 0.9
    GHCorner.layer.maskedCorners = .layerMaxXMinYCorner
    GHCorner.layer.cornerRadius = GHTextBackground.frame.width * 0.05
    GHCorner.alpha = 0.9

    settingsBtn.clipsToBounds = true
    settingsBtn.layer.masksToBounds = false
    settingsBtn.layer.cornerRadius = appTextBackground.frame.width * 0.05
    GHBtn.clipsToBounds = true
    GHBtn.layer.masksToBounds = false
    GHBtn.layer.cornerRadius = GHTextBackground.frame.width * 0.05

    let allTextViews: [UITextView] = [appTextView, GHTextView]

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
      radius: appTextBackground.frame.width * 0.05
    )

    GHTextBackground.isUserInteractionEnabled = false
    GHTextBackground.clipsToBounds = true
    applyCornerRadius(
      elem: GHTextBackground,
      radius: GHTextBackground.frame.width * 0.05
    )

    // Set link attributes for all textViews.
    for textView in allTextViews {
      textView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor(named: "linkBlue")!,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
      ]
    }
  }

  /// Sets the necessary properties for the installation UI including calling text generation functions.
  func setInstallationUI() {
    let settingsSymbol: UIImage = getSettingsSymbol(fontSize: fontSize * 0.9)
    topIconPhone.image = settingsSymbol
    topIconPad.image = settingsSymbol
    topIconPhone.tintColor = .init(.keyChar)
    topIconPad.tintColor = .init(.keyChar)

    // Enable installation directions and GitHub notice elements.
    settingsBtn.isUserInteractionEnabled = true
    appTextBackground.backgroundColor = UIColor(named: "commandBar")
    applyShadowEffects(elem: appTextBackground)

    GHBtn.isUserInteractionEnabled = true
    GHCorner.isHidden = false
    GHTextBackground.backgroundColor = UIColor(named: "commandBar")
    applyShadowEffects(elem: GHTextBackground)

    // Set the texts for the fields.
    switch Locale.userSystemLanguage {
    case "EN":
      appTextView.attributedText = setENInstallation(fontSize: fontSize)
      GHTextView.attributedText = setENGitHubText(fontSize: fontSize)

    case "DE":
      appTextView.attributedText = setDEInstallation(fontSize: fontSize)
      GHTextView.attributedText = setDEGitHubText(fontSize: fontSize)

    default:
      appTextView.attributedText = setENInstallation(fontSize: fontSize)
      GHTextView.attributedText = setENGitHubText(fontSize: fontSize)
    }
    appTextView.textColor = .init(.keyChar)
    GHTextView.textColor = .init(.keyChar)
  }

  /// Creates the current app UI by applying constraints and calling child UI functions.
  func setCurrentUI() {
    // Sets the font size for the text in the app screen and corresponding UIImage icons.
    if DeviceType.isPhone {
      if Locale.userSystemLanguage == "DE" {
        fontSize = UIScreen.main.bounds.height / 61
      } else {
        fontSize = UIScreen.main.bounds.height / 59
      }
    } else if DeviceType.isPad {
      fontSize = UIScreen.main.bounds.height / 53
    }
    setTopIcon()
    setSettingsBtn()
    setGHBtn()
    setUIConstantProperties()
    setUIDeviceProperties()
    setInstallationUI()
  }

  /// Function to open the settings app that is targeted by settingsBtn.
  @objc func openSettingsApp() {
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
  }

  /// Function to open Scribe's GitHub page that is targeted by GHBtn.
  @objc func openScribeGH() {
    guard let url = URL(string: "https://github.com/scribe-org/Scribe-iOS") else {
      return
    }

    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }

  /// Function to change the key coloration given a touch down.
  ///
  /// - Parameters
  ///  - sender: the button that has been pressed.
  @objc func keyTouchDown(_ sender: UIButton) {
    sender.backgroundColor = .black
    sender.alpha = 0.2

    // Bring sender's opacity back up to fully opaque and replace the background color.
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
      sender.backgroundColor = .clear
      sender.alpha = 1.0
    }
  }
}
