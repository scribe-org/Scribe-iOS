/**
 * Classes for the parent keyboard view controller that language keyboards.
 *
 * Copyright (C) 2023 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import GRDB
import UIKit

/// The parent KeyboardViewController class that is inherited by all Scribe keyboards.
class KeyboardViewController: UIInputViewController {
  var keyboardView: UIView!

  // Stack views that are populated with they keyboard rows.
  @IBOutlet var stackViewNum: UIStackView!
  @IBOutlet var stackView0: UIStackView!
  @IBOutlet var stackView1: UIStackView!
  @IBOutlet var stackView2: UIStackView!
  @IBOutlet var stackView3: UIStackView!

  private var tipView: ToolTipView?

  /// Changes the height of `stackViewNum` depending on device type and size.
  func conditionallyShowTopNumbersRow() {
    if DeviceType.isPhone {
      if let stackViewNum = stackViewNum {
        view.addConstraint(
          NSLayoutConstraint(
            item: stackViewNum, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0
          )
        )
      }
    } else if DeviceType.isPad {
      // Update the size of the numbers row to add it to the view.
      if usingExpandedKeyboard {
        let numbersRowHeight = scribeKey.frame.height * 1.8
        if let stackViewNum = stackViewNum {
          view.addConstraint(
            NSLayoutConstraint(
              item: stackViewNum,
              attribute: .height,
              relatedBy: .equal,
              toItem: nil,
              attribute: .height,
              multiplier: 1,
              constant: numbersRowHeight
            )
          )
        }
      } else {
        if let stackViewNum = stackViewNum {
          view.addConstraint(
            NSLayoutConstraint(
              item: stackViewNum, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0
            )
          )
        }
      }
    }
  }

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

    // Set tap handler for info button on CommandBar.
    commandBar.infoButtonTapHandler = { [weak self] in
      commandState = .displayInformation
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
      if isLandscapeView {
        keyboardHeight = 200
      } else {
        keyboardHeight = 270
      }
    } else if DeviceType.isPad {
      // Expanded keyboard on larger iPads can be higher.
      if UIScreen.main.bounds.width > 768 {
        if isLandscapeView {
          keyboardHeight = 430
        } else {
          keyboardHeight = 360
        }
      } else {
        if isLandscapeView {
          keyboardHeight = 420
        } else {
          keyboardHeight = 340
        }
      }
    }

    guard let view = view else {
      fatalError("The view is nil.")
    }

    let heightConstraint = NSLayoutConstraint(
      item: view,
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
    if view.viewWithTag(1001) != nil {
      let viewWithTag = view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
      alternatesShapeLayer.removeFromSuperlayer()
    }
    proxy = textDocumentProxy as UITextDocumentProxy
    keyboardState = .letters
    annotationState = false
    isFirstKeyboardLoad = true
    loadInterface()
    isFirstKeyboardLoad = false

    selectKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
  }

  /// Includes hiding the keyboard selector button if it is not needed for the current device.
  override func viewWillLayoutSubviews() {
    selectKeyboardButton.isHidden = !needsInputModeSwitchKey
    super.viewWillLayoutSubviews()
  }

  /// Includes updateViewConstraints to change the keyboard height given device type and orientation.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateViewConstraints()
    isFirstKeyboardLoad = true
    loadKeys()
    isFirstKeyboardLoad = false
  }

  /// Includes:
  /// - updateViewConstraints to change the keyboard height
  /// - A call to loadKeys to reload the display after an orientation change
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.updateViewConstraints()
      self.loadKeys()
    })
    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
      isFirstKeyboardLoad = true
      self.loadKeys()
      isFirstKeyboardLoad = false
    }
  }

  /// Overrides the previous color variables if the user switches between light and dark mode.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    // If alternateKeysView is already added than remove it so it's not colored wrong.
    if view.viewWithTag(1001) != nil {
      let viewWithTag = view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
      alternatesShapeLayer.removeFromSuperlayer()
    }
    annotationState = false
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
      isFirstKeyboardLoad = true
      self.loadKeys()
      isFirstKeyboardLoad = false
    }
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

  /// Sets the tooltip to display information to the user.
  func setInformationState() {
    let contentData = InformationToolTipData.getContent()
    let datasources = contentData.enumerated().compactMap { _, text in
      createInformationStateDatasource(text: text, backgroundColor: keyColor)
    }
    tipView = ToolTipView(datasources: datasources)

    bindTooltipview()

    guard let tipView = tipView else { return }
    tipView.translatesAutoresizingMaskIntoConstraints = false
    formKeySingle.addSubview(tipView)
    formKeySingle.isUserInteractionEnabled = false
    tipView.leadingAnchor.constraint(
      equalTo: formKeySingle.leadingAnchor, constant: DeviceType.isPhone ? 15 : 40
    ).isActive = true
    tipView.trailingAnchor.constraint(
      equalTo: formKeySingle.trailingAnchor, constant: DeviceType.isPhone ? -15 : -40
    ).isActive = true
    tipView.topAnchor.constraint(equalTo: formKeySingle.topAnchor, constant: 8).isActive = true
    tipView.bottomAnchor.constraint(equalTo: formKeySingle.bottomAnchor, constant: -5).isActive = true
    styleBtn(btn: formKeySingle, title: "", radius: keyCornerRadius)
  }

  // Shifts the view of the information tooltip view.
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

  /// Generate emoji suggestions or completions for a given word.
  ///
  /// - Parameters
  ///   - word: the word for which corresponding emojis should be shown for.
  func getEmojiAutoSuggestions(for word: String) {
    let query = "SELECT * FROM emoji_keywords WHERE word = ?"
    let args = [word.lowercased()]
    let outputCols = ["emoji_0", "emoji_1", "emoji_2"]
    let emojisToDisplay = queryDBRow(query: query, outputCols: outputCols, args: args)

    if !emojisToDisplay[0].isEmpty {
      emojisToDisplayArray = [String]()
      currentEmojiTriggerWord = word.lowercased()

      if !emojisToDisplay[2].isEmpty && DeviceType.isPad {
        for i in 0 ..< 3 {
          emojisToDisplayArray.append(emojisToDisplay[i])
        }
        autoAction2Visible = false
        emojisToShow = .three

        if UITraitCollection.current.userInterfaceStyle == .light {
          padEmojiDivider0.backgroundColor = specialKeyColor
          padEmojiDivider1.backgroundColor = specialKeyColor
        } else if UITraitCollection.current.userInterfaceStyle == .dark {
          padEmojiDivider0.backgroundColor = UIColor(cgColor: commandBarBorderColor)
          padEmojiDivider1.backgroundColor = UIColor(cgColor: commandBarBorderColor)
        }
        conditionallyHideEmojiDividers()
      } else if !emojisToDisplay[1].isEmpty {
        for i in 0 ..< 2 {
          emojisToDisplayArray.append(emojisToDisplay[i])
        }
        autoAction2Visible = false
        emojisToShow = .two

        if UITraitCollection.current.userInterfaceStyle == .light {
          phoneEmojiDivider.backgroundColor = specialKeyColor
        } else if UITraitCollection.current.userInterfaceStyle == .dark {
          phoneEmojiDivider.backgroundColor = UIColor(cgColor: commandBarBorderColor)
        }
        conditionallyHideEmojiDividers()
      } else {
        emojisToDisplayArray.append(emojisToDisplay[0])

        emojisToShow = .one
      }
    }
  }

  /// Generates an array of the three autocomplete words.
  func getAutocompletions() {
    completionWords = [" ", " ", " "]
    if let documentContext = proxy.documentContextBeforeInput, !documentContext.isEmpty {
      if let inString = proxy.documentContextBeforeInput {
        // To only focus on the current word as prefix in autocomplete.
        currentPrefix = inString.replacingOccurrences(of: pastStringInTextProxy, with: "")

        if currentPrefix.hasPrefix("(") || currentPrefix.hasPrefix("#") ||
          currentPrefix.hasPrefix("/") || currentPrefix.hasPrefix("\"")
        {
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

        // Trigger autocompletions for selected text instead.
        if proxy.selectedText != nil && [.idle, .selectCommand, .alreadyPlural, .invalid].contains(commandState) {
          if let selectedText = proxy.selectedText {
            currentPrefix = selectedText
          }
        }

        // Get options for completion that start with the current prefix and are not just one letter.
        let completionOptions = queryAutocompletions(word: currentPrefix)

        if !completionOptions[0].isEmpty {
          if completionOptions.count <= 3 {
            for i in 0 ..< completionOptions.count {
              if shiftButtonState == .shift {
                completionWords[i] = completionOptions[i].capitalize()
              } else if capsLockButtonState == .locked {
                completionWords[i] = completionOptions[i].uppercased()
              } else if currentPrefix.isCapitalized {
                if completionOptions[i].isUppercase {
                  completionWords[i] = completionOptions[i]
                } else {
                  completionWords[i] = completionOptions[i].capitalize()
                }
              } else {
                completionWords[i] = completionOptions[i]
              }
            }
          } else {
            for i in 0 ..< 3 {
              if shiftButtonState == .shift {
                completionWords[i] = completionOptions[i].capitalize()
              } else if capsLockButtonState == .locked {
                completionWords[i] = completionOptions[i].uppercased()
              } else if currentPrefix.isCapitalized {
                if completionOptions[i].isUppercase {
                  completionWords[i] = completionOptions[i]
                } else {
                  completionWords[i] = completionOptions[i].capitalize()
                }
              } else {
                completionWords[i] = completionOptions[i]
              }
            }
          }
        }

        // Disable the third auto action button if we'll have emoji suggestions.
        if emojiAutosuggestIsEnabled() {
          getEmojiAutoSuggestions(for: currentPrefix)
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
    let query = "SELECT * FROM verbs WHERE verb = ?"
    for i in 0 ..< 3 {
      // Get conjugations of the preselected verbs.
      let args = [verbsAfterPronounsArray[i]]
      if let tense = pronounAutosuggestionTenses[prefix.lowercased()] {
        let outputCols = [tense]
        var suggestion = queryDBRow(query: query, outputCols: outputCols, args: args)[0]
        if suggestion == "" {
          suggestion = verbsAfterPronounsArray[i]
        }

        if suggestion == "REFLEXIVE_PRONOUN" && controllerLanguage == "Spanish" {
          suggestion = getESReflexivePronoun(pronoun: prefix.lowercased())
        }
        if shiftButtonState == .shift {
          completionWords.append(suggestion.capitalize())
        } else if capsLockButtonState == .locked {
          completionWords.append(suggestion.uppercased())
        } else {
          completionWords.append(suggestion)
        }
      }
    }
  }

  /// Generates an array of three words that serve as baseline autosuggestions.
  func getDefaultAutosuggestions() {
    completionWords = [String]()
    for i in 0 ..< 3 {
      if allowUndo {
        completionWords.append(previousWord)
        continue
      }
      if shiftButtonState == .shift {
        completionWords.append(baseAutosuggestions[i].capitalize())
      } else if capsLockButtonState == .locked {
        completionWords.append(baseAutosuggestions[i].uppercased())
      } else {
        completionWords.append(baseAutosuggestions[i])
      }
    }
  }

  /// Generates an array of the three autosuggest words.
  func getAutosuggestions() {
    var prefix = proxy.documentContextBeforeInput?.components(
      separatedBy: " "
    ).secondToLast() ?? ""

    if emojiAutoActionRepeatPossible {
      prefix = currentEmojiTriggerWord
    }

    // If there's a line break, take the word after it.
    if prefix.contains("\n") {
      prefix = prefix.components(
        separatedBy: "\n"
      ).last ?? ""
    }

    // Trigger autocompletions for selected text instead.
    if proxy.selectedText != nil && [.idle, .selectCommand, .alreadyPlural, .invalid].contains(commandState) {
      if let selectedText = proxy.selectedText {
        prefix = selectedText
      }
    }

    if prefix.isNumeric {
      completionWords = numericAutosuggestions
    } else if ["French", "German", "Spanish"].contains(controllerLanguage) && pronounAutosuggestionTenses.keys.contains(prefix.lowercased()) {
      getPronounAutosuggestions()
    } else {
      // We have to consider these different cases as the key always has to match.
      // Else, even if the lowercased prefix is present in the dictionary, if the actual prefix isn't present we won't get an output.
      let query = "SELECT * FROM autosuggestions WHERE word = ?"
      let argsLower = [prefix.lowercased()]
      let argsCapitalize = [prefix.capitalized]
      let outputCols = ["suggestion_0", "suggestion_1", "suggestion_2"]

      let suggestionsLowerCasePrefix = queryDBRow(query: query, outputCols: outputCols, args: argsLower)
      let suggestionsCapitalizedPrefix = queryDBRow(query: query, outputCols: outputCols, args: argsCapitalize)
      if !suggestionsLowerCasePrefix[0].isEmpty {
        completionWords = [String]()
        for i in 0 ..< 3 {
          if allowUndo {
            completionWords.append(previousWord)
            continue
          }
          if shiftButtonState == .shift {
            completionWords.append(suggestionsLowerCasePrefix[i].capitalize())
          } else if capsLockButtonState == .locked {
            completionWords.append(suggestionsLowerCasePrefix[i].uppercased())
          } else {
            let nounGenderQuery = "SELECT * FROM nouns WHERE noun = ?"
            let nounGenderArgs = [suggestionsLowerCasePrefix[i]]
            let outputCols = ["form"]

            let nounForm = queryDBRow(query: nounGenderQuery, outputCols: outputCols, args: nounGenderArgs)[0]
            hasNounForm = !nounForm.isEmpty
            if !hasNounForm {
              completionWords.append(suggestionsLowerCasePrefix[i].lowercased())
            } else {
              completionWords.append(suggestionsLowerCasePrefix[i])
            }
          }
        }
      } else if !suggestionsCapitalizedPrefix[0].isEmpty {
        completionWords = [String]()
        for i in 0 ..< 3 {
          if allowUndo {
            completionWords.append(previousWord)
            continue
          }
          if shiftButtonState == .shift {
            completionWords.append(suggestionsCapitalizedPrefix[i].capitalize())
          } else if capsLockButtonState == .locked {
            completionWords.append(suggestionsCapitalizedPrefix[i].uppercased())
          } else {
            completionWords.append(suggestionsCapitalizedPrefix[i])
          }
        }
      } else {
        getDefaultAutosuggestions()
      }
    }

    // Disable the third auto action button if we'll have emoji suggestions.
    if emojiAutosuggestIsEnabled() {
      getEmojiAutoSuggestions(for: prefix)
    }
  }

  /// Sets up command buttons to execute autocomplete and autosuggest.
  func conditionallySetAutoActionBtns() {
    // Clear noun auto action annotations.
    autoActionAnnotationBtns.forEach { $0.removeFromSuperview() }
    autoActionAnnotationBtns.removeAll()
    autoActionAnnotationSeparators.forEach { $0.removeFromSuperview() }
    autoActionAnnotationSeparators.removeAll()

    if autoActionState == .suggest {
      getAutosuggestions()
    } else {
      getAutocompletions()
    }
    if commandState == .idle {
      deactivateBtn(btn: translateKey)
      deactivateBtn(btn: conjugateKey)
      deactivateBtn(btn: pluralKey)

      deactivateBtn(btn: phoneEmojiKey0)
      deactivateBtn(btn: phoneEmojiKey1)
      deactivateBtn(btn: padEmojiKey0)
      deactivateBtn(btn: padEmojiKey1)
      deactivateBtn(btn: padEmojiKey2)

      if autoAction0Visible {
        allowUndo = false
        firstCompletionIsHighlighted = false
        // Highlight if the current prefix is the first autocompletion or there is only one available.
        if (
          currentPrefix == completionWords[0] && completionWords[1] != " "
        ) || (
          // Highlighting last remaining autocomplete.
          completionWords[0] != " " && completionWords[1] == " "
        ) {
          firstCompletionIsHighlighted = true
        }
        setBtn(
          btn: translateKey,
          color: firstCompletionIsHighlighted ? keyColor.withAlphaComponent(0.5) : keyboardBgColor,
          name: "AutoAction0",
          canBeCapitalized: false,
          isSpecial: false
        )
        styleBtn(
          btn: translateKey,
          title: completionWords[0],
          radius: firstCompletionIsHighlighted ? commandKeyCornerRadius / 2.5 : commandKeyCornerRadius
        )
        if translateKey.currentTitle != " " {
          activateBtn(btn: translateKey)
        }
        autoActionAnnotation(autoActionWord: completionWords[0], index: 0, KVC: self)
      }

      // Add the current word being typed to the completion words if there is only one option that's highlighted.
      if firstCompletionIsHighlighted && completionWords[1] == " " && completionWords[0] != currentPrefix {
        spaceAutoInsertIsPossible = true
        completionWords[1] = currentPrefix
      }

      setBtn(
        btn: conjugateKey,
        color: keyboardBgColor, name: "AutoAction1",
        canBeCapitalized: false,
        isSpecial: false
      )
      styleBtn(
        btn: conjugateKey,
        title: !autoAction0Visible ? completionWords[0] : completionWords[1],
        radius: commandKeyCornerRadius
      )
      if conjugateKey.currentTitle != " " {
        activateBtn(btn: conjugateKey)
      }
      autoActionAnnotation(
        autoActionWord: !autoAction0Visible ? completionWords[0] : completionWords[1], index: 1, KVC: self
      )

      if autoAction2Visible && emojisToShow == .zero {
        setBtn(
          btn: pluralKey,
          color: keyboardBgColor,
          name: "AutoAction2",
          canBeCapitalized: false,
          isSpecial: false
        )
        styleBtn(
          btn: pluralKey,
          title: !autoAction0Visible ? completionWords[1] : completionWords[2],
          radius: commandKeyCornerRadius
        )
        if pluralKey.currentTitle != " " {
          activateBtn(btn: pluralKey)
        }
        autoActionAnnotation(
          autoActionWord: !autoAction0Visible ? completionWords[1] : completionWords[2], index: 2, KVC: self
        )

        conditionallyHideEmojiDividers()
      } else if autoAction2Visible && emojisToShow == .one {
        setBtn(
          btn: pluralKey,
          color: keyboardBgColor,
          name: "AutoAction2",
          canBeCapitalized: false,
          isSpecial: false
        )
        styleBtn(
          btn: pluralKey,
          title: emojisToDisplayArray[0],
          radius: commandKeyCornerRadius
        )
        if DeviceType.isPhone {
          pluralKey.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarFontPhone)
        } else if DeviceType.isPad {
          pluralKey.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarFontPad)
        }
        activateBtn(btn: pluralKey)

        conditionallyHideEmojiDividers()
      } else if !autoAction2Visible && emojisToShow == .two {
        setBtn(
          btn: phoneEmojiKey0,
          color: keyboardBgColor,
          name: "EmojiKey0",
          canBeCapitalized: false,
          isSpecial: false
        )
        setBtn(
          btn: phoneEmojiKey1,
          color: keyboardBgColor,
          name: "EmojiKey1",
          canBeCapitalized: false,
          isSpecial: false
        )
        styleBtn(btn: phoneEmojiKey0, title: emojisToDisplayArray[0], radius: commandKeyCornerRadius)
        styleBtn(btn: phoneEmojiKey1, title: emojisToDisplayArray[1], radius: commandKeyCornerRadius)

        if DeviceType.isPhone {
          phoneEmojiKey0.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarFontPhone)
          phoneEmojiKey1.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarFontPhone)
        } else if DeviceType.isPad {
          phoneEmojiKey0.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarFontPad)
          phoneEmojiKey1.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarFontPad)
        }

        activateBtn(btn: phoneEmojiKey0)
        activateBtn(btn: phoneEmojiKey1)

        conditionallyHideEmojiDividers()
      } else if !autoAction2Visible && emojisToShow == .three {
        setBtn(btn: padEmojiKey0, color: keyboardBgColor, name: "EmojiKey0", canBeCapitalized: false, isSpecial: false)
        setBtn(btn: padEmojiKey1, color: keyboardBgColor, name: "EmojiKey1", canBeCapitalized: false, isSpecial: false)
        setBtn(btn: padEmojiKey2, color: keyboardBgColor, name: "EmojiKey2", canBeCapitalized: false, isSpecial: false)
        styleBtn(btn: padEmojiKey0, title: emojisToDisplayArray[0], radius: commandKeyCornerRadius)
        styleBtn(btn: padEmojiKey1, title: emojisToDisplayArray[1], radius: commandKeyCornerRadius)
        styleBtn(btn: padEmojiKey2, title: emojisToDisplayArray[2], radius: commandKeyCornerRadius)

        padEmojiKey0.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarEmojiKeyFont)
        padEmojiKey1.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarEmojiKeyFont)
        padEmojiKey2.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarEmojiKeyFont)

        activateBtn(btn: padEmojiKey0)
        activateBtn(btn: padEmojiKey1)
        activateBtn(btn: padEmojiKey2)

        conditionallyHideEmojiDividers()
      }

      translateKey.layer.shadowColor = UIColor.clear.cgColor
      conjugateKey.layer.shadowColor = UIColor.clear.cgColor
      pluralKey.layer.shadowColor = UIColor.clear.cgColor
    }

    // Reset autocorrect and autosuggest button visibility.
    autoAction0Visible = true
    autoAction2Visible = true
  }

  /// Clears the text proxy when inserting using an auto action.
  /// Note: the completion is appended after the typed text if this is not ran.
  func clearPrefixFromTextFieldProxy() {
    // Only delete characters for autocomplete, not autosuggest.
    guard !currentPrefix.isEmpty, autoActionState != .suggest else {
      return
    }

    guard let documentContext = proxy.documentContextBeforeInput, !documentContext.isEmpty else {
      return
    }

    // Delete characters in text proxy.
    for _ in 0 ..< currentPrefix.count {
      proxy.deleteBackward()
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
    emojisToDisplayArray = [String]()
    // Remove the space from the previous auto action or replace the current prefix.
    if emojiAutoActionRepeatPossible && (
      (keyPressed == phoneEmojiKey0 || keyPressed == phoneEmojiKey1)
        || (keyPressed == padEmojiKey0 || keyPressed == padEmojiKey1 || keyPressed == padEmojiKey2)
        || (keyPressed == pluralKey && emojisToShow == .one)
    ) {
      proxy.deleteBackward()
    } else {
      currentPrefix = ""
    }
    proxy.insertText(keyPressed.titleLabel?.text ?? "")
    proxy.insertText(" ")
    autoActionState = .suggest
    if shiftButtonState == .shift {
      shiftButtonState = .normal
      loadKeys()
    }
    conditionallyDisplayAnnotation()
    if (keyPressed == phoneEmojiKey0 || keyPressed == phoneEmojiKey1)
      || (keyPressed == padEmojiKey0 || keyPressed == padEmojiKey1 || keyPressed == padEmojiKey2)
      || (keyPressed == pluralKey && emojisToShow == .one)
    {
      emojiAutoActionRepeatPossible = true
    }
  }

  // The background for the Scribe command elements.
  @IBOutlet var commandBackground: UILabel!

  /// Sets the background and user interactivity of the command bar.
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
    } else if [.translate, .conjugate, .plural].contains(commandState) && !(allPrompts.contains(commandBar.text ?? "") || allColoredPrompts.contains(commandBar.attributedText ?? NSAttributedString())) {
      guard let inputText = commandBar.text, !inputText.isEmpty else {
        return
      }
      commandBar.text = inputText.deletePriorToCursor()
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

  @IBOutlet var phoneEmojiKey0: UIButton!
  @IBOutlet var phoneEmojiKey1: UIButton!
  @IBOutlet var phoneEmojiDivider: UILabel!

  @IBOutlet var padEmojiKey0: UIButton!
  @IBOutlet var padEmojiKey1: UIButton!
  @IBOutlet var padEmojiKey2: UIButton!
  @IBOutlet var padEmojiDivider0: UILabel!
  @IBOutlet var padEmojiDivider1: UILabel!

  /// Sets up all buttons that are associated with Scribe commands.
  func setCommandBtns() {
    setBtn(btn: translateKey, color: commandKeyColor, name: "Translate", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: conjugateKey, color: commandKeyColor, name: "Conjugate", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: pluralKey, color: commandKeyColor, name: "Plural", canBeCapitalized: false, isSpecial: false)

    activateBtn(btn: translateKey)
    activateBtn(btn: conjugateKey)
    activateBtn(btn: pluralKey)
  }

  /// Hides all emoji dividers based on conditions determined by the keyboard state.
  func conditionallyHideEmojiDividers() {
    if commandState == .idle {
      if [.zero, .one, .three].contains(emojisToShow) {
        phoneEmojiDivider.backgroundColor = .clear
      }
      if [.zero, .one, .two].contains(emojisToShow) {
        padEmojiDivider0.backgroundColor = .clear
        padEmojiDivider1.backgroundColor = .clear
      }
    } else {
      phoneEmojiDivider.backgroundColor = .clear
      padEmojiDivider0.backgroundColor = .clear
      padEmojiDivider1.backgroundColor = .clear
    }
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
      formKeyFPS, formKeySPS, formKeyTPS, formKeyFPP, formKeySPP, formKeyTPP,
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
      formLblFPS, formLblSPS, formLblTPS, formLblFPP, formLblSPP, formLblTPP,
    ]

    return conjugationLabels
  }

  /// Sets up all buttons and labels that are associated with the 3x2 conjugation display.
  func setFormDisplay3x2View() {
    setBtn(btn: formKeyFPS, color: keyColor, name: "firstPersonSingular", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: formKeySPS, color: keyColor, name: "secondPersonSingular", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: formKeyTPS, color: keyColor, name: "thirdPersonSingular", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: formKeyFPP, color: keyColor, name: "firstPersonPlural", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: formKeySPP, color: keyColor, name: "secondPersonPlural", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: formKeyTPP, color: keyColor, name: "thirdPersonPlural", canBeCapitalized: false, isSpecial: false)

    for btn in get3x2FormDisplayButtons() {
      activateBtn(btn: btn)
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get3x2FormDisplayButtons() {
        btn.titleLabel?.font = .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
      }
    }
  }

  @IBOutlet var formKeyTop: UIButton!
  @IBOutlet var formKeyMiddle: UIButton!
  @IBOutlet var formKeyBottom: UIButton!

  /// Returns all buttons for the 3x1 conjugation display
  func get3x1FormDisplayButtons() -> [UIButton] {
    let conjugationButtons: [UIButton] = [
      formKeyTop, formKeyMiddle, formKeyBottom,
    ]

    return conjugationButtons
  }

  @IBOutlet var formLblTop: UIButton!
  @IBOutlet var formLblMiddle: UIButton!
  @IBOutlet var formLblBottom: UIButton!

  /// Returns all labels for the 3x1 conjugation display.
  func get3x1FormDisplayLabels() -> [UIButton] {
    let conjugationLabels: [UIButton] = [
      formLblTop, formLblMiddle, formLblBottom,
    ]

    return conjugationLabels
  }

  /// Sets up all buttons and labels that are associated with the 3x1 conjugation display.
  func setFormDisplay3x1View() {
    setBtn(btn: formKeyTop, color: keyColor, name: "formTop", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: formKeyMiddle, color: keyColor, name: "formMiddle", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: formKeyBottom, color: keyColor, name: "formBottom", canBeCapitalized: false, isSpecial: false)

    for btn in get3x1FormDisplayButtons() {
      activateBtn(btn: btn)
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get3x1FormDisplayButtons() {
        btn.titleLabel?.font = .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
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
      formKeyTL, formKeyTR, formKeyBL, formKeyBR,
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
      formLblTL, formLblTR, formLblBL, formLblBR,
    ]

    return conjugationLabels
  }

  /// Sets up all buttons and labels that are associated with the 2x2 conjugation display.
  func setFormDisplay2x2View() {
    setBtn(btn: formKeyTL, color: keyColor, name: "formTopLeft", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: formKeyTR, color: keyColor, name: "formTopRight", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: formKeyBL, color: keyColor, name: "formBottomLeft", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: formKeyBR, color: keyColor, name: "formBottomRight", canBeCapitalized: false, isSpecial: false)

    for btn in get2x2FormDisplayButtons() {
      activateBtn(btn: btn)
      btn.isEnabled = true
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get2x2FormDisplayButtons() {
        btn.titleLabel?.font = .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
      }
    }
  }

  @IBOutlet var formKeyLeft: UIButton!
  @IBOutlet var formKeyRight: UIButton!

  /// Returns all buttons for the 1x2 conjugation display
  func get1x2FormDisplayButtons() -> [UIButton] {
    let conjugationButtons: [UIButton] = [
      formKeyLeft, formKeyRight,
    ]

    return conjugationButtons
  }

  @IBOutlet var formLblLeft: UIButton!
  @IBOutlet var formLblRight: UIButton!

  /// Returns all labels for the 1x2 conjugation display.
  func get1x2FormDisplayLabels() -> [UIButton] {
    let conjugationLabels: [UIButton] = [
      formLblLeft, formLblRight,
    ]

    return conjugationLabels
  }

  /// Sets up all buttons and labels that are associated with the 3x1 conjugation display.
  func setFormDisplay1x2View() {
    setBtn(btn: formKeyLeft, color: keyColor, name: "formLeft", canBeCapitalized: false, isSpecial: false)
    setBtn(btn: formKeyRight, color: keyColor, name: "formRight", canBeCapitalized: false, isSpecial: false)

    for btn in get1x2FormDisplayButtons() {
      activateBtn(btn: btn)
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get1x2FormDisplayButtons() {
        btn.titleLabel?.font = .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
      }
    }
  }

  @IBOutlet var formKeySingle: UIButton!

  /// Returns all buttons for the 1x1 conjugation display
  func get1x1FormDisplayButtons() -> [UIButton] {
    let conjugationButtons: [UIButton] = [
      formKeySingle,
    ]

    return conjugationButtons
  }

  @IBOutlet var formLblSingle: UIButton!

  /// Returns all labels for the 1x1 conjugation display.
  func get1x1FormDisplayLabels() -> [UIButton] {
    let conjugationLabels: [UIButton] = [
      formLblSingle,
    ]

    return conjugationLabels
  }

  /// Sets up all buttons and labels that are associated with the 1x1 conjugation display.
  func setFormDisplay1x1View() {
    setBtn(btn: formKeySingle, color: keyColor, name: "formSingle", canBeCapitalized: false, isSpecial: false)

    for btn in get1x1FormDisplayButtons() {
      activateBtn(btn: btn)
    }

    if DeviceType.isPad {
      var conjugationFontDivisor = 3.5
      if isLandscapeView {
        conjugationFontDivisor = 4
      }
      for btn in get1x1FormDisplayButtons() {
        btn.titleLabel?.font = .systemFont(ofSize: letterKeyWidth / conjugationFontDivisor)
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
      && deCaseVariantDeclensionState != .disabled
    {
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
        .accusativeDefinite, .accusativeIndefinite, .accusativeDemonstrative,
        .dativeDefinite, .dativeIndefinite, .dativeDemonstrative,
        .genitiveDefinite, .genitiveIndefinite, .genitiveDemonstrative,
      ].contains(deCaseDeclensionState)
    {
      formsDisplayDimensions = .view2x2
    } else if
      commandState == .displayInformation
    {
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
      canBeCapitalized: false,
      isSpecial: false
    )
    setBtn(
      btn: shiftFormsDisplayRight,
      color: keyColor,
      name: "shiftFormsDisplayRight",
      canBeCapitalized: false,
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
        lbl.titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 4)
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

      if controllerLanguage == "German"
        && [.accusativeIndefinite, .dativeIndefinite, .genitiveIndefinite].contains(deCaseDeclensionState)
      {
        formKeyBR.isUserInteractionEnabled = false
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
    if let conjugationFxn = keyboardConjStateDict[controllerLanguage] as? () -> String {
      conjugationStateFxn = conjugationFxn
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
    if let titleFxn = keyboardConjTitleDict[controllerLanguage] as? () -> String {
      conjugationTitleFxn = titleFxn
    }
    if let labelsFxn = keyboardConjLabelDict[controllerLanguage] as? () -> Void {
      conjugationLabelsFxn = labelsFxn
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
    let query = "SELECT * FROM verbs WHERE verb = ?"
    let args = [verbToConjugate]
    let outputCols = allConjugations
    let conjugationsToDisplay = queryDBRow(query: query, outputCols: outputCols, args: args)
    for index in 0 ..< allConjugations.count {
      if conjugationsToDisplay[index] == "" {
        // Assign the invalid message if the conjugation isn't present in the directory.
        styleBtn(btn: allConjugationBtns[index], title: invalidCommandMsg, radius: keyCornerRadius)
      } else {
        conjugationToDisplay = conjugationsToDisplay[index]
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
    for index in 0 ..< allConjugations.count {
      styleBtn(btn: allConjugationBtns[index], title: allConjugations[index], radius: keyCornerRadius)
    }
  }

  /// Displays an annotation instead of the translate auto action button given the word that was just typed or selected.
  func conditionallyDisplayAnnotation() {
    if [.idle, .alreadyPlural, .invalid].contains(commandState) {
      typedWordAnnotation(KVC: self)
    }
  }

  func setKeywidth() {
    // keyWidth determined per keyboard by the top row.
    if isLandscapeView {
      if DeviceType.isPhone {
        letterKeyWidth = (UIScreen.main.bounds.height - 5) / CGFloat(letterKeys[0].count) * scalarLetterNumSymKeyWidthLandscapeViewPhone
        numSymKeyWidth = (UIScreen.main.bounds.height - 5) / CGFloat(numberKeys[0].count) * scalarLetterNumSymKeyWidthLandscapeViewPhone
      } else if DeviceType.isPad {
        letterKeyWidth = (UIScreen.main.bounds.height - 5) / CGFloat(letterKeys[0].count) * scalarLetterNumSymKeyWidthLandscapeViewPad
        if !usingExpandedKeyboard {
          numSymKeyWidth = (UIScreen.main.bounds.height - 5) / CGFloat(numberKeys[0].count) * scalarLetterNumSymKeyWidthLandscapeViewPad
        }
      }
    } else {
      letterKeyWidth = (UIScreen.main.bounds.width - 6) / CGFloat(letterKeys[0].count) * scalarLetterNumSymKeyWidth
      numSymKeyWidth = (UIScreen.main.bounds.width - 6) / CGFloat(symbolKeys[0].count) * scalarLetterNumSymKeyWidth
    }
  }

  func setKeyPadding() {
    let numRows = keyboard.count
    for row in 0 ..< numRows {
      for idx in 0 ..< keyboard[row].count {
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
          && commandState != .translate
        {
          leftPadding = keyWidth / 3
          addPadding(to: stackView2, width: leftPadding, key: "y")
        }
        if DeviceType.isPhone
          && key == "a"
          && (controllerLanguage == "Portuguese"
            || controllerLanguage == "Italian"
            || commandState == .translate)
        {
          leftPadding = keyWidth / 4
          addPadding(to: stackView1, width: leftPadding, key: "a")
        }
        if DeviceType.isPad
          && key == "a"
          && !usingExpandedKeyboard
          && (controllerLanguage == "Portuguese"
            || controllerLanguage == "Italian"
            || commandState == .translate)
        {
          leftPadding = keyWidth / 3
          addPadding(to: stackView1, width: leftPadding, key: "a")
        }
        if DeviceType.isPad
          && key == "@"
          && !usingExpandedKeyboard
          && (controllerLanguage == "Portuguese"
            || controllerLanguage == "Italian"
            || commandState == .translate)
        {
          leftPadding = keyWidth / 3
          addPadding(to: stackView1, width: leftPadding, key: "@")
        }
        if DeviceType.isPad
          && key == "€"
          && !usingExpandedKeyboard
          && (controllerLanguage == "Portuguese"
            || commandState == .translate)
        {
          leftPadding = keyWidth / 3
          addPadding(to: stackView1, width: leftPadding, key: "€")
        }

        keyboardKeys.append(btn)
        if !usingExpandedKeyboard {
          switch row {
          case 0: stackView0.addArrangedSubview(btn)
          case 1: stackView1.addArrangedSubview(btn)
          case 2: stackView2.addArrangedSubview(btn)
          case 3: stackView3.addArrangedSubview(btn)
          default:
            break
          }
        } else {
          switch row {
          case 0: stackViewNum.addArrangedSubview(btn)
          case 1: stackView0.addArrangedSubview(btn)
          case 2: stackView1.addArrangedSubview(btn)
          case 3: stackView2.addArrangedSubview(btn)
          case 4: stackView3.addArrangedSubview(btn)
          default:
            break
          }
        }

        // Special key styling.
        if key == "delete" {
          let deleteLongPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(deleteLongPressed(_:)))
          btn.addGestureRecognizer(deleteLongPressRecognizer)
        }

        if key == "selectKeyboard" {
          selectKeyboardButton = btn
          selectKeyboardButton.addTarget(
            self,
            action: #selector(handleInputModeList(from:with:)),
            for: .allTouchEvents
          )
          styleIconBtn(btn: btn, color: keyCharColor, iconName: "globe")
        }

        if key == "hideKeyboard" {
          styleIconBtn(btn: btn, color: keyCharColor, iconName: "keyboard.chevron.compact.down")
        }

        if key == SpecialKeys.indent {
          styleIconBtn(btn: btn, color: keyCharColor, iconName: "arrow.forward.to.line")
        }

        if key == SpecialKeys.capsLock {
          styleIconBtn(btn: btn, color: keyCharColor, iconName: "capslock")
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
          && commandState != .translate
        {
          rightPadding = keyWidth / 3
          addPadding(to: stackView2, width: rightPadding, key: "m")
        }
        if DeviceType.isPhone
          && key == "l"
          && (controllerLanguage == "Portuguese"
            || controllerLanguage == "Italian"
            || commandState == .translate)
        {
          rightPadding = keyWidth / 4
          addPadding(to: stackView1, width: rightPadding, key: "l")
        }

        // Set the width of the key given device and the given key.
        btn.adjustKeyWidth()

        // Update the button style.
        btn.adjustButtonStyle()

        if key == "return" && proxy.keyboardType == .webSearch && ![.translate, .conjugate, .plural].contains(commandState) {
          // Override background color from adjustKeyWidth for "search" blue for web searches.
          styleIconBtn(btn: btn, color: .white.withAlphaComponent(0.9), iconName: "arrow.turn.down.left")
          btn.backgroundColor = UIColor(red: 0.0 / 255.0, green: 121.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
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
              - (CGFloat(usingExpandedKeyboard == true ? symbolKeys[0].count : numberKeys[0].count) * numSymKeyWidth)
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
          btn.leftShift = -leftPadding
        }
        if rightPadding == CGFloat(0) {
          btn.rightShift = -(widthOfSpacing / 2)
        } else {
          btn.rightShift = -rightPadding
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
  }

  // MARK: Load Keys

  /// Loads the keys given the current constraints.
  func loadKeys() {
    // The name of the language keyboard that's referencing KeyboardViewController.
    controllerLanguage = classForCoder.description().components(separatedBy: ".KeyboardViewController")[0]
    if let userDefaults = UserDefaults(suiteName: "group.scribe.userDefaultsContainer") {
      if userDefaults.bool(forKey: "svAccentCharacters") {
        disableAccentCharacters = true
      } else {
        disableAccentCharacters = false
      }
    }

    // Actions to be done only on initial loads.
    if isFirstKeyboardLoad {
      shiftButtonState = .shift
      commandBar.textColor = keyCharColor
      commandBar.conditionallyAddPlaceholder() // in case of color mode change during commands
      keyboardView.backgroundColor? = keyboardBgColor
      allNonSpecialKeys = allKeys.filter { !specialKeys.contains($0) }

      // Check if the device has a home button and is large enough so we should use an expanded keyboard.
      if DeviceType.isPad {
        if UIScreen.main.bounds.width > 768 {
          usingExpandedKeyboard = true
        } else {
          usingExpandedKeyboard = false
        }
      }

      linkShadowBlendElements()
      setAutoActionPartitions()
      conditionallyShowTopNumbersRow()

      // Show the name of the keyboard to the user.
      showKeyboardLanguage = true

      // Initialize the language database and create the autosuggestions lexicon.
      languageDB = openDBQueue()

      // Add UILexicon words including unpaired first and last names from Contacts to autocompletions.
      let addToAutocompleteLexiconQuery = "INSERT OR IGNORE INTO autocomplete_lexicon (word) VALUES (?)"
      requestSupplementaryLexicon { (userLexicon: UILexicon?) in
        if let lexicon = userLexicon {
          for item in lexicon.entries {
            if item.documentText.count > 1 {
              writeDBRow(query: addToAutocompleteLexiconQuery, args: [item.documentText])
            }
          }
        }
      }

      // Drop non-unique values in case the lexicon has added words that were already present.
      let dropNonUniqueAutosuggestionsQuery = """
      DELETE FROM autocomplete_lexicon
      WHERE rowid NOT IN (
        SELECT
          MIN(rowid)

        FROM
          autocomplete_lexicon

        GROUP BY
          word
      )
      """
      do {
        try languageDB.write { db in
          try db.execute(sql: dropNonUniqueAutosuggestionsQuery)
        }
      } catch let error as DatabaseError {
        let errorMessage = error.message
        let errorSQL = error.sql
        print(
          "An error '\(String(describing: errorMessage))' occurred in the query: \(String(describing: errorSQL))"
        )
      } catch {}
    }

    setKeyboard()
    setCommaAndPeriodKeysConditionally()
    setCommandBackground()
    setCommandBtns()
    setConjugationBtns()

    // Clear annotation state if a keyboard state change dictates it.
    if !annotationState {
      annotationBtns.forEach { $0.removeFromSuperview() }
      annotationBtns.removeAll()
      annotationSeparators.forEach { $0.removeFromSuperview() }
      annotationSeparators.removeAll()
    }

    // Clear interface from the last state.
    keyboardKeys.forEach { $0.removeFromSuperview() }
    paddingViews.forEach { $0.removeFromSuperview() }

    setKeywidth()

    // Derive keyboard given current states and set widths.
    switch keyboardState {
    case .letters:
      keyboard = letterKeys
      keyWidth = letterKeyWidth

      // Auto-capitalization if the cursor is at the start of the proxy.
      if let documentContext = proxy.documentContextBeforeInput, documentContext.isEmpty {
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
      if isLandscapeView {
        keyCornerRadius = keyWidth / scalarKeyCornerRadiusLandscapeViewPhone
        commandKeyCornerRadius = keyWidth / scalarCommandKeyCornerRadiusLandscapeViewPhone
      } else {
        keyCornerRadius = keyWidth / scalarKeyCornerRadiusPhone
        commandKeyCornerRadius = keyWidth / scalarCommandKeyCornerRadiusPhone
      }
    } else if DeviceType.isPad {
      if isLandscapeView {
        keyCornerRadius = keyWidth / scalarKeyCornerRadiusLandscapeViewPad
        commandKeyCornerRadius = keyWidth / scalarCommandKeyCornerRadiusLandscapeViewPad
      } else {
        keyCornerRadius = keyWidth / scalarKeyCornerRadiusPad
        commandKeyCornerRadius = keyWidth / scalarCommandKeyCornerRadiusPad
      }
    }

    if ![
      .selectVerbConjugation, .selectCaseDeclension, .displayInformation
    ].contains(commandState) { // normal keyboard view
      for view in [stackViewNum, stackView0, stackView1, stackView2, stackView3] {
        view?.isUserInteractionEnabled = true
        view?.isLayoutMarginsRelativeArrangement = true

        // Set edge insets for stack views to provide vertical key spacing.
        if DeviceType.isPad {
          if view == stackViewNum {
            view?.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
          } else if view == stackView0 {
            view?.layoutMargins = UIEdgeInsets(top: 2, left: 0, bottom: 6, right: 0)
          } else if view == stackView1 {
            view?.layoutMargins = UIEdgeInsets(top: 3, left: 0, bottom: 4, right: 0)
          } else if view == stackView2 {
            view?.layoutMargins = UIEdgeInsets(top: 3, left: 0, bottom: 4, right: 0)
          } else if view == stackView3 {
            view?.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 3, right: 0)
          }
        } else {
          if view == stackViewNum {
            view?.layoutMargins = UIEdgeInsets(top: 3, left: 0, bottom: 4, right: 0)
          } else if view == stackView0 {
            view?.layoutMargins = UIEdgeInsets(top: 3, left: 0, bottom: 8, right: 0)
          } else if view == stackView1 {
            view?.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 6, right: 0)
          } else if view == stackView2 {
            view?.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 6, right: 0)
          } else if view == stackView3 {
            view?.layoutMargins = UIEdgeInsets(top: 6, left: 0, bottom: 5, right: 0)
          }
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
        translateKey.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarCommandKeyHeightPhone)
        conjugateKey.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarCommandKeyHeightPhone)
        pluralKey.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarCommandKeyHeightPhone)
      } else if DeviceType.isPad {
        translateKey.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarCommandKeyHeightPad)
        conjugateKey.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarCommandKeyHeightPad)
        pluralKey.titleLabel?.font = .systemFont(ofSize: scribeKey.frame.height * scalarCommandKeyHeightPad)
      }

      if commandState == .selectCommand {
        styleBtn(btn: translateKey, title: translateKeyLbl, radius: commandKeyCornerRadius)
        styleBtn(btn: conjugateKey, title: conjugateKeyLbl, radius: commandKeyCornerRadius)
        styleBtn(btn: pluralKey, title: pluralKeyLbl, radius: commandKeyCornerRadius)

        scribeKey.toEscape()
        scribeKey.setFullCornerRadius()
        scribeKey.setFullShadow()

        commandBar.hide()
        hideAutoActionPartitions()
      } else {
        deactivateBtn(btn: conjugateKey)
        deactivateBtn(btn: translateKey)
        deactivateBtn(btn: pluralKey)

        deactivateBtn(btn: phoneEmojiKey0)
        deactivateBtn(btn: phoneEmojiKey1)
        deactivateBtn(btn: padEmojiKey0)
        deactivateBtn(btn: padEmojiKey1)
        deactivateBtn(btn: padEmojiKey2)

        if [.translate, .conjugate, .plural].contains(commandState) {
          scribeKey.setPartialCornerRadius()
          scribeKey.setPartialShadow()
          scribeKey.toEscape()

          commandBar.set()
          commandBar.setCornerRadiusAndShadow()
          hideAutoActionPartitions()
        } else if [.alreadyPlural, .invalid].contains(commandState) {
          // Command bar as a view for invalid messages with a Scribe key to allow for new commands.
          scribeKey.setPartialCornerRadius()
          scribeKey.setPartialShadow()

          commandBar.set()
          commandBar.setCornerRadiusAndShadow()
          hideAutoActionPartitions()
        } else if commandState == .idle {
          scribeKey.setFullCornerRadius()
          scribeKey.setFullShadow()

          commandBar.text = ""
          commandBar.hide()
          // Set autosuggestions on keyboard's first load.
          if isFirstKeyboardLoad {
            conditionallySetAutoActionBtns()
          }
        }
      }

      setKeyPadding()

    } else {
      // Load conjugation view.
      for view in [stackViewNum, stackView0, stackView1, stackView2, stackView3] {
        view?.isUserInteractionEnabled = false
      }

      scribeKey.toEscape()
      scribeKey.setPartialShadow()
      scribeKey.setPartialCornerRadius()

      commandBar.backgroundColor = commandBarColor
      commandBarBlend.backgroundColor = commandBarColor
      commandBar.textColor = keyCharColor
      commandBar.set()
      commandBar.setCornerRadiusAndShadow()
      hideAutoActionPartitions()

      deactivateBtn(btn: conjugateKey)
      deactivateBtn(btn: translateKey)
      deactivateBtn(btn: pluralKey)

      deactivateBtn(btn: phoneEmojiKey0)
      deactivateBtn(btn: phoneEmojiKey1)
      deactivateBtn(btn: padEmojiKey0)
      deactivateBtn(btn: padEmojiKey1)
      deactivateBtn(btn: padEmojiKey2)

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

  func setCommaAndPeriodKeysConditionally() {
    let langCode = languagesAbbrDict[controllerLanguage] ?? "unknown"
    if let userDefaults = UserDefaults(suiteName: "group.scribe.userDefaultsContainer") {
      let dictionaryKey = langCode + "CommaAndPeriod"
      let letterKeysHaveCommaPeriod = userDefaults.bool(forKey: dictionaryKey)

      if letterKeysHaveCommaPeriod {
        let spaceIndex = letterKeys[3].firstIndex(where: { $0 == "space" })
        letterKeys[3].insert(",", at: spaceIndex!)
        letterKeys[3].insert(".", at: spaceIndex! + 2)
      }
    }
  }

  func emojiAutosuggestIsEnabled() -> Bool {
    let langCode = languagesAbbrDict[controllerLanguage] ?? "unknown"
    if let userDefaults = UserDefaults(suiteName: "group.scribe.userDefaultsContainer") {
      let dictionaryKey = langCode + "EmojiAutosuggest"

      return userDefaults.bool(forKey: dictionaryKey)
    } else {
      return true // return the default value
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
      let keyToDisplay = sender.layer.value(forKey: "keyToDisplay") as? String
    else {
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
        emojisToShow = .zero
        loadKeys()
        selectedWordAnnotation(KVC: self)
      } else {
        if [.translate,
            .conjugate,
            .selectVerbConjugation,
            .selectCaseDeclension,
            .plural].contains(commandState)
        { // escape
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
        let conjugationTblTriggered = triggerVerbConjugation(commandBar: commandBar)
        if conjugationTblTriggered {
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
      conditionallyHideEmojiDividers()
      loadKeys()
      commandBar.textColor = keyCharColor
      commandBar.attributedText = translatePromptAndColorPlaceholder

    case "Conjugate":
      commandState = .conjugate
      conditionallyHideEmojiDividers()
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
      conditionallyHideEmojiDividers()
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

    case "AutoAction0":
      executeAutoAction(keyPressed: translateKey)

    case "AutoAction1":
      executeAutoAction(keyPressed: conjugateKey)

    case "AutoAction2":
      executeAutoAction(keyPressed: pluralKey)
      if emojisToShow == .one {
        if shiftButtonState == .normal {
          shiftButtonState = .shift
        }
        loadKeys()
      }

    case "EmojiKey0":
      if DeviceType.isPhone || emojisToShow == .two {
        executeAutoAction(keyPressed: phoneEmojiKey0)
      } else if DeviceType.isPad {
        executeAutoAction(keyPressed: padEmojiKey0)
      }
      if shiftButtonState == .normal {
        shiftButtonState = .shift
      }
      loadKeys()

    case "EmojiKey1":
      if DeviceType.isPhone || emojisToShow == .two {
        executeAutoAction(keyPressed: phoneEmojiKey1)
      } else if DeviceType.isPad {
        executeAutoAction(keyPressed: padEmojiKey1)
      }
      if shiftButtonState == .normal {
        shiftButtonState = .shift
      }
      loadKeys()

    case "EmojiKey2":
      executeAutoAction(keyPressed: padEmojiKey2)
      if shiftButtonState == .normal {
        shiftButtonState = .shift
      }
      loadKeys()

    case "GetAnnotationInfo":
      // Remove all prior annotations.
      annotationBtns.forEach { $0.removeFromSuperview() }
      annotationBtns.removeAll()
      annotationSeparators.forEach { $0.removeFromSuperview() }
      annotationSeparators.removeAll()

      for i in 0 ..< annotationBtns.count {
        annotationBtns[i].backgroundColor = annotationColors[i]
      }

      if let wordSelected = proxy.selectedText {
        wordToCheck = wordSelected
      } else {
        if let contextBeforeInput = proxy.documentContextBeforeInput {
          wordsTyped = contextBeforeInput.components(separatedBy: " ")
          let lastWordTyped = wordsTyped.secondToLast()
          if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
            wordToCheck = lastWordTyped!.lowercased()
          } else {
            wordToCheck = lastWordTyped!
          }
        }
      }
      let prepCaseQuery = "SELECT * FROM prepositions WHERE preposition = ?"
      let prepCaseArgs = [wordToCheck.lowercased()]
      let outputCols = ["form"]

      let prepForm = queryDBRow(query: prepCaseQuery, outputCols: outputCols, args: prepCaseArgs)[0]
      hasPrepForm = !prepForm.isEmpty
      if hasPrepForm {
        resetCaseDeclensionState()
        commandState = .selectCaseDeclension
        loadKeys() // go to conjugation view
        return
      } else {
        return
      }

    case "ScribeAnnotation":
      for i in 0 ..< annotationBtns.count {
        annotationBtns[i].backgroundColor = annotationColors[i]
      }
      let emojisToSelectFrom = "🥳🎉"
      let emojis = String((0 ..< 3).compactMap { _ in emojisToSelectFrom.randomElement() })
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
        if let commandBarText = commandBar?.text, let commandBarAttributedText = commandBar?.attributedText {
          if allPrompts.contains(commandBarText) || allColoredPrompts.contains(commandBarAttributedText) {
            shiftButtonState = .shift // Auto-capitalization
            loadKeys()
            // Function call required due to return.
            // Not including means placeholder is never added on last delete action.
            commandBar.conditionallyAddPlaceholder()
            return
          }
        }

        handleDeleteButtonPressed()

        // Inserting the placeholder when commandBar text is deleted.
        commandBar.conditionallyAddPlaceholder()
      }

    case spaceBar, languageTextForSpaceBar:
      if currentPrefix != completionWords[0] && (completionWords[0] != " " && spaceAutoInsertIsPossible) {
        previousWord = currentPrefix
        clearPrefixFromTextFieldProxy()
        proxy.insertText(completionWords[0])
        autoActionState = .suggest
        currentPrefix = ""
        firstCompletionIsHighlighted = false
        spaceAutoInsertIsPossible = false
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
        if let commandBarText = commandBar?.text {
          commandBar?.text = commandBarText.insertPriorToCursor(char: " ")
          if [". " + commandCursor, "? " + commandCursor, "! " + commandCursor].contains(String(commandBarText.suffix(3))) {
            shiftButtonState = .shift
          }
          if keyboardState != .letters {
            changeKeyboardToLetterKeys()
          }
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
        if let commandBarText = commandBar.text {
          commandBar.text = commandBarText.insertPriorToCursor(char: "'")
        }
      }
      changeKeyboardToLetterKeys()

    case "-":
      if [.idle, .selectCommand, .alreadyPlural, .invalid].contains(commandState) {
        if proxy.documentContextBeforeInput?.last == "-" {
          proxy.deleteBackward()
          proxy.insertText("—")
        } else {
          proxy.insertText(keyToDisplay)
        }
      } else {
        if let commandBarText = commandBar.text {
          commandBar.text = commandBarText.insertPriorToCursor(char: keyToDisplay)
        }
      }

    case ",", ".", "!", "?":
      if [.idle, .selectCommand, .alreadyPlural, .invalid].contains(commandState) {
        if proxy.documentContextBeforeInput?.last == " " {
          proxy.deleteBackward()
        }
        proxy.insertText(keyToDisplay)
      } else {
        if let commandBarText = commandBar.text {
          commandBar.text = commandBarText.insertPriorToCursor(char: keyToDisplay)
        }
      }

    case "shift":
      if capsLockButtonState == .locked {
        // Return capitalization to default.
        capsLockButtonState = .normal
        shiftButtonState = .normal
      } else {
        shiftButtonState = shiftButtonState == .normal ? .shift : .normal
      }

      loadKeys()
      capsLockPossible = true

    case "123", ".?123":
      usingExpandedKeyboard == true ? changeKeyboardToSymbolKeys() : changeKeyboardToNumberKeys()

    case "#+=":
      changeKeyboardToSymbolKeys()

    case "ABC", "АБВ":
      changeKeyboardToLetterKeys()
      autoCapAtStartOfProxy()

    case SpecialKeys.capsLock:
      switchToFullCaps()

    case SpecialKeys.indent:
      proxy.insertText("\t")

    case "selectKeyboard":
      advanceToNextInputMode()

    case "hideKeyboard":
      dismissKeyboard()

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
        if let currentText = commandBar.text {
          commandBar.text = currentText.insertPriorToCursor(char: keyToDisplay)
        }
      }
    }

    // Cancel already plural and invalid states after another key press.
    if [.alreadyPlural, .invalid].contains(commandState) {
      commandState = .idle
      loadKeys()
    }

    // Reset emoji repeat functionality.
    if !(
      ["EmojiKey0", "EmojiKey1", "EmojiKey2"].contains(originalKey)
        || (originalKey == "AutoAction2" && emojisToShow == .one)
    ) {
      emojiAutoActionRepeatPossible = false
    }

    if !["Scribe"].contains(originalKey) {
      emojisToShow = .zero
    }

    // Add partitions and show auto actions if the keyboard states dictate.
    conditionallyShowAutoActionPartitions()
    conditionallySetAutoActionBtns()

    if !annotationState {
      annotationBtns.forEach { $0.removeFromSuperview() }
      annotationBtns.removeAll()
      annotationSeparators.forEach { $0.removeFromSuperview() }
      annotationSeparators.removeAll()
    }
    annotationState = false
    activateAnnotationBtn = false

    // Remove alternates view if it's present.
    if view.viewWithTag(1001) != nil {
      let viewWithTag = view.viewWithTag(1001)
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

    if let touches = event.allTouches, let touch = touches.first {
      // Caps lock given two taps of shift.
      if touch.tapCount == 2 && originalKey == "shift" && capsLockPossible {
        switchToFullCaps()
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
        && doubleSpacePeriodPossible
      {
        // The fist condition prevents a period if the prior characters are spaces as the user wants a series of spaces.
        if proxy.documentContextBeforeInput?.suffix(2) != "  " && ![.translate, .conjugate, .plural].contains(commandState) {
          proxy.deleteBackward()
          proxy.insertText(". ")
          emojisToShow = .zero // was showing empty emoji spots
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
  }

  private func switchToFullCaps() {
    // Return SHIFT button to normal state as the CAPSLOCK button will be enabled.
    shiftButtonState = .normal
    capsLockButtonState = capsLockButtonState == .normal ? .locked : .normal

    loadKeys()
    conditionallySetAutoActionBtns()
  }

  /// Defines the criteria under which delete is long pressed.
  ///
  /// - Parameters
  ///   - gesture: the gesture that was received.
  @objc func deleteLongPressed(_ gesture: UIGestureRecognizer) {
    // Prevent the command state prompt from being deleted.
    if let commandBarText = commandBar?.text, [.translate, .conjugate, .plural].contains(commandState), allPrompts.contains(commandBarText) {
      gesture.state = .cancelled
      commandBar.conditionallyAddPlaceholder()
    }

    // Delete is sped up based on the number of deletes that have been completed.
    var deleteCount = 0
    if gesture.state == .began {
      backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
        deleteCount += 1
        self.handleDeleteButtonPressed()

        if deleteCount == 20 {
          backspaceTimer?.invalidate()
          backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { _ in
            deleteCount += 1
            self.handleDeleteButtonPressed()

            if deleteCount == 50 {
              backspaceTimer?.invalidate()
              backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { _ in
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

    view.layer.addSublayer(keyPopLayer)
    view.addSubview(keyPopChar)
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
    _ = Timer.scheduledTimer(withTimeInterval: 0.00001, repeats: false) { _ in
      if keysWithAlternates.contains(charPressed) {
        self.setAlternatesView(sender: sender)
        keyHoldPopLayer.removeFromSuperlayer()
        keyHoldPopChar.removeFromSuperview()
      }
    }

    switch sender.state {
    case .began:
      genKeyPop(key: key, layer: keyHoldPopLayer, char: charPressed, displayChar: displayChar)
      view.layer.addSublayer(keyHoldPopLayer)
      view.addSubview(keyHoldPopChar)

    case .ended:
      // Remove the key hold pop up and execute key only if the alternates view isn't present.
      keyHoldPopLayer.removeFromSuperlayer()
      keyHoldPopChar.removeFromSuperview()
      if !keysWithAlternates.contains(charPressed) {
        executeKeyActions(key)
      } else if view.viewWithTag(1001) == nil {
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
    var alternatesBtnY = key.frame.height * scalarAlternatesBtnYPhone
    if DeviceType.isPad {
      alternatesBtnY = key.frame.height * scalarAlternatesBtnYPad
    }
    for char in alternateKeys {
      let alternateKey = KeyboardKey(
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
        setBtn(btn: alternateKey, color: commandKeyColor, name: char, canBeCapitalized: true, isSpecial: false)
      } else if char == alternateKeys.last && keysWithAlternatesRight.contains(char) {
        setBtn(btn: alternateKey, color: commandKeyColor, name: char, canBeCapitalized: true, isSpecial: false)
      } else {
        setBtn(btn: alternateKey, color: keyColor, name: char, canBeCapitalized: true, isSpecial: false)
      }
      activateBtn(btn: alternateKey)

      alternateBtnStartX += (key.frame.width + 3.0)
    }

    // If alternateKeysView is already added than remove and then add again.
    if view.viewWithTag(1001) != nil {
      let viewWithTag = view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
      alternatesShapeLayer.removeFromSuperlayer()
    }

    view.layer.addSublayer(alternatesShapeLayer)
    view.addSubview(alternatesKeyView)
  }
}
