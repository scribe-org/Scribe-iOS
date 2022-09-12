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

    // Override prior command states from previous sessions.
    commandState = .idle

    // Set height for Scribe command functionality.
    annotationHeight = nounAnnotation1.frame.size.height

    loadKeys()
  }

  /// Activates a button by assigning key touch functions for their given actions.
  ///
  /// - Parameters
  ///   - btn: the button to be activated.
  func activateBtn(btn: UIButton) {
    btn.addTarget(self, action: #selector(executeKeyActions), for: .touchUpInside)
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
    btn.removeTarget(self, action: #selector(executeKeyActions), for: .touchUpInside)
    btn.removeTarget(self, action: #selector(keyTouchDown), for: .touchDown)
    btn.removeTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
    btn.isUserInteractionEnabled = false
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
        keyboardHeight = 420
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

  // Button to be assigned as the select keyboard button if necessary.
  @IBOutlet var selectKeyboardButton: UIButton!

  /// Includes the following:
  /// - Assignment of the proxy
  /// - Loading the Scribe interface
  /// - Making keys letters
  /// - Adding the keyboard selector target
  override func viewDidLoad() {
    super.viewDidLoad()

    checkDarkModeSetColors()
    // If alternateKeysView is already added than remove it so it's not colored wrong.
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
      alternatesShapeLayer.removeFromSuperlayer()
    }
    proxy = textDocumentProxy as UITextDocumentProxy
    keyboardState = .letters
    keyboardLoad = true
    loadInterface()
    keyboardLoad = false

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
    // If alternateKeysView is already added than remove it so it's not colored wrong.
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
      alternatesShapeLayer.removeFromSuperlayer()
    }
    keyboardLoad = true
    loadKeys()
    keyboardLoad = false
  }

  // MARK: Scribe Command Elements

  // Partitions for autocomplete and autosuggest
  @IBOutlet var leftAutoPartition: UILabel!
  @IBOutlet var rightAutoPartition: UILabel!

  /// Sets the user interaction potential of the partitions for autocomplete and autosuggest.
  func setAutoActionPartitions() {
    leftAutoPartition.isUserInteractionEnabled = false
    rightAutoPartition.isUserInteractionEnabled = false
  }

  /// Shows the partitions for autocomplete and autosuggest.
  func conditionallyShowAutoActionPartitions() {
    if commandState == .idle {
      if UITraitCollection.current.userInterfaceStyle == .light {
        leftAutoPartition.backgroundColor = specialKeyColor
        rightAutoPartition.backgroundColor = specialKeyColor
      } else if UITraitCollection.current.userInterfaceStyle == .dark {
        leftAutoPartition.backgroundColor = UIColor(cgColor: commandBarBorderColor)
        rightAutoPartition.backgroundColor = UIColor(cgColor: commandBarBorderColor)
      }
    }
  }

  /// Hides the partitions for autocomplete and autosuggest.
  /// Note: this function is called during command mode when the commandBar is viewable and the Scribe key state.
  func hideAutoActionPartitions() {
    leftAutoPartition.backgroundColor = .clear
    rightAutoPartition.backgroundColor = .clear
  }

  /// Generates an array of the three autocomplete words.
  func getAutocompletions() {
    completionWords = [" ", " ", " "]
    if proxy.documentContextBeforeInput?.count != 0 {
      if let inString = proxy.documentContextBeforeInput {
        // To only focus on the current word as prefix in autocomplete.
        currentPrefix = inString.replacingOccurrences(of: pastStringInTextProxy, with: "")

        // Post commands pastStringInTextProxy is "", so take last word.
        if currentPrefix.contains(" ") {
          currentPrefix = currentPrefix.components(separatedBy: " ").last ?? ""
        }

        let stringOptions = autocompleteWords.filter { item in
            return item.lowercased().hasPrefix(currentPrefix.lowercased())
        }

        var i = 0
        if stringOptions.count <= 3 {
          while i < stringOptions.count {
            if shiftButtonState == .caps {
              completionWords[i] = stringOptions[i].uppercased()
            } else if currentPrefix.isCaptalized {
              completionWords[i] = stringOptions[i].capitalize()
            } else {
              completionWords[i] = stringOptions[i]
            }
            i += 1
          }
        } else {
          while i < 3 {
            if shiftButtonState == .caps {
              completionWords[i] = stringOptions[i].uppercased()
            } else if currentPrefix.isCaptalized {
              completionWords[i] = stringOptions[i].capitalize()
            } else {
              completionWords[i] = stringOptions[i]
            }
            i += 1
          }
        }
      } else {
        getDefaultAutosuggestions()
      }
    } else {
      // For getting words on launch when the user hasn't typed anything in the proxy.
      getDefaultAutosuggestions()
    }
  }

  /// Generates an array of three words that serve as baseline autosuggestions.
  func getDefaultAutosuggestions() {
    var i = 0
    completionWords = [String]()
    while i < 3 {
      if shiftButtonState == .shift {
        completionWords.append(baseAutosuggestions[i].capitalize())
      } else if shiftButtonState == .caps {
        completionWords.append(baseAutosuggestions[i].uppercased())
      } else {
        completionWords.append(baseAutosuggestions[i])
      }
      i += 1
    }
  }

  /// Generates an array of the three autosuggest words.
  func getAutosuggestions() {
    let dummySuggestions = [
      "Buch": ["lesen", "kaufen", "schenken"],
      "ich": ["habe", "bin", "kann"],
      "mit": ["mir", "dir", "ihr"]
    ]
    
    let prefix = pastStringInTextProxy.replacingOccurrences(of: secondaryPastStringOnDelete, with: "").replacingOccurrences(of: " ", with: "")
    if dummySuggestions.keys.contains(prefix) {
      completionWords = dummySuggestions[prefix] ?? [String]()
    }
    if completionWords.isEmpty {
      getDefaultAutosuggestions()
    }
  }

  /// Sets up command buttons to execute autocomplete and autosuggest.
  func conditionallySetAutoActionBtns() {
    if autoActionState == .suggest {
      getAutosuggestions()
    } else {
      getAutocompletions()
    }
    if commandState == .idle {
      deactivateBtn(btn: translateKey)
      deactivateBtn(btn: conjugateKey)
      deactivateBtn(btn: pluralKey)

      if autoAction1Visible == true {
        setBtn(btn: translateKey, color: keyboardBgColor, name: "AutoAction1", canCap: false, isSpecial: false)
        styleBtn(btn: translateKey, title: completionWords[0], radius: commandKeyCornerRadius)
        activateBtn(btn: translateKey)
      }

      setBtn(btn: conjugateKey, color: keyboardBgColor, name: "AutoAction2", canCap: false, isSpecial: false)
      styleBtn(btn: conjugateKey, title: !autoAction1Visible ? completionWords[0] : completionWords[1], radius: commandKeyCornerRadius)
      activateBtn(btn: conjugateKey)

      setBtn(btn: pluralKey, color: keyboardBgColor, name: "AutoAction3", canCap: false, isSpecial: false)
      styleBtn(btn: pluralKey, title: !autoAction1Visible ? completionWords[1] : completionWords[2], radius: commandKeyCornerRadius)
      activateBtn(btn: pluralKey)

      translateKey.layer.shadowColor = UIColor.clear.cgColor
      conjugateKey.layer.shadowColor = UIColor.clear.cgColor
      pluralKey.layer.shadowColor = UIColor.clear.cgColor
    }

    // Reset autocorrect and autosuggest button visibility.
    autoAction1Visible = true
  }

  /// Clears the text proxy when inserting using an auto action.
  /// Note: the completion is appended after the typed text if this is not ran.
  func clearPrefixFromTextFieldProxy() {
    if currentPrefix != "" {
      if proxy.documentContextBeforeInput?.count != 0 {
        for _ in 0...currentPrefix.count - 1 {
          proxy.deleteBackward()
        }
      }
    }
  }

  /// Inserts the word that appears on the given auto action key and executes all following actions.
  ///
  /// - Parameters
  ///   - keyPressed: the auto action button that was executed.
  func executeAutoAction(keyPressed: UIButton) {
    autoActionState = .suggest
    clearPrefixFromTextFieldProxy()
    proxy.insertText(keyPressed.titleLabel?.text ?? "")
    proxy.insertText(" ")
    currentPrefix = ""
    secondaryPastStringOnDelete = pastStringInTextProxy
    pastStringInTextProxy = proxy.documentContextBeforeInput ?? ""
    clearCommandBar()
    conditionallyDisplayAnnotation()
  }

  // The background for the Scribe command elements.
  @IBOutlet var commandBackground: UILabel!
  func setCommandBackground() {
    commandBackground.backgroundColor = keyboardBgColor
    commandBackground.isUserInteractionEnabled = false
  }

  // The bar that displays language logic or is typed into for Scribe commands.
  @IBOutlet var commandBar: CommandBar!
  @IBOutlet var commandBarShadow: UIButton!
  @IBOutlet var commandBarBlend: UILabel!

  /// Clears the text found in the command bar.
  func clearCommandBar() {
    if [.idle, .select].contains(commandState) {
      commandBar.textColor = keyCharColor
      commandBar.text = ""
    }

    // Trigger the removal of the noun or preposition annotations.
    hideAnnotations(annotationDisplay: getAnnotationLabels())
  }

  /// Deletes in the proxy or command bar given the current constraints.
  func handleDeleteButtonPressed() {
    if [.idle, .select, .alreadyPlural, .invalid].contains(commandState) {
      proxy.deleteBackward()
    } else if [.translate, .conjugate, .plural].contains(commandState) && !(allPrompts.contains(commandBar.text!) || allColoredPrompts.contains(commandBar.attributedText!)) {
      guard
        let inputText = commandBar.text,
        !inputText.isEmpty
      else {
        return
      }
      commandBar.text = commandBar.text!.deletePriorToCursor()
    } else {
      backspaceTimer?.invalidate()
      backspaceTimer = nil
    }
  }

  // The button used to display Scribe commands and its shadow.
  @IBOutlet var scribeKey: ScribeKey!
  @IBOutlet var scribeKeyShadow: UIButton!

  /// Links various UI elements that interact concurrently.
  func linkShadowBlendElements() {
    scribeKey.shadow = scribeKeyShadow
    commandBar.shadow = commandBarShadow
    commandBar.blend = commandBarBlend
  }

  // Buttons used to trigger Scribe command functionality.
  @IBOutlet var translateKey: UIButton!
  @IBOutlet var conjugateKey: UIButton!
  @IBOutlet var pluralKey: UIButton!

  /// Sets up all buttons that are associated with Scribe commands.
  func setCommandBtns() {
    setBtn(btn: translateKey, color: commandKeyColor, name: "Translate", canCap: false, isSpecial: false)
    setBtn(btn: conjugateKey, color: commandKeyColor, name: "Conjugate", canCap: false, isSpecial: false)
    setBtn(btn: pluralKey, color: commandKeyColor, name: "Plural", canCap: false, isSpecial: false)

    activateBtn(btn: translateKey)
    activateBtn(btn: conjugateKey)
    activateBtn(btn: pluralKey)
  }

  // Buttons and functions for the conjugation view.
  @IBOutlet var conjugateShiftLeft: UIButton!
  @IBOutlet var conjugateShiftRight: UIButton!

  @IBOutlet var conjugateKeyFPS: UIButton!
  @IBOutlet var conjugateKeySPS: UIButton!
  @IBOutlet var conjugateKeyTPS: UIButton!
  @IBOutlet var conjugateKeyFPP: UIButton!
  @IBOutlet var conjugateKeySPP: UIButton!
  @IBOutlet var conjugateKeyTPP: UIButton!

  /// Returns all buttons for the 3x2 conjugation display.
  func get3x2ConjButtons() -> [UIButton] {
    let conjugationButtons: [UIButton] = [
      conjugateKeyFPS, conjugateKeySPS, conjugateKeyTPS, conjugateKeyFPP, conjugateKeySPP, conjugateKeyTPP
    ]

    return conjugationButtons
  }

  @IBOutlet var conjugateKeyTL: UIButton!
  @IBOutlet var conjugateKeyTR: UIButton!
  @IBOutlet var conjugateKeyBL: UIButton!
  @IBOutlet var conjugateKeyBR: UIButton!

  /// Returns all buttons for the 2x2 conjugation display
  func get2x2ConjButtons() -> [UIButton] {
    let conjugationButtons: [UIButton] = [
      conjugateKeyTL, conjugateKeyTR, conjugateKeyBL, conjugateKeyBR
    ]

    return conjugationButtons
  }

  // Labels for the conjugation view buttons.
  // Note that we're using buttons as labels weren't allowing for certain constraints to be set.
  @IBOutlet var conjugateLblFPS: UIButton!
  @IBOutlet var conjugateLblSPS: UIButton!
  @IBOutlet var conjugateLblTPS: UIButton!
  @IBOutlet var conjugateLblFPP: UIButton!
  @IBOutlet var conjugateLblSPP: UIButton!
  @IBOutlet var conjugateLblTPP: UIButton!

  /// Returns all labels for the 3x2 conjugation display.
  func get3x2ConjLabels() -> [UIButton] {
    let conjugationLabels: [UIButton] = [
      conjugateLblFPS, conjugateLblSPS, conjugateLblTPS, conjugateLblFPP, conjugateLblSPP, conjugateLblTPP
    ]

    return conjugationLabels
  }

  @IBOutlet var conjugateLblTL: UIButton!
  @IBOutlet var conjugateLblTR: UIButton!
  @IBOutlet var conjugateLblBL: UIButton!
  @IBOutlet var conjugateLblBR: UIButton!

  /// Returns all labels for the 2x2 conjugation display.
  func get2x2ConjLabels() -> [UIButton] {
    let conjugationLabels: [UIButton] = [
      conjugateLblTL, conjugateLblTR, conjugateLblBL, conjugateLblBR
    ]

    return conjugationLabels
  }

  /// Sets up all buttons and labels that are associated with the 3x2 conjugation display.
  func setConj3x2View() {
    setBtn(btn: conjugateKeyFPS, color: keyColor, name: "firstPersonSingular", canCap: false, isSpecial: false)
    setBtn(btn: conjugateKeySPS, color: keyColor, name: "secondPersonSingular", canCap: false, isSpecial: false)
    setBtn(btn: conjugateKeyTPS, color: keyColor, name: "thirdPersonSingular", canCap: false, isSpecial: false)
    setBtn(btn: conjugateKeyFPP, color: keyColor, name: "firstPersonPlural", canCap: false, isSpecial: false)
    setBtn(btn: conjugateKeySPP, color: keyColor, name: "secondPersonPlural", canCap: false, isSpecial: false)
    setBtn(btn: conjugateKeyTPP, color: keyColor, name: "thirdPersonPlural", canCap: false, isSpecial: false)

    for btn in get3x2ConjButtons() {
      activateBtn(btn: btn)
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get3x2ConjButtons() {
        btn.titleLabel?.font =  .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
      }
    }
  }

  /// Sets up all buttons and labels that are associated with the 2x2 conjugation display.
  func setConj2x2View() {
    setBtn(btn: conjugateKeyTL, color: keyColor, name: "conjugateTopLeft", canCap: false, isSpecial: false)
    setBtn(btn: conjugateKeyTR, color: keyColor, name: "conjugateTopRight", canCap: false, isSpecial: false)
    setBtn(btn: conjugateKeyBL, color: keyColor, name: "conjugateBottomLeft", canCap: false, isSpecial: false)
    setBtn(btn: conjugateKeyBR, color: keyColor, name: "conjugateBottomRight", canCap: false, isSpecial: false)

    for btn in get2x2ConjButtons() {
      activateBtn(btn: btn)
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get2x2ConjButtons() {
        btn.titleLabel?.font =  .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
      }
    }
  }

  /// Sets up all buttons and labels for the conjugation view given constraints to determine the dimensions.
  func setConjugationBtns() {
    // Set the conjugation view to 2x2 for Swedish and Russian past tense.
    if controllerLanguage == "Swedish" {
      conjugateAlternateView = true
    } else if controllerLanguage == "Russian" && ruConjugationState == .past {
      conjugateAlternateView = true
    } else {
      conjugateAlternateView = false
    }

    // The base conjugation view is 3x2 for first, second, and third person in singular and plural.
    if conjugateAlternateView == false {
      setConj3x2View()
    } else {
      setConj2x2View()
    }

    // Setup the view shift buttons.
    setBtn(
      btn: conjugateShiftLeft,
      color: keyColor,
      name: "shiftConjugateLeft",
      canCap: false,
      isSpecial: false
    )
    setBtn(
      btn: conjugateShiftRight,
      color: keyColor,
      name: "shiftConjugateRight",
      canCap: false,
      isSpecial: false
    )

    activateBtn(btn: conjugateShiftLeft)
    activateBtn(btn: conjugateShiftRight)

    // Make all labels clear and set their font for if they will be used.
    let allConjLabels: [UIButton] = get3x2ConjLabels() + get2x2ConjLabels()
    for lbl in allConjLabels {
      lbl.backgroundColor = UIColor.clear
      lbl.setTitleColor(specialKeyColor, for: .normal)
      lbl.isUserInteractionEnabled = false
      if DeviceType.isPad {
        lbl.titleLabel?.font =  .systemFont(ofSize: letterKeyWidth / 4)
      }
    }
  }

  /// Activates all buttons that are associated with the conjugation display.
  func activateConjugationDisplay() {
    activateBtn(btn: conjugateShiftLeft)
    activateBtn(btn: conjugateShiftRight)

    if conjugateAlternateView == false {
      for elem in get3x2ConjButtons() {
        activateBtn(btn: elem)
      }

      for elem in get2x2ConjButtons() {
        deactivateBtn(btn: elem)
      }
    }

    if conjugateAlternateView == true {
      for elem in get3x2ConjButtons() {
        deactivateBtn(btn: elem)
      }

      for elem in get2x2ConjButtons() {
        activateBtn(btn: elem)
      }
    }
  }

  /// Deactivates all buttons that are associated with the conjugation display.
  func deactivateConjugationDisplay() {
    deactivateBtn(btn: conjugateShiftLeft)
    conjugateShiftLeft.tintColor = UIColor.clear
    deactivateBtn(btn: conjugateShiftRight)
    conjugateShiftRight.tintColor = UIColor.clear

    let allConjLabels: [UIButton] = get3x2ConjLabels() + get2x2ConjLabels()
    let allConjElements: [UIButton] = get3x2ConjButtons() + get2x2ConjButtons() + allConjLabels

    for elem in allConjElements {
      deactivateBtn(btn: elem)
    }

    for lbl in allConjLabels {
      lbl.setTitle("", for: .normal)
    }
  }

  /// Assign the conjugations that will be selectable in the conjugation display.
  func assignConjStates() {
    var conjugationStateFxn: () -> String = deGetConjugationState
    if controllerLanguage != "Swedish" {
      conjugationStateFxn = keyboardConjStateDict[controllerLanguage] as! () -> String
    }

    if !["Russian", "Swedish"].contains(controllerLanguage) {
      tenseFPS = conjugationStateFxn() + "FPS"
      tenseSPS = conjugationStateFxn() + "SPS"
      tenseTPS = conjugationStateFxn() + "TPS"
      tenseFPP = conjugationStateFxn() + "FPP"
      tenseSPP = conjugationStateFxn() + "SPP"
      tenseTPP = conjugationStateFxn() + "TPP"

    } else if controllerLanguage == "Russian" {
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

    } else if controllerLanguage == "Swedish" {
      let swedishTenses = svGetConjugationState()

      tenseTopLeft = swedishTenses[0]
      tenseTopRight = swedishTenses[1]
      tenseBottomLeft = swedishTenses[2]
      tenseBottomRight = swedishTenses[3]
    }
  }

  /// Sets the label of the conjugation state and assigns the current tenses that are accessed to label the buttons.
  func setConjugationState() {
    // Assign the conjugations that will be selectable.
    assignConjStates()

    // Set the view title and its labels.
    var conjugationTitleFxn: () -> String = deGetConjugationTitle
    var conjugationLabelsFxn: () -> Void = deSetConjugationLabels
    if controllerLanguage != "Swedish" {
      conjugationTitleFxn = keyboardConjTitleDict[controllerLanguage] as! () -> String
      conjugationLabelsFxn = keyboardConjLabelDict[controllerLanguage] as! () -> Void
    }

    if !["Russian", "Swedish"].contains(controllerLanguage) {
      commandBar.text = conjugationTitleFxn()
      conjugationLabelsFxn()
    } else if controllerLanguage == "Russian" {
      commandBar.text = ruGetConjugationTitle()
      ruSetConjugationLabels()
    } else if controllerLanguage == "Swedish" {
      commandBar.text = svGetConjugationTitle()
      svSetConjugationLabels()
    }

    // Assign labels that have been set by SetConjugationLabels functions.
    conjugateLblFPS.setTitle("  " + labelFPS, for: .normal)
    conjugateLblSPS.setTitle("  " + labelSPS, for: .normal)
    conjugateLblTPS.setTitle("  " + labelTPS, for: .normal)
    conjugateLblFPP.setTitle("  " + labelFPP, for: .normal)
    conjugateLblSPP.setTitle("  " + labelSPP, for: .normal)
    conjugateLblTPP.setTitle("  " + labelTPP, for: .normal)

    conjugateLblTL.setTitle("  " + labelTopLeft, for: .normal)
    conjugateLblTR.setTitle("  " + labelTopRight, for: .normal)
    conjugateLblBL.setTitle("  " + labelBottomLeft, for: .normal)
    conjugateLblBR.setTitle("  " + labelBottomRight, for: .normal)

    if conjugateAlternateView == false {
      allTenses = [tenseFPS, tenseSPS, tenseTPS, tenseFPP, tenseSPP, tenseTPP]
      allConjugationBtns = get3x2ConjButtons()
    } else {
      allTenses = [tenseTopLeft, tenseTopRight, tenseBottomLeft, tenseBottomRight]
      allConjugationBtns = get2x2ConjButtons()
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

  /// Returns all available annotation labels.
  func getAnnotationLabels() -> [UILabel] {
    let nounAnnotationDisplay: [UILabel] = [
      nounAnnotation1, nounAnnotation2, nounAnnotation3, nounAnnotation4, nounAnnotation5
    ]

    let prepAnnotationDisplay: [UILabel] = [
      prepAnnotation11, prepAnnotation12, prepAnnotation13, prepAnnotation14,
      prepAnnotation21, prepAnnotation22, prepAnnotation23, prepAnnotation24,
      prepAnnotation31, prepAnnotation32, prepAnnotation33, prepAnnotation34
    ]

    return nounAnnotationDisplay + prepAnnotationDisplay
  }

  /// Returns the noun annotation labels.
  func getNounAnnotationLabels() -> [UILabel] {
    let nounAnnotationDisplay: [UILabel] = [
      nounAnnotation1, nounAnnotation2, nounAnnotation3, nounAnnotation4, nounAnnotation5
    ]

    return nounAnnotationDisplay
  }

  /// Returns the preposition annotation labels given the current number of noun annotations displayed.
  func getPrepAnnotationLabels() -> [UILabel] {
    // Initialize an array of display elements and count how many will be changed.
    // This is initialized based on how many noun annotations have already been assigned (max 2).
    var prepAnnotationDisplay: [UILabel] = [UILabel]()
    if nounAnnotationsToDisplay == 0 {
      prepAnnotationDisplay = [prepAnnotation11, prepAnnotation12, prepAnnotation13, prepAnnotation14]
    } else if nounAnnotationsToDisplay == 1 {
      prepAnnotationDisplay = [prepAnnotation21, prepAnnotation22, prepAnnotation23, prepAnnotation24]
    } else if nounAnnotationsToDisplay == 2 {
      prepAnnotationDisplay = [prepAnnotation31, prepAnnotation32, prepAnnotation33, prepAnnotation34]
    }
    return prepAnnotationDisplay
  }

  /// Styles the labels within the annotation display and removes user interactions.
  func styleAnnotations() {
    let nounAnnotationDisplay = getNounAnnotationLabels()

    let prepAnnotationDisplay: [UILabel] = [
      prepAnnotation11, prepAnnotation12, prepAnnotation13, prepAnnotation14,
      prepAnnotation21, prepAnnotation22, prepAnnotation23, prepAnnotation24,
      prepAnnotation31, prepAnnotation32, prepAnnotation33, prepAnnotation34
    ]

    for annotationDisplay in nounAnnotationDisplay {
      annotationDisplay.clipsToBounds = true
      annotationDisplay.layer.cornerRadius = keyCornerRadius / 2
      annotationDisplay.textAlignment = NSTextAlignment.center
      annotationDisplay.isUserInteractionEnabled = false
      annotationDisplay.font = .systemFont(ofSize: annotationHeight * 0.70)
      annotationDisplay.textColor = keyboardBgColor
    }

    for annotationDisplay in prepAnnotationDisplay {
      annotationDisplay.clipsToBounds = true
      annotationDisplay.layer.cornerRadius = keyCornerRadius / 2
      annotationDisplay.textAlignment = NSTextAlignment.center
      annotationDisplay.isUserInteractionEnabled = false
      annotationDisplay.font = .systemFont(ofSize: annotationHeight * 0.65)
      annotationDisplay.textColor = keyboardBgColor
    }
  }

  /// Displays an annotation instead of the translate auto action button given the word that was just typed or selected.
  func conditionallyDisplayAnnotation() {
    typedNounAnnotation(
      commandBar: commandBar,
      nounAnnotationDisplay: getNounAnnotationLabels(),
      annotationDisplay: getAnnotationLabels()
    )
    typedPrepAnnotation(
      commandBar: commandBar,
      prepAnnotationDisplay: getPrepAnnotationLabels()
    )
    annotationState = false
    prepAnnotationState = false
    nounAnnotationsToDisplay = 0
  }

  // MARK: Load keys

  /// Loads the keys given the current constraints.
  func loadKeys() {
    // The name of the language keyboard that's referencing KeyboardViewController.
    controllerLanguage = classForCoder.description().components(separatedBy: ".KeyboardViewController")[0]

    // Actions to be done only on initial loads.
    if keyboardLoad == true {
      commandBar.textColor = keyCharColor
      commandBar.conditionallyAddPlaceholder() // in case of color mode change during commands
      keyboardView.backgroundColor? = keyboardBgColor

      linkShadowBlendElements()
      setAutoActionPartitions()

      let specialKeys = [
        "shift", "delete", "ABC", "АБВ", "123", "#+=", "selectKeyboard", "space", "return", ".?123", "hideKeyboard"
      ]
      allNonSpecialKeys = allKeys.filter { !specialKeys.contains($0) }
    }

    setKeyboard()
    setCommandBackground()
    setCommandBtns()
    setConjugationBtns()

    // Clear interface from the last state.
    keyboardKeys.forEach {$0.removeFromSuperview()}
    paddingViews.forEach {$0.removeFromSuperview()}

    // keyWidth determined per keyboard by the top row.
    if isLandscapeView == true {
      if DeviceType.isPhone {
        letterKeyWidth = (UIScreen.main.bounds.height - 5) / CGFloat(letterKeys[0].count) * 1.5
        numSymKeyWidth = (UIScreen.main.bounds.height - 5) / CGFloat(numberKeys[0].count) * 1.5
      } else if DeviceType.isPad {
        letterKeyWidth = (UIScreen.main.bounds.height - 5) / CGFloat(letterKeys[0].count) * 1.2
        numSymKeyWidth = (UIScreen.main.bounds.height - 5) / CGFloat(numberKeys[0].count) * 1.2
      }
    } else {
      letterKeyWidth = (UIScreen.main.bounds.width - 6) / CGFloat(letterKeys[0].count) * 0.9
      numSymKeyWidth = (UIScreen.main.bounds.width - 6) / CGFloat(numberKeys[0].count) * 0.9
    }

    // Derive keyboard given current states and set widths.
    switch keyboardState {
    case .letters:
      keyboard = letterKeys
      keyWidth = letterKeyWidth
      // Auto-capitalization if the cursor is at the start of the proxy.
      if proxy.documentContextBeforeInput?.count == 0 {
        shiftButtonState = .shift
      }
    case .numbers:
      keyboard = numberKeys
      keyWidth = numSymKeyWidth
    case .symbols:
      keyboard = symbolKeys
      keyWidth = numSymKeyWidth
    }

    // Derive corner radii.
    if DeviceType.isPhone {
      if isLandscapeView == true {
        keyCornerRadius = keyWidth / 9
        commandKeyCornerRadius = keyWidth / 5
      } else {
        keyCornerRadius = keyWidth / 6
        commandKeyCornerRadius = keyWidth / 3
      }
    } else if DeviceType.isPad {
      if isLandscapeView == true {
        keyCornerRadius = keyWidth / 12
        commandKeyCornerRadius = keyWidth / 7.5
      } else {
        keyCornerRadius = keyWidth / 9
        commandKeyCornerRadius = keyWidth / 5
      }
    }

    styleAnnotations()
    if annotationState == false {
      hideAnnotations(annotationDisplay: getAnnotationLabels())
    }

    if commandState != .selectConjugation { // normal keyboard view
      for view in [stackView0, stackView1, stackView2, stackView3] {
        view?.isUserInteractionEnabled = true
        view?.isLayoutMarginsRelativeArrangement = true

        // Set edge insets for stack views to provide vertical key spacing.
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

      // Set up and activate Scribe key and other command elements.
      scribeKey.set()
      activateBtn(btn: scribeKey)
      styleBtn(btn: scribeKey, title: "Scribe", radius: commandKeyCornerRadius)
      scribeKey.setTitle("", for: .normal)
      commandBar.set() // set here so text spacing is appropriate
      conditionallyShowAutoActionPartitions()
      deactivateConjugationDisplay()

      if DeviceType.isPhone {
        translateKey.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.65)
        conjugateKey.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.65)
        pluralKey.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.65)
      } else if DeviceType.isPad {
        translateKey.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.9)
        conjugateKey.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.9)
        pluralKey.titleLabel?.font = .systemFont(ofSize: annotationHeight * 0.9)
      }

      if commandState == .select {
        styleBtn(btn: translateKey, title: translateKeyLbl, radius: commandKeyCornerRadius)
        styleBtn(btn: conjugateKey, title: conjugateKeyLbl, radius: commandKeyCornerRadius)
        styleBtn(btn: pluralKey, title: pluralKeyLbl, radius: commandKeyCornerRadius)

        scribeKey.toEscape()
        scribeKey.setFullCornerRadius()
        scribeKey.setEscShadow()

        commandBar.hide()
        hideAutoActionPartitions()
      } else {
        deactivateBtn(btn: conjugateKey)
        deactivateBtn(btn: translateKey)
        deactivateBtn(btn: pluralKey)

        if [.translate, .conjugate, .plural].contains(commandState) {
          scribeKey.setLeftCornerRadius()
          scribeKey.setShadow()
          scribeKey.toEscape()

          commandBar.set()
          commandBar.setCornerRadiusAndShadow()
          hideAutoActionPartitions()
        } else if [.alreadyPlural, .invalid].contains(commandState) {
          // Command bar as a view for invalid messages with a Scribe key to allow for new commands.
          scribeKey.setLeftCornerRadius()
          scribeKey.setShadow()

          commandBar.set()
          commandBar.setCornerRadiusAndShadow()
          hideAutoActionPartitions()
        } else if commandState == .idle {
          scribeKey.setFullCornerRadius()
          scribeKey.setEscShadow()
          
          commandBar.text = ""
          commandBar.hide()
          // Set autosuggestions on keyboard's first load.
          if keyboardLoad == true {
            conditionallySetAutoActionBtns()
          }
        }
      }

      let numRows = keyboard.count
      for row in 0...numRows - 1 {
        for idx in 0...keyboard[row].count - 1 {
          // Set up button as a key with its values and properties.
          let btn = KeyboardKey(type: .custom)
          btn.row = row
          btn.idx = idx
          btn.style()
          btn.setChar()
          btn.setCharSize()

          let key: String = btn.key

          // Pad before key is added.
          var leftPadding = CGFloat(0)
          if DeviceType.isPhone
            && key == "y"
            && ["German", "Swedish"].contains(controllerLanguage)
            && commandState != .translate {
            leftPadding = keyWidth / 3
            addPadding(to: stackView2, width: leftPadding, key: "y")
          }
          if DeviceType.isPhone
            && key == "a"
            && (controllerLanguage == "Portuguese"
                || controllerLanguage == "Italian"
                || commandState == .translate) {
            leftPadding = keyWidth / 4
            addPadding(to: stackView1, width: leftPadding, key: "a")
          }
          if DeviceType.isPad
            && key == "a"
            && (controllerLanguage == "Portuguese"
                || controllerLanguage == "Italian"
                || commandState == .translate) {
            leftPadding = keyWidth / 3
            addPadding(to: stackView1, width: leftPadding, key: "a")
          }
          if DeviceType.isPad
            && key == "@"
            && (controllerLanguage == "Portuguese"
                || controllerLanguage == "Italian"
                || commandState == .translate) {
            leftPadding = keyWidth / 3
            addPadding(to: stackView1, width: leftPadding, key: "@")
          }
          if DeviceType.isPad
            && key == "$"
            && controllerLanguage == "Italian" {
            leftPadding = keyWidth / 3
            addPadding(to: stackView1, width: leftPadding, key: "$")
          }
          if DeviceType.isPad
            && key == "€"
            && (controllerLanguage == "Portuguese"
                || commandState == .translate) {
            leftPadding = keyWidth / 3
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
            let deleteLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(deleteLongPressed(_:)))
            btn.addGestureRecognizer(deleteLongPressRecognizer)
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
            if [.translate, .conjugate, .plural].contains(commandState) {
              styleIconBtn(btn: btn, color: keyCharColor, iconName: "arrowtriangle.right.fill")
            } else {
              styleIconBtn(btn: btn, color: keyCharColor, iconName: "arrow.turn.down.left")
            }
          }

          if key == "delete" {
            styleIconBtn(btn: btn, color: keyCharColor, iconName: "delete.left")
          }

          // Setting key pop functionality.
          let keyHoldPop = UILongPressGestureRecognizer(
            target: self,
            action: #selector(genHoldPopUpView(sender:))
          )
          keyHoldPop.minimumPressDuration = 0.125

         if allNonSpecialKeys.contains(key) {
            btn.addTarget(self, action: #selector(genPopUpView), for: .touchDown)
            btn.addGestureRecognizer(keyHoldPop)
          }

          // Pad after key is added.
          var rightPadding = CGFloat(0)
          if DeviceType.isPhone
            && key == "m"
            && ["German", "Swedish"].contains(controllerLanguage)
              && commandState != .translate {
            rightPadding = keyWidth / 3
            addPadding(to: stackView2, width: rightPadding, key: "m")
          }
          if DeviceType.isPhone
            && key == "l"
            && (controllerLanguage == "Portuguese"
                || controllerLanguage == "Italian"
                || commandState == .translate) {
            rightPadding = keyWidth / 4
            addPadding(to: stackView1, width: rightPadding, key: "l")
          }

          // Set the width of the key given device and the given key.
          btn.adjustKeyWidth()

          // Extend button touch areas.
          var widthOfSpacing = CGFloat(0)
          if keyboardState == .letters {
            widthOfSpacing = (
              (UIScreen.main.bounds.width - 6.0)
              - (CGFloat(letterKeys[0].count) * keyWidth)
              ) / (CGFloat(letterKeys[0].count)
              - 1.0
            )
          } else {
            widthOfSpacing = (
              (UIScreen.main.bounds.width - 6.0)
              - (CGFloat(numberKeys[0].count) * numSymKeyWidth)
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

      scribeKey.toEscape()
      scribeKey.setLeftCornerRadius()

      commandBar.backgroundColor = commandBarColor
      commandBarBlend.backgroundColor = commandBarColor
      commandBar.textColor = keyCharColor

      deactivateBtn(btn: conjugateKey)
      deactivateBtn(btn: translateKey)
      deactivateBtn(btn: pluralKey)

      activateConjugationDisplay()
      setConjugationState()

      styleBtn(btn: conjugateShiftLeft, title: "", radius: keyCornerRadius)
      styleIconBtn(btn: conjugateShiftLeft, color: keyCharColor, iconName: "chevron.left")
      styleBtn(btn: conjugateShiftRight, title: "", radius: keyCornerRadius)
      styleIconBtn(btn: conjugateShiftRight, color: keyCharColor, iconName: "chevron.right")
    }
  }

  // MARK: Button Actions

  /// Triggers actions based on the press of a key.
  ///
  /// - Parameters
  ///   - sender: the button pressed as sender.
  @IBAction func executeKeyActions(_ sender: UIButton) {
    guard let originalKey = sender.layer.value(
      forKey: "original"
    ) as? String,
      let keyToDisplay = sender.layer.value(forKey: "keyToDisplay") as? String else {
        return
      }

    guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else { return }
    sender.backgroundColor = isSpecial ? specialKeyColor : keyColor

    // Disable the possibility of a double shift call.
    if originalKey != "shift" {
      capsLockPossible = false
    }
    // Disable the possibility of a double space period call.
    if originalKey != spaceBar {
      doubleSpacePeriodPossible = false
    }

    switch originalKey {
    case "Scribe":
      if proxy.selectedText != nil && [.idle, .select, .alreadyPlural, .invalid].contains(commandState) { // annotate word
        if [.select, .alreadyPlural, .invalid].contains(commandState) {
          commandState = .idle
        }
        loadKeys()
        selectedNounAnnotation(
          commandBar: commandBar,
          nounAnnotationDisplay: getNounAnnotationLabels(),
          annotationDisplay: getAnnotationLabels()
        )
        selectedPrepAnnotation(
          commandBar: commandBar,
          prepAnnotationDisplay: getPrepAnnotationLabels()
        )
      } else {
        if [.translate, .conjugate, .selectConjugation, .plural].contains(commandState) { // escape
          commandState = .idle
        } else if [.idle, .alreadyPlural, .invalid].contains(commandState) { // ScribeKey
          commandState = .select
          activateBtn(btn: translateKey)
          activateBtn(btn: conjugateKey)
          activateBtn(btn: pluralKey)
        } else { // escape
          commandState = .idle
        }
        loadKeys()
      }

    case "return":
      if ![.translate, .conjugate, .plural].contains(commandState) { // normal return button
        proxy.insertText("\n")
        clearCommandBar()
      } else if commandState == .translate {
        queryTranslation(commandBar: commandBar)
      } else if commandState == .conjugate {
        resetConjugationState()
        let triggerConjugationTbl = triggerConjugation(commandBar: commandBar)
        if triggerConjugationTbl == true {
          commandState = .selectConjugation
          loadKeys()
          return // go to conjugation view
        } else {
          commandState = .invalid
        }
      } else if commandState == .plural {
        queryPlural(commandBar: commandBar)
      }

      if [.invalid, .alreadyPlural].contains(commandState) { // invalid state
        loadKeys()
        autoCapAtStartOfProxy()

        if commandState == .invalid {
          commandBar.text = commandPromptSpacing + invalidCommandMsg
        } else if commandState == .alreadyPlural {
          commandBar.text = commandPromptSpacing + alreadyPluralMsg
        }
        commandBar.textColor = keyCharColor
        return
      } else if [.translate, .plural].contains(commandState) { // functional commands above
        autoActionState = .suggest
        commandState = .idle
        clearCommandBar()
        autoCapAtStartOfProxy()
        loadKeys()
        conditionallyDisplayAnnotation()
      }

    case "Translate":
      commandState = .translate
      // Always start in letters with a new keyboard.
      keyboardState = .letters
      loadKeys()
      commandBar.textColor = keyCharColor
      commandBar.attributedText = translatePromptAndColorPlaceholder

    case "Conjugate":
      commandState = .conjugate
      loadKeys()
      commandBar.textColor = keyCharColor
      commandBar.attributedText = conjugatePromptAndColorPlaceholder

    case "Plural":
      commandState = .plural
      if controllerLanguage == "German" { // capitalize for nouns
        if shiftButtonState == .normal {
          shiftButtonState = .shift
        }
      }
      loadKeys()
      commandBar.textColor = keyCharColor
      commandBar.attributedText = pluralPromptAndColorPlaceholder

    case "shiftConjugateLeft":
      conjugationStateLeft()
      loadKeys()

    case "shiftConjugateRight":
      conjugationStateRight()
      loadKeys()

    case "firstPersonSingular":
      returnConjugation(keyPressed: sender, requestedTense: tenseFPS)
      autoActionState = .suggest
      loadKeys()

    case "secondPersonSingular":
      returnConjugation(keyPressed: sender, requestedTense: tenseSPS)
      autoActionState = .suggest
      loadKeys()

    case "thirdPersonSingular":
      returnConjugation(keyPressed: sender, requestedTense: tenseTPS)
      autoActionState = .suggest
      loadKeys()

    case "firstPersonPlural":
      returnConjugation(keyPressed: sender, requestedTense: tenseFPP)
      autoActionState = .suggest
      loadKeys()

    case "secondPersonPlural":
      returnConjugation(keyPressed: sender, requestedTense: tenseSPP)
      autoActionState = .suggest
      loadKeys()

    case "thirdPersonPlural":
      returnConjugation(keyPressed: sender, requestedTense: tenseTPP)
      autoActionState = .suggest
      loadKeys()

    case "conjugateTopLeft":
      returnConjugation(keyPressed: sender, requestedTense: tenseTopLeft)
      autoActionState = .suggest
      loadKeys()

    case "conjugateTopRight":
      returnConjugation(keyPressed: sender, requestedTense: tenseTopRight)
      autoActionState = .suggest
      loadKeys()

    case "conjugateBottomLeft":
      returnConjugation(keyPressed: sender, requestedTense: tenseBottomLeft)
      autoActionState = .suggest
      loadKeys()

    case "conjugateBottomRight":
      returnConjugation(keyPressed: sender, requestedTense: tenseBottomRight)
      autoActionState = .suggest
      loadKeys()

    case "AutoAction1":
      executeAutoAction(keyPressed: translateKey)

    case "AutoAction2":
      executeAutoAction(keyPressed: conjugateKey)

    case "AutoAction3":
      executeAutoAction(keyPressed: pluralKey)

    case "delete":
      if ![.translate, .conjugate, .plural].contains(commandState) {
        // Control shift state on delete.
        if keyboardState == .letters && shiftButtonState == .shift && proxy.documentContextBeforeInput != nil {
          shiftButtonState = .normal
          loadKeys()
        } else if keyboardState == .letters && shiftButtonState == .normal && proxy.documentContextBeforeInput == nil {
          autoCapAtStartOfProxy()
          pastStringInTextProxy = ""
        }

        handleDeleteButtonPressed()
        clearCommandBar()

        autoActionState = .complete
        conditionallySetAutoActionBtns()
      } else {
        // Shift state if the user presses delete when the prompt is present.
        if allPrompts.contains((commandBar?.text!)!) || allColoredPrompts.contains(commandBar.attributedText!) {
          shiftButtonState = .shift // Auto-capitalization
          loadKeys()
          // Function call required due to return.
          // Not including means placeholder is never added on last delete action.
          commandBar.conditionallyAddPlaceholder()
          return
        }

        handleDeleteButtonPressed()

        // Inserting the placeholder when commandBar text is deleted.
        commandBar.conditionallyAddPlaceholder()
      }

    case spaceBar:
      autoActionState = .suggest
      commandBar.conditionallyRemovePlaceholder()
      if ![.translate, .conjugate, .plural].contains(commandState) {
        proxy.insertText(" ")
        if [". ", "? ", "! "].contains(proxy.documentContextBeforeInput?.suffix(2)) {
          shiftButtonState = .shift
        }
        if keyboardState != .letters {
          changeKeyboardToLetterKeys()
        }
      } else {
        commandBar.text! = (commandBar?.text!.insertPriorToCursor(char: " "))!
        if [
          ". " + commandCursor,
          "? " + commandCursor,
          "! " + commandCursor
        ].contains(String(commandBar.text!.suffix(3))) {
          shiftButtonState = .shift
        }
        if keyboardState != .letters {
          changeKeyboardToLetterKeys()
        }
      }
      
      secondaryPastStringOnDelete = pastStringInTextProxy
      pastStringInTextProxy = proxy.documentContextBeforeInput ?? ""
      conditionallySetAutoActionBtns()
      conditionallyDisplayAnnotation()

      if proxy.documentContextBeforeInput?.suffix("  ".count) == "  " {
        clearCommandBar()
      }
      doubleSpacePeriodPossible = true

    case "'":
      // Change back to letter keys.
      commandBar.conditionallyRemovePlaceholder()
      if ![.translate, .conjugate, .plural].contains(commandState) {
        proxy.insertText("'")
      } else {
        commandBar.text! = (commandBar.text!.insertPriorToCursor(char: "'"))
      }
      changeKeyboardToLetterKeys()
      clearCommandBar()

    case "shift":
      shiftButtonState = shiftButtonState == .normal ? .shift : .normal
      loadKeys()
      clearCommandBar()
      capsLockPossible = true

    case "123", ".?123":
      changeKeyboardToNumberKeys()
      clearCommandBar()

    case "#+=":
      changeKeyboardToSymbolKeys()
      clearCommandBar()

    case "ABC", "АБВ":
      changeKeyboardToLetterKeys()
      clearCommandBar()
      autoCapAtStartOfProxy()

    case "selectKeyboard":
      self.advanceToNextInputMode()

    case "hideKeyboard":
      self.dismissKeyboard()

    default:
      autoActionState = .complete
      commandBar.conditionallyRemovePlaceholder()
      if shiftButtonState == .shift {
        shiftButtonState = .normal
        loadKeys()
      }
      if [.idle, .select, .alreadyPlural, .invalid].contains(commandState) {
        proxy.insertText(keyToDisplay)
        clearCommandBar()
      } else {
        commandBar.text = commandBar.text!.insertPriorToCursor(char: keyToDisplay)
      }
    }

    // Cancel already plural and invalid states after another key press.
    if [.alreadyPlural, .invalid].contains(commandState) {
      commandState = .idle
      loadKeys()
    }

    // Add partitions if the keyboard states dictate.
    conditionallyShowAutoActionPartitions()
    conditionallySetAutoActionBtns()

    // Remove alternates view if it's present.
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
      alternatesShapeLayer.removeFromSuperlayer()
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
    guard var originalKey = sender.layer.value(forKey: "original") as? String else { return }

    let touch: UITouch = event.allTouches!.first!

    // Caps lock given two taps of shift.
    if touch.tapCount == 2 && originalKey == "shift" && capsLockPossible == true {
      shiftButtonState = .caps
      loadKeys()
      clearCommandBar()
      conditionallySetAutoActionBtns()
    }

    // To make sure that the user can still use the double space period shortcut after numbers and symbols.
    let punctuationThatCancelsShortcut = ["?", "!", ",", ".", ":", ";", "-"]
    if originalKey != "shift" && proxy.documentContextBeforeInput?.count != 1 && ![.translate, .conjugate, .plural].contains(commandState) {
      let charBeforeSpace = String(Array(proxy.documentContextBeforeInput!).secondToLast()!)
      if punctuationThatCancelsShortcut.contains(charBeforeSpace) {
        originalKey = "Cancel shortcut"
      }
    } else if [.translate, .conjugate, .plural].contains(commandState) {
      let charBeforeSpace = String(Array((commandBar?.text!)!).secondToLast()!)
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
      if proxy.documentContextBeforeInput?.suffix(2) != "  " && ![.translate, .conjugate, .plural].contains(commandState) {
        proxy.deleteBackward()
        proxy.insertText(". ")
        keyboardState = .letters
        shiftButtonState = .shift
        loadKeys()
      // The fist condition prevents a period if the prior characters are spaces as the user wants a series of spaces.
      } else if commandBar.text!.suffix(2) != "  " && [.translate, .conjugate, .plural].contains(commandState) {
        commandBar.text! = (commandBar?.text!.deletePriorToCursor())!
        commandBar.text! = (commandBar?.text!.insertPriorToCursor(char: ". "))!
        keyboardState = .letters
        shiftButtonState = .shift
        loadKeys()
      }
      clearCommandBar()
    }
  }

  /// Defines the criteria under which delete is long pressed.
  ///
  /// - Parameters
  ///   - gesture: the gesture that was received.
  @objc func deleteLongPressed(_ gesture: UIGestureRecognizer) {
    // Prevent the command state prompt from being deleted.
    if [.translate, .conjugate, .plural].contains(commandState) && allPrompts.contains((commandBar?.text!)!) {
      gesture.state = .cancelled
      commandBar.conditionallyAddPlaceholder()
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
    guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else { return }
    sender.backgroundColor = isSpecial ? specialKeyColor : keyColor
  }

  /// Generates a pop up of the key pressed.
  ///
  /// - Parameters
  ///   - key: the key pressed.
  @objc func genPopUpView(key: UIButton) {
    let charPressed: String = key.layer.value(forKey: "original") as? String ?? ""
    let displayChar: String = key.layer.value(forKey: "keyToDisplay") as? String ?? ""
    genKeyPop(key: key, layer: keyPopLayer, char: charPressed, displayChar: displayChar)

    self.view.layer.addSublayer(keyPopLayer)
    self.view.addSubview(keyPopChar)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.125) {
      keyPopLayer.removeFromSuperlayer()
      keyPopChar.removeFromSuperview()
    }
  }

  /// Generates a pop up of the key long pressed.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func genHoldPopUpView(sender: UILongPressGestureRecognizer) {
    // Derive which button was pressed and get its alternates.
    guard let key: UIButton = sender.view as? UIButton else { return }
    let charPressed: String = key.layer.value(forKey: "original") as? String ?? ""
    let displayChar: String = key.layer.value(forKey: "keyToDisplay") as? String ?? ""

    // Timer is short as the alternates view gets canceled by sender.state.changed.
    _ = Timer.scheduledTimer(withTimeInterval: 0.00001, repeats: false) { (_) in
      if keysWithAlternates.contains(charPressed) {
        self.setAlternatesView(sender: sender)
        keyHoldPopLayer.removeFromSuperlayer()
        keyHoldPopChar.removeFromSuperview()
      }
    }

    switch sender.state {
    case .began:
      genKeyPop(key: key, layer: keyHoldPopLayer, char: charPressed, displayChar: displayChar)
      self.view.layer.addSublayer(keyHoldPopLayer)
      self.view.addSubview(keyHoldPopChar)

    case .ended:
      // Remove the key hold pop up and execute key only if the alternates view isn't present.
      keyHoldPopLayer.removeFromSuperlayer()
      keyHoldPopChar.removeFromSuperview()
      if !keysWithAlternates.contains(charPressed) {
        executeKeyActions(key)
      } else if self.view.viewWithTag(1001) == nil {
        executeKeyActions(key)
      }
      keyUntouched(key)

    default:
      break
    }
  }

  /// Sets the characters that can be selected on an alternates view that is generated.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func setAlternatesView(sender: UILongPressGestureRecognizer) {
    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }

    // Derive which button was pressed and get its alternates.
    guard let key: UIButton = sender.view as? UIButton else { return }
    genAlternatesView(key: key)

    alternateBtnStartX = 5.0
    var alternatesBtnY = key.frame.height * 0.15
    if DeviceType.isPad {
      alternatesBtnY = key.frame.height * 0.2
    }
    for char in alternateKeys {
      let alternateKey: KeyboardKey = KeyboardKey(
        frame: CGRect(
          x: alternateBtnStartX,
          y: alternatesBtnY,
          width: key.frame.width,
          height: alternatesBtnHeight
        )
      )
      if shiftButtonState == .normal || char == "ß" {
        alternateKey.setTitle(char, for: .normal)
      } else {
        alternateKey.setTitle(char.capitalized, for: .normal)
      }
      alternateKey.setCharSize()
      alternateKey.setTitleColor(keyCharColor, for: .normal)
      alternateKey.layer.cornerRadius = keyCornerRadius

      alternatesKeyView.addSubview(alternateKey)
      if char == alternateKeys.first && keysWithAlternatesLeft.contains(char) {
        setBtn(btn: alternateKey, color: commandKeyColor, name: char, canCap: true, isSpecial: false)
      } else if char == alternateKeys.last && keysWithAlternatesRight.contains(char) {
        setBtn(btn: alternateKey, color: commandKeyColor, name: char, canCap: true, isSpecial: false)
      } else {
        setBtn(btn: alternateKey, color: keyColor, name: char, canCap: true, isSpecial: false)
      }
      activateBtn(btn: alternateKey)

      alternateBtnStartX += (key.frame.width + 3.0)
    }

    // If alternateKeysView is already added than remove and then add again.
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
      alternatesShapeLayer.removeFromSuperlayer()
    }

    self.view.layer.addSublayer(alternatesShapeLayer)
    self.view.addSubview(alternatesKeyView)
  }
}
