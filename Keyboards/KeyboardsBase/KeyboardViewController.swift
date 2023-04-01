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

  private var tipView: ToolTipView?

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

    loadKeys()

    // Set tap handler for info button on CommandBar
    commandBar.infoButtonTapHandler = { [weak self] in
      commandState = .displayInformation
      //resetCaseDeclensionState()
      conjViewShiftButtonsState = .leftInactive
      self?.loadKeys()
    }
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
    // If alternateKeysView is already added than remove it so it's not colored wrong.
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
      alternatesShapeLayer.removeFromSuperlayer()
    }
    proxy = textDocumentProxy as UITextDocumentProxy
    keyboardState = .letters
    annotationState = false
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
    keyboardLoad = true
    loadKeys()
    keyboardLoad = false
  }

  /// Includes:
  /// - updateViewConstraints to change the keyboard height
  /// - A call to loadKeys to reload the display after an orientation change
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    updateViewConstraints()
    keyboardLoad = true
    loadKeys()
    keyboardLoad = false
  }

  /// Overrides the previous color variables if the user switches between light and dark mode.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    // If alternateKeysView is already added than remove it so it's not colored wrong.
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
      alternatesShapeLayer.removeFromSuperlayer()
    }
    annotationState = false
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


  // Logic to create notification tooltip.
  func createInformationStateDatasource(text: NSMutableAttributedString, backgroundColor: UIColor) -> ToolTipViewDatasource {
    let theme = ToolTipViewTheme(backgroundColor: backgroundColor, textFont: nil, textColor: keyCharColor, textAlignment: .center, cornerRadius: 10, masksToBounds: true)

    return ToolTipViewDatasource(content: text, theme: theme)
  }

  func setInformationState() {
    let contentData = InformationToolTipData.getContent()
    let datasources = contentData.enumerated().compactMap({ index, text in
      createInformationStateDatasource(text: text, backgroundColor: keyColor)
    })
    tipView = ToolTipView(datasources: datasources)

    bindTooltipview()

    guard let tipView = tipView else { return }
    tipView.translatesAutoresizingMaskIntoConstraints = false
    formKeySingle.addSubview(tipView)
    tipView.leadingAnchor.constraint(
      equalTo: formKeySingle.leadingAnchor, constant: DeviceType.isPhone ? 15: 40
    ).isActive = true
    tipView.trailingAnchor.constraint(
      equalTo: formKeySingle.trailingAnchor, constant: DeviceType.isPhone ? -15: -40
    ).isActive = true
    tipView.topAnchor.constraint(equalTo: formKeySingle.topAnchor, constant: 8).isActive = true
    tipView.bottomAnchor.constraint(equalTo: formKeySingle.bottomAnchor, constant: -5).isActive = true
    styleBtn(btn: formKeySingle, title: "", radius: keyCornerRadius)
  }

  private func bindTooltipview() {
    tipView?.didUpdatePage = { [weak self] currentState in
      conjViewShiftButtonsState = currentState

      guard let weakSelf = self else { return }

      switch currentState {
      case .rightInactive:
        weakSelf.shiftFormsDisplayRight.isUserInteractionEnabled = false
      case .leftInactive:
        weakSelf.shiftFormsDisplayLeft.isUserInteractionEnabled = false
      case .bothActive:
        weakSelf.activateBtn(btn: weakSelf.shiftFormsDisplayLeft)
        weakSelf.activateBtn(btn: weakSelf.shiftFormsDisplayRight)
      default:
        break
      }

      weakSelf.styleShiftButtons()
    }
  }

  /// Styles the shift buttons for the displayInformation states.
  private func styleShiftButtons() {
    styleBtn(btn: shiftFormsDisplayLeft, title: "", radius: keyCornerRadius)
    styleIconBtn(
      btn: shiftFormsDisplayLeft,
      color: ![.bothInactive, .leftInactive].contains(conjViewShiftButtonsState) ? keyCharColor : specialKeyColor,
      iconName: "chevron.left"
    )
    styleBtn(btn: shiftFormsDisplayRight, title: "", radius: keyCornerRadius)
    styleIconBtn(
      btn: shiftFormsDisplayRight,
      color: ![.bothInactive, .rightInactive].contains(conjViewShiftButtonsState) ? keyCharColor : specialKeyColor,
      iconName: "chevron.right"
    )
  }

  /// Generates an array of the three autocomplete words.
  func getAutocompletions() {
    completionWords = [" ", " ", " "]
    if proxy.documentContextBeforeInput?.count != 0 {
      if let inString = proxy.documentContextBeforeInput {
        // To only focus on the current word as prefix in autocomplete.
        currentPrefix = inString.replacingOccurrences(of: pastStringInTextProxy, with: "")

        if currentPrefix.hasPrefix("(") || currentPrefix.hasPrefix("#") ||
          currentPrefix.hasPrefix("/") || currentPrefix.hasPrefix("\"") {
          currentPrefix = currentPrefix.replacingOccurrences(of: #"[\"(#\/]"#, with: "", options: .regularExpression)
        }

        // Post commands pastStringInTextProxy is "", so take last word.
        if currentPrefix.contains(" ") {
          currentPrefix = currentPrefix.components(
            separatedBy: " "
          ).last ?? ""
        }

        // If there's a line break, take the word after it.
        if currentPrefix.contains("\n") {
          currentPrefix = currentPrefix.components(
            separatedBy: "\n"
          ).last ?? ""
        }

        // Get options for completion that have start with the current prefix and are not just one letter.
        let stringOptions = autocompleteWords.filter { item in
          return item.lowercased().hasPrefix(currentPrefix.lowercased()) && item.count > 1
        }

        var i = 0
        if stringOptions.count <= 3 {
          while i < stringOptions.count {
            if shiftButtonState == .caps {
              completionWords[i] = stringOptions[i].uppercased()
            } else if currentPrefix.isCapitalized {
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
            } else if currentPrefix.isCapitalized {
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

  /// Gets consistent autosguestions for all pronouns in the given language.
  /// Note: currently only works for German, Spanish and French languages.
  func getPronounAutosuggestions() {
    let prefix = proxy.documentContextBeforeInput?.components(separatedBy: " ").secondToLast() ?? ""

    completionWords = [String]()
    var i = 0
    while i < 3 {
      var suggestion = verbs[verbsAfterPronounsArray[i]][pronounAutosuggestionTenses[prefix.lowercased()]!].string ?? verbsAfterPronounsArray[i]
      if suggestion == "REFLEXIVE_PRONOUN" && controllerLanguage == "Spanish" {
        suggestion = getESReflexivePronoun(pronoun: prefix.lowercased())
      }
      if shiftButtonState == .shift {
        completionWords.append(suggestion.capitalize())
      } else if shiftButtonState == .caps {
        completionWords.append(suggestion.uppercased())
      } else {
        completionWords.append(suggestion)
      }
      i += 1
    }
  }

  /// Generates an array of three words that serve as baseline autosuggestions.
  func getDefaultAutosuggestions() {
    var i = 0
    completionWords = [String]()
    if allowUndo {
      completionWords.append(previousWord)
      i += 1
    }
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
    var prefix = proxy.documentContextBeforeInput?.components(
      separatedBy: " "
    ).secondToLast() ?? ""

    // If there's a line break, take the word after it.
    if prefix.contains("\n") {
      prefix = prefix.components(
        separatedBy: "\n"
      ).last ?? ""
    }

    if prefix.isNumeric {
      completionWords = numericAutosuggestions
    } else if [ "French_AZERTY", "French_QWERTY", "German", "Spanish"].contains(controllerLanguage) && pronounAutosuggestionTenses.keys.contains(prefix.lowercased()) {
      getPronounAutosuggestions()
    } else {
      /// We have to consider these different cases as the key always has to match.
      /// Else, even if the lowercased prefix is present in the dictionary, if the actual prefix isn't present we won't get an output.
      if autosuggestions[prefix.lowercased()].exists() {
        let suggestions = autosuggestions[prefix.lowercased()].rawValue as! [String]
        completionWords = [String]()
        var i = 0
        if allowUndo {
          completionWords.append(previousWord)
          i += 1
        }
        while i < 3 {
          if shiftButtonState == .shift {
            completionWords.append(suggestions[i].capitalize())
          } else if shiftButtonState == .caps {
            completionWords.append(suggestions[i].uppercased())
          } else {
            if !nouns[suggestions[i]].exists() {
              completionWords.append(suggestions[i].lowercased())
            } else {
              completionWords.append(suggestions[i])
            }
          }
          i += 1
        }
      } else if autosuggestions[prefix.capitalize()].exists() {
        let suggestions = autosuggestions[prefix.capitalize()].rawValue as! [String]
        completionWords = [String]()
        var i = 0
        if allowUndo {
          completionWords.append(previousWord)
          i += 1
        }
        while i < 3 {
          if shiftButtonState == .shift {
            completionWords.append(suggestions[i].capitalize())
          } else if shiftButtonState == .caps {
            completionWords.append(suggestions[i].uppercased())
          } else {
            completionWords.append(suggestions[i])
          }
          i += 1
        }
      } else {
        getDefaultAutosuggestions()
      }
    }

    // Disable the third auto action button if we'll have emoji suggestions.
    if emojiAutosuggestions[prefix].exists() {
      for i in 0..<2 {
        let emojiDesc = emojiAutosuggestions[prefix][i]
        let emoji = emojiDesc["emoji"].rawValue as! String
        emojisToSuggestArray.append(emoji)
      }
      autoAction3Visible = false
      emojiSuggestVisible = true
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
      deactivateBtn(btn: emojiSuggest1)
      deactivateBtn(btn: emojiSuggest2)

      if autoAction1Visible == true {
        allowUndo = false
        shouldHighlightFirstCompletion = false
        // Highlight if the current prefix is the first autocompletion or there is only one available.
        if currentPrefix == completionWords[0] || (completionWords[0] != " " && completionWords[1] == " ") {
          shouldHighlightFirstCompletion = true
        }
        setBtn(btn: translateKey, color: shouldHighlightFirstCompletion ? keyColor.withAlphaComponent(0.5) : keyboardBgColor, name: "AutoAction1", canCap: false, isSpecial: false)
        styleBtn(btn: translateKey, title: completionWords[0], radius: commandKeyCornerRadius)
        activateBtn(btn: translateKey)
      }

      setBtn(btn: conjugateKey, color: keyboardBgColor, name: "AutoAction2", canCap: false, isSpecial: false)
      styleBtn(btn: conjugateKey, title: !autoAction1Visible ? completionWords[0] : completionWords[1], radius: commandKeyCornerRadius)
      activateBtn(btn: conjugateKey)

      if autoAction3Visible == true {
        setBtn(btn: pluralKey, color: keyboardBgColor, name: "AutoAction3", canCap: false, isSpecial: false)
        styleBtn(btn: pluralKey, title: !autoAction1Visible ? completionWords[1] : completionWords[2], radius: commandKeyCornerRadius)
        activateBtn(btn: pluralKey)
      } else if emojiSuggestVisible == true {
        setBtn(btn: emojiSuggest1, color: keyboardBgColor, name: "EmojiSuggest1", canCap: false, isSpecial: false)
        styleBtn(btn: emojiSuggest1, title: emojisToSuggestArray[0], radius: commandKeyCornerRadius)
        activateBtn(btn: emojiSuggest1)
        
        setBtn(btn: emojiSuggest2, color: keyboardBgColor, name: "EmojiSuggest2", canCap: false, isSpecial: false)
        styleBtn(btn: emojiSuggest2, title: emojisToSuggestArray[1], radius: commandKeyCornerRadius)
        activateBtn(btn: emojiSuggest2)
      }

      translateKey.layer.shadowColor = UIColor.clear.cgColor
      conjugateKey.layer.shadowColor = UIColor.clear.cgColor
      pluralKey.layer.shadowColor = UIColor.clear.cgColor
    }

    // Reset autocorrect and autosuggest button visibility.
    autoAction1Visible = true
    autoAction3Visible = true
  }

  /// Clears the text proxy when inserting using an auto action.
  /// Note: the completion is appended after the typed text if this is not ran.
  func clearPrefixFromTextFieldProxy() {
    // Only delete characters for autocomplete, not autosuggest.
    if currentPrefix != "" && autoActionState != .suggest {
      if proxy.documentContextBeforeInput?.count != 0 {
        for _ in 0..<currentPrefix.count {
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
    // Remove all prior annotations.
    annotationBtns.forEach { $0.removeFromSuperview() }
    annotationBtns.removeAll()
    annotationSeparators.forEach { $0.removeFromSuperview() }
    annotationSeparators.removeAll()

    // If user doesn't want the completion and wants what they typed back,
    // Completion is made the currentPrefix to be removed from the proxy.
    // Then autoActionButton title is inserted like normal.
    if allowUndo && completionWords.contains(previousWord) {
      // Auto Action state has to be .complete else clearPrefixFromTextFieldProxy() won't work.
      autoActionState = .complete
      currentPrefix = (proxy.documentContextBeforeInput?.components(separatedBy: " ").secondToLast() ?? "") + " "
      previousWord = ""
      allowUndo = false
    }

    clearPrefixFromTextFieldProxy()
    proxy.insertText(keyPressed.titleLabel?.text ?? "")
    autoActionState = .suggest
    proxy.insertText(" ")
    currentPrefix = ""
    if shiftButtonState == .shift {
      shiftButtonState = .normal
      loadKeys()
    }
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

  /// Deletes in the proxy or command bar given the current constraints.
  func handleDeleteButtonPressed() {
    if [.idle, .selectCommand, .alreadyPlural, .invalid].contains(commandState) {
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
  @IBOutlet var emojiSuggest1: UIButton!
  @IBOutlet var emojiSuggest2: UIButton!

  /// Sets up all buttons that are associated with Scribe commands.
  func setCommandBtns() {
    setBtn(btn: translateKey, color: commandKeyColor, name: "Translate", canCap: false, isSpecial: false)
    setBtn(btn: conjugateKey, color: commandKeyColor, name: "Conjugate", canCap: false, isSpecial: false)
    setBtn(btn: pluralKey, color: commandKeyColor, name: "Plural", canCap: false, isSpecial: false)

    activateBtn(btn: translateKey)
    activateBtn(btn: conjugateKey)
    activateBtn(btn: pluralKey)
  }

  // MARK: Conjugation Variables and Functions
  // Note that we use "form" to describe both conjugations and declensions.
  @IBOutlet var shiftFormsDisplayLeft: UIButton!
  @IBOutlet var shiftFormsDisplayRight: UIButton!

  @IBOutlet var formKeyFPS: UIButton!
  @IBOutlet var formKeySPS: UIButton!
  @IBOutlet var formKeyTPS: UIButton!
  @IBOutlet var formKeyFPP: UIButton!
  @IBOutlet var formKeySPP: UIButton!
  @IBOutlet var formKeyTPP: UIButton!

  /// Returns all buttons for the 3x2 conjugation display.
  func get3x2FormDisplayButtons() -> [UIButton] {
    let conjugationButtons: [UIButton] = [
      formKeyFPS, formKeySPS, formKeyTPS, formKeyFPP, formKeySPP, formKeyTPP
    ]

    return conjugationButtons
  }

  // Labels for the conjugation view buttons.
  // Note that we're using buttons as labels weren't allowing for certain constraints to be set.
  @IBOutlet var formLblFPS: UIButton!
  @IBOutlet var formLblSPS: UIButton!
  @IBOutlet var formLblTPS: UIButton!
  @IBOutlet var formLblFPP: UIButton!
  @IBOutlet var formLblSPP: UIButton!
  @IBOutlet var formLblTPP: UIButton!

  /// Returns all labels for the 3x2 conjugation display.
  func get3x2FormDisplayLabels() -> [UIButton] {
    let conjugationLabels: [UIButton] = [
      formLblFPS, formLblSPS, formLblTPS, formLblFPP, formLblSPP, formLblTPP
    ]

    return conjugationLabels
  }

  /// Sets up all buttons and labels that are associated with the 3x2 conjugation display.
  func setFormDisplay3x2View() {
    setBtn(btn: formKeyFPS, color: keyColor, name: "firstPersonSingular", canCap: false, isSpecial: false)
    setBtn(btn: formKeySPS, color: keyColor, name: "secondPersonSingular", canCap: false, isSpecial: false)
    setBtn(btn: formKeyTPS, color: keyColor, name: "thirdPersonSingular", canCap: false, isSpecial: false)
    setBtn(btn: formKeyFPP, color: keyColor, name: "firstPersonPlural", canCap: false, isSpecial: false)
    setBtn(btn: formKeySPP, color: keyColor, name: "secondPersonPlural", canCap: false, isSpecial: false)
    setBtn(btn: formKeyTPP, color: keyColor, name: "thirdPersonPlural", canCap: false, isSpecial: false)

    for btn in get3x2FormDisplayButtons() {
      activateBtn(btn: btn)
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get3x2FormDisplayButtons() {
        btn.titleLabel?.font =  .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
      }
    }
  }

  @IBOutlet var formKeyTop: UIButton!
  @IBOutlet var formKeyMiddle: UIButton!
  @IBOutlet var formKeyBottom: UIButton!

  /// Returns all buttons for the 3x1 conjugation display
  func get3x1FormDisplayButtons() -> [UIButton] {
    let conjugationButtons: [UIButton] = [
      formKeyTop, formKeyMiddle, formKeyBottom
    ]

    return conjugationButtons
  }

  @IBOutlet var formLblTop: UIButton!
  @IBOutlet var formLblMiddle: UIButton!
  @IBOutlet var formLblBottom: UIButton!

  /// Returns all labels for the 3x1 conjugation display.
  func get3x1FormDisplayLabels() -> [UIButton] {
    let conjugationLabels: [UIButton] = [
      formLblTop, formLblMiddle, formLblBottom
    ]

    return conjugationLabels
  }

  /// Sets up all buttons and labels that are associated with the 3x1 conjugation display.
  func setFormDisplay3x1View() {
    setBtn(btn: formKeyTop, color: keyColor, name: "formTop", canCap: false, isSpecial: false)
    setBtn(btn: formKeyMiddle, color: keyColor, name: "formMiddle", canCap: false, isSpecial: false)
    setBtn(btn: formKeyBottom, color: keyColor, name: "formBottom", canCap: false, isSpecial: false)

    for btn in get3x1FormDisplayButtons() {
      activateBtn(btn: btn)
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get3x1FormDisplayButtons() {
        btn.titleLabel?.font =  .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
      }
    }
  }

  @IBOutlet var formKeyTL: UIButton!
  @IBOutlet var formKeyTR: UIButton!
  @IBOutlet var formKeyBL: UIButton!
  @IBOutlet var formKeyBR: UIButton!

  /// Returns all buttons for the 2x2 conjugation display
  func get2x2FormDisplayButtons() -> [UIButton] {
    let conjugationButtons: [UIButton] = [
      formKeyTL, formKeyTR, formKeyBL, formKeyBR
    ]

    return conjugationButtons
  }

  @IBOutlet var formLblTL: UIButton!
  @IBOutlet var formLblTR: UIButton!
  @IBOutlet var formLblBL: UIButton!
  @IBOutlet var formLblBR: UIButton!

  /// Returns all labels for the 2x2 conjugation display.
  func get2x2FormDisplayLabels() -> [UIButton] {
    let conjugationLabels: [UIButton] = [
      formLblTL, formLblTR, formLblBL, formLblBR
    ]

    return conjugationLabels
  }

  /// Sets up all buttons and labels that are associated with the 2x2 conjugation display.
  func setFormDisplay2x2View() {
    setBtn(btn: formKeyTL, color: keyColor, name: "formTopLeft", canCap: false, isSpecial: false)
    setBtn(btn: formKeyTR, color: keyColor, name: "formTopRight", canCap: false, isSpecial: false)
    setBtn(btn: formKeyBL, color: keyColor, name: "formBottomLeft", canCap: false, isSpecial: false)
    setBtn(btn: formKeyBR, color: keyColor, name: "formBottomRight", canCap: false, isSpecial: false)

    for btn in get2x2FormDisplayButtons() {
      activateBtn(btn: btn)
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get2x2FormDisplayButtons() {
        btn.titleLabel?.font =  .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
      }
    }
  }

  @IBOutlet var formKeyLeft: UIButton!
  @IBOutlet var formKeyRight: UIButton!

  /// Returns all buttons for the 1x2 conjugation display
  func get1x2FormDisplayButtons() -> [UIButton] {
    let conjugationButtons: [UIButton] = [
      formKeyLeft, formKeyRight
    ]

    return conjugationButtons
  }

  @IBOutlet var formLblLeft: UIButton!
  @IBOutlet var formLblRight: UIButton!

  /// Returns all labels for the 1x2 conjugation display.
  func get1x2FormDisplayLabels() -> [UIButton] {
    let conjugationLabels: [UIButton] = [
      formLblLeft, formLblRight
    ]

    return conjugationLabels
  }

  /// Sets up all buttons and labels that are associated with the 3x1 conjugation display.
  func setFormDisplay1x2View() {
    setBtn(btn: formKeyLeft, color: keyColor, name: "formLeft", canCap: false, isSpecial: false)
    setBtn(btn: formKeyRight, color: keyColor, name: "formRight", canCap: false, isSpecial: false)

    for btn in get1x2FormDisplayButtons() {
      activateBtn(btn: btn)
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get1x2FormDisplayButtons() {
        btn.titleLabel?.font =  .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
      }
    }
  }

  @IBOutlet var formKeySingle: UIButton!

  /// Returns all buttons for the 1x1 conjugation display
  func get1x1FormDisplayButtons() -> [UIButton] {
    let conjugationButtons: [UIButton] = [
      formKeySingle
    ]

    return conjugationButtons
  }

  @IBOutlet var formLblSingle: UIButton!

  /// Returns all labels for the 1x1 conjugation display.
  func get1x1FormDisplayLabels() -> [UIButton] {
    let conjugationLabels: [UIButton] = [
      formLblSingle
    ]

    return conjugationLabels
  }

  /// Sets up all buttons and labels that are associated with the 1x1 conjugation display.
  func setFormDisplay1x1View() {
    setBtn(btn: formKeySingle, color: keyColor, name: "formSingle", canCap: false, isSpecial: false)

    for btn in get1x1FormDisplayButtons() {
      activateBtn(btn: btn)
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get1x1FormDisplayButtons() {
        btn.titleLabel?.font =  .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
      }
    }
  }

  /// Sets up all buttons and labels for the conjugation view given constraints to determine the dimensions.
  func setConjugationBtns() {
    // Set the conjugation view to 2x2 for Swedish and Russian past tense.
    if controllerLanguage == "Swedish" {
      formsDisplayDimensions = .view2x2
    } else if controllerLanguage == "Russian" && ruConjugationState == .past {
      formsDisplayDimensions = .view2x2
    } else if
      commandState == .selectCaseDeclension
      && controllerLanguage == "German"
      && deCaseVariantDeclensionState != .disabled {
      switch deCaseVariantDeclensionState {
      case .disabled:
        break
      case .accusativePersonalSPS, .dativePersonalSPS, .genitivePersonalSPS,
          .accusativePossessiveSPS, .dativePossessiveSPS, .genitivePossessiveSPS:
        formsDisplayDimensions = .view1x2
      case .accusativePersonalTPS, .dativePersonalTPS, .genitivePersonalTPS,
          .accusativePossessiveTPS, .dativePossessiveTPS, .genitivePossessiveTPS:
        formsDisplayDimensions = .view3x1
      case .accusativePossessiveFPS, .accusativePossessiveSPSInformal, .accusativePossessiveSPSFormal,
          .accusativePossessiveTPSMasculine, .accusativePossessiveTPSFeminine, .accusativePossessiveTPSNeutral,
          .accusativePossessiveFPP, .accusativePossessiveSPP, .accusativePossessiveTPP,
          .dativePossessiveFPS, .dativePossessiveSPSInformal, .dativePossessiveSPSFormal,
          .dativePossessiveTPSMasculine, .dativePossessiveTPSFeminine, .dativePossessiveTPSNeutral,
          .dativePossessiveFPP, .dativePossessiveSPP, .dativePossessiveTPP,
          .genitivePossessiveFPS, .genitivePossessiveSPSInformal, .genitivePossessiveSPSFormal,
          .genitivePossessiveTPSMasculine, .genitivePossessiveTPSFeminine, .genitivePossessiveTPSNeutral,
          .genitivePossessiveFPP, .genitivePossessiveSPP, .genitivePossessiveTPP:
        formsDisplayDimensions = .view2x2
      }
    } else if
      commandState == .selectCaseDeclension
      && controllerLanguage == "German"
      && [
        .accusative, .accusativeDemonstrative,
        .dative, .dativeDemonstrative,
        .genitive, .genitiveDemonstrative
      ].contains(deCaseDeclensionState) {
      formsDisplayDimensions = .view2x2
    } else if
      commandState == .displayInformation {
      formsDisplayDimensions = .view1x1
    } else {
      formsDisplayDimensions = .view3x2
    }

    // The base conjugation view is 3x2 for first, second, and third person in singular and plural.
    switch formsDisplayDimensions {
    case .view3x2:
      setFormDisplay3x2View()
    case .view3x1:
      setFormDisplay3x1View()
    case .view2x2:
      setFormDisplay2x2View()
    case .view1x2:
      setFormDisplay1x2View()
    case .view1x1:
      setFormDisplay1x1View()
    }

    // Setup the view shift buttons.
    setBtn(
      btn: shiftFormsDisplayLeft,
      color: keyColor,
      name: "shiftFormsDisplayLeft",
      canCap: false,
      isSpecial: false
    )
    setBtn(
      btn: shiftFormsDisplayRight,
      color: keyColor,
      name: "shiftFormsDisplayRight",
      canCap: false,
      isSpecial: false
    )

    if [.bothActive, .rightInactive].contains(conjViewShiftButtonsState) {
      activateBtn(btn: shiftFormsDisplayLeft)
    } else {
      shiftFormsDisplayLeft.isUserInteractionEnabled = false
    }
    if [.bothActive, .leftInactive].contains(conjViewShiftButtonsState) {
      activateBtn(btn: shiftFormsDisplayRight)
    } else {
      shiftFormsDisplayRight.isUserInteractionEnabled = false
    }

    // Make all labels clear and set their font for if they will be used.
    let allFormDisplayLabels: [UIButton] =
      get3x2FormDisplayLabels()
      + get3x1FormDisplayLabels()
      + get2x2FormDisplayLabels()
      + get1x2FormDisplayLabels()
      + get1x1FormDisplayLabels()
    for lbl in allFormDisplayLabels {
      lbl.backgroundColor = UIColor.clear
      lbl.setTitleColor(UITraitCollection.current.userInterfaceStyle == .light ? specialKeyColor : commandBarColor, for: .normal)
      lbl.isUserInteractionEnabled = false
      if DeviceType.isPad {
        lbl.titleLabel?.font =  .systemFont(ofSize: letterKeyWidth / 4)
      }
    }
  }

  /// Activates all buttons that are associated with the conjugation display.
  func activateConjugationDisplay() {
    if [.bothActive, .rightInactive].contains(conjViewShiftButtonsState) {
      activateBtn(btn: shiftFormsDisplayLeft)
    } else {
      shiftFormsDisplayLeft.isUserInteractionEnabled = false
    }
    if [.bothActive, .leftInactive].contains(conjViewShiftButtonsState) {
      activateBtn(btn: shiftFormsDisplayRight)
    } else {
      shiftFormsDisplayRight.isUserInteractionEnabled = false
    }

    switch formsDisplayDimensions {
    case .view3x2:
      for btn in get3x2FormDisplayButtons() {
        activateBtn(btn: btn)
      }

      for btn in get3x1FormDisplayButtons() + get2x2FormDisplayButtons() + get1x2FormDisplayButtons() {
        deactivateBtn(btn: btn)
      }
    case .view3x1:
      for btn in get3x1FormDisplayButtons() {
        activateBtn(btn: btn)
      }

      for btn in get3x2FormDisplayButtons() + get2x2FormDisplayButtons() + get1x2FormDisplayButtons() {
        deactivateBtn(btn: btn)
      }
    case .view2x2:
      for btn in get2x2FormDisplayButtons() {
        activateBtn(btn: btn)
      }

      for btn in get3x2FormDisplayButtons() + get3x1FormDisplayButtons() + get1x2FormDisplayButtons() {
        deactivateBtn(btn: btn)
      }
    case .view1x2:
      for btn in get1x2FormDisplayButtons() {
        activateBtn(btn: btn)
      }

      for btn in get3x2FormDisplayButtons() + get3x1FormDisplayButtons() + get2x2FormDisplayButtons() {
        deactivateBtn(btn: btn)
      }
    case .view1x1:
      break
    }
  }

  /// Deactivates all buttons that are associated with the conjugation display.
  func deactivateConjugationDisplay() {
    deactivateBtn(btn: shiftFormsDisplayLeft)
    shiftFormsDisplayLeft.tintColor = UIColor.clear
    deactivateBtn(btn: shiftFormsDisplayRight)
    shiftFormsDisplayRight.tintColor = UIColor.clear

    let allFormDisplayButtons: [UIButton] =
      get3x2FormDisplayButtons()
      + get3x1FormDisplayButtons()
      + get2x2FormDisplayButtons()
      + get1x2FormDisplayButtons()
      + get1x1FormDisplayButtons()
    let allFormDisplayLabels: [UIButton] =
      get3x2FormDisplayLabels()
      + get3x1FormDisplayLabels()
      + get2x2FormDisplayLabels()
      + get1x2FormDisplayLabels()
      + get1x1FormDisplayLabels()
    let allConjElements: [UIButton] = allFormDisplayButtons + allFormDisplayLabels

    for elem in allConjElements {
      deactivateBtn(btn: elem)
    }

    for lbl in allFormDisplayLabels {
      lbl.setTitle("", for: .normal)
    }
  }

  /// Assign the verb conjugations that will be selectable in the conjugation display.
  func assignVerbConjStates() {
    var conjugationStateFxn: () -> String = deGetConjugationState
    if controllerLanguage != "Swedish" {
      conjugationStateFxn = keyboardConjStateDict[controllerLanguage] as! () -> String
    }

    if !["Russian", "Swedish"].contains(controllerLanguage) {
      formFPS = conjugationStateFxn() + "FPS"
      formSPS = conjugationStateFxn() + "SPS"
      formTPS = conjugationStateFxn() + "TPS"
      formFPP = conjugationStateFxn() + "FPP"
      formSPP = conjugationStateFxn() + "SPP"
      formTPP = conjugationStateFxn() + "TPP"

    } else if controllerLanguage == "Russian" {
      if formsDisplayDimensions == .view3x2 {
        formFPS = ruGetConjugationState() + "FPS"
        formSPS = ruGetConjugationState() + "SPS"
        formTPS = ruGetConjugationState() + "TPS"
        formFPP = ruGetConjugationState() + "FPP"
        formSPP = ruGetConjugationState() + "SPP"
        formTPP = ruGetConjugationState() + "TPP"
      } else {
        formTopLeft = "pastMasculine"
        formTopRight = "pastFeminine"
        formBottomLeft = "pastNeutral"
        formBottomRight = "pastPlural"
      }

    } else if controllerLanguage == "Swedish" {
      let swedishTenses = svGetConjugationState()

      formTopLeft = swedishTenses[0]
      formTopRight = swedishTenses[1]
      formBottomLeft = swedishTenses[2]
      formBottomRight = swedishTenses[3]
    }
  }

  /// Sets the label of the conjugation state and assigns the current tenses that are accessed to label the buttons.
  func setVerbConjugationState() {
    // Assign the conjugations that will be selectable.
    assignVerbConjStates()

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

    // Assign labels that have been set by SetConjugationLabels function.
    // Other labels not assigned as they're not used in conjugation at this time.
    formLblFPS.setTitle("  " + (formLabelsDict["FPS"] ?? ""), for: .normal)
    formLblSPS.setTitle("  " + (formLabelsDict["SPS"] ?? ""), for: .normal)
    formLblTPS.setTitle("  " + (formLabelsDict["TPS"] ?? ""), for: .normal)
    formLblFPP.setTitle("  " + (formLabelsDict["FPP"] ?? ""), for: .normal)
    formLblSPP.setTitle("  " + (formLabelsDict["SPP"] ?? ""), for: .normal)
    formLblTPP.setTitle("  " + (formLabelsDict["TPP"] ?? ""), for: .normal)

    formLblTL.setTitle("  " + (formLabelsDict["TL"] ?? ""), for: .normal)
    formLblTR.setTitle("  " + (formLabelsDict["TR"] ?? ""), for: .normal)
    formLblBL.setTitle("  " + (formLabelsDict["BL"] ?? ""), for: .normal)
    formLblBR.setTitle("  " + (formLabelsDict["BR"] ?? ""), for: .normal)

    if formsDisplayDimensions == .view3x2 {
      allConjugations = [formFPS, formSPS, formTPS, formFPP, formSPP, formTPP]
      allConjugationBtns = get3x2FormDisplayButtons()
    } else {
      allConjugations = [formTopLeft, formTopRight, formBottomLeft, formBottomRight]
      allConjugationBtns = get2x2FormDisplayButtons()
    }

    // Populate conjugation view buttons.
    for index in 0..<allConjugations.count {
      if verbs[verbToConjugate][allConjugations[index]].string == "" {
        // Assign the invalid message if the conjugation isn't present in the directory.
        styleBtn(btn: allConjugationBtns[index], title: invalidCommandMsg, radius: keyCornerRadius)
      } else {
        conjugationToDisplay = verbs[verbToConjugate][allConjugations[index]].string!
        if inputWordIsCapitalized && deConjugationState != .indicativePerfect {
          conjugationToDisplay = conjugationToDisplay.capitalized
        }
        styleBtn(btn: allConjugationBtns[index], title: conjugationToDisplay, radius: keyCornerRadius)
      }
    }
  }

  /// Sets the label of the conjugation state and assigns pronoun conjugations for the given case.
  func setCaseDeclensionState() {
    // Set the view title and its labels.
    var conjugationTitleFxn: () -> String = deGetCaseDeclensionTitle
    var conjugationLabelsFxn: () -> Void = deSetCaseDeclensionLabels
    var conjugationsFxn: () -> Void = deSetCaseDeclensions
    if deCaseVariantDeclensionState != .disabled {
      conjugationsFxn = deSetCaseVariantDeclensions
    }

    if controllerLanguage == "Russian" {
      conjugationTitleFxn = ruGetCaseDeclensionTitle
      conjugationLabelsFxn = ruSetCaseDeclensionLabels
      conjugationsFxn = ruSetCaseDeclensions
    }

    commandBar.text = conjugationTitleFxn()
    conjugationLabelsFxn()
    conjugationsFxn()

    // Assign labels that have been set by SetCaseDeclensionLabels function.
    formLblFPS.setTitle("  " + (formLabelsDict["FPS"] ?? ""), for: .normal)
    formLblSPS.setTitle("  " + (formLabelsDict["SPS"] ?? ""), for: .normal)
    formLblTPS.setTitle("  " + (formLabelsDict["TPS"] ?? ""), for: .normal)
    formLblFPP.setTitle("  " + (formLabelsDict["FPP"] ?? ""), for: .normal)
    formLblSPP.setTitle("  " + (formLabelsDict["SPP"] ?? ""), for: .normal)
    formLblTPP.setTitle("  " + (formLabelsDict["TPP"] ?? ""), for: .normal)

    formLblTop.setTitle("  " + (formLabelsDict["Top"] ?? ""), for: .normal)
    formLblMiddle.setTitle("  " + (formLabelsDict["Middle"] ?? ""), for: .normal)
    formLblBottom.setTitle("  " + (formLabelsDict["Bottom"] ?? ""), for: .normal)

    formLblTL.setTitle("  " + (formLabelsDict["TL"] ?? ""), for: .normal)
    formLblTR.setTitle("  " + (formLabelsDict["TR"] ?? ""), for: .normal)
    formLblBL.setTitle("  " + (formLabelsDict["BL"] ?? ""), for: .normal)
    formLblBR.setTitle("  " + (formLabelsDict["BR"] ?? ""), for: .normal)

    formLblLeft.setTitle("  " + (formLabelsDict["Left"] ?? ""), for: .normal)
    formLblRight.setTitle("  " + (formLabelsDict["Right"] ?? ""), for: .normal)

    switch formsDisplayDimensions {
    case .view3x2:
      allConjugations = [formFPS, formSPS, formTPS, formFPP, formSPP, formTPP]
      allConjugationBtns = get3x2FormDisplayButtons()
    case .view3x1:
      allConjugations = [formTop, formMiddle, formBottom]
      allConjugationBtns = get3x1FormDisplayButtons()
    case .view2x2:
      allConjugations = [formTopLeft, formTopRight, formBottomLeft, formBottomRight]
      allConjugationBtns = get2x2FormDisplayButtons()
    case .view1x2:
      allConjugations = [formLeft, formRight]
      allConjugationBtns = get1x2FormDisplayButtons()
    case .view1x1:
      break
    }

    // Populate conjugation view buttons.
    for index in 0..<allConjugations.count {
      styleBtn(btn: allConjugationBtns[index], title: allConjugations[index], radius: keyCornerRadius)
    }
  }

  /// Displays an annotation instead of the translate auto action button given the word that was just typed or selected.
  func conditionallyDisplayAnnotation() {
    if [.idle, .alreadyPlural, .invalid].contains(commandState) {
      typedWordAnnotation(self)
    }
  }

  // MARK: Load Keys

  /// Loads the keys given the current constraints.
  func loadKeys() {
    // The name of the language keyboard that's referencing KeyboardViewController.
    controllerLanguage = classForCoder.description().components(separatedBy: ".KeyboardViewController")[0]

    // Actions to be done only on initial loads.
    if keyboardLoad == true {
      shiftButtonState = .shift
      commandBar.textColor = keyCharColor
      commandBar.conditionallyAddPlaceholder() // in case of color mode change during commands
      keyboardView.backgroundColor? = keyboardBgColor
      allNonSpecialKeys = allKeys.filter { !specialKeys.contains($0) }

      // Set height for Scribe command functionality and annotation elements.
      scribeKeyHeight = scribeKey.frame.size.height

      linkShadowBlendElements()
      setAutoActionPartitions()

      // Show the name of the keyboard to the user.
      showKeyboardLanguage = true

      // Make sure that Scribe shows up in auto actions.
      nouns["Scribe"] = [
        "plural": "Scribes",
        "form": ""
      ]

      // Access UILexicon words.
      var lexiconWords = [String]()
      self.requestSupplementaryLexicon { (userLexicon: UILexicon!) -> Void in
        for item in userLexicon.entries {
          lexiconWords.append(item.documentText)
        }
      }

      var uniqueAutosuggestKeys = [String]()
      for elem in autosuggestions.dictionaryValue.keys {
        if elem.count > 2 && !nouns[elem].exists() {
          if autosuggestions[elem.lowercased()].exists()
              && !uniqueAutosuggestKeys.contains(elem.lowercased()) {
            uniqueAutosuggestKeys.append(elem.lowercased())
          } else if
              elem.count > 2
              && elem.isCapitalized
              && !uniqueAutosuggestKeys.contains(elem)
              && !uniqueAutosuggestKeys.contains(elem.lowercased()) {
            uniqueAutosuggestKeys.append(elem)
          }
        }
      }

      autocompleteWords = Array(nouns.dictionaryValue.keys) + uniqueAutosuggestKeys + lexiconWords
      autocompleteWords = autocompleteWords.filter(
        { $0.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890-")) == nil }
      ).sorted{$0.caseInsensitiveCompare($1) == .orderedAscending}
      autocompleteWords = autocompleteWords.unique()
    }

    setKeyboard()
    setCommandBackground()
    setCommandBtns()
    setConjugationBtns()

    // Clear annotation state if a keyboard state change dictates it.
    if annotationState == false {
      annotationBtns.forEach { $0.removeFromSuperview() }
      annotationBtns.removeAll()
      annotationSeparators.forEach { $0.removeFromSuperview() }
      annotationSeparators.removeAll()
    }

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

    if ![.selectVerbConjugation, .selectCaseDeclension, .displayInformation].contains(commandState) { // normal keyboard view
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
        translateKey.titleLabel?.font = .systemFont(ofSize: scribeKeyHeight * 0.435)
        conjugateKey.titleLabel?.font = .systemFont(ofSize: scribeKeyHeight * 0.435)
        pluralKey.titleLabel?.font = .systemFont(ofSize: scribeKeyHeight * 0.435)
      } else if DeviceType.isPad {
        translateKey.titleLabel?.font = .systemFont(ofSize: scribeKeyHeight * 0.475)
        conjugateKey.titleLabel?.font = .systemFont(ofSize: scribeKeyHeight * 0.475)
        pluralKey.titleLabel?.font = .systemFont(ofSize: scribeKeyHeight * 0.475)
      }

      if commandState == .selectCommand {
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
        deactivateBtn(btn: emojiSuggest1)
        deactivateBtn(btn: emojiSuggest2)

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
      for row in 0..<numRows {
        for idx in 0..<keyboard[row].count {
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
          if key == "return" && proxy.keyboardType == .webSearch && ![.translate, .conjugate, .plural].contains(commandState) {
            // Override background color from adjustKeyWidth for "search" blue for web searches.
            styleIconBtn(btn: btn, color: .white.withAlphaComponent(0.9), iconName: "arrow.turn.down.left")
            btn.backgroundColor = UIColor(red: 0.0/255.0, green: 121.0/255.0, blue: 251.0/255.0, alpha: 1.0)
          }

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
          if key == "shift" || key == spaceBar || key == languageTextForSpaceBar {
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
      scribeKey.setShadow()
      scribeKey.setLeftCornerRadius()

      commandBar.backgroundColor = commandBarColor
      commandBarBlend.backgroundColor = commandBarColor
      commandBar.textColor = keyCharColor
      commandBar.set()
      commandBar.setCornerRadiusAndShadow()
      hideAutoActionPartitions()

      deactivateBtn(btn: conjugateKey)
      deactivateBtn(btn: translateKey)
      deactivateBtn(btn: pluralKey)
      deactivateBtn(btn: emojiSuggest1)
      deactivateBtn(btn: emojiSuggest2)

      activateConjugationDisplay()
      styleBtn(btn: shiftFormsDisplayLeft, title: "", radius: keyCornerRadius)
      styleIconBtn(btn: shiftFormsDisplayLeft,
                   color: ![.bothInactive, .leftInactive].contains(conjViewShiftButtonsState) ? keyCharColor : specialKeyColor,
                   iconName: "chevron.left")
      styleBtn(btn: shiftFormsDisplayRight, title: "", radius: keyCornerRadius)
      styleIconBtn(btn: shiftFormsDisplayRight,
                   color: ![.bothInactive, .rightInactive].contains(conjViewShiftButtonsState) ? keyCharColor : specialKeyColor,
                   iconName: "chevron.right")

      if commandState == .selectVerbConjugation {
        setVerbConjugationState()
      } else if commandState == .displayInformation {
        setInformationState()
      } else {
        setCaseDeclensionState()
      }
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
    if originalKey != spaceBar && originalKey != languageTextForSpaceBar {
      doubleSpacePeriodPossible = false
    }

    switch originalKey {
    case "Scribe":
      if proxy.selectedText != nil && [.idle, .selectCommand, .alreadyPlural, .invalid].contains(commandState) { // annotate word
        if [.selectCommand, .alreadyPlural, .invalid].contains(commandState) {
          commandState = .idle
        }
        loadKeys()
        selectedWordAnnotation(self)
      } else {
        if [.translate,
            .conjugate,
            .selectVerbConjugation,
            .selectCaseDeclension,
            .plural].contains(commandState) { // escape
          commandState = .idle
          deCaseVariantDeclensionState = .disabled
        } else if [.idle, .alreadyPlural, .invalid].contains(commandState) { // ScribeKey
          commandState = .selectCommand
          activateBtn(btn: translateKey)
          activateBtn(btn: conjugateKey)
          activateBtn(btn: pluralKey)
        } else { // escape
          commandState = .idle
          deCaseVariantDeclensionState = .disabled
        }
        loadKeys()
      }

    case "return":
      if ![.translate, .conjugate, .plural].contains(commandState) { // normal return button
        proxy.insertText("\n")
        if shiftButtonState == .normal { // capitalize the proxy
          shiftButtonState = .shift
        }
        commandState = .idle
        autoActionState = .suggest
        conditionallySetAutoActionBtns()
        loadKeys()
      } else if commandState == .translate {
        queryTranslation(commandBar: commandBar)
      } else if commandState == .conjugate {
        resetVerbConjugationState()
        let triggerConjugationTbl = triggerVerbConjugation(commandBar: commandBar)
        if triggerConjugationTbl == true {
          commandState = .selectVerbConjugation
          loadKeys() // go to conjugation view
          return
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
          commandBar.isShowingInfoButton = true
        } else {
          commandBar.isShowingInfoButton = false
          if commandState == .alreadyPlural {
            commandBar.text = commandPromptSpacing + alreadyPluralMsg
          }
        }
        commandBar.textColor = keyCharColor
        return
      } else if [.translate, .plural].contains(commandState) { // functional commands above
        autoActionState = .suggest
        commandState = .idle
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

    case "shiftFormsDisplayLeft":
      if commandState == .displayInformation {
        tipView?.updatePrevious()
      } else {
        conjugationStateLeft()
        loadKeys()
      }

    case "shiftFormsDisplayRight":
      if commandState == .displayInformation {
        tipView?.updateNext()
      } else {
        conjugationStateRight()
        loadKeys()
      }


    case "firstPersonSingular":
      returnConjugation(keyPressed: sender, requestedForm: formFPS)
      loadKeys()

    case "secondPersonSingular":
      returnConjugation(keyPressed: sender, requestedForm: formSPS)
      loadKeys()

    case "thirdPersonSingular":
      returnConjugation(keyPressed: sender, requestedForm: formTPS)
      loadKeys()

    case "firstPersonPlural":
      returnConjugation(keyPressed: sender, requestedForm: formFPP)
      loadKeys()

    case "secondPersonPlural":
      returnConjugation(keyPressed: sender, requestedForm: formSPP)
      loadKeys()

    case "thirdPersonPlural":
      returnConjugation(keyPressed: sender, requestedForm: formTPP)
      loadKeys()

    case "formTop":
      returnConjugation(keyPressed: sender, requestedForm: formTop)
      loadKeys()

    case "formMiddle":
      returnConjugation(keyPressed: sender, requestedForm: formMiddle)
      loadKeys()

    case "formBottom":
      returnConjugation(keyPressed: sender, requestedForm: formBottom)
      loadKeys()

    case "formTopLeft":
      returnConjugation(keyPressed: sender, requestedForm: formTopLeft)
      loadKeys()

    case "formTopRight":
      returnConjugation(keyPressed: sender, requestedForm: formTopRight)
      loadKeys()

    case "formBottomLeft":
      returnConjugation(keyPressed: sender, requestedForm: formBottomLeft)
      loadKeys()

    case "formBottomRight":
      returnConjugation(keyPressed: sender, requestedForm: formBottomRight)
      loadKeys()

    case "formLeft":
      returnConjugation(keyPressed: sender, requestedForm: formLeft)
      loadKeys()

    case "formRight":
      returnConjugation(keyPressed: sender, requestedForm: formRight)
      loadKeys()

    case "AutoAction1":
      executeAutoAction(keyPressed: translateKey)

    case "AutoAction2":
      executeAutoAction(keyPressed: conjugateKey)

    case "AutoAction3":
      executeAutoAction(keyPressed: pluralKey)
      
    case "EmojiSuggest1":
      executeAutoAction(keyPressed: emojiSuggest1)
      emojisToSuggestArray = [String]()
    
    case "EmojiSuggest2":
      executeAutoAction(keyPressed: emojiSuggest2)
      emojisToSuggestArray = [String]()

    case "GetAnnotationInfo":
      // Remove all prior annotations.
      annotationBtns.forEach { $0.removeFromSuperview() }
      annotationBtns.removeAll()
      annotationSeparators.forEach { $0.removeFromSuperview() }
      annotationSeparators.removeAll()

      for i in 0..<annotationBtns.count {
        annotationBtns[i].backgroundColor = annotationColors[i]
      }

      if let wordSelected = proxy.selectedText {
        wordToCheck = wordSelected
      } else {
        wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
        let lastWordTyped = wordsTyped.secondToLast()
        if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
          wordToCheck = lastWordTyped!.lowercased()
        } else {
          wordToCheck = lastWordTyped!
        }
      }
      isPrep = prepositions[wordToCheck.lowercased()].exists()
      if isPrep {
        resetCaseDeclensionState()
        commandState = .selectCaseDeclension
        loadKeys() // go to conjugation view
        return
      } else {
        return
      }

    case "ScribeAnnotation":
      for i in 0..<annotationBtns.count {
        annotationBtns[i].backgroundColor = annotationColors[i]
      }
      let emojisToSelectFrom = "🥳🎉"
      let emojis = String((0..<3).map{ _ in emojisToSelectFrom.randomElement()! })
      sender.setTitle(emojis, for: .normal)
      return

    case "delete":
      styleDeleteButton(sender, isPressed: false)
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
        autoCapAtStartOfProxy()

        // Check if the last character is a space such that the user is deleting multiple spaces and suggest is so.
        if proxy.documentContextBeforeInput?.suffix(" ".count) == " " {
          autoActionState = .suggest
        } else {
          autoActionState = .complete
        }
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

    case spaceBar, languageTextForSpaceBar:
      if  previousWord != completionWords[0] && (completionWords[0] != " " && completionWords[1] == " ") {
        previousWord = currentPrefix
        clearPrefixFromTextFieldProxy()
        proxy.insertText(completionWords[0])
        autoActionState = .suggest
        currentPrefix = ""
        shouldHighlightFirstCompletion = false
        allowUndo = true
      }
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

      if proxy.documentContextBeforeInput?.suffix("  ".count) == "  " {
        // Remove all prior annotations.
        annotationBtns.forEach { $0.removeFromSuperview() }
        annotationBtns.removeAll()
        annotationSeparators.forEach { $0.removeFromSuperview() }
        annotationSeparators.removeAll()
      }

      conditionallyDisplayAnnotation()
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

    case ",", ".", "!", "?":
      if [.idle, .selectCommand, .alreadyPlural, .invalid].contains(commandState) {
        if proxy.documentContextBeforeInput?.last == " " {
          proxy.deleteBackward()
        }
        proxy.insertText(keyToDisplay)
      } else {
        commandBar.text = commandBar.text!.insertPriorToCursor(char: keyToDisplay)
      }

    case "shift":
      shiftButtonState = shiftButtonState == .normal ? .shift : .normal
      loadKeys()
      capsLockPossible = true

    case "123", ".?123":
      changeKeyboardToNumberKeys()

    case "#+=":
      changeKeyboardToSymbolKeys()

    case "ABC", "АБВ":
      changeKeyboardToLetterKeys()
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
      if [.idle, .selectCommand, .alreadyPlural, .invalid].contains(commandState) {
        proxy.insertText(keyToDisplay)
      } else {
        commandBar.text = commandBar.text!.insertPriorToCursor(char: keyToDisplay)
      }
    }

    // Cancel already plural and invalid states after another key press.
    if [.alreadyPlural, .invalid].contains(commandState) {
      commandState = .idle
      loadKeys()
    }

    // Add partitions and show auto actions if the keyboard states dictate.
    conditionallyShowAutoActionPartitions()
    conditionallySetAutoActionBtns()

    if annotationState == false {
      annotationBtns.forEach { $0.removeFromSuperview() }
      annotationBtns.removeAll()
      annotationSeparators.forEach { $0.removeFromSuperview() }
      annotationSeparators.removeAll()
    }
    annotationState = false
    activateAnnotationBtn = false

    // Remove alternates view if it's present.
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
      alternatesShapeLayer.removeFromSuperlayer()
    }

    // Remove tipview if it's present.
    if formsDisplayDimensions != .view1x1, tipView != nil {
      tipView?.removeFromSuperview()
      tipView = nil
    }

  }

  // MARK: Key Press Functions

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
    guard let originalKey = sender.layer.value(
      forKey: "original"
    ) as? String else {
      return
    }

    if originalKey == "GetAnnotationInfo" {
      // Blink each btn in the annotation display if one is pressed.
      for btn in annotationBtns {
        btn.backgroundColor = keyPressedColor
      }
    } else if originalKey == "delete" {
      // Change the icon of the delete button to be filled in.
      sender.backgroundColor = keyPressedColor
      styleDeleteButton(sender, isPressed: true)
    } else {
      sender.backgroundColor = keyPressedColor
    }
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
      && (originalKey == spaceBar || originalKey == languageTextForSpaceBar)
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
      // Show auto actions if the keyboard states dictate.
      conditionallySetAutoActionBtns()
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

    // Delete is sped up based on the number of deletes that have been completed.
    var deleteCount = 0
    if gesture.state == .began {
      backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (_) in
        deleteCount += 1
        self.handleDeleteButtonPressed()

        if deleteCount == 20 {
          backspaceTimer?.invalidate()
          backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { (_) in
            deleteCount += 1
            self.handleDeleteButtonPressed()

            if deleteCount == 50 {
              backspaceTimer?.invalidate()
              backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { (_) in
                self.handleDeleteButtonPressed()
              }
            }
          }
        }
      }
    } else if gesture.state == .ended || gesture.state == .cancelled {
      backspaceTimer?.invalidate()
      backspaceTimer = nil
      if let button = gesture.view as? UIButton {
        button.backgroundColor = specialKeyColor
        styleDeleteButton(button, isPressed: false)
      }
    }
  }

  /// Resets key coloration after they have been changed to keyPressedColor.
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
    let charPressed = key.layer.value(forKey: "original") as? String ?? ""
    let displayChar = key.layer.value(forKey: "keyToDisplay") as? String ?? ""
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
    let charPressed = key.layer.value(forKey: "original") as? String ?? ""
    let displayChar = key.layer.value(forKey: "keyToDisplay") as? String ?? ""

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
