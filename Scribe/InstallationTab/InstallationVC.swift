// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * The ViewController for the Installation screen of the Scribe app.
 */

import UIKit
import SwiftUI

/// A UIViewController that provides instructions on how to install Keyboards as well as information about Scribe.
class InstallationVC: UIViewController {
  // Variables linked to elements in AppScreen.storyboard.
  @IBOutlet var appTextViewPhone: UITextView!
  @IBOutlet var appTextViewPad: UITextView!
  var appTextView: UITextView!

  @IBOutlet var appTextBackgroundPhone: UIView!
  @IBOutlet var appTextBackgroundPad: UIView!
  var appTextBackground: UIView!

  @IBOutlet var topIconPhone: UIImageView!
  @IBOutlet var topIconPad: UIImageView!
  var topIcon: UIImageView!

  @IBOutlet var settingsBtnPhone: UIButton!
  @IBOutlet var settingsBtnPad: UIButton!
  var settingsBtn: UIButton!

  @IBOutlet var settingsCornerPhone: UIImageView!
  @IBOutlet var settingsCornerPad: UIImageView!
  var settingsCorner: UIImageView!

  @IBOutlet var settingCornerWidthConstraintPhone: NSLayoutConstraint!
  @IBOutlet var settingCornerWidthConstraintPad: NSLayoutConstraint!
  var settingCornerWidthConstraint: NSLayoutConstraint!

  // Spacing views to size app screen proportionally.
  @IBOutlet var topSpace: UIView!
  @IBOutlet var logoSpace: UIView!

  @IBOutlet var installationHeaderLabel: UILabel!

  private let installationTipCardState: Bool = {
    let userDefault = UserDefaults.standard
    let state = userDefault.object(forKey: "installationTipCardState") as? Bool ?? true
    return state
  }()

  func setAppTextView() {
    if DeviceType.isPad {
      appTextView = appTextViewPad
      appTextBackground = appTextBackgroundPad
      topIcon = topIconPad
      settingsBtn = settingsBtnPad
      settingsCorner = settingsCornerPad
      settingCornerWidthConstraint = settingCornerWidthConstraintPad

      appTextViewPhone.removeFromSuperview()
      appTextBackgroundPhone.removeFromSuperview()
      topIconPhone.removeFromSuperview()
      settingsBtnPhone.removeFromSuperview()
      settingsCornerPhone.removeFromSuperview()
    } else {
      appTextView = appTextViewPhone
      appTextBackground = appTextBackgroundPhone
      topIcon = topIconPhone
      settingsBtn = settingsBtnPhone
      settingsCorner = settingsCornerPhone
      settingCornerWidthConstraint = settingCornerWidthConstraintPhone

      appTextViewPad.removeFromSuperview()
      appTextBackgroundPad.removeFromSuperview()
      topIconPad.removeFromSuperview()
      settingsBtnPad.removeFromSuperview()
      settingsCornerPad.removeFromSuperview()
    }
  }

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.setNavigationBarHidden(true, animated: false)
    edgesForExtendedLayout = .all
    extendedLayoutIncludesOpaqueBars = true

    self.tabBarController?.viewControllers?[0].title = NSLocalizedString(
      "i18n.app.installation.title", value: "Installation", comment: ""
    )
    self.tabBarController?.viewControllers?[1].title = NSLocalizedString(
      "i18n.app.settings.title", value: "Settings", comment: ""
    )
    self.tabBarController?.viewControllers?[2].title = NSLocalizedString(
      "i18n.app.about.title", value: "About", comment: ""
    )

    setCurrentUI()
    showTipCardView()
    addPopupButton()
  }

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
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
    get { return orientations }
    set { orientations = newValue }
  }

  /// Sets the top icon for the app screen given the device to assure that it's oriented correctly to its background.
  func setTopIcon() {
    if DeviceType.isPad {
      topIconPhone.isHidden = true
      topIconPad.isHidden = false
      for constraint in settingsCorner.constraints where constraint.identifier == "settingsCorner" {
          constraint.constant = 125
      }
    } else {
      topIconPhone.isHidden = false
      topIconPad.isHidden = true
      for constraint in settingsCorner.constraints where constraint.identifier == "settingsCorner" {
          constraint.constant = 70
      }
    }
  }

  /// Sets the functionality of the button over the keyboard installation guide that opens Settings.
  func setSettingsBtn() {
    settingsBtn.addTarget(self, action: #selector(openSettingsApp), for: .touchUpInside)
    settingsBtn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
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
  }

  /// Sets properties for the app screen given the current device.
  func setUIDeviceProperties() {
    // Flips coloured corner with settings icon based on orientation of text.
    settingsCorner.image = settingsCorner.image?.imageFlippedForRightToLeftLayoutDirection()
    if UIView.userInterfaceLayoutDirection(for: appTextView.semanticContentAttribute) == .rightToLeft {
      settingsCorner.layer.maskedCorners = .layerMinXMinYCorner // "top-left"
    } else {
      settingsCorner.layer.maskedCorners = .layerMaxXMinYCorner // "top-right"
    }
    settingsCorner.layer.cornerRadius = DeviceType.isPad ? appTextBackground.frame.width * 0.02 : appTextBackground.frame.width * 0.05

    settingsBtn.setTitle("", for: .normal)
    settingsBtn.clipsToBounds = true
    settingsBtn.layer.masksToBounds = false
    settingsBtn.layer.cornerRadius = DeviceType.isPad ? appTextBackground.frame.width * 0.02 : appTextBackground.frame.width * 0.05

    let allTextViews: [UITextView] = [appTextView]

    // Disable text views.
    for textView in allTextViews {
      textView.isUserInteractionEnabled = false
      textView.backgroundColor = .clear
      textView.isEditable = false
    }

    // Set backgrounds and corner radii.
    appTextBackground.isUserInteractionEnabled = true
    appTextBackground.clipsToBounds = true
    applyCornerRadius(
      elem: appTextBackground,
      radius: DeviceType.isPad ? appTextBackground.frame.width * 0.02 : appTextBackground.frame.width * 0.05
    )

    // Set link attributes for all textViews.
    for textView in allTextViews {
      textView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: linkBlueColor,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
    }
  }

  /// Sets the necessary properties for the installation UI including calling text generation functions.
  func setInstallationUI() {
    let settingsSymbol: UIImage = getSettingsSymbol(fontSize: fontSize * 0.9)
    topIconPhone.image = settingsSymbol
    topIconPad.image = settingsSymbol
    topIconPhone.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? scribeCTAColor : keyCharColor
    topIconPad.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? scribeCTAColor : keyCharColor

    // Enable installation directions and GitHub notice elements.
    settingsBtn.isUserInteractionEnabled = true
    appTextBackground.backgroundColor = lightWhiteDarkBlackColor

    // Set the texts for the fields.
    appTextView.attributedText = setInstallation(fontSize: fontSize)
    appTextView.textColor = keyCharColor
  }

  /// Creates the current app UI by applying constraints and calling child UI functions.
  func setCurrentUI() {
    // Sets the font size for the text in the app screen and corresponding UIImage icons.
    if DeviceType.isPhone {
      if UIScreen.main.bounds.width > 413 || UIScreen.main.bounds.width <= 375 {
        fontSize = UIScreen.main.bounds.height / 59
      } else if UIScreen.main.bounds.width <= 413 && UIScreen.main.bounds.width > 375 {
        fontSize = UIScreen.main.bounds.height / 50
      }

    } else if DeviceType.isPad {
      fontSize = UIScreen.main.bounds.height / 50
    }

    installationHeaderLabel.text = NSLocalizedString(
      "i18n.app.installation.keyboard.title", value: "Keyboard installation", comment: ""
    )
    installationHeaderLabel.font = UIFont.boldSystemFont(ofSize: fontSize * 1.1)

    setAppTextView()
    setTopIcon()
    setSettingsBtn()
    setUIConstantProperties()
    setUIDeviceProperties()
    setInstallationUI()
  }

  /// Function to open the settings app that is targeted by settingsBtn.
  @objc func openSettingsApp() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
      fatalError("Failed to create settings URL.")
    }
    UIApplication.shared.open(settingsURL)
  }

  /// Function to change the key coloration given a touch down.
  ///
  /// - Parameters
  ///  - sender: the button that has been pressed.
  @objc func keyTouchDown(_ sender: UIButton) {
    sender.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
    sender.alpha = 0.2
    topIcon.alpha = 0.2

    // Bring sender's opacity back up to fully opaque and replace the background color.
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
      sender.backgroundColor = .clear
      sender.alpha = 1.0
      self?.topIcon.alpha = 1.0
    }
  }
}

// MARK: TipHintView

extension InstallationVC {
  private func showTipCardView() {
    let overlayView = InstallationTipCardView(
      installationTipCardState: installationTipCardState
    )

    let hostingController = UIHostingController(rootView: overlayView)
    hostingController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 178)
    hostingController.view.backgroundColor = .clear

    if !UIDevice.hasNotch {
      startGlowingEffect(on: hostingController.view)
      addChild(hostingController)
      view.addSubview(hostingController.view)
      hostingController.view.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
      ])

    } else {
      startGlowingEffect(on: hostingController.view)
      addChild(hostingController)
      view.addSubview(hostingController.view)

    }
    hostingController.didMove(toParent: self)
  }

  func startGlowingEffect(on view: UIView, duration: TimeInterval = 1.0) {
    view.layer.shadowColor = UIColor.scribeCTA.cgColor
    view.layer.shadowRadius = 8
    view.layer.shadowOpacity = 0.0
    view.layer.shadowOffset = CGSize(width: 0, height: 0)

    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: [.curveEaseOut, .autoreverse],
      animations: {
        view.layer.shadowOpacity = 0.6
      }, completion: nil
    )
  }

  private func addPopupButton() {
          let popupButton = UIButton(type: .system)
          popupButton.setTitle("Open Popup", for: .normal)
          popupButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
          popupButton.backgroundColor = .systemBlue
          popupButton.setTitleColor(.white, for: .normal)
          popupButton.layer.cornerRadius = 10
          popupButton.translatesAutoresizingMaskIntoConstraints = false

          popupButton.addTarget(self, action: #selector(showPopup), for: .touchUpInside)
          view.addSubview(popupButton)

          NSLayoutConstraint.activate([
              popupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
              popupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              popupButton.widthAnchor.constraint(equalToConstant: 150),
              popupButton.heightAnchor.constraint(equalToConstant: 44)
          ])
      }

      @objc private func showPopup() {
        var sourceLanguage = "English"
        var destLanguage = "German"
        var infoText = "The data you will download will allow you to translate from  \(sourceLanguage) to \(destLanguage). Do you want to change the language you'll translate  from?"
        var changeText = "Change language"
        var confirmText = "Use \(sourceLanguage)"

        let popupView = ConfirmTranslationSource(
          infoText: infoText,
          changeButtonText: changeText,
          confirmButtonText: confirmText,
          onDismiss: {self.dismiss(animated: true)},
          onChange: {
                self.dismiss(animated: true) {
                    if let translationLangController = self.storyboard?.instantiateViewController(
                    identifier: "SelectionViewTemplateViewController"
                    ) as? SelectionViewTemplateViewController {

                    var data = SettingsTableData.translateLangSettingsData
                    let langCode = "de"

                    // Remove the current keyboard language from translation.
                    let langCodeIndex = SettingsTableData.translateLangSettingsData[0].section.firstIndex(where: { s in
                        s.sectionState == .specificLang(langCode)
                    }) ?? -1
                    if langCodeIndex >= 0 {
                        data[0].section.remove(at: langCodeIndex)
                    }

                    let sectionTitle = getKeyInDict(givenValue: langCode, dict: languagesAbbrDict)

                    let parentSection = Section(
                              sectionTitle: sectionTitle,
                              imageString: nil,
                              hasToggle: false,
                              hasNestedNavigation: true,
                              sectionState: .translateLang,
                              shortDescription: nil,
                              externalLink: false
                            )

                    translationLangController.configureTable(
                        for: data,
                        parentSection: parentSection,
                        langCode: langCode
                    )

                    translationLangController.edgesForExtendedLayout = .all

                    // COPY the navigation bar appearance from Settings tab.
                    if let settingsNavController = self.tabBarController?.viewControllers?[1] as? UINavigationController {
                        // Copy all the styling from Settings' nav controller.
                        self.navigationController?.navigationBar.standardAppearance = settingsNavController.navigationBar.standardAppearance
                        self.navigationController?.navigationBar.scrollEdgeAppearance = settingsNavController.navigationBar.scrollEdgeAppearance
                        self.navigationController?.navigationBar.tintColor = settingsNavController.navigationBar.tintColor
                        self.navigationController?.navigationBar.barTintColor = settingsNavController.navigationBar.barTintColor
                        }

                    self.navigationController?.setNavigationBarHidden(false, animated: false)
                    self.navigationController?.pushViewController(translationLangController, animated: true)
                    }
                }
            },
          onConfirm: {self.dismiss(animated: true)},

        )
          let hostingController = UIHostingController(rootView: popupView)
          hostingController.modalPresentationStyle = .overFullScreen
          hostingController.modalTransitionStyle = .crossDissolve
          hostingController.view.backgroundColor = .clear

          present(hostingController, animated: true)
      }
}
