//
//  KeyboardViewController.swift
//
//  A parent KeyboardViewController class that is inherited by all Scribe keyboards.
//

import UIKit

// All data needed for Scribe features for the given language keyboard.
let nouns = loadJSONToDict(filename: "nouns")
let verbs = loadJSONToDict(filename: "verbs")
let translations = loadJSONToDict(filename: "translations")
let prepositions = loadJSONToDict(filename: "prepositions")

class KeyboardViewController: UIInputViewController {
  var keyboardView: UIView!
  var keys: [UIButton] = []
  var paddingViews: [UIButton] = []
  @IBOutlet var selectKeyboardButton: UIButton!
  var backspaceTimer: Timer?

  // Stack views that are populated with they keyboard rows.
  @IBOutlet weak var stackView1: UIStackView!
  @IBOutlet weak var stackView2: UIStackView!
  @IBOutlet weak var stackView3: UIStackView!
  @IBOutlet weak var stackView4: UIStackView!

  /// Sets the keyboard layouts given the chosen keyboard and device type.
  func setKeyboardLayouts() {
    if controllerLanguage == "German" {
      if DeviceType.isPhone {
        letterKeys = GermanKeyboardConstants.letterKeysPhone
        numberKeys = GermanKeyboardConstants.numberKeysPhone
        symbolKeys = GermanKeyboardConstants.symbolKeysPhone
      } else {
        letterKeys = GermanKeyboardConstants.letterKeysPad
        numberKeys = GermanKeyboardConstants.numberKeysPad
        symbolKeys = GermanKeyboardConstants.symbolKeysPad
      }
    } else if controllerLanguage == "Spanish" {
      if DeviceType.isPhone {
        letterKeys = SpanishKeyboardConstants.letterKeysPhone
        numberKeys = SpanishKeyboardConstants.numberKeysPhone
        symbolKeys = SpanishKeyboardConstants.symbolKeysPhone
      } else {
        letterKeys = SpanishKeyboardConstants.letterKeysPad
        numberKeys = SpanishKeyboardConstants.numberKeysPad
        symbolKeys = SpanishKeyboardConstants.symbolKeysPad
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

  /// Styles a button's appearance including it's shape and text.
  ///
  /// - Parameters
  ///  - btn: the button to be styled.
  ///  - title: the title to be assigned.
  ///  - radius: the corner radius of the button.
  func styleBtn(btn: UIButton, title: String, radius: CGFloat) {
    btn.clipsToBounds = true
    btn.layer.masksToBounds = true
    btn.layer.cornerRadius = radius
    btn.setTitle(title, for: .normal)
    btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    btn.setTitleColor(UIColor.label, for: .normal)
  }

  /// Activates a button by assigning key touch functions for their given actions.
  ///
  /// - Parameters
  ///   - btn: the button to be activated.
  func activateBtn(btn: UIButton) {
    btn.addTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
    btn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
    btn.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
  }

  /// Deavtives a button by removing key touch functions for their given actions and making it clear.
  ///
  /// - Parameters
  ///   - btn: the button to be deactivated.
  func deactivateBtn(btn: UIButton) {
    btn.setTitle("", for: .normal)
    btn.backgroundColor = UIColor.clear
    btn.removeTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
    btn.removeTarget(self, action: #selector(keyTouchDown), for: .touchDown)
    btn.removeTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
  }

  /// Deletes in the proxy or preview bar given the current constaints.
  func handlDeleteButtonPressed() {
    if previewState != true {
      proxy.deleteBackward()
    } else if !(previewState == true && allPrompts.contains((previewBar?.text!)!)) {
      guard
        let text = previewBar?.text,
        !text.isEmpty
      else {
        return
      }
      previewBar?.text = previewBar.text!.deletePriorToCursor()
    } else {
      backspaceTimer?.invalidate()
      backspaceTimer = nil
    }
  }

  // MARK: Scribe command elements

  /// Sets a button's values that are displayed and inseted into the proxy as well as assigning a color.
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

  // The bar that displays language logic or is typed into for Scribe commands.
  @IBOutlet var previewBar: UILabel!

  /// Sets up the preview bar's color and text allignment.
  func setPreviewBar() {
    previewBar?.backgroundColor = specialKeyColor
    previewBar?.textAlignment = NSTextAlignment.left
  }

  // The button used to display Scribe commands.
  @IBOutlet var scribeBtn: UIButton!

  /// Assigns the icon and sets up the Scribe button.
  func setScribeBtn() {
    scribeBtn.setImage(UIImage(named: "ScribeBtn.png"), for: .normal)
    setBtn(btn: scribeBtn, color: UIColor.scribeBlue, name: "Scribe", canCapitalize: false, isSpecial: false)
  }

  func scribeBtnToEscape() {
    scribeBtn.setTitle("", for: .normal)
    var selectKeyboardIconConfig = UIImage.SymbolConfiguration(pointSize: buttonWidth / 1.75, weight: .regular, scale: .medium)
    if DeviceType.isPad {
      selectKeyboardIconConfig = UIImage.SymbolConfiguration(pointSize: buttonWidth / 3, weight: .regular, scale: .medium)
    }
    scribeBtn.setImage(UIImage(systemName: "xmark", withConfiguration: selectKeyboardIconConfig), for: .normal)
    scribeBtn.tintColor = UIColor.scribeGrey
  }

  // Buttons used to trigger Scribe command functionality.
  @IBOutlet var translateBtn: UIButton!
  @IBOutlet var conjugateBtn: UIButton!
  @IBOutlet var pluralBtn: UIButton!

  /// Sets up all buttons that are assosciated with Scribe commands.
  func setCommandBtns() {
    setBtn(btn: translateBtn, color: specialKeyColor, name: "Translate", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtn, color: specialKeyColor, name: "Conjugate", canCapitalize: false, isSpecial: false)
    setBtn(btn: pluralBtn, color: specialKeyColor, name: "Plural", canCapitalize: false, isSpecial: false)
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

  /// Sets up all buttons that are associated with the conjugation display.
  func setConjugationBtns() {
    setBtn(btn: conjugateBtnFPS, color: keyColor, name: "firstPersonSingular", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnSPS, color: keyColor, name: "secondPersonSingular", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnTPS, color: keyColor, name: "thirdPersonSingular", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnFPP, color: keyColor, name: "firstPersonPlural", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnSPP, color: keyColor, name: "secondPersonPlural", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtnTPP, color: keyColor, name: "thirdPersonPlural", canCapitalize: false, isSpecial: false)

    setBtn(btn: conjugateShiftLeftBtn, color: keyColor, name: "shiftConjugateLeft", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateShiftRightBtn, color: keyColor, name: "shiftConjugateRight", canCapitalize: false, isSpecial: false)
  }

  /// Activates all buttons that are associated with the conjugation display.
  func activateConjugationDisplay() {
    activateBtn(btn: conjugateBtnFPS)
    activateBtn(btn: conjugateBtnSPS)
    activateBtn(btn: conjugateBtnTPS)
    activateBtn(btn: conjugateBtnFPP)
    activateBtn(btn: conjugateBtnSPP)
    activateBtn(btn: conjugateBtnTPP)

    activateBtn(btn: conjugateShiftLeftBtn)
    activateBtn(btn: conjugateShiftRightBtn)
  }

  /// Deactivates all buttons that are associated with the conjugation display.
  func deactivateConjugationDisplay() {
    deactivateBtn(btn: conjugateBtnFPS)
    deactivateBtn(btn: conjugateBtnSPS)
    deactivateBtn(btn: conjugateBtnTPS)
    deactivateBtn(btn: conjugateBtnFPP)
    deactivateBtn(btn: conjugateBtnSPP)
    deactivateBtn(btn: conjugateBtnTPP)

    deactivateBtn(btn: conjugateShiftLeftBtn)
    deactivateBtn(btn: conjugateShiftRightBtn)
  }

  /// Sets the label of the conjugation statea nd assigns the current tenses that are accessed to label the buttons.
  func setConjugationState() {
    if controllerLanguage == "German" {
      previewBar?.text = deGetConjugationTitle()

      tenseFPS = deGetConjugationState() + "FPS"
      tenseSPS = deGetConjugationState() + "SPS"
      tenseTPS = deGetConjugationState() + "TPS"
      tenseFPP = deGetConjugationState() + "FPP"
      tenseSPP = deGetConjugationState() + "SPP"
      tenseTPP = deGetConjugationState() + "TPP"
    } else if controllerLanguage == "Spanish" {
      previewBar?.text = esGetConjugationTitle()

      tenseFPS = esGetConjugationState() + "FPS"
      tenseSPS = esGetConjugationState() + "SPS"
      tenseTPS = esGetConjugationState() + "TPS"
      tenseFPP = esGetConjugationState() + "FPP"
      tenseSPP = esGetConjugationState() + "SPP"
      tenseTPP = esGetConjugationState() + "TPP"
    }

    let allTenses = [tenseFPS, tenseSPS, tenseTPS, tenseFPP, tenseSPP, tenseTPP]
    let allConjugationBtns = [conjugateBtnFPS, conjugateBtnSPS, conjugateBtnTPS, conjugateBtnFPP, conjugateBtnSPP, conjugateBtnTPP]

    // Assign the invalid message if the conjugation isn't present in the directory.
    for index in 0..<allTenses.count {
      if verbs?[verbToConjugate]![allTenses[index]] as? String == "" {
        styleBtn(btn: allConjugationBtns[index]!, title: "Not in directory", radius: keyCornerRadius)
      } else {
        styleBtn(btn: allConjugationBtns[index]!, title: verbs?[verbToConjugate]![allTenses[index]] as! String, radius: keyCornerRadius)
      }
    }
  }

  /// Adds padding to keys to position them.
  /// - Parameters
  ///  - to: the stackView in which the button is found.
  ///  - width: the width of the padding.
  ///  - key: the key assosciated with the bytton.
  func addPadding(to stackView: UIStackView, width: CGFloat, key: String) {
    let padding = UIButton(frame: CGRect(x: 0, y: 0, width: 3, height: 5))
    padding.setTitleColor(.clear, for: .normal)
    padding.alpha = 0.0
    padding.widthAnchor.constraint(equalToConstant: width).isActive = true

    // If we want to use this padding as a key.
    let keyToDisplay = shiftButtonState == .normal ? key : key.capitalized
    padding.layer.setValue(key, forKey: "original")
    padding.layer.setValue(keyToDisplay, forKey: "keyToDisplay")
    padding.layer.setValue(false, forKey: "isSpecial")
    padding.addTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
    padding.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
    padding.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)

    paddingViews.append(padding)
    stackView.addArrangedSubview(padding)
  }
  // Place before or after desiredStackView.addArrangedSubview(button) in loadKeys.
  // addPadding(to: desiredStackView, width: buttonWidth/2, key: "desiredKey")

  // MARK: Override UIInputViewController functions

  /// Includes adding custom view sizing constraints.
  override func updateViewConstraints() {
    super.updateViewConstraints()
    keyboardView.frame.size = view.frame.size
  }

  /// Includes instantiation of the interface builder given the UINib, adding sub views, and loading keys.
  func loadInterface() {
    let keyboardNib = UINib(nibName: "Keyboard", bundle: nil)
    keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as? UIView
    keyboardView.translatesAutoresizingMaskIntoConstraints = true
    view.addSubview(keyboardView)
    loadKeys()
  }

  /// Includes assignment of the proxy, loading the Scribe interface, and adds the keyboard selector target.
  override func viewDidLoad() {
    super.viewDidLoad()

    proxy = textDocumentProxy as UITextDocumentProxy
    loadInterface()
    self.selectKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
  }

  /// Includes hiding the keyboard selector button if it is not needed for the current device.
  override func viewWillLayoutSubviews() {
    self.selectKeyboardButton.isHidden = !self.needsInputModeSwitchKey
    super.viewWillLayoutSubviews()
  }

  /// Includes conditions to assign the keyboard height given device type and orientation.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if DeviceType.isPhone {
      if isLandscapeView == true {
        keyboardHeight = 180
      } else {
        keyboardHeight = 240
      }
    } else if DeviceType.isPad {
      if isLandscapeView == true {
        keyboardHeight = 320
      } else {
        keyboardHeight = 340
      }
    }

    let heightConstraint = NSLayoutConstraint(item: view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: keyboardHeight)
    view.addConstraint(heightConstraint)
  }

  /// Includes a call to loadKeys to reload the display after an orientation change.
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    loadKeys()
  }

  // MARK: Load keys

  /// Loads the keys given the current constraints.
  func loadKeys() {
    // German or Spanish
    controllerLanguage = classForCoder.description().components(separatedBy: ".KeyboardViewController")[0]

    if controllerLanguage == "German" {
      keysWithAlternates = GermanKeyboardConstants.keysWithAlternates
      keysWithAlternatesLeft = GermanKeyboardConstants.keysWithAlternatesLeft
      keysWithAlternatesRight = GermanKeyboardConstants.keysWithAlternatesRight
      aAlternateKeys = GermanKeyboardConstants.aAlternateKeys
      eAlternateKeys = GermanKeyboardConstants.eAlternateKeys
      iAlternateKeys = GermanKeyboardConstants.iAlternateKeys
      oAlternateKeys = GermanKeyboardConstants.oAlternateKeys
      uAlternateKeys = GermanKeyboardConstants.uAlternateKeys
      yAlternateKeys = GermanKeyboardConstants.yAlternateKeys
      sAlternateKeys = GermanKeyboardConstants.sAlternateKeys
      cAlternateKeys = GermanKeyboardConstants.cAlternateKeys
      nAlternateKeys = GermanKeyboardConstants.nAlternateKeys
    } else if controllerLanguage == "Spanish" {
      keysWithAlternates = SpanishKeyboardConstants.keysWithAlternates
      keysWithAlternatesLeft = SpanishKeyboardConstants.keysWithAlternatesLeft
      keysWithAlternatesRight = SpanishKeyboardConstants.keysWithAlternatesRight
      aAlternateKeys = SpanishKeyboardConstants.aAlternateKeys
      eAlternateKeys = SpanishKeyboardConstants.eAlternateKeys
      iAlternateKeys = SpanishKeyboardConstants.iAlternateKeys
      oAlternateKeys = SpanishKeyboardConstants.oAlternateKeys
      uAlternateKeys = SpanishKeyboardConstants.uAlternateKeys
      sAlternateKeys = SpanishKeyboardConstants.sAlternateKeys
      dAlternateKeys = SpanishKeyboardConstants.dAlternateKeys
      cAlternateKeys = SpanishKeyboardConstants.cAlternateKeys
      nAlternateKeys = SpanishKeyboardConstants.nAlternateKeys
    }

    checkLandscapeMode()
    checkDarkModeSetColors()
    setKeyboardLayouts()
    setScribeBtn()
    setPreviewBar()
    setCommandBtns()
    setConjugationBtns()
    invalidState = false

    // Clear interface from the last state.
    keys.forEach {$0.removeFromSuperview()}
    paddingViews.forEach {$0.removeFromSuperview()}

    // Start new keyboard.
    var keyboard: [[String]]

    if UITraitCollection.current.userInterfaceStyle == .dark {
      keyboardView.backgroundColor? = UIColor.systemGray5
    } else if UITraitCollection.current.userInterfaceStyle == .light {
      keyboardView.backgroundColor? = UIColor.systemGray4
    }

    // buttonWidth determined per keyboard by the top row.
    var letterButtonWidth = CGFloat(0)
    var numSymButtonWidth = CGFloat(0)

    if isLandscapeView == true {
      if DeviceType.isPhone {
        letterButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(letterKeys[0].count) * 1.8
        numSymButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(numberKeys[0].count) * 1.8
      } else if DeviceType.isPad {
        letterButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(letterKeys[0].count) * 1.3
        numSymButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(numberKeys[0].count) * 1.3
      }
    } else {
      letterButtonWidth = (UIScreen.main.bounds.width - 5) / CGFloat(letterKeys[0].count)
      numSymButtonWidth = (UIScreen.main.bounds.width - 5) / CGFloat(numberKeys[0].count)
    }

    switch keyboardState {
    case .letters:
      keyboard = letterKeys
      buttonWidth = letterButtonWidth
      // Auto-capitalization.
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
        keyCornerRadius = buttonWidth / 8
      } else {
        keyCornerRadius = buttonWidth / 4
      }
    } else if DeviceType.isPad {
      if isLandscapeView == true {
        keyCornerRadius = buttonWidth / 12
      } else {
        keyCornerRadius = buttonWidth / 8
      }
    }

    if !conjugateView { // normal keybaord view
      stackView1.isUserInteractionEnabled = true
      stackView2.isUserInteractionEnabled = true
      stackView3.isUserInteractionEnabled = true
      stackView4.isUserInteractionEnabled = true

      deactivateConjugationDisplay()

      let numRows = keyboard.count
      for row in 0...numRows - 1 {
        for col in 0...keyboard[row].count - 1 {
          // Set up button as a key with its values and properties.
          let btn = UIButton(type: .custom)
          btn.backgroundColor = keyColor
          btn.layer.borderColor = keyboardView.backgroundColor?.cgColor
          btn.layer.borderWidth = 3
          btn.layer.cornerRadius = keyCornerRadius

          let key = keyboard[row][col]
          var capsKey = ""
          if key != "ß" {
            capsKey = keyboard[row][col].capitalized
          } else {
            capsKey = key
          }
          let keyToDisplay = shiftButtonState == .normal ? key : capsKey
          btn.setTitleColor(UIColor.label, for: .normal)
          btn.layer.setValue(key, forKey: "original")
          btn.layer.setValue(keyToDisplay, forKey: "keyToDisplay")
          btn.layer.setValue(false, forKey: "isSpecial")
          btn.setTitle(keyToDisplay, for: .normal) // set button character

          // Set key character sizes.
          if DeviceType.isPhone {
            if isLandscapeView == true {
              if key == "#+=" || key == "ABC" || key == "123" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.5)
              } else if key == "Leerzeichen" || key == "espacio" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 4)
              } else {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3)
              }
            } else {
              if key == "#+=" || key == "ABC" || key == "123" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.75)
              } else if key == "Leerzeichen" || key == "espacio" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 2)
              } else {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.5)
              }
            }
          } else if DeviceType.isPad {
            if key == "#+=" || key == "ABC" || key == "hideKeyboard" {
              btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.25)
            } else if key == "Leerzeichen" || key == "espacio" {
              btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.5)
            } else if key == ".?123" {
              btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 4)
            } else {
              btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3)
            }
          }

          activateBtn(btn: btn)
          btn.addTarget(self, action: #selector(keyMultiPress(_:event:)), for: .touchDownRepeat)

          styleBtn(btn: scribeBtn, title: "Scribe", radius: keyCornerRadius)
          scribeBtn?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

          if scribeBtnState {
            scribeBtnToEscape()
            scribeBtn?.layer.cornerRadius = keyCornerRadius
            scribeBtn?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]

            previewBar?.backgroundColor = UIColor.clear
            previewBar?.text = ""

            styleBtn(btn: translateBtn, title: "Translate", radius: keyCornerRadius)
            styleBtn(btn: conjugateBtn, title: "Conjugate", radius: keyCornerRadius)
            styleBtn(btn: pluralBtn, title: "Plural", radius: keyCornerRadius)
          } else {
            if previewState == true {
              scribeBtnToEscape()
            }
            scribeBtn?.setTitle("", for: .normal)
            deactivateBtn(btn: conjugateBtn)
            deactivateBtn(btn: translateBtn)
            deactivateBtn(btn: pluralBtn)

            previewBar?.clipsToBounds = true
            previewBar?.layer.cornerRadius = keyCornerRadius
            previewBar?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            if DeviceType.isPhone {
              previewBar?.font = .systemFont(ofSize: letterButtonWidth / 2)
            } else if DeviceType.isPad {
              previewBar?.font = .systemFont(ofSize: letterButtonWidth / 4)
            }
            previewBar?.textColor = UIColor.label
            previewBar?.lineBreakMode = NSLineBreakMode.byWordWrapping
            if previewState == false {
              previewBar?.text = ""
            }
            previewBar?.sizeToFit()
          }

          // Pad before key is added.
          if DeviceType.isPhone && key == "y" && controllerLanguage == "German" {
            addPadding(to: stackView3, width: buttonWidth / 3, key: "y")
          }

          if key == "delete" {
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(keyLongPressed(_:)))
            btn.addGestureRecognizer(longPressRecognizer)
          }

          keys.append(btn)
          switch row {
          case 0: stackView1.addArrangedSubview(btn)
          case 1: stackView2.addArrangedSubview(btn)
          case 2: stackView3.addArrangedSubview(btn)
          case 3: stackView4.addArrangedSubview(btn)
          default:
            break
          }

          if key == "selectKeyboard" {
            selectKeyboardButton = btn
            btn.setTitle("", for: .normal)
            var selectKeyboardIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .light, scale: .medium)
            if DeviceType.isPad {
              selectKeyboardIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .light, scale: .medium)
            }
            btn.setImage(UIImage(systemName: "globe", withConfiguration: selectKeyboardIconConfig), for: .normal)
            if UITraitCollection.current.userInterfaceStyle == .dark {
              btn.tintColor = .white
            } else {
              btn.tintColor = .black
            }
          }

          if key == "hideKeyboard" {
            btn.setTitle("", for: .normal)
            let hideKeyboardIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .light, scale: .medium)
            btn.setImage(UIImage(systemName: "keyboard.chevron.compact.down", withConfiguration: hideKeyboardIconConfig), for: .normal)
            if UITraitCollection.current.userInterfaceStyle == .dark {
              btn.tintColor = .white
            } else {
              btn.tintColor = .black
            }
          }

          if key == "shift" {
            btn.setTitle("", for: .normal)
            var shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .regular, scale: .medium)
            if DeviceType.isPad {
              shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .regular, scale: .medium)
            }
            btn.setImage(UIImage(systemName: "shift", withConfiguration: shiftIconConfig), for: .normal)
            if UITraitCollection.current.userInterfaceStyle == .dark {
              btn.tintColor = .white
            } else {
              btn.tintColor = .black
            }
          }

          if key == "return" {
            btn.setTitle("", for: .normal)
            var returnIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .regular, scale: .medium)
            if DeviceType.isPad {
              returnIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .regular, scale: .medium)
            }
            btn.setImage(UIImage(systemName: "arrow.turn.down.left", withConfiguration: returnIconConfig), for: .normal)
            if UITraitCollection.current.userInterfaceStyle == .dark {
              btn.tintColor = .white
            } else {
              btn.tintColor = .black
            }
          }

          if key == "delete" {
            btn.setTitle("", for: .normal)
            var deleteIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .regular, scale: .medium)
            if DeviceType.isPad {
              deleteIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .regular, scale: .medium)
            }
            btn.setImage(UIImage(systemName: "delete.left", withConfiguration: deleteIconConfig), for: .normal)
            if UITraitCollection.current.userInterfaceStyle == .dark {
              btn.tintColor = .white
            } else {
              btn.tintColor = .black
            }
          }

          if key == "a" {
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(aLongPressedSelectAlternates(sender:)))
            longGesture.minimumPressDuration = 1.2
            btn.addGestureRecognizer(longGesture)
          }

          if key == "e" {
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(eLongPressedSelectAlternates(sender:)))
            longGesture.minimumPressDuration = 1.2
            btn.addGestureRecognizer(longGesture)
          }

          if key == "i" {
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(iLongPressedSelectAlternates(sender:)))
            longGesture.minimumPressDuration = 1.2
            btn.addGestureRecognizer(longGesture)
          }

          if key == "o" {
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(oLongPressedSelectAlternates(sender:)))
            longGesture.minimumPressDuration = 1.2
            btn.addGestureRecognizer(longGesture)
          }

          if key == "u" {
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(uLongPressedSelectAlternates(sender:)))
            longGesture.minimumPressDuration = 1.2
            btn.addGestureRecognizer(longGesture)
          }

          if key == "y" {
            if controllerLanguage == "German" {
              let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(yLongPressedSelectAlternates(sender:)))
              longGesture.minimumPressDuration = 1.2
              btn.addGestureRecognizer(longGesture)
            }
          }

          if key == "s" {
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(sLongPressedSelectAlternates(sender:)))
            longGesture.minimumPressDuration = 1.2
            btn.addGestureRecognizer(longGesture)
          }

          if key == "d" {
            if controllerLanguage == "Spanish" {
              let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(dLongPressedSelectAlternates(sender:)))
              longGesture.minimumPressDuration = 1.2
              btn.addGestureRecognizer(longGesture)
            }
          }

          if key == "c" {
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(cLongPressedSelectAlternates(sender:)))
            longGesture.minimumPressDuration = 1.2
            btn.addGestureRecognizer(longGesture)
          }

          if key == "n" {
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(nLongPressedSelectAlternates(sender:)))
            longGesture.minimumPressDuration = 1.2
            btn.addGestureRecognizer(longGesture)
          }

          // Pad after key is added.
          if DeviceType.isPhone && key == "m" && controllerLanguage == "German" {
            addPadding(to: stackView3, width: buttonWidth / 3, key: "m")
          }

          // specialKey constraints.
          if key == "ABC" {
            if DeviceType.isPhone {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 2).isActive = true
            } else {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1).isActive = true
            }
            btn.layer.setValue(true, forKey: "isSpecial")
            btn.backgroundColor = specialKeyColor
          } else if key == "delete" || key == "#+=" || key == "shift" || key == "undoArrow" || key == "selectKeyboard" {
            if DeviceType.isPhone {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.5).isActive = true
            } else {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1).isActive = true
            }
            btn.layer.setValue(true, forKey: "isSpecial")
            btn.backgroundColor = specialKeyColor
            if key == "shift" {
              if shiftButtonState != .normal {
                btn.backgroundColor = keyPressedColor
                var shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .regular, scale: .medium)
                if DeviceType.isPad {
                  shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .regular, scale: .medium)
                }
                btn.setImage(UIImage(systemName: "shift.fill", withConfiguration: shiftIconConfig), for: .normal)
                if UITraitCollection.current.userInterfaceStyle == .dark {
                  btn.tintColor = .white
                } else {
                  btn.tintColor = .black
                }
              }
              if shiftButtonState == .caps {
                var shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .regular, scale: .medium)
                if DeviceType.isPad {
                  shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .regular, scale: .medium)
                }
                btn.setImage(UIImage(systemName: "capslock.fill", withConfiguration: shiftIconConfig), for: .normal)
                if UITraitCollection.current.userInterfaceStyle == .dark {
                  btn.tintColor = .white
                } else {
                  btn.tintColor = .black
                }
              }
            }
          } else if key == "123" || key == ".?123" || key == "return" || key == "hideKeyboard" {
            if DeviceType.isPhone {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 2).isActive = true
            } else {
              btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1).isActive = true
            }
            btn.layer.setValue(true, forKey: "isSpecial")
            if key == "return" && previewState == true {
              btn.backgroundColor = UIColor.scribeBlue
            } else {
              btn.backgroundColor = specialKeyColor
            }
            // Only change widths for number and symbol keys for iPhones.
          } else if (keyboardState == .numbers || keyboardState == .symbols) && row == 2 && DeviceType.isPhone {
            btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.4).isActive = true
          } else if ( key != "Leerzeichen" && controllerLanguage == "German" ) || ( key != "espacio" && controllerLanguage == "Spanish" ) {
            btn.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
          } else {
            btn.layer.setValue(key, forKey: "original")
            btn.setTitle(key, for: .normal)
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

    } else { // conjugate view
      stackView1.isUserInteractionEnabled = false
      stackView2.isUserInteractionEnabled = false
      stackView3.isUserInteractionEnabled = false
      stackView4.isUserInteractionEnabled = false

      scribeBtnToEscape()
      scribeBtn?.layer.cornerRadius = buttonWidth / 4
      scribeBtn?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

      previewBar?.backgroundColor = specialKeyColor
      previewBar?.textColor = UIColor.label

      deactivateBtn(btn: conjugateBtn)
      deactivateBtn(btn: translateBtn)
      deactivateBtn(btn: pluralBtn)

      activateConjugationDisplay()
      setConjugationState()

      styleBtn(btn: conjugateShiftLeftBtn, title: "⟨", radius: keyCornerRadius)
      styleBtn(btn: conjugateShiftRightBtn, title: "⟩", radius: keyCornerRadius)
    }
  }

  // MARK: Scribe command functionality

  /// Inserts the translation of a valid word in the preview bar into the proxy.
  func queryTranslation() {
    // Cancel via a return press.
    if previewBar?.text! == translatePromptAndCursor {
      return
    }
    let word = previewBar?.text!.substring(with: conjugatePrompt.count..<((previewBar?.text!.count)!-1))
    let lowerCaseWord = word!.lowercased()
    let wordInDirectory = translations?[lowerCaseWord] != nil
    if wordInDirectory {
      proxy.insertText(translations?[lowerCaseWord] as! String + " ")
    } else {
      invalidState = true
    }
  }

  /// Triggers the display of the conjugation view for a valid verb in the preview bar.
  func queryConjugation() {
    // Cancel via a return press.
    if previewBar?.text! == conjugatePromptAndCursor {
      return
    }
    verbToConjugate = (previewBar?.text!.substring(with: conjugatePrompt.count..<((previewBar?.text!.count)!-1)))!
    let verbInDirectory = verbs?[verbToConjugate] != nil
    if verbInDirectory {
      conjugateView = true
      loadKeys()
    } else {
      invalidState = true
    }
  }

  /// Inserts the plural of a valid noun in the preview bar into the proxy.
  func queryPlural() {
    // Cancel via a return press.
    if previewBar?.text! == pluralPromptAndCursor {
      return
    }
    var noun = previewBar?.text!.substring(with: pluralPrompt.count..<((previewBar?.text!.count)!-1))
    var queriedWordIsUpperCase: Bool = false
    // Check to see if the input was uppercase to return an uppercase plural.
    if controllerLanguage == "Spanish" {
      let firstLetter = noun?.substring(toIdx: 1)
      queriedWordIsUpperCase = firstLetter!.isUppercase
      noun = noun?.lowercased()
    }
    let nounInDirectory = nouns?[noun!] != nil
    if nounInDirectory {
      if nouns?[noun!]?["plural"] as? String != "isPlural" {
        let plural = nouns?[noun!]?["plural"] as! String
        if queriedWordIsUpperCase == false {
          proxy.insertText(plural + " ")
        } else {
          proxy.insertText(plural.capitalized + " ")
        }
      } else {
        proxy.insertText(noun! + " ")
        previewBar?.text = previewPromptSpacing + "Already plural"
        invalidState = true
        isAlreadyPluralState = true
      }
    } else {
      invalidState = true
    }
  }

  /// Annotates the preview bar with the form of a valid selected noun.
  func selectedNounAnnotation() {
    var selectedWord = proxy.selectedText
    // Check to see if the input was uppercase to return an uppercase plural.
    var queriedWordIsUpperCase: Bool = false
    if controllerLanguage == "Spanish" {
      let firstLetter = selectedWord?.substring(toIdx: 1)
      queriedWordIsUpperCase = firstLetter!.isUppercase
      selectedWord = selectedWord?.lowercased()
    }
    let isNoun = nouns?[selectedWord!] != nil
    if isNoun {
      let nounForm = nouns?[selectedWord!]?["form"] as? String
      if nounForm == "F" {
        if UITraitCollection.current.userInterfaceStyle == .dark {
          previewBar?.textColor = UIColor.previewRedDarkTheme
        } else {
          previewBar?.textColor = UIColor.previewRedLightTheme
        }
      } else if nounForm == "M" {
        if UITraitCollection.current.userInterfaceStyle == .dark {
          previewBar?.textColor = UIColor.previewBlueDarkTheme
        } else {
          previewBar?.textColor = UIColor.previewBlueLightTheme
        }
      } else if nounForm ==  "N" {
        if UITraitCollection.current.userInterfaceStyle == .dark {
          previewBar?.textColor = UIColor.previewGreenDarkTheme
        } else {
          previewBar?.textColor = UIColor.previewGreenLightTheme
        }
      } else if nounForm ==  "PL" {
        if UITraitCollection.current.userInterfaceStyle == .dark {
          previewBar?.textColor = UIColor.previewOrangeDarkTheme
        } else {
          previewBar?.textColor = UIColor.previewOrangeLightTheme
        }
      } else if nounForm ==  "" {
        invalidState = true
      } else {
        previewBar?.textColor = UIColor.label
      }

      if invalidState != true {
        if queriedWordIsUpperCase == false {
          previewBar?.text = previewPromptSpacing + "(\(nounForm ?? "")) " + selectedWord!
        } else {
          previewBar?.text = previewPromptSpacing + "(\(nounForm ?? "")) " + selectedWord!.capitalized
        }
      }
      previewBar?.sizeToFit()
      invalidState = false
    }
  }

  /// Annotates the preview bar with the form of a valid typed noun.
  func typedNounAnnotation() {
    if proxy.documentContextBeforeInput != nil {
      let wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
      var lastWordTyped = wordsTyped.penultimate()
      // Check to see if the input was uppercase to return an uppercase plural.
      var queriedWordIsUpperCase: Bool = false
      if controllerLanguage == "Spanish" {
        let firstLetter = lastWordTyped?.substring(toIdx: 1)
        queriedWordIsUpperCase = firstLetter!.isUppercase
        lastWordTyped = lastWordTyped?.lowercased()
      }
      let isNoun = nouns?[lastWordTyped!] != nil || nouns?[lastWordTyped!.lowercased()] != nil
      if isNoun {
        let nounForm = nouns?[lastWordTyped!]?["form"] as? String
        if nounForm == "F" {
          if UITraitCollection.current.userInterfaceStyle == .dark {
            previewBar?.textColor = UIColor.previewRedDarkTheme
          } else {
            previewBar?.textColor = UIColor.previewRedLightTheme
          }
        } else if nounForm == "M" {
          if UITraitCollection.current.userInterfaceStyle == .dark {
            previewBar?.textColor = UIColor.previewBlueDarkTheme
          } else {
            previewBar?.textColor = UIColor.previewBlueLightTheme
          }
        } else if nounForm ==  "N" {
          if UITraitCollection.current.userInterfaceStyle == .dark {
            previewBar?.textColor = UIColor.previewGreenDarkTheme
          } else {
            previewBar?.textColor = UIColor.previewGreenLightTheme
          }
        } else if nounForm ==  "PL" {
          if UITraitCollection.current.userInterfaceStyle == .dark {
            previewBar?.textColor = UIColor.previewOrangeDarkTheme
          } else {
            previewBar?.textColor = UIColor.previewOrangeLightTheme
          }
        } else if nounForm ==  "" {
          invalidState = true
        } else {
          previewBar?.textColor = UIColor.label
        }

        if invalidState != true {
          if queriedWordIsUpperCase == false {
            previewBar?.text = previewPromptSpacing + "(\(nounForm ?? "")) " + lastWordTyped!
          } else {
            previewBar?.text = previewPromptSpacing + "(\(nounForm ?? "")) " + lastWordTyped!.capitalized
          }
        }
        previewBar?.sizeToFit()
        invalidState = false
      }
    }
  }

  /// Annotates the preview bar with the form of a valid selected preposition.
  func selectedPrepositionAnnotation() {
    if controllerLanguage == "German" {
      var selectedWord = proxy.selectedText
      // Check to see if the input was uppercase to return an uppercase plural.
      var queriedWordIsUpperCase: Bool = false
      let firstLetter = selectedWord?.substring(toIdx: 1)
      queriedWordIsUpperCase = firstLetter!.isUppercase
      selectedWord = selectedWord?.lowercased()
      let isPreposition = prepositions?[selectedWord!] != nil
      if isPreposition {
        let prepositionCase = prepositions?[selectedWord!] as? String
        if queriedWordIsUpperCase == false {
          previewBar?.text = previewPromptSpacing + "(\(prepositionCase ?? "")) " + selectedWord!
        } else {
          previewBar?.text = previewPromptSpacing + "(\(prepositionCase ?? "")) " + selectedWord!.capitalized
        }
        previewBar?.sizeToFit()
      }
    }
  }

  /// Annotates the preview bar with the form of a valid typed preposition.
  func typedPrepositionAnnotation() {
    if controllerLanguage == "German" {
      if proxy.documentContextBeforeInput != nil {
        let wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
        var lastWordTyped = wordsTyped.penultimate()
        // Check to see if the input was uppercase to return an uppercase plural.
        var queriedWordIsUpperCase: Bool = false
        let firstLetter = lastWordTyped?.substring(toIdx: 1)
        queriedWordIsUpperCase = firstLetter!.isUppercase
        lastWordTyped = lastWordTyped?.lowercased()
        let isPreposition = prepositions?[lastWordTyped!] != nil
        if isPreposition {
          let prepositionCase = prepositions?[lastWordTyped!] as? String
          if queriedWordIsUpperCase == false {
            previewBar?.text = previewPromptSpacing + "(\(prepositionCase ?? "")) " + lastWordTyped!
          } else {
            previewBar?.text = previewPromptSpacing + "(\(prepositionCase ?? "")) " + lastWordTyped!.capitalized
          }
          previewBar?.sizeToFit()
        }
      }
    }
  }

  /// Clears the text found in the preview bar.
  func clearPreviewBar() {
    if previewState != true {
      previewBar?.textColor = UIColor.label
      previewBar?.text = " "
    }
  }

  // MARK: Button actions

  /// Triggers actions based on the press of a key.
  ///
  /// - Parameters
  ///   - sender: the button pressed as sender.
  @IBAction func keyPressedTouchUp(_ sender: UIButton) {
    guard let originalKey = sender.layer.value(forKey: "original") as? String, let keyToDisplay = sender.layer.value(forKey: "keyToDisplay") as? String else {return}

    guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
    sender.backgroundColor = isSpecial ? specialKeyColor : keyColor

    switch originalKey {
    case "Scribe":
      if proxy.selectedText != nil { // annotate word
        loadKeys()
        selectedNounAnnotation()
        selectedPrepositionAnnotation()
      } else {
        if previewState == true { // esc
          scribeBtnState = false
          previewState = false
        } else if scribeBtnState == false && conjugateView != true { // ScribeBtn
          scribeBtnState = true
          activateBtn(btn: translateBtn)
          activateBtn(btn: conjugateBtn)
          activateBtn(btn: pluralBtn)
        } else if conjugateView == true { // esc
          conjugateView = false
          scribeBtnState = false
          previewState = false
        } else { // esc
          scribeBtnState = false
          previewState = false
        }
        loadKeys()
      }

    // Switch to translate state.
    case "Translate":
      scribeBtnState = false
      previewState = true
      loadKeys()
      previewBar?.text = translatePromptAndCursor
      getTranslation = true

    // Switch to conjugate state.
    case "Conjugate":
      scribeBtnState = false
      if shiftButtonState == .shift {
        shiftButtonState = .normal
      }
      previewState = true
      loadKeys()
      previewBar?.text = conjugatePromptAndCursor
      getConjugation = true

    // Move displayed conjugations to the left in order if able.
    case "shiftConjugateLeft":
      if controllerLanguage == "German" {
        deConjugationStateLeft()
      } else if controllerLanguage == "Spanish" {
        esConjugationStateLeft()
      }
      loadKeys()

    // Move displayed conjugations to the right in order if able.
    case "shiftConjugateRight":
      if controllerLanguage == "German" {
        deConjugationStateRight()
      } else if controllerLanguage == "Spanish" {
        esConjugationStateRight()
      }
      loadKeys()

    // Switch to plural state.
    case "Plural":
      scribeBtnState = false
      if controllerLanguage == "German" { // capitalize for nouns
        if shiftButtonState == .normal {
          shiftButtonState = .shift
        }
      }
      previewState = true
      loadKeys()
      previewBar?.text = pluralPromptAndCursor
      getPlural = true

    case "firstPersonSingular":
      // Don't change proxy if they select a conjugation that's missing.
      if sender.titleLabel?.text == "Not in directory" {
        proxy.insertText("")
      } else if deConjugationState != .indicativePerfect {
        proxy.insertText(verbs?[verbToConjugate]![tenseFPS] as! String + " ")
      } else {
        proxy.insertText(verbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
      }
      previewState = false
      conjugateView = false
      loadKeys()

    case "secondPersonSingular":
      // Don't change proxy if they select a conjugation that's missing.
      if sender.titleLabel?.text == "Not in directory" {
        proxy.insertText("")
      } else if deConjugationState != .indicativePerfect {
        proxy.insertText(verbs?[verbToConjugate]![tenseSPS] as! String + " ")
      } else {
        proxy.insertText(verbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
      }
      previewState = false
      conjugateView = false
      loadKeys()

    case "thirdPersonSingular":
      // Don't change proxy if they select a conjugation that's missing.
      if sender.titleLabel?.text == "Not in directory" {
        proxy.insertText("")
      } else if deConjugationState != .indicativePerfect {
        proxy.insertText(verbs?[verbToConjugate]![tenseTPS] as! String + " ")
      } else {
        proxy.insertText(verbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
      }
      previewState = false
      conjugateView = false
      loadKeys()

    case "firstPersonPlural":
      // Don't change proxy if they select a conjugation that's missing.
      if sender.titleLabel?.text == "Not in directory" {
        proxy.insertText("")
      } else if deConjugationState != .indicativePerfect {
        proxy.insertText(verbs?[verbToConjugate]![tenseFPP] as! String + " ")
      } else {
        proxy.insertText(verbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
      }
      previewState = false
      conjugateView = false
      loadKeys()

    case "secondPersonPlural":
      // Don't change proxy if they select a conjugation that's missing.
      if sender.titleLabel?.text == "Not in directory" {
        proxy.insertText("")
      } else if deConjugationState != .indicativePerfect {
        proxy.insertText(verbs?[verbToConjugate]![tenseSPP] as! String + " ")
      } else {
        proxy.insertText(verbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
      }
      previewState = false
      conjugateView = false
      loadKeys()

    case "thirdPersonPlural":
      // Don't change proxy if they select a conjugation that's missing.
      if sender.titleLabel?.text == "Not in directory" {
        proxy.insertText("")
      } else if deConjugationState != .indicativePerfect {
        proxy.insertText(verbs?[verbToConjugate]![tenseTPP] as! String + " ")
      } else {
        proxy.insertText(verbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
      }
      previewState = false
      conjugateView = false
      loadKeys()

    case "delete":
      if shiftButtonState == .shift {
        shiftButtonState = .normal
        loadKeys()
      }
      // Prevent the preview state prompt from being deleted.
      if previewState == true && allPrompts.contains((previewBar?.text!)!) {
        return
      }
      handlDeleteButtonPressed()
      // Shift state if delete goes to the start of the proxy.
      if proxy.documentContextBeforeInput == nil && previewState != true {
        if keyboardState == .letters && shiftButtonState == .normal {
          shiftButtonState = .shift
          loadKeys()
        }
      }
      clearPreviewBar()

    case "Leerzeichen":
      if previewState != true {
        proxy.insertText(" ")
      } else {
        previewBar?.text! = (previewBar?.text!.insertPriorToCursor(char: " "))!
      }
      typedNounAnnotation()
      typedPrepositionAnnotation()
      if proxy.documentContextBeforeInput?.suffix("  ".count) == "  " {
        clearPreviewBar()
      }

    case "espacio":
      if previewState != true {
        proxy.insertText(" ")
      } else {
        previewBar?.text! = (previewBar?.text!.insertPriorToCursor(char: " "))!
      }
      typedNounAnnotation()
      typedPrepositionAnnotation()
      if proxy.documentContextBeforeInput?.suffix("  ".count) == "  " {
        clearPreviewBar()
      }

    case "selectKeyboard":
      self.advanceToNextInputMode()

    case "hideKeyboard":
      self.dismissKeyboard()

    case "return":
      if getTranslation && previewState == true { // translate state
        queryTranslation()
        getTranslation = false
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
        // Auto-capitalization if at the start of the proxy.
        proxy.insertText(" ")
        if proxy.documentContextBeforeInput == " " {
          if shiftButtonState == .normal {
            shiftButtonState = .shift
            loadKeys()
          }
        }
        proxy.deleteBackward()
        if isAlreadyPluralState != true {
          previewBar?.text = previewPromptSpacing + "Not in directory"
        }
        previewBar?.textColor = UIColor.label

        invalidState = false
        isAlreadyPluralState = false
      } else {
        previewState = false
        clearPreviewBar()
        // Auto-capitalization if at the start of the proxy.
        proxy.insertText(" ")
        if proxy.documentContextBeforeInput == " " {
          if shiftButtonState == .normal {
            shiftButtonState = .shift
            loadKeys()
          }
        }
        proxy.deleteBackward()
        loadKeys()
        // Avoid showing noun annotation instead of conjugation state header.
        if conjugateView == false {
          typedNounAnnotation()
          typedPrepositionAnnotation()
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
      proxy.insertText(" ")
      if proxy.documentContextBeforeInput == " " {
        if shiftButtonState == .normal {
          shiftButtonState = .shift
          loadKeys()
        }
      }
      proxy.deleteBackward()

    case "'":
      // Change back to letter keys.
      if previewState != true {
        proxy.insertText("'")
      } else {
        previewBar?.text! = (previewBar?.text!.insertPriorToCursor(char: "'"))!
      }
      changeKeyboardToLetterKeys()
      clearPreviewBar()

    case "shift":
      shiftButtonState = shiftButtonState == .normal ? .shift : .normal
      loadKeys()
      clearPreviewBar()

    default:
      if shiftButtonState == .shift {
        shiftButtonState = .normal
        loadKeys()
      }
      if previewState == false {
        proxy.insertText(keyToDisplay)
        clearPreviewBar()
      } else {
        previewBar?.text = previewBar?.text!.insertPriorToCursor(char: keyToDisplay)
      }
    }
    // Remove alternates view if it's present.
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
    }
  }

  // MARK: Key press functions

  /// Colors keys to show they have been pressed.
  ///
  /// - Parameters
  ///   - sender: the key that was pressed.
  @objc func keyTouchDown(_ sender: UIButton) {
    sender.backgroundColor = keyPressedColor

    // Scribe key annotation.
    let senderKey = sender.layer.value(forKey: "original") as? String
    if senderKey == "Scribe" {
      sender.alpha = 0.5
      // Bring sender's opacity back up to fully opaque
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
          sender.alpha = 1.0
      }
    }
  }

  /// Defines events that occur given multiple presses of a single key.
  ///
  /// - Parameters
  ///  - sender: the key that was pressed multiple times.
  ///  - event: event to derive tap counts.
  @objc func keyMultiPress(_ sender: UIButton, event: UIEvent) {
    guard let originalKey = sender.layer.value(forKey: "original") as? String else {return}

    // Caps lock given two taps of shift.
    let touch: UITouch = event.allTouches!.first!
    if touch.tapCount == 2 && originalKey == "shift" {
      shiftButtonState = .caps
      loadKeys()
      clearPreviewBar()
    }
    // Double space period shortcut.
    if touch.tapCount == 2 && ( originalKey == "Leerzeichen" || originalKey == "espacio" ) && keyboardState == .letters && proxy.documentContextBeforeInput?.count != 1 {
      if proxy.documentContextBeforeInput?.suffix(2) != "  " && previewState != true {
        proxy.deleteBackward()
        proxy.insertText(". ")
        shiftButtonState = .shift
        loadKeys()
      } else if proxy.documentContextBeforeInput?.suffix(2) != "  " && previewState == true {
        previewBar?.text! = (previewBar?.text!.deletePriorToCursor())!
        previewBar?.text! = (previewBar?.text!.insertPriorToCursor(char: ". "))!
        shiftButtonState = .shift
        loadKeys()
      }
      clearPreviewBar()
    }
  }

  /// Defines the criteria under which a key is long pressed.
  ///
  /// - Parameters
  ///   - gesture: the gesture that was recived.
  @objc func keyLongPressed(_ gesture: UIGestureRecognizer) {
    // Prevent the preview state prompt from being deleted.
    if previewState == true && allPrompts.contains((previewBar?.text!)!) {
      gesture.state = .cancelled
    }
    if gesture.state == .began {
      backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (_) in
        self.handlDeleteButtonPressed()
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

  // MARK: Hold to select functions

  /// Sets and styles the view displayed for hold-to-select keys.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  ///   - numAlternates: number of alternates for the given key.
  func setAlternatesView(sender: UILongPressGestureRecognizer, keyOn: String, alternateKeys: Array<String>) {
    let tapLocation = sender.location(in: self.view)
    let numAlternates = CGFloat(alternateKeys.count)

    // Variables for alternate key view appearance.
    var alternatesViewWidth = CGFloat(0)
    var alternatesViewX = CGFloat(0)
    var alternatesViewY = CGFloat(0)
    let alternateButtonWidth = buttonWidth * 0.9
    var alternateBtnStartX = CGFloat(0)
    var alternatesBtnHeight = CGFloat(0)
    var alternatesCharHeight = CGFloat(0)

    if keyOn == "Left" {
      alternatesViewX = tapLocation.x - 10.0
    } else if keyOn == "Right" {
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

    alternatesKeyView = UIView(frame: CGRect(x: alternatesViewX, y: alternatesViewY, width: alternatesViewWidth, height: alternatesBtnHeight))

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is already added than remove and then add again.
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyboardView.backgroundColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = specialKeyColor.cgColor

    alternateBtnStartX = 5.0
    for char in alternateKeys {
      let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: alternateButtonWidth, height: alternatesBtnHeight))
      if shiftButtonState == .normal || char == "ß" {
        btn.setTitle(char, for: .normal)
      } else {
        btn.setTitle(char.capitalized, for: .normal)
      }
      btn.titleLabel?.font = .systemFont(ofSize: alternatesCharHeight)
      btn.setTitleColor(UIColor.label, for: .normal)

      alternatesKeyView.addSubview(btn)
      setBtn(btn: btn, color: keyboardView.backgroundColor!, name: char, canCapitalize: true, isSpecial: false)

      alternateBtnStartX += (alternateButtonWidth + 3.0)
    }
    self.view.addSubview(alternatesKeyView)
  }

  /// Adds a view with alternate keys above the a key.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func aLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    setAlternatesView(sender: sender, keyOn: "Left", alternateKeys: aAlternateKeys)
  }

  /// Adds a view with alternate keys above the e key.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func eLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    setAlternatesView(sender: sender, keyOn: "Left", alternateKeys: eAlternateKeys)
  }

  /// Adds a view with alternate keys above the i key.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func iLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    setAlternatesView(sender: sender, keyOn: "Right", alternateKeys: iAlternateKeys)
  }

  /// Adds a view with alternate keys above the o key.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func oLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    setAlternatesView(sender: sender, keyOn: "Right", alternateKeys: oAlternateKeys)
  }

  /// Adds a view with alternate keys above the u key.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func uLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    setAlternatesView(sender: sender, keyOn: "Right", alternateKeys: uAlternateKeys)
  }

  /// Adds a view with alternate keys above the y key.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func yLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    setAlternatesView(sender: sender, keyOn: "Left", alternateKeys: yAlternateKeys)
  }

  /// Adds a view with alternate keys above the s key.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func sLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    setAlternatesView(sender: sender, keyOn: "Left", alternateKeys: sAlternateKeys)
  }

  /// Adds a view with alternate keys above the d key.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func dLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    setAlternatesView(sender: sender, keyOn: "Left", alternateKeys: dAlternateKeys)
  }

  /// Adds a view with alternate keys above the c key.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func cLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    setAlternatesView(sender: sender, keyOn: "Left", alternateKeys: cAlternateKeys)
  }

  /// Adds a view with alternate keys above the n key.
  ///
  /// - Parameters
  ///   - sender: the long press of the given key.
  @objc func nLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    setAlternatesView(sender: sender, keyOn: "Right", alternateKeys: nAlternateKeys)
  }
}
