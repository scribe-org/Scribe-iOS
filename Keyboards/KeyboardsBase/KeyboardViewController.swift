//
//  KeyboardViewController.swift
//
//  Classes for the parent keyboard view controller that language keyboards inherit and keyboard keys.
//

import UIKit

/// The parent KeyboardViewController class that is inherited by all Scribe keyboards.
class KeyboardViewController: UIInputViewController {
  var keyboardView: UIView!

  // Stack views that are populated with they keyboard rows.
  @IBOutlet weak var stackView0: UIStackView!
  @IBOutlet weak var stackView1: UIStackView!
  @IBOutlet weak var stackView2: UIStackView!
  @IBOutlet weak var stackView3: UIStackView!

  /// Changes the keyboard state such that the letters view will be shown.
  func changeKeyboardToLetterKeys() {
    keyboardState = .letters
    loadKeys()
  }

  /// Changes the keyboard state such that the numbers view will be shown.
  func changeKeyboardToNumberKeys() {
    keyboardState = .numbers
    shiftButtonState = .normal
    loadKeys()
  }

  /// Changes the keyboard state such that the symbols view will be shown.
  func changeKeyboardToSymbolKeys() {
    keyboardState = .symbols
    loadKeys()
  }

  // MARK: Display Activation Functions

  /// Function to load the keyboard interface into which keyboardView is instantiated.
  func loadInterface() {
    let keyboardNib = UINib(nibName: "Keyboard", bundle: nil)
    keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as? UIView
    keyboardView.translatesAutoresizingMaskIntoConstraints = true
    view.addSubview(keyboardView)

    // Override keyboards switching to others for translation and prior Scribe commands.
    switchInput = false
    scribeBtnState = false
    previewState = false

    // Set height for Scribe command functionality.
    annotationHeight = nounAnnotation1.frame.size.height

    loadKeys()
  }

  /// Activates a button by assigning key touch functions for their given actions.
  ///
  /// - Parameters
  ///   - btn: the button to be activated.
  func activateBtn(btn: UIButton) {
    btn.addTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
    btn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
    btn.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
    btn.isUserInteractionEnabled = true
  }

  /// Deactivates a button by removing key touch functions for their given actions and making it clear.
  ///
  /// - Parameters
  ///   - btn: the button to be deactivated.
  func deactivateBtn(btn: UIButton) {
    btn.setTitle("", for: .normal)
    btn.backgroundColor = UIColor.clear
    btn.removeTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
    btn.removeTarget(self, action: #selector(keyTouchDown), for: .touchDown)
    btn.removeTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
    btn.isUserInteractionEnabled = false
  }

  /// Sets a button's values that are displayed and inserted into the proxy as well as assigning a color.
  ///
  /// - Parameters
  ///   - btn: the button to be set up.
  ///   - color: the color to assign to the background.
  ///   - name: the name of the value for the key.
  ///   - canCapitalize: whether the key receives a special character for the shift state.
  ///   - isSpecial: whether the btn should be marked as special to be colored accordingly.
  func setBtn(btn: UIButton, color: UIColor, name: String, canCapitalize: Bool, isSpecial: Bool) {
    btn.backgroundColor = color
    btn.layer.setValue(name, forKey: "original")

    let charsWithoutShiftState = ["ß"]

    var capsKey = ""
    if canCapitalize == true {
      if !charsWithoutShiftState.contains(name) {
        capsKey = name.capitalized
      } else {
        capsKey = name
      }
      let shiftChar = shiftButtonState == .normal ? name : capsKey
      btn.layer.setValue(shiftChar, forKey: "keyToDisplay")
    } else {
      btn.layer.setValue(name, forKey: "keyToDisplay")
    }
    btn.layer.setValue(isSpecial, forKey: "isSpecial")

    activateBtn(btn: btn)
  }

  // MARK: Override UIInputViewController Functions

  /// Includes adding custom view sizing constraints.
  override func updateViewConstraints() {
    super.updateViewConstraints()

    checkLandscapeMode()
    if DeviceType.isPhone {
      if isLandscapeView == true {
        keyboardHeight = 200
      } else {
        keyboardHeight = 270
      }
    } else if DeviceType.isPad {
      if isLandscapeView == true {
        keyboardHeight = 320
      } else {
        keyboardHeight = 340
      }
    }

    let heightConstraint = NSLayoutConstraint(
      item: view!,
      attribute: NSLayoutConstraint.Attribute.height,
      relatedBy: NSLayoutConstraint.Relation.equal,
      toItem: nil,
      attribute: NSLayoutConstraint.Attribute.notAnAttribute,
      multiplier: 1.0,
      constant: keyboardHeight
    )
    view.addConstraint(heightConstraint)

    keyboardView.frame.size = view.frame.size
  }

  // Button to be asigned as the select keyboard button if necessary.
  @IBOutlet var selectKeyboardButton: UIButton!

  /// Includes the following:
  /// - Assignment of the proxy
  /// - Loading the Scribe interface
  /// - Making keys letters
  /// - Adding the keyboard selector target
  override func viewDidLoad() {
    super.viewDidLoad()

    checkDarkModeSetColors()
    proxy = textDocumentProxy as UITextDocumentProxy
    keyboardState = .letters
    loadInterface()

    self.selectKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
  }

  /// Includes hiding the keyboard selector button if it is not needed for the current device.
  override func viewWillLayoutSubviews() {
    self.selectKeyboardButton.isHidden = !self.needsInputModeSwitchKey
    super.viewWillLayoutSubviews()
  }

  /// Includes updateViewConstraints to change the keyboard height given device type and orientation.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateViewConstraints()
  }

  /// Includes:
  /// - updateViewConstraints to change the keyboard height
  /// - A call to loadKeys to reload the display after an orientation change
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    updateViewConstraints()
    loadKeys()
  }

  /// Overrides the previous color variables if the user switches between light and dark mode.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    checkDarkModeSetColors()
    loadKeys()
  }

  // MARK: Scribe Command Elements

  // The bar that displays language logic or is typed into for Scribe commands.
  @IBOutlet var previewBar: UILabel!
  @IBOutlet var previewBarShadow: UIButton!
  @IBOutlet var previewBarBlend: UILabel!

  /// Sets up the preview bar's color and text alignment.
  func setPreviewBar() {
    previewBar.backgroundColor = previewBarColor
    previewBarBlend.backgroundColor = previewBarColor
    previewBar.layer.borderColor = previewBarBorderColor
    previewBar.layer.borderWidth = 1.0
    previewBar.textAlignment = NSTextAlignment.left
    if DeviceType.isPhone {
      previewBar.font = .systemFont(ofSize: annotationHeight * 0.7)
    } else if DeviceType.isPad {
      previewBar.font = .systemFont(ofSize: annotationHeight * 0.85)
    }
    previewBarShadow.isUserInteractionEnabled = false

    if DeviceType.isPhone {
      previewPromptSpacing = String(repeating: " ", count: 2)
    } else if DeviceType.isPad {
      previewPromptSpacing = String(repeating: " ", count: 5)
    }
  }

  /// Deletes in the proxy or preview bar given the current constraints.
  func handleDeleteButtonPressed() {
    if previewState != true {
      proxy.deleteBackward()
    } else if !(previewState == true && allPrompts.contains(previewBar.text!)) {
      guard
        let inputText = previewBar.text,
        !inputText.isEmpty
      else {
        return
      }
      previewBar.text = previewBar.text!.deletePriorToCursor()
    } else {
      backspaceTimer?.invalidate()
      backspaceTimer = nil
    }
  }

  // The background for the Scribe command elements.
  @IBOutlet var commandBackground: UILabel!
  func setCommandBackground() {
    commandBackground.backgroundColor = keyboardBackColor
    commandBackground.isUserInteractionEnabled = false
  }

  // The button used to display Scribe commands and its shadow.
  @IBOutlet var scribeBtn: UIButton!
  @IBOutlet var scribeBtnShadow: UIButton!

  /// Assigns the icon and sets up the Scribe button.
  func setScribeBtn() {
    scribeBtn.setImage(scribeKeyIcon, for: .normal)
    setBtn(btn: scribeBtn, color: commandKeyColor, name: "Scribe", canCapitalize: false, isSpecial: false)
    scribeBtn.layer.borderColor = previewBarBorderColor
    scribeBtn.layer.borderWidth = 1.0
    scribeBtn.contentMode = .center
    scribeBtn.imageView?.contentMode = .scaleAspectFit
    scribeBtnShadow.isUserInteractionEnabled = false
  }

  /// Changes the Scribe key to an escape key.
  func scribeBtnToEscape() {
    scribeBtn.setTitle("", for: .normal)
    var selectKeyboardIconConfig = UIImage.SymbolConfiguration(
      pointSize: annotationHeight * 0.75,
      weight: .light,
      scale: .medium
    )
    if DeviceType.isPad {
      selectKeyboardIconConfig = UIImage.SymbolConfiguration(
        pointSize: annotationHeight * 1.1,
        weight: .light,
        scale: .medium
      )
    }
    scribeBtn.setImage(UIImage(systemName: "xmark", withConfiguration: selectKeyboardIconConfig), for: .normal)
    scribeBtn.tintColor = keyCharColor
  }

  // Buttons used to trigger Scribe command functionality.
  @IBOutlet var translateBtn: UIButton!
  @IBOutlet var conjugateBtn: UIButton!
  @IBOutlet var pluralBtn: UIButton!

  /// Sets up all buttons that are associated with Scribe commands.
  func setCommandBtns() {
    setBtn(btn: translateBtn, color: commandKeyColor, name: "Translate", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtn, color: commandKeyColor, name: "Conjugate", canCapitalize: false, isSpecial: false)
    setBtn(btn: pluralBtn, color: commandKeyColor, name: "Plural", canCapitalize: false, isSpecial: false)
  }

  // Buttons for the conjugation view.
  @IBOutlet var conjugateBtnFPS: UIButton!
  @IBOutlet var conjugateBtnSPS: UIButton!
  @IBOutlet var conjugateBtnTPS: UIButton!
  @IBOutlet var conjugateBtnFPP: UIButton!
  @IBOutlet var conjugateBtnSPP: UIButton!
  @IBOutlet var conjugateBtnTPP: UIButton!

  @IBOutlet var conjugateShiftLeftBtn: UIButton!
  @IBOutlet var conjugateShiftRightBtn: UIButton!

  @IBOutlet var conjugateBtnTL: UIButton!
  @IBOutlet var conjugateBtnTR: UIButton!
  @IBOutlet var conjugateBtnBL: UIButton!
  @IBOutlet var conjugateBtnBR: UIButton!

  // Labels for the conjugation view buttons.
  // Note that we're using buttons as labels weren't allowing for certain constraints to be set.
  @IBOutlet var conjugateLblFPS: UIButton!
  @IBOutlet var conjugateLblSPS: UIButton!
  @IBOutlet var conjugateLblTPS: UIButton!
  @IBOutlet var conjugateLblFPP: UIButton!
  @IBOutlet var conjugateLblSPP: UIButton!
  @IBOutlet var conjugateLblTPP: UIButton!

  @IBOutlet var conjugateLblTL: UIButton!
  @IBOutlet var conjugateLblTR: UIButton!
  @IBOutlet var conjugateLblBL: UIButton!
  @IBOutlet var conjugateLblBR: UIButton!

  /// Sets up all buttons that are associated with the conjugation display.
  func setConjugationBtns() {
    // Set the conjugation view to 2x2 for Swedish and Russian past tense.
    if controllerLanguage == "Swedish" {
      conjugateAlternateView = true
    } else if controllerLanguage == "Russian" && ruConjugationState == .past {
      conjugateAlternateView = true
    } else {
      conjugateAlternateView = false
    }

    setBtn(btn: conjugateBtnFPS, color: keyColor, name: "firstPersonSingular", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnSPS, color: keyColor, name: "secondPersonSingular", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnTPS, color: keyColor, name: "thirdPersonSingular", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnFPP, color: keyColor, name: "firstPersonPlural", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnSPP, color: keyColor, name: "secondPersonPlural", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnTPP, color: keyColor, name: "thirdPersonPlural", canCapitalize: false, isSpecial: false)

    setBtn(
      btn: conjugateShiftLeftBtn,
      color: keyColor,
      name: "shiftConjugateLeft",
      canCapitalize: false,
      isSpecial: false
    )
    setBtn(
      btn: conjugateShiftRightBtn,
      color: keyColor,
      name: "shiftConjugateRight",
      canCapitalize: false,
      isSpecial: false
    )

    setBtn(btn: conjugateBtnTL, color: keyColor, name: "conjugateTopLeft", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnTR, color: keyColor, name: "conjugateTopRight", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnBL, color: keyColor, name: "conjugateBottomLeft", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnBR, color: keyColor, name: "conjugateBottomRight", canCapitalize: false, isSpecial: false)

    let conjugationLbls = [
      conjugateLblFPS, conjugateLblSPS, conjugateLblTPS, conjugateLblFPP, conjugateLblSPP, conjugateLblTPP,
      conjugateLblTL, conjugateLblBL, conjugateLblTR, conjugateLblBR
    ]

    for lbl in conjugationLbls {
      lbl!.backgroundColor = UIColor.clear
      lbl!.setTitleColor(specialKeyColor, for: .normal)
      lbl!.removeTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
      lbl!.removeTarget(self, action: #selector(keyTouchDown), for: .touchDown)
      lbl!.removeTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
      lbl!.isUserInteractionEnabled = false
    }
    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      conjugateBtnFPS.titleLabel?.font =  .systemFont(ofSize: letterButtonWidth / conjugationFontDivisor)
      conjugateBtnSPS.titleLabel?.font =  .systemFont(ofSize: letterButtonWidth / conjugationFontDivisor)
      conjugateBtnTPS.titleLabel?.font =  .systemFont(ofSize: letterButtonWidth / conjugationFontDivisor)
      conjugateBtnFPP.titleLabel?.font =  .systemFont(ofSize: letterButtonWidth / conjugationFontDivisor)
      conjugateBtnSPP.titleLabel?.font =  .systemFont(ofSize: letterButtonWidth / conjugationFontDivisor)
      conjugateBtnTPP.titleLabel?.font =  .systemFont(ofSize: letterButtonWidth / conjugationFontDivisor)

      conjugateBtnTL.titleLabel?.font =  .systemFont(ofSize: letterButtonWidth / conjugationFontDivisor)
      conjugateBtnBL.titleLabel?.font =  .systemFont(ofSize: letterButtonWidth / conjugationFontDivisor)
      conjugateBtnTR.titleLabel?.font =  .systemFont(ofSize: letterButtonWidth / conjugationFontDivisor)
      conjugateBtnBR.titleLabel?.font =  .systemFont(ofSize: letterButtonWidth / conjugationFontDivisor)

      for lbl in conjugationLbls {
        lbl!.titleLabel?.font =  .systemFont(ofSize: letterButtonWidth / 4)
      }
    }
  }

  /// Activates all buttons that are associated with the conjugation display.
  func activateConjugationDisplay() {
    let conjugateViewElements: [UIButton] = [
      conjugateBtnFPS, conjugateBtnSPS, conjugateBtnTPS, conjugateBtnFPP, conjugateBtnSPP, conjugateBtnTPP,
      conjugateLblFPS, conjugateLblSPS, conjugateLblTPS, conjugateLblFPP, conjugateLblSPP, conjugateLblTPP
    ]
    let conjugateViewElementsAlt: [UIButton] = [
      conjugateBtnTL, conjugateBtnBL, conjugateBtnTR, conjugateBtnBR,
      conjugateLblTL, conjugateLblBL, conjugateLblTR, conjugateLblBR
    ]

    if conjugateAlternateView == false {
      for elem in conjugateViewElements {
        activateBtn(btn: elem)
      }

      for elem in conjugateViewElementsAlt {
        deactivateBtn(btn: elem)
      }
    }

    activateBtn(btn: conjugateShiftLeftBtn)
    activateBtn(btn: conjugateShiftRightBtn)

    if conjugateAlternateView == true {
      for elem in conjugateViewElements {
        deactivateBtn(btn: elem)
      }

      for elem in conjugateViewElementsAlt {
        activateBtn(btn: elem)
      }
    }
  }

  /// Deactivates all buttons that are associated with the conjugation display.
  func deactivateConjugationDisplay() {
    deactivateBtn(btn: conjugateBtnFPS)
    deactivateBtn(btn: conjugateBtnSPS)
    deactivateBtn(btn: conjugateBtnTPS)
    deactivateBtn(btn: conjugateBtnFPP)
    deactivateBtn(btn: conjugateBtnSPP)
    deactivateBtn(btn: conjugateBtnTPP)

    deactivateBtn(btn: conjugateLblFPS)
    deactivateBtn(btn: conjugateLblSPS)
    deactivateBtn(btn: conjugateLblTPS)
    deactivateBtn(btn: conjugateLblFPP)
    deactivateBtn(btn: conjugateLblSPP)
    deactivateBtn(btn: conjugateLblTPP)

    deactivateBtn(btn: conjugateShiftLeftBtn)
    conjugateShiftLeftBtn.tintColor = UIColor.clear
    deactivateBtn(btn: conjugateShiftRightBtn)
    conjugateShiftRightBtn.tintColor = UIColor.clear

    deactivateBtn(btn: conjugateBtnTL)
    deactivateBtn(btn: conjugateBtnBL)
    deactivateBtn(btn: conjugateBtnTR)
    deactivateBtn(btn: conjugateBtnBR)

    let conjugationLbls: [UIButton] = [
      conjugateLblFPS, conjugateLblSPS, conjugateLblTPS, conjugateLblFPP, conjugateLblSPP, conjugateLblTPP,
      conjugateLblTL, conjugateLblBL, conjugateLblTR, conjugateLblBR
    ]

    for lbl in conjugationLbls {
      lbl.setTitle("", for: .normal)
    }
  }

  /// Sets the label of the conjugation state and assigns the current tenses that are accessed to label the buttons.
  func setConjugationState() {
    if controllerLanguage == "French" {
      previewBar.text = frGetConjugationTitle()
      frSetConjugationLabels()

      tenseFPS = frGetConjugationState() + "FPS"
      tenseSPS = frGetConjugationState() + "SPS"
      tenseTPS = frGetConjugationState() + "TPS"
      tenseFPP = frGetConjugationState() + "FPP"
      tenseSPP = frGetConjugationState() + "SPP"
      tenseTPP = frGetConjugationState() + "TPP"

    } else if controllerLanguage == "German" {
      previewBar.text = deGetConjugationTitle()
      deSetConjugationLabels()

      tenseFPS = deGetConjugationState() + "FPS"
      tenseSPS = deGetConjugationState() + "SPS"
      tenseTPS = deGetConjugationState() + "TPS"
      tenseFPP = deGetConjugationState() + "FPP"
      tenseSPP = deGetConjugationState() + "SPP"
      tenseTPP = deGetConjugationState() + "TPP"

    } else if controllerLanguage == "Portuguese" {
      previewBar.text = ptGetConjugationTitle()
      ptSetConjugationLabels()

      tenseFPS = ptGetConjugationState() + "FPS"
      tenseSPS = ptGetConjugationState() + "SPS"
      tenseTPS = ptGetConjugationState() + "TPS"
      tenseFPP = ptGetConjugationState() + "FPP"
      tenseSPP = ptGetConjugationState() + "SPP"
      tenseTPP = ptGetConjugationState() + "TPP"

    } else if controllerLanguage == "Russian" {
      previewBar.text = ruGetConjugationTitle()
      ruSetConjugationLabels()

      if conjugateAlternateView == false {
        tenseFPS = ruGetConjugationState() + "FPS"
        tenseSPS = ruGetConjugationState() + "SPS"
        tenseTPS = ruGetConjugationState() + "TPS"
        tenseFPP = ruGetConjugationState() + "FPP"
        tenseSPP = ruGetConjugationState() + "SPP"
        tenseTPP = ruGetConjugationState() + "TPP"
      } else {
        tenseTopLeft = "pastMasculine"
        tenseTopRight = "pastFeminine"
        tenseBottomLeft = "pastNeutral"
        tenseBottomRight = "pastPlural"
      }

    } else if controllerLanguage == "Spanish" {
      previewBar.text = esGetConjugationTitle()
      esSetConjugationLabels()

      tenseFPS = esGetConjugationState() + "FPS"
      tenseSPS = esGetConjugationState() + "SPS"
      tenseTPS = esGetConjugationState() + "TPS"
      tenseFPP = esGetConjugationState() + "FPP"
      tenseSPP = esGetConjugationState() + "SPP"
      tenseTPP = esGetConjugationState() + "TPP"

    } else if controllerLanguage == "Swedish" {
      previewBar.text = svGetConjugationTitle()
      svSetConjugationLabels()
      let swedishTenses = svGetConjugationState()

      tenseTopLeft = swedishTenses[0]
      tenseTopRight = swedishTenses[1]
      tenseBottomLeft = swedishTenses[2]
      tenseBottomRight = swedishTenses[3]
    }

    // Assign labels that have been set by SetConjugationLabels functions.
    conjugateLblFPS.setTitle("  " + labelFPS, for: .normal)
    conjugateLblSPS.setTitle("  " + labelSPS, for: .normal)
    conjugateLblTPS.setTitle("  " + labelTPS, for: .normal)
    conjugateLblFPP.setTitle("  " + labelFPP, for: .normal)
    conjugateLblSPP.setTitle("  " + labelSPP, for: .normal)
    conjugateLblTPP.setTitle("  " + labelTPP, for: .normal)

    conjugateLblFPS.isUserInteractionEnabled = false
    conjugateLblSPS.isUserInteractionEnabled = false
    conjugateLblTPS.isUserInteractionEnabled = false
    conjugateLblFPP.isUserInteractionEnabled = false
    conjugateLblSPP.isUserInteractionEnabled = false
    conjugateLblTPP.isUserInteractionEnabled = false

    conjugateLblTL.setTitle("  " + labelTopLeft, for: .normal)
    conjugateLblTR.setTitle("  " + labelTopRight, for: .normal)
    conjugateLblBL.setTitle("  " + labelBottomLeft, for: .normal)
    conjugateLblBR.setTitle("  " + labelBottomRight, for: .normal)

    conjugateLblTL.isUserInteractionEnabled = false
    conjugateLblTR.isUserInteractionEnabled = false
    conjugateLblBL.isUserInteractionEnabled = false
    conjugateLblBR.isUserInteractionEnabled = false

    if conjugateAlternateView == true {
      allTenses = [tenseTopLeft, tenseTopRight, tenseBottomLeft, tenseBottomRight]
      allConjugationBtns = [conjugateBtnTL, conjugateBtnTR, conjugateBtnBL, conjugateBtnBR]
    } else {
      allTenses = [tenseFPS, tenseSPS, tenseTPS, tenseFPP, tenseSPP, tenseTPP]
      allConjugationBtns = [
        conjugateBtnFPS, conjugateBtnSPS, conjugateBtnTPS, conjugateBtnFPP, conjugateBtnSPP, conjugateBtnTPP
      ]
    }

    // Populate conjugation view buttons.
    for index in 0..<allTenses.count {
      if verbs?[verbToConjugate]![allTenses[index]] as? String == "" {
        // Assign the invalid message if the conjugation isn't present in the directory.
        styleBtn(btn: allConjugationBtns[index], title: invalidCommandMsg, radius: keyCornerRadius)
      } else {
        conjugationToDisplay = verbs?[verbToConjugate]![allTenses[index]] as! String
        if inputWordIsCapitalized && deConjugationState != .indicativePerfect {
          conjugationToDisplay = conjugationToDisplay.capitalized
        }
        styleBtn(btn: allConjugationBtns[index], title: conjugationToDisplay, radius: keyCornerRadius)
      }
    }
  }

  // Labels to annotate noun genders.
  @IBOutlet var nounAnnotation1: UILabel!
  @IBOutlet var nounAnnotation2: UILabel!
  @IBOutlet var nounAnnotation3: UILabel!
  @IBOutlet var nounAnnotation4: UILabel!
  @IBOutlet var nounAnnotation5: UILabel!

  // Labels to annotate preposition cases.
  // There are multiple versions to account for when a word is both a noun and a preposition.
  // In this case a shifted set is used - the noun annotations precede those of prepositions.
  @IBOutlet var prepAnnotation11: UILabel!
  @IBOutlet var prepAnnotation12: UILabel!
  @IBOutlet var prepAnnotation13: UILabel!
  @IBOutlet var prepAnnotation14: UILabel!
  @IBOutlet var prepAnnotation21: UILabel!
  @IBOutlet var prepAnnotation22: UILabel!
  @IBOutlet var prepAnnotation23: UILabel!
  @IBOutlet var prepAnnotation24: UILabel!
  @IBOutlet var prepAnnotation31: UILabel!
  @IBOutlet var prepAnnotation32: UILabel!
  @IBOutlet var prepAnnotation33: UILabel!
  @IBOutlet var prepAnnotation34: UILabel!

  /// Styles the labels within the annotation display and removes user interactions.
  func styleAnnotations() {
    let nounAnnotationDisplay = [nounAnnotation1, nounAnnotation2, nounAnnotation3, nounAnnotation4, nounAnnotation5]

    let prepAnnotationDisplay = [
      prepAnnotation11, prepAnnotation12, prepAnnotation13, prepAnnotation14,
      prepAnnotation21, prepAnnotation22, prepAnnotation23, prepAnnotation24,
      prepAnnotation31, prepAnnotation32, prepAnnotation33, prepAnnotation34
    ]

    for annotationDisplay in nounAnnotationDisplay {
      annotationDisplay?.clipsToBounds = true
      annotationDisplay?.layer.cornerRadius = keyCornerRadius / 2
      annotationDisplay?.textAlignment = NSTextAlignment.center
      annotationDisplay?.isUserInteractionEnabled = false
      annotationDisplay?.font = .systemFont(ofSize: annotationHeight * 0.70)
      annotationDisplay?.textColor = previewBarColor
    }

    for annotationDisplay in prepAnnotationDisplay {
      annotationDisplay?.clipsToBounds = true
      annotationDisplay?.layer.cornerRadius = keyCornerRadius / 2
      annotationDisplay?.textAlignment = NSTextAlignment.center
      annotationDisplay?.isUserInteractionEnabled = false
      annotationDisplay?.font = .systemFont(ofSize: annotationHeight * 0.65)
      annotationDisplay?.textColor = previewBarColor
    }
  }

  /// Hides the annotation display so that it can be selectively shown to the user as needed.
  func hideAnnotations() {
    let nounAnnotationDisplay = [nounAnnotation1, nounAnnotation2, nounAnnotation3, nounAnnotation4, nounAnnotation5]

    let prepAnnotationDisplay = [
      prepAnnotation11, prepAnnotation12, prepAnnotation13, prepAnnotation14,
      prepAnnotation21, prepAnnotation22, prepAnnotation23, prepAnnotation24,
      prepAnnotation31, prepAnnotation32, prepAnnotation33, prepAnnotation34
    ]

    let annotationDisplay = nounAnnotationDisplay + prepAnnotationDisplay

    for idx in 0..<annotationDisplay.count {
      annotationDisplay[idx]?.backgroundColor = UIColor.clear
      annotationDisplay[idx]?.text = ""
    }
  }

  // MARK: Load keys

  /// Loads the keys given the current constraints.
  func loadKeys() {
    // The name of the language keyboard that's referencing KeyboardViewController.
    controllerLanguage = classForCoder.description().components(separatedBy: ".KeyboardViewController")[0]

    setCommandBackground()
    setKeyboardLayouts()
    setScribeBtn()
    setPreviewBar()
    setCommandBtns()
    setConjugationBtns()
    invalidState = false

    // Clear interface from the last state.
    keyboardKeys.forEach {$0.removeFromSuperview()}
    paddingViews.forEach {$0.removeFromSuperview()}

    // Start new keyboard.
    var keyboard: [[String]]

    keyboardView.backgroundColor? = keyboardBackColor

    // buttonWidth determined per keyboard by the top row.
    if isLandscapeView == true {
      if DeviceType.isPhone {
        letterButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(letterKeys[0].count) * 1.5
        numSymButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(numberKeys[0].count) * 1.5
      } else if DeviceType.isPad {
        letterButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(letterKeys[0].count) * 1.2
        numSymButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(numberKeys[0].count) * 1.2
      }
    } else {
      letterButtonWidth = (UIScreen.main.bounds.width - 6) / CGFloat(letterKeys[0].count) * 0.9
      numSymButtonWidth = (UIScreen.main.bounds.width - 6) / CGFloat(numberKeys[0].count) * 0.9
    }

    // Derive keyboard given current states.
    switch keyboardState {
    case .letters:
      keyboard = letterKeys
      buttonWidth = letterButtonWidth
      // Auto-capitalization if the cursor is at the start of the proxy.
      if proxy.documentContextBeforeInput?.count == 0 {
        shiftButtonState = .shift
      }
    case .numbers:
      keyboard = numberKeys
      buttonWidth = numSymButtonWidth
    case .symbols:
      keyboard = symbolKeys
      buttonWidth = numSymButtonWidth
    }

    if DeviceType.isPhone {
      if isLandscapeView == true {
        keyCornerRadius = buttonWidth / 9
        commandKeyCornerRadius = buttonWidth / 5
      } else {
        keyCornerRadius = buttonWidth / 6
        commandKeyCornerRadius = buttonWidth / 3
      }
    } else if DeviceType.isPad {
      if isLandscapeView == true {
        keyCornerRadius = buttonWidth / 12
        commandKeyCornerRadius = buttonWidth / 7.5
      } else {
        keyCornerRadius = buttonWidth / 9
        commandKeyCornerRadius = buttonWidth / 5
      }
    }

    styleAnnotations()
    if annotationState == false {
      hideAnnotations()
    }

    if !conjugateView { // normal keyboard view
      for view in [stackView0, stackView1, stackView2, stackView3] {
        view?.isUserInteractionEnabled = true
        view?.isLayoutMarginsRelativeArrangement = true

        if view == stackView0 {
          view?.layoutMargins = UIEdgeInsets(top: 3, left: 0, bottom: 8, right: 0)
        } else if view == stackView1 {
          view?.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 6, right: 0)
        } else if view == stackView2 {
          view?.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 6, right: 0)
        } else if view == stackView3 {
          view?.layoutMargins = UIEdgeInsets(top: 6, left: 0, bottom: 5, right: 0)
        }
      }

      deactivateConjugationDisplay()

      let numRows = keyboard.count
      for row in 0...numRows - 1 {
        for idx in 0...keyboard[row].count - 1 {
          // Set up button as a key with its values and properties.
          let btn = KeyboardKey(type: .custom)
          btn.backgroundColor = keyColor
          btn.layer.borderColor = keyboardView.backgroundColor?.cgColor
          btn.layer.borderWidth = 0
          btn.layer.cornerRadius = keyCornerRadius

          btn.layer.shadowColor = keyShadowColor
          btn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
          btn.layer.shadowOpacity = 1.0
          btn.layer.shadowRadius = 0.0
          btn.layer.masksToBounds = false

          var key = keyboard[row][idx]
          if key == "space" {
            key = spaceBar
          }
          var capsKey = ""
          if key != "ß" && key != spaceBar {
            capsKey = keyboard[row][idx].capitalized
          } else {
            capsKey = key
          }
          let keyToDisplay = shiftButtonState == .normal ? key : capsKey
          btn.setTitleColor(keyCharColor, for: .normal)
          btn.layer.setValue(key, forKey: "original")
          btn.layer.setValue(keyToDisplay, forKey: "keyToDisplay")
          btn.layer.setValue(false, forKey: "isSpecial")
          btn.setTitle(keyToDisplay, for: .normal) // set button character

          // Set key character sizes.
          if DeviceType.isPhone {
            if isLandscapeView == true {
              if key == "#+=" || key == "ABC" || key == "АБВ" || key == "123" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.5)
              } else if key == spaceBar {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 4)
              } else {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3)
              }
            } else {
              if key == "#+=" || key == "ABC" || key == "АБВ" || key == "123" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.75)
              } else if key == spaceBar {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 2)
              } else {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.5)
              }
            }
          } else if DeviceType.isPad {
            if isLandscapeView == true {
              if key == "#+=" || key == "ABC" || key == "АБВ" || key == "hideKeyboard" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.75)
              } else if key == spaceBar {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 4.25)
              } else if key == ".?123" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 4.5)
              } else {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.75)
              }
            } else {
              if key == "#+=" || key == "ABC" || key == "АБВ" || key == "hideKeyboard" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.25)
              } else if key == spaceBar {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.5)
              } else if key == ".?123" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 4)
              } else {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3)
              }
            }
          }

          // Set up and activate Scribe command buttons.
          styleBtn(btn: scribeBtn, title: "Scribe", radius: commandKeyCornerRadius)
          scribeBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
          scribeBtn.layer.masksToBounds = true

          scribeBtnShadow.backgroundColor = specialKeyColor
          scribeBtnShadow.layer.cornerRadius = commandKeyCornerRadius
          scribeBtnShadow.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
          scribeBtnShadow.clipsToBounds = true
          scribeBtnShadow.layer.masksToBounds = false
          scribeBtnShadow.layer.shadowRadius = 0
          scribeBtnShadow.layer.shadowOpacity = 1.0
          scribeBtnShadow.layer.shadowOffset = CGSize(width: 0, height: 1)
          scribeBtnShadow.layer.shadowColor = keyShadowColor

          if scribeBtnState {
            scribeBtnToEscape()
            scribeBtn.layer.borderColor = UIColor.clear.cgColor
            scribeBtn.layer.cornerRadius = commandKeyCornerRadius
            scribeBtn.layer.maskedCorners = [
              .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner
            ]

            scribeBtnShadow.backgroundColor = specialKeyColor
            scribeBtnShadow.layer.cornerRadius = commandKeyCornerRadius
            scribeBtnShadow.layer.maskedCorners = [
              .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner
            ]
            scribeBtnShadow.clipsToBounds = true
            scribeBtnShadow.layer.masksToBounds = false
            scribeBtnShadow.layer.shadowRadius = 0
            scribeBtnShadow.layer.shadowOpacity = 1.0
            scribeBtnShadow.layer.shadowOffset = CGSize(width: 0, height: 1)
            scribeBtnShadow.layer.shadowColor = keyShadowColor

            previewBar.backgroundColor = UIColor.clear
            previewBar.layer.borderColor = UIColor.clear.cgColor
            previewBarBlend.backgroundColor = UIColor.clear
            previewBar.text = ""
            previewBarShadow.backgroundColor = UIColor.clear

            styleBtn(btn: translateBtn, title: translateBtnLbl, radius: commandKeyCornerRadius)
            styleBtn(btn: conjugateBtn, title: conjugateBtnLbl, radius: commandKeyCornerRadius)
            styleBtn(btn: pluralBtn, title: pluralBtnLbl, radius: commandKeyCornerRadius)

            if DeviceType.isPhone {
              translateBtn.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.65)
              conjugateBtn.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.65)
              pluralBtn.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.65)
            } else if DeviceType.isPad {
              translateBtn.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.9)
              conjugateBtn.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.9)
              pluralBtn.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.9)
            }

          } else {
            if previewState == true {
              scribeBtnToEscape()
            }
            scribeBtn.setTitle("", for: .normal)
            deactivateBtn(btn: conjugateBtn)
            deactivateBtn(btn: translateBtn)
            deactivateBtn(btn: pluralBtn)

            previewBar.clipsToBounds = true
            previewBar.layer.cornerRadius = commandKeyCornerRadius
            previewBar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]

            previewBarShadow.backgroundColor = specialKeyColor
            previewBarShadow.layer.cornerRadius = commandKeyCornerRadius
            previewBarShadow.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            previewBarShadow.clipsToBounds = true
            previewBarShadow.layer.masksToBounds = false
            previewBarShadow.layer.shadowRadius = 0
            previewBarShadow.layer.shadowOpacity = 1.0
            previewBarShadow.layer.shadowOffset = CGSize(width: 0, height: 1)
            previewBarShadow.layer.shadowColor = keyShadowColor

            previewBar.textColor = keyCharColor
            previewBar.lineBreakMode = NSLineBreakMode.byWordWrapping
            if previewState == false {
              previewBar.text = ""
            }
            previewBar.sizeToFit()
          }

          // Pad before key is added.
          var leftPadding = CGFloat(0)
          if DeviceType.isPhone
            && key == "y"
            && ["German", "Swedish"].contains(controllerLanguage)
            && switchInput != true {
            leftPadding = buttonWidth / 3
            addPadding(to: stackView2, width: leftPadding, key: "y")
          }
          if DeviceType.isPhone
            && key == "a"
            && (controllerLanguage == "Portuguese" || switchInput == true) {
            leftPadding = buttonWidth / 4
            addPadding(to: stackView1, width: leftPadding, key: "a")
          }
          if DeviceType.isPad
            && key == "a"
            && (controllerLanguage == "Portuguese" || switchInput == true) {
            leftPadding = buttonWidth / 3
            addPadding(to: stackView1, width: leftPadding, key: "a")
          }
          if DeviceType.isPad
            && key == "@"
            && (controllerLanguage == "Portuguese" || switchInput == true) {
            leftPadding = buttonWidth / 3
            addPadding(to: stackView1, width: leftPadding, key: "@")
          }
          if DeviceType.isPad
            && key == "€"
            && (controllerLanguage == "Portuguese" || switchInput == true) {
            leftPadding = buttonWidth / 3
            addPadding(to: stackView1, width: leftPadding, key: "€")
          }

          keyboardKeys.append(btn)
          switch row {
          case 0: stackView0.addArrangedSubview(btn)
          case 1: stackView1.addArrangedSubview(btn)
          case 2: stackView2.addArrangedSubview(btn)
          case 3: stackView3.addArrangedSubview(btn)
          default:
            break
          }

          // Special key styling.
          if key == "delete" {
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(keyLongPressed(_:)))
            btn.addGestureRecognizer(longPressRecognizer)
          }

          if key == "selectKeyboard" {
            selectKeyboardButton = btn
            self.selectKeyboardButton.addTarget(
              self,
              action: #selector(handleInputModeList(from:with:)),
              for: .allTouchEvents
            )
            styleIconBtn(btn: btn, color: keyCharColor, iconName: "globe")
          }

          if key == "hideKeyboard" {
            styleIconBtn(btn: btn, color: keyCharColor, iconName: "keyboard.chevron.compact.down")
          }

          if key == "shift" {
            styleIconBtn(btn: btn, color: keyCharColor, iconName: "shift")
          }

          if key == "return" {
            styleIconBtn(btn: btn, color: keyCharColor, iconName: "arrow.turn.down.left")
          }

          if key == "delete" {
            styleIconBtn(btn: btn, color: keyCharColor, iconName: "delete.left")
          }

          // Setting hold-to-select functionality.
          let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(setAlternatesView(sender:))
          )
          longPressGesture.minimumPressDuration = 1.2

          if keysWithAlternates.contains(key) {
            btn.addGestureRecognizer(longPressGesture)
          }

          // Pad after key is added.
          var rightPadding = CGFloat(0)
          if DeviceType.isPhone
            && key == "m"
            && ["German", "Swedish"].contains(controllerLanguage)
            && switchInput != true {
            rightPadding = buttonWidth / 3
            addPadding(to: stackView2, width: rightPadding, key: "m")
          }
          if DeviceType.isPhone
            && key == "l"
            && (controllerLanguage == "Portuguese" || switchInput == true) {
            rightPadding = buttonWidth / 4
            addPadding(to: stackView1, width: rightPadding, key: "l")
          }

          // specialKey styling.
          if key == "ABC" || key == "АБВ" {
            if DeviceType.isPhone {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 2).isActive = true
            } else {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1).isActive = true
            }
            btn.layer.setValue(true, forKey: "isSpecial")
            btn.backgroundColor = specialKeyColor
          } else if key == "delete"
              || key == "#+="
              || key == "shift"
              || key == "selectKeyboard" { // key == "undoArrow"
            if DeviceType.isPhone {
              // Cancel Russian keyboard key resizing if translating as the keyboard is English.
              if controllerLanguage == "Russian"
                && keyboardState == .letters
                && switchInput != true {
                btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1).isActive = true
              } else {
                btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.5).isActive = true
              }
            } else {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1).isActive = true
            }
            btn.layer.setValue(true, forKey: "isSpecial")
            btn.backgroundColor = specialKeyColor
            if key == "shift" {
              if shiftButtonState == .shift {
                btn.backgroundColor = keyPressedColor
                styleIconBtn(btn: btn, color: UIColor.label, iconName: "shift.fill")
              } else if shiftButtonState == .caps {
                btn.backgroundColor = keyPressedColor
                styleIconBtn(btn: btn, color: UIColor.label, iconName: "capslock.fill")
              }
            }
          } else if key == "123"
              || key == ".?123"
              || key == "return"
              || key == "hideKeyboard" {
            if DeviceType.isPhone && row == 2 {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.5).isActive = true
            } else if DeviceType.isPhone && row != 2 {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 2).isActive = true
            } else if controllerLanguage == "Russian" && row == 2 && DeviceType.isPhone {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.5).isActive = true
            } else if key == "return"
                && ( controllerLanguage == "Portuguese" || switchInput == true )
                && row == 1
                && DeviceType.isPad {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.5).isActive = true
            } else {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1).isActive = true
            }
            btn.layer.setValue(true, forKey: "isSpecial")
            if key == "return" && previewState == true {
              btn.backgroundColor = commandKeyColor
            } else {
              btn.backgroundColor = specialKeyColor
            }
            // Only change widths for number and symbol keys for iPhones.
          } else if (keyboardState == .numbers || keyboardState == .symbols)
              && row == 2
              && DeviceType.isPhone {
            btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.4).isActive = true
          } else if key != spaceBar {
            btn.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
          } else {
            btn.layer.setValue(key, forKey: "original")
            btn.setTitle(key, for: .normal)
          }

          // Extend button touch areas.
          var widthOfSpacing = CGFloat(0)
          if keyboardState == .letters {
            widthOfSpacing = (
              (UIScreen.main.bounds.width - 6.0)
              - (CGFloat(letterKeys[0].count) * buttonWidth)
              ) / (CGFloat(letterKeys[0].count)
              - 1.0
            )
          } else {
            widthOfSpacing = (
              (UIScreen.main.bounds.width - 6.0)
              - (CGFloat(numberKeys[0].count) * numSymButtonWidth)
              ) / (CGFloat(letterKeys[0].count)
              - 1.0
            )
          }

          switch row {
          case 0:
            btn.topShift = -5
            btn.bottomShift = -6
          case 1:
            btn.topShift = -6
            btn.bottomShift = -6
          case 2:
            btn.topShift = -6
            btn.bottomShift = -6
          case 3:
            btn.topShift = -6
            btn.bottomShift = -5
          default:
            break
          }

          // Pad left and right based on if the button has been shifted.
          if leftPadding == CGFloat(0) {
            btn.leftShift = -(widthOfSpacing / 2)
          } else {
            btn.leftShift = -(leftPadding)
          }
          if rightPadding == CGFloat(0) {
            btn.rightShift = -(widthOfSpacing / 2)
          } else {
            btn.rightShift = -(rightPadding)
          }

          // Activate keyboard interface buttons.
          activateBtn(btn: btn)
          if key == "shift" || key == spaceBar {
            btn.addTarget(self, action: #selector(keyMultiPress(_:event:)), for: .touchDownRepeat)
          }
        }
      }

      // End padding.
      switch keyboardState {
      case .letters:
        break
      case .numbers:
        break
      case .symbols:
        break
      }

    } else {
      // Load conjugation view.
      for view in [stackView0, stackView1, stackView2, stackView3] {
        view?.isUserInteractionEnabled = false
      }

      scribeBtnToEscape()
      scribeBtn.layer.cornerRadius = commandKeyCornerRadius
      scribeBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

      previewBar.backgroundColor = previewBarColor
      previewBarBlend.backgroundColor = previewBarColor
      previewBar.textColor = keyCharColor

      deactivateBtn(btn: conjugateBtn)
      deactivateBtn(btn: translateBtn)
      deactivateBtn(btn: pluralBtn)

      activateConjugationDisplay()
      setConjugationState()

      styleIconBtn(btn: conjugateShiftLeftBtn, color: keyCharColor, iconName: "chevron.left")
      conjugateShiftLeftBtn.clipsToBounds = true
      conjugateShiftLeftBtn.layer.masksToBounds = false
      conjugateShiftLeftBtn.layer.cornerRadius = keyCornerRadius
      conjugateShiftLeftBtn.layer.shadowColor = keyShadowColor
      conjugateShiftLeftBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
      conjugateShiftLeftBtn.layer.shadowOpacity = 1.0
      conjugateShiftLeftBtn.layer.shadowRadius = 0.0
      styleIconBtn(btn: conjugateShiftRightBtn, color: keyCharColor, iconName: "chevron.right")
      conjugateShiftRightBtn.clipsToBounds = true
      conjugateShiftRightBtn.layer.masksToBounds = false
      conjugateShiftRightBtn.layer.cornerRadius = keyCornerRadius
      conjugateShiftRightBtn.layer.shadowColor = keyShadowColor
      conjugateShiftRightBtn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
      conjugateShiftRightBtn.layer.shadowOpacity = 1.0
      conjugateShiftRightBtn.layer.shadowRadius = 0.0
    }
  }

  // MARK: Scribe commands

  /// Inserts the translation of a valid word in the preview bar into the proxy.
  func queryTranslation() {
    // Cancel via a return press.
    if previewBar.text! == translatePromptAndCursor {
      return
    }
    wordToTranslate = (previewBar?.text!.substring(with: translatePrompt.count..<((previewBar?.text!.count)!-1)))!
    wordToTranslate = String(wordToTranslate.trailingSpacesTrimmed)

    // Check to see if the input was uppercase to return an uppercase conjugation.
    inputWordIsCapitalized = false
    let firstLetter = wordToTranslate.substring(toIdx: 1)
    inputWordIsCapitalized = firstLetter.isUppercase
    wordToTranslate = wordToTranslate.lowercased()

    let wordInDirectory = translations?[wordToTranslate] != nil
    if wordInDirectory {
      wordToReturn = translations?[wordToTranslate] as! String
      if inputWordIsCapitalized {
        proxy.insertText(wordToReturn.capitalized + " ")
      } else {
        proxy.insertText(wordToReturn + " ")
      }
    } else {
      invalidState = true
    }
  }

  /// Triggers the display of the conjugation view for a valid verb in the preview bar.
  func queryConjugation() {
    // Cancel via a return press.
    if previewBar.text! == conjugatePromptAndCursor {
      return
    }
    verbToConjugate = (previewBar?.text!.substring(with: conjugatePrompt.count..<((previewBar?.text!.count)!-1)))!
    verbToConjugate = String(verbToConjugate.trailingSpacesTrimmed)

    // Check to see if the input was uppercase to return an uppercase conjugation.
    inputWordIsCapitalized = false
    let firstLetter = verbToConjugate.substring(toIdx: 1)
    inputWordIsCapitalized = firstLetter.isUppercase
    verbToConjugate = verbToConjugate.lowercased()

    let verbInDirectory = verbs?[verbToConjugate] != nil
    if verbInDirectory {
      conjugateView = true
      loadKeys()
    } else {
      invalidState = true
    }
  }

  /// Returns a conjugation once a user presses a key in the conjugateView.
  ///
  /// - Parameters
  ///   - keyPressed: the button pressed as sender.
  ///   - requestedTense: the tense that is triggered by the given key.
  func returnConjugation(keyPressed: UIButton, requestedTense: String) {
    // Don't change proxy if they select a conjugation that's missing.
    if keyPressed.titleLabel?.text == invalidCommandMsg {
      proxy.insertText("")
    } else if conjugateAlternateView == false {
      if deConjugationState != .indicativePerfect {
        wordToReturn = verbs?[verbToConjugate]![requestedTense] as! String
        if inputWordIsCapitalized == true {
          proxy.insertText(wordToReturn.capitalized + " ")
        } else {
          proxy.insertText(wordToReturn + " ")
        }
      } else {
        proxy.insertText(verbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
      }
    } else if conjugateAlternateView == true {
      wordToReturn = verbs?[verbToConjugate]![requestedTense] as! String
      if inputWordIsCapitalized == true {
        proxy.insertText(wordToReturn.capitalized + " ")
      } else {
        proxy.insertText(wordToReturn + " ")
      }
    }
    previewState = false
    conjugateView = false
    loadKeys()
  }

  /// Inserts the plural of a valid noun in the preview bar into the proxy.
  func queryPlural() {
    // Cancel via a return press.
    if previewBar.text! == pluralPromptAndCursor {
      return
    }
    var noun: String = (previewBar?.text!.substring(with: pluralPrompt.count..<((previewBar?.text!.count)!-1)))!
    noun = String(noun.trailingSpacesTrimmed)

    // Check to see if the input was uppercase to return an uppercase plural.
    inputWordIsCapitalized = false
    if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
      let firstLetter = noun.substring(toIdx: 1)
      inputWordIsCapitalized = firstLetter.isUppercase
      noun = noun.lowercased()
    }
    let nounInDirectory = nouns?[noun] != nil
    if nounInDirectory {
      if nouns?[noun]?["plural"] as? String != "isPlural" {
        guard let plural = nouns?[noun]?["plural"] as? String else {
          return
        }
        if inputWordIsCapitalized == false {
          proxy.insertText(plural + " ")
        } else {
          proxy.insertText(plural.capitalized + " ")
        }
      } else {
        proxy.insertText(noun + " ")
        previewBar.text = previewPromptSpacing + "Already plural"
        invalidState = true
        isAlreadyPluralState = true
      }
    } else {
      invalidState = true
    }
  }

  /// Sets the annotation of an annotation element given parameters.
  ///
  /// - Parameters
  ///  - elem: the element to change the appearance of to show annotations.
  ///  - annotation: the annotation to set to the element.
  func setAnnotation(elem: UILabel, annotation: String) {
    var annotationToDisplay = annotation

    if scribeBtnState != true { // Cancel if typing while commands are displayed.
      if prepAnnotationState == false {
        if controllerLanguage == "Swedish" {
          if annotation == "C" {
            annotationToDisplay = "U"
          }
        } else if controllerLanguage == "Russian" {
          if annotation == "F" {
            annotationToDisplay = "Ж"
          } else if annotation == "M" {
            annotationToDisplay = "М"
          } else if annotation == "N" {
            annotationToDisplay = "Н"
          } else if annotation == "PL" {
            annotationToDisplay = "МН"
          }
        }

        if annotation == "PL" {
          // Make text smaller to fit the annotation.
          if DeviceType.isPhone {
            elem.font = .systemFont(ofSize: annotationHeight * 0.6)
          } else if DeviceType.isPad {
            elem.font = .systemFont(ofSize: annotationHeight * 0.8)
          }
        } else {
          if DeviceType.isPhone {
            elem.font = .systemFont(ofSize: annotationHeight * 0.70)
          } else if DeviceType.isPad {
            elem.font = .systemFont(ofSize: annotationHeight * 0.95)
          }
        }

        if annotation == "F" {
          elem.backgroundColor = previewRed
        } else if annotation == "M" {
          elem.backgroundColor = previewBlue
        } else if annotation == "C" {
          elem.backgroundColor = previewPurple
        } else if annotation == "N" {
          elem.backgroundColor = previewGreen
        } else if annotation == "PL" {
          elem.backgroundColor = previewOrange
        }
      } else {
        if controllerLanguage == "German" {
          if annotation == "Acc" {
            annotationToDisplay = "Akk"
          }
        } else if controllerLanguage == "Russian" {
          if annotation == "Acc" {
            annotationToDisplay = "Вин"
          } else if annotation == "Dat" {
            annotationToDisplay = "Дат"
          } else if annotation == "Gen" {
            annotationToDisplay = "Род"
          } else if annotation == "Loc" {
            annotationToDisplay = "Мес"
          } else if annotation == "Pre" {
            annotationToDisplay = "Пре"
          } else if annotation == "Ins" {
            annotationToDisplay = "Инс"
          }
        }
        if DeviceType.isPhone {
          elem.font = .systemFont(ofSize: annotationHeight * 0.65)
        } else if DeviceType.isPad {
          elem.font = .systemFont(ofSize: annotationHeight * 0.85)
        }
        elem.backgroundColor = keyCharColor
      }
      elem.text = annotationToDisplay
    }
  }

  /// Checks if a word is a noun and annotates the preview bar if so.
  ///
  /// - Parameters
  ///   - givenWord: a word that is potentially a noun.
  func nounAnnotation(givenWord: String) {
    // Check to see if the input was uppercase to return an uppercase annotation.
    inputWordIsCapitalized = false
    var wordToCheck: String = ""
    if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
      let firstLetter = givenWord.substring(toIdx: 1)
      inputWordIsCapitalized = firstLetter.isUppercase
      wordToCheck = givenWord.lowercased()
    } else {
      wordToCheck = givenWord
    }

    let isNoun = nouns?[wordToCheck] != nil || nouns?[givenWord.lowercased()] != nil
    if isNoun {
      // Clear the prior annotations to assure that preposition annotations don't persist.
      hideAnnotations()
      nounAnnotationsToDisplay = 0

      // Make preview bar font larger for annotation.
      if DeviceType.isPhone {
        previewBar.font = .systemFont(ofSize: annotationHeight * 0.8)
      } else if DeviceType.isPad {
        previewBar.font = .systemFont(ofSize: annotationHeight)
      }

      let nounForm = nouns?[wordToCheck]?["form"] as? String
      if nounForm == "" {
        return
      } else {
        // Initialize an array of display elements and count how many will be changed.
        let nounAnnotationDisplay: [UILabel] = [
          nounAnnotation1, nounAnnotation2, nounAnnotation3, nounAnnotation4, nounAnnotation5
        ]
        var numberOfAnnotations: Int = 0
        var annotationsToAssign: [String] = [String]()
        if nounForm?.count ?? 0 >= 3 { // Would have a slash as the largest is PL
          annotationsToAssign = (nounForm?.components(separatedBy: "/"))!
          numberOfAnnotations = annotationsToAssign.count
        } else {
          numberOfAnnotations = 1
          annotationsToAssign.append(nounForm ?? "")
        }

        // To be passed to preposition annotations.
        nounAnnotationsToDisplay = numberOfAnnotations

        for idx in 0..<numberOfAnnotations {
          setAnnotation(elem: nounAnnotationDisplay[idx], annotation: annotationsToAssign[idx])
        }

        if nounForm == "F" {
          previewBar.textColor = previewRed
        } else if nounForm == "M" {
          previewBar.textColor = previewBlue
        } else if nounForm == "C" {
          previewBar.textColor = previewPurple
        } else if nounForm ==  "N" {
          previewBar.textColor = previewGreen
        } else if nounForm ==  "PL" {
          previewBar.textColor = previewOrange
        } else {
          previewBar.textColor = keyCharColor
        }

        let wordSpacing = String(
          repeating: " ",
          count: ( numberOfAnnotations * 7 ) - ( numberOfAnnotations - 1 )
        )
        if invalidState != true {
          if inputWordIsCapitalized == false {
            previewBar.text = previewPromptSpacing + wordSpacing + wordToCheck
          } else {
            previewBar.text = previewPromptSpacing + wordSpacing + wordToCheck.capitalized
          }
        }
      }
      let isPrep = prepositions?[wordToCheck] != nil
      // Pass the preposition state so that if it's false nounAnnotationsToDisplay can be made 0.
      if isPrep {
        prepAnnotationState = true
      }
    }
  }

  /// Annotates the preview bar with the form of a valid selected noun.
  func selectedNounAnnotation() {
    if scribeBtnState {
      scribeBtnState = false
      loadKeys()
    }
    let selectedWord = proxy.selectedText ?? ""

    nounAnnotation(givenWord: selectedWord)
  }

  /// Annotates the preview bar with the form of a valid typed noun.
  func typedNounAnnotation() {
    if proxy.documentContextBeforeInput != nil {
      let wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
      let lastWordTyped = wordsTyped.secondToLast()

      if lastWordTyped != "" {
        nounAnnotation(givenWord: lastWordTyped ?? "")
      }
    }
  }

  /// Checks if a word is a preposition and annotates the preview bar if so.
  ///
  /// - Parameters
  ///   - givenWord: a word that is potentially a preposition.
  func prepositionAnnotation(givenWord: String) {
    // Check to see if the input was uppercase to return an uppercase annotation.
    inputWordIsCapitalized = false
    let firstLetter = givenWord.substring(toIdx: 1)
    inputWordIsCapitalized = firstLetter.isUppercase
    let wordToCheck = givenWord.lowercased()

    // Check if prepAnnotationState has been passed and reset nounAnnotationsToDisplay if not.
    if prepAnnotationState == false {
      nounAnnotationsToDisplay = 0
    }

    let isPreposition = prepositions?[wordToCheck] != nil
    if isPreposition {
      prepAnnotationState = true
      // Make preview bar font larger for annotation.
      if DeviceType.isPhone {
        previewBar.font = .systemFont(ofSize: annotationHeight * 0.8)
      } else if DeviceType.isPad {
        previewBar.font = .systemFont(ofSize: annotationHeight)
      }
      previewBar.textColor = keyCharColor

      // Initialize an array of display elements and count how many will be changed.
      // This is initialized based on how many noun annotations have already been assigned (max 2).
      var prepAnnotationDisplay: [UILabel] = [UILabel]()
      if nounAnnotationsToDisplay == 0 {
        prepAnnotationDisplay = [prepAnnotation11, prepAnnotation12, prepAnnotation13, prepAnnotation14]
      } else if nounAnnotationsToDisplay == 1 {
        prepAnnotationDisplay = [prepAnnotation21, prepAnnotation22, prepAnnotation23, prepAnnotation24]
      } else if nounAnnotationsToDisplay == 2 {
        prepAnnotationDisplay = [prepAnnotation31, prepAnnotation32, prepAnnotation33, prepAnnotation34]
      } else if nounAnnotationsToDisplay > 2 {
        // Cancel annotation as the limit of noun and preposition labels has been reached.
        return
      }

      guard let prepositionCase: String = prepositions?[wordToCheck] as? String else {
        return
      }

      var numberOfAnnotations: Int = 0
      var annotationsToAssign: [String] = [String]()
      if prepositionCase.count >= 4 { // Would have a slash as they all are three characters long
        annotationsToAssign = (prepositionCase.components(separatedBy: "/"))
        numberOfAnnotations = annotationsToAssign.count
      } else {
        numberOfAnnotations = 1
        annotationsToAssign.append(prepositionCase )
      }

      for idx in 0..<numberOfAnnotations {
        setAnnotation(elem: prepAnnotationDisplay[idx], annotation: annotationsToAssign[idx])
      }
      // Cancel the state to allow for symbol coloration in selection annotation without calling loadKeys.
      prepAnnotationState = false

      let wordSpacing = String(
        repeating: " ",
        count:
        ( nounAnnotationsToDisplay * 7 )
        - ( nounAnnotationsToDisplay - 1 )
        + ( numberOfAnnotations * 9 )
        - ( numberOfAnnotations - 1 )
      )
      if inputWordIsCapitalized == false {
        previewBar.text = previewPromptSpacing + wordSpacing + wordToCheck
      } else {
        previewBar.text = previewPromptSpacing + wordSpacing + wordToCheck.capitalized
      }
    }
  }

  /// Annotates the preview bar with the form of a valid selected preposition.
  func selectedPrepositionAnnotation() {
    if scribeBtnState {
      scribeBtnState = false
      loadKeys()
    }

    if languagesWithCaseDependantOnPrepositions.contains(controllerLanguage) {
      let selectedWord = proxy.selectedText ?? ""

      prepositionAnnotation(givenWord: selectedWord)
    }
  }

  /// Annotates the preview bar with the form of a valid typed preposition.
  func typedPrepositionAnnotation() {
    if languagesWithCaseDependantOnPrepositions.contains(controllerLanguage) {
      if proxy.documentContextBeforeInput != nil {
        let wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
        let lastWordTyped = wordsTyped.secondToLast()

        if lastWordTyped != "" {
          prepositionAnnotation(givenWord: lastWordTyped ?? "")
        }
      }
    }
  }

  /// Clears the text found in the preview bar.
  func clearPreviewBar() {
    if previewState == false {
      previewBar.textColor = keyCharColor
      previewBar.text = " "
    }

    // Trigger the removal of the noun or preposition annotations.
    hideAnnotations()
  }

  // MARK: Button Actions

  /// Triggers actions based on the press of a key.
  ///
  /// - Parameters
  ///   - sender: the button pressed as sender.
  @IBAction func keyPressedTouchUp(_ sender: UIButton) {
    guard let originalKey = sender.layer.value(
      forKey: "original"
    ) as? String,
      let keyToDisplay = sender.layer.value(forKey: "keyToDisplay") as? String else {
        return
      }

    guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {
      return
    }
    sender.backgroundColor = isSpecial ? specialKeyColor : keyColor

    // Disable the possibility of a double shift call.
    if originalKey != "shift" {
      capsLockPossible = false
    }
    // Disable the possibility of a double space period call.
    if originalKey != spaceBar {
      doubleSpacePeriodPossible = false
    }

    // Reset the Russian verbs view after a selection.
    ruConjugationState = .present

    switch originalKey {
    case "Scribe":
      if proxy.selectedText != nil && previewState != true { // annotate word
        loadKeys()
        selectedNounAnnotation()
        selectedPrepositionAnnotation()
      } else {
        if previewState == true { // escape
          scribeBtnState = false
          previewState = false
          getTranslation = false
          getConjugation = false
          getPlural = false
          switchInput = false
        } else if scribeBtnState == false && conjugateView != true { // ScribeBtn
          scribeBtnState = true
          activateBtn(btn: translateBtn)
          activateBtn(btn: conjugateBtn)
          activateBtn(btn: pluralBtn)
        } else { // escape
          conjugateView = false
          scribeBtnState = false
          previewState = false
          getTranslation = false
          getConjugation = false
          getPlural = false
          switchInput = false
        }
        loadKeys()
      }

    // Switch to translate state.
    case "Translate":
      scribeBtnState = false
      previewState = true
      getTranslation = true
      switchInput = true
      // Always start in letters with a new keyboard.
      keyboardState = .letters
      loadKeys()
      previewBar.text = translatePromptAndCursor

    // Switch to conjugate state.
    case "Conjugate":
      scribeBtnState = false
      previewState = true
      getConjugation = true
      loadKeys()
      previewBar.text = conjugatePromptAndCursor

    // Switch to plural state.
    case "Plural":
      scribeBtnState = false
      if controllerLanguage == "German" { // capitalize for nouns
        if shiftButtonState == .normal {
          shiftButtonState = .shift
        }
      }
      previewState = true
      getPlural = true
      loadKeys()
      previewBar.text = pluralPromptAndCursor

    // Move displayed conjugations to the left in order if able.
    case "shiftConjugateLeft":
      if controllerLanguage == "French" {
        frConjugationStateLeft()
      } else if controllerLanguage == "German" {
        deConjugationStateLeft()
      } else if controllerLanguage == "Portuguese" {
        ptConjugationStateLeft()
      } else if controllerLanguage == "Russian" {
        ruConjugationStateLeft()
      } else if controllerLanguage == "Spanish" {
        esConjugationStateLeft()
      } else if controllerLanguage == "Swedish" {
        svConjugationStateLeft()
      }
      loadKeys()

    // Move displayed conjugations to the right in order if able.
    case "shiftConjugateRight":
      if controllerLanguage == "French" {
        frConjugationStateRight()
      } else if controllerLanguage == "German" {
        deConjugationStateRight()
      } else if controllerLanguage == "Portuguese" {
        ptConjugationStateRight()
      } else if controllerLanguage == "Russian" {
        ruConjugationStateRight()
      } else if controllerLanguage == "Spanish" {
        esConjugationStateRight()
      } else if controllerLanguage == "Swedish" {
        svConjugationStateRight()
      }
      loadKeys()

    case "firstPersonSingular":
      returnConjugation(keyPressed: sender, requestedTense: tenseFPS)

    case "secondPersonSingular":
      returnConjugation(keyPressed: sender, requestedTense: tenseSPS)

    case "thirdPersonSingular":
      returnConjugation(keyPressed: sender, requestedTense: tenseTPS)

    case "firstPersonPlural":
      returnConjugation(keyPressed: sender, requestedTense: tenseFPP)

    case "secondPersonPlural":
      returnConjugation(keyPressed: sender, requestedTense: tenseSPP)

    case "thirdPersonPlural":
      returnConjugation(keyPressed: sender, requestedTense: tenseTPP)

    case "conjugateTopLeft":
      returnConjugation(keyPressed: sender, requestedTense: tenseTopLeft)

    case "conjugateTopRight":
      returnConjugation(keyPressed: sender, requestedTense: tenseTopRight)

    case "conjugateBottomLeft":
      returnConjugation(keyPressed: sender, requestedTense: tenseBottomLeft)

    case "conjugateBottomRight":
      returnConjugation(keyPressed: sender, requestedTense: tenseBottomRight)

    case "delete":
      if shiftButtonState == .shift {
        shiftButtonState = .normal
        loadKeys()
      }
      // Prevent the preview state prompt from being deleted.
      if previewState == true && allPrompts.contains((previewBar?.text!)!) {
        shiftButtonState = .shift // Auto-capitalization
        loadKeys()
        return
      }
      handleDeleteButtonPressed()
      // Auto-capitalization if delete goes to the start of the proxy.
      if proxy.documentContextBeforeInput == nil && previewState != true {
        if keyboardState == .letters && shiftButtonState == .normal {
          shiftButtonState = .shift
          loadKeys()
        }
      }
      clearPreviewBar()

    case spaceBar:
      if previewState != true {
        proxy.insertText(" ")
        if [". ", "? ", "! "].contains(proxy.documentContextBeforeInput?.suffix(2)) {
          shiftButtonState = .shift
        }
        if keyboardState != .letters {
          changeKeyboardToLetterKeys()
        }
      } else {
        previewBar.text! = (previewBar?.text!.insertPriorToCursor(char: " "))!
        if [
          ". " + previewCursor,
          "? " + previewCursor,
          "! " + previewCursor
        ].contains(String(previewBar.text!.suffix(3))) {
          shiftButtonState = .shift
        }
        if keyboardState != .letters {
          changeKeyboardToLetterKeys()
        }
      }
      // Prevent annotations from being triggered during commands.
      if getConjugation == false && getTranslation == false {
        typedNounAnnotation()
        typedPrepositionAnnotation()
        annotationState = false
        prepAnnotationState = false
        nounAnnotationsToDisplay = 0
      }

      if proxy.documentContextBeforeInput?.suffix("  ".count) == "  " {
        clearPreviewBar()
      }
      doubleSpacePeriodPossible = true

    case "selectKeyboard":
      self.advanceToNextInputMode()

    case "hideKeyboard":
      self.dismissKeyboard()

    case "return":
      if getTranslation && previewState == true { // translate state
        queryTranslation()
        getTranslation = false
        switchInput = false
      }
      if getConjugation && previewState == true { // conjugate state
        // Reset to the most basic conjugations.
        deConjugationState = .indicativePresent
        queryConjugation()
        getConjugation = false
      }
      if getPlural && previewState == true { // plural state
        queryPlural()
        getPlural = false
      }
      if previewState == false { // normal return button
        proxy.insertText("\n")
        clearPreviewBar()
      } else if invalidState == true { // invalid state
        previewState = false

        // Return to the original input method if it has been switched away from.
        if switchInput == true {
          switchInput = false
          loadKeys()
        }

        autoCapAtStartOfProxy()
        if isAlreadyPluralState != true {
          previewBar.text = previewPromptSpacing + invalidCommandMsg
        }
        previewBar.textColor = keyCharColor

        invalidState = false
        isAlreadyPluralState = false
      } else {
        previewState = false
        clearPreviewBar()
        autoCapAtStartOfProxy()
        loadKeys()
        // Avoid showing noun annotation instead of conjugation state header.
        if conjugateView == false {
          typedNounAnnotation()
          typedPrepositionAnnotation()
          annotationState = false
          prepAnnotationState = false
          nounAnnotationsToDisplay = 0
        }
      }

    case "123":
      changeKeyboardToNumberKeys()
      clearPreviewBar()

    case ".?123":
      changeKeyboardToNumberKeys()
      clearPreviewBar()

    case "#+=":
      changeKeyboardToSymbolKeys()
      clearPreviewBar()

    case "ABC":
      changeKeyboardToLetterKeys()
      clearPreviewBar()
      autoCapAtStartOfProxy()

    case "АБВ":
      changeKeyboardToLetterKeys()
      clearPreviewBar()
      autoCapAtStartOfProxy()

    case "'":
      // Change back to letter keys.
      if previewState != true {
        proxy.insertText("'")
      } else {
        previewBar.text! = (previewBar.text!.insertPriorToCursor(char: "'"))
      }
      changeKeyboardToLetterKeys()
      clearPreviewBar()

    case "shift":
      shiftButtonState = shiftButtonState == .normal ? .shift : .normal
      loadKeys()
      clearPreviewBar()
      capsLockPossible = true

    default:
      if shiftButtonState == .shift {
        shiftButtonState = .normal
        loadKeys()
      }
      if previewState == false {
        proxy.insertText(keyToDisplay)
        clearPreviewBar()
      } else {
        previewBar.text = previewBar.text!.insertPriorToCursor(char: keyToDisplay)
      }
    }
    // Remove alternates view if it's present.
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
    }
  }

  // MARK: Key press functions

  /// Auto-capitalization if the cursor is at the start of the proxy.
  func autoCapAtStartOfProxy() {
    proxy.insertText(" ")
    if proxy.documentContextBeforeInput == " " {
      if shiftButtonState == .normal {
        shiftButtonState = .shift
        loadKeys()
      }
    }
    proxy.deleteBackward()
  }

  /// Colors keys to show they have been pressed.
  ///
  /// - Parameters
  ///   - sender: the key that was pressed.
  @objc func keyTouchDown(_ sender: UIButton) {
    sender.backgroundColor = keyPressedColor
  }

  /// Defines events that occur given multiple presses of a single key.
  ///
  /// - Parameters
  ///  - sender: the key that was pressed multiple times.
  ///  - event: event to derive tap counts.
  @objc func keyMultiPress(_ sender: UIButton, event: UIEvent) {
    guard var originalKey = sender.layer.value(forKey: "original") as? String else {return}

    let touch: UITouch = event.allTouches!.first!

    // Caps lock given two taps of shift.
    if touch.tapCount == 2 && originalKey == "shift" && capsLockPossible == true {
      shiftButtonState = .caps
      loadKeys()
      clearPreviewBar()
    }

    // To make sure that the user can still use the double space period shortcut after numbers and symbols.
    let punctuationThatCancelsShortcut = ["?", "!", ",", ".", ":", ";", "-"]
    if originalKey != "shift" && proxy.documentContextBeforeInput?.count != 1 && previewState == false {
      let charBeforeSpace = String(Array(proxy.documentContextBeforeInput!).secondToLast()!)
      if punctuationThatCancelsShortcut.contains(charBeforeSpace) {
        originalKey = "Cancel shortcut"
      }
    } else if previewState == true {
      let charBeforeSpace = String(Array((previewBar?.text!)!).secondToLast()!)
      if punctuationThatCancelsShortcut.contains(charBeforeSpace) {
        originalKey = "Cancel shortcut"
      }
    }
    // Double space period shortcut.
    if touch.tapCount == 2
      && originalKey == spaceBar
      && proxy.documentContextBeforeInput?.count != 1
      && doubleSpacePeriodPossible == true {
      // The fist condition prevents a period if the prior characters are spaces as the user wants a series of spaces.
      if proxy.documentContextBeforeInput?.suffix(2) != "  " && previewState == false {
        proxy.deleteBackward()
        proxy.insertText(". ")
        keyboardState = .letters
        shiftButtonState = .shift
        loadKeys()
      // The fist condition prevents a period if the prior characters are spaces as the user wants a series of spaces.
      } else if previewBar.text!.suffix(2) != "  " && previewState == true {
        previewBar.text! = (previewBar?.text!.deletePriorToCursor())!
        previewBar.text! = (previewBar?.text!.insertPriorToCursor(char: ". "))!
        keyboardState = .letters
        shiftButtonState = .shift
        loadKeys()
      }
      clearPreviewBar()
    }
  }

  /// Defines the criteria under which a key is long pressed.
  ///
  /// - Parameters
  ///   - gesture: the gesture that was received.
  @objc func keyLongPressed(_ gesture: UIGestureRecognizer) {
    // Prevent the preview state prompt from being deleted.
    if previewState == true && allPrompts.contains((previewBar?.text!)!) {
      gesture.state = .cancelled
    }
    if gesture.state == .began {
      backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (_) in
        self.handleDeleteButtonPressed()
      }
    } else if gesture.state == .ended || gesture.state == .cancelled {
      backspaceTimer?.invalidate()
      backspaceTimer = nil
      (gesture.view as! UIButton).backgroundColor = specialKeyColor
    }
  }

  /// Resets key coloration after they have been annotated to by keyPressedColor.
  ///
  /// - Parameters
  ///   - sender: the key that was pressed.
  @objc func keyUntouched(_ sender: UIButton) {
    guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
    sender.backgroundColor = isSpecial ? specialKeyColor : keyColor
  }

  /// Sets and styles the view displayed for hold-to-select keys.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func setAlternatesView(sender: UILongPressGestureRecognizer) {
    let tapLocation = sender.location(in: self.view)

    // Derive which button was pressed and get its alternates.
    guard let button = sender.view as? UIButton else {
      return
    }
    let btnPressed = button.layer.value(forKey: "original") as? String
    let alternateKeys = keyAlternatesDict[btnPressed ?? ""]
    let numAlternates = CGFloat(alternateKeys!.count)

    // Variables for alternate key view appearance.
    var alternatesViewWidth = CGFloat(0)
    var alternatesViewX = CGFloat(0)
    var alternatesViewY = CGFloat(0)
    let alternateButtonWidth = buttonWidth * 0.9
    var alternateBtnStartX = CGFloat(0)
    var alternatesBtnHeight = CGFloat(0)
    var alternatesCharHeight = CGFloat(0)

    if keysWithAlternatesLeft.contains(btnPressed ?? "") {
      alternatesViewX = tapLocation.x - 10.0
    } else if keysWithAlternatesRight.contains(btnPressed ?? "") {
      alternatesViewX = tapLocation.x - CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) - 5.0)
    }

    if numAlternates > 0 {
      alternatesViewWidth = CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) + 5.0)
    }

    if DeviceType.isPhone {
      alternatesViewY = tapLocation.y - 50.0
      alternatesBtnHeight = buttonWidth * 1.4
      alternatesCharHeight = buttonWidth / 2
    } else if DeviceType.isPad {
      alternatesViewY = tapLocation.y - 100.0
      alternatesBtnHeight = buttonWidth
      alternatesCharHeight = buttonWidth / 3
    }

    alternatesKeyView = UIView(
      frame: CGRect(
        x: alternatesViewX,
        y: alternatesViewY,
        width: alternatesViewWidth,
        height: alternatesBtnHeight
      )
    )

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is already added than remove and then add again.
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = keyShadowColor

    alternateBtnStartX = 5.0
    for char in alternateKeys! {
      let btn: UIButton = UIButton(
        frame: CGRect(
          x: alternateBtnStartX,
          y: 0,
          width: alternateButtonWidth,
          height: alternatesBtnHeight
        )
      )
      if shiftButtonState == .normal || char == "ß" {
        btn.setTitle(char, for: .normal)
      } else {
        btn.setTitle(char.capitalized, for: .normal)
      }
      btn.titleLabel?.font = .systemFont(ofSize: alternatesCharHeight)
      btn.setTitleColor(keyCharColor, for: .normal)

      alternatesKeyView.addSubview(btn)
      setBtn(btn: btn, color: keyColor, name: char, canCapitalize: true, isSpecial: false)

      alternateBtnStartX += (alternateButtonWidth + 3.0)
    }
    self.view.addSubview(alternatesKeyView)
    button.backgroundColor = keyColor
  }
}
