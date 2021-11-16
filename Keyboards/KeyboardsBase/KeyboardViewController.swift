//
//  KeyboardViewController.swift
//
//  A parent KeyboardViewController class that is inherited by all Scribe keyboards.
//

import UIKit

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

  /// Sets the keyboard layouts given the chosen keyboard and device type.
  func setKeyboardLayouts() {
    if controllerLanguage == "German" {
      if DeviceType.isPhone {
        letterKeys = deKeyboardConstants.letterKeysPhone
        numberKeys = deKeyboardConstants.numberKeysPhone
        symbolKeys = deKeyboardConstants.symbolKeysPhone
      } else {
        letterKeys = deKeyboardConstants.letterKeysPad
        numberKeys = deKeyboardConstants.numberKeysPad
        symbolKeys = deKeyboardConstants.symbolKeysPad
      }
    } else if controllerLanguage == "Spanish" {
      if DeviceType.isPhone {
        letterKeys = esKeyboardConstants.letterKeysPhone
        numberKeys = esKeyboardConstants.numberKeysPhone
        symbolKeys = esKeyboardConstants.symbolKeysPhone
      } else {
        letterKeys = esKeyboardConstants.letterKeysPad
        numberKeys = esKeyboardConstants.numberKeysPad
        symbolKeys = esKeyboardConstants.symbolKeysPad
      }
    }
  }

  /// Styles a button's appearance including it's shape and text.
  func styleBtn(btn: UIButton, title: String, radius: CGFloat) {
    btn.clipsToBounds = true
    btn.layer.masksToBounds = true
    btn.layer.cornerRadius = radius
    btn.setTitle(title, for: .normal)
    btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    btn.setTitleColor(UIColor.label, for: .normal)
  }

  func activateBtn(btn: UIButton) {
    btn.addTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
    btn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
    btn.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
  }

  func deactivateBtn(btn: UIButton) {
    btn.setTitle("", for: .normal)
    btn.backgroundColor = UIColor.clear
    btn.removeTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
    btn.removeTarget(self, action: #selector(keyTouchDown), for: .touchDown)
    btn.removeTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
  }

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

  @IBOutlet var previewLabel: UILabel!
  func setPreviewLabel() {
    previewLabel?.backgroundColor = specialKeyColor
    previewLabel?.textAlignment = NSTextAlignment.left
  }

  @IBOutlet var scribeBtn: UIButton!
  func setScribeBtn() {
    scribeBtn.setImage(UIImage(named: "ScribeBtn.png"), for: .normal)
    setBtn(btn: scribeBtn, color: UIColor.scribeBlue, name: "Scribe", canCapitalize: false, isSpecial: false)
  }

  @IBOutlet var translateBtn: UIButton!
  @IBOutlet var conjugateBtn: UIButton!
  @IBOutlet var pluralBtn: UIButton!
  func setCommandBtns() {
    setBtn(btn: translateBtn, color: specialKeyColor, name: "Translate", canCapitalize: false, isSpecial: false)
    setBtn(btn: conjugateBtn, color: specialKeyColor, name: "Conjugate", canCapitalize: false, isSpecial: false)
    setBtn(btn: pluralBtn, color: specialKeyColor, name: "Plural", canCapitalize: false, isSpecial: false)
  }

  @IBOutlet var conjugateBtnFPS: UIButton!
  @IBOutlet var conjugateBtnSPS: UIButton!
  @IBOutlet var conjugateBtnTPS: UIButton!
  @IBOutlet var conjugateBtnFPP: UIButton!
  @IBOutlet var conjugateBtnSPP: UIButton!
  @IBOutlet var conjugateBtnTPP: UIButton!

  @IBOutlet var conjugateShiftLeftBtn: UIButton!
  @IBOutlet var conjugateShiftRightBtn: UIButton!

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

  func setConjugationState() {
    if controllerLanguage == "German" {
      previewLabel?.text = deGetConjugationTitle()

      tenseFPS = deGetConjugationState() + "FPS"
      tenseSPS = deGetConjugationState() + "SPS"
      tenseTPS = deGetConjugationState() + "TPS"
      tenseFPP = deGetConjugationState() + "FPP"
      tenseSPP = deGetConjugationState() + "SPP"
      tenseTPP = deGetConjugationState() + "TPP"
    } else if controllerLanguage == "Spanish" {
      previewLabel?.text = esGetConjugationTitle()

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
        styleBtn(btn: allConjugationBtns[index]!, title: "Not in directory", radius: btnKeyCornerRadius)
      } else {
        styleBtn(btn: allConjugationBtns[index]!, title: verbs?[verbToConjugate]![allTenses[index]] as! String, radius: btnKeyCornerRadius)
      }
    }
  }

  @IBOutlet weak var stackView1: UIStackView!
  @IBOutlet weak var stackView2: UIStackView!
  @IBOutlet weak var stackView3: UIStackView!
  @IBOutlet weak var stackView4: UIStackView!

  override func updateViewConstraints() {
    super.updateViewConstraints()
    // Add custom view sizing constraints here.
    keyboardView.frame.size = view.frame.size
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    proxy = textDocumentProxy as UITextDocumentProxy
    loadInterface()
    self.selectKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewWillLayoutSubviews() {
    self.selectKeyboardButton.isHidden = !self.needsInputModeSwitchKey
    super.viewWillLayoutSubviews()
  }

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

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    loadKeys()
  }

  func loadInterface() {
    let keyboardNib = UINib(nibName: "Keyboard", bundle: nil)
    keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as? UIView
    keyboardView.translatesAutoresizingMaskIntoConstraints = true
    view.addSubview(keyboardView)
    loadKeys()
  }

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

  func loadKeys() {
    // German or Spanish
    controllerLanguage = classForCoder.description().components(separatedBy: ".KeyboardViewController")[0]

    if controllerLanguage == "German" {
      keysWithAlternates = deKeyboardConstants.keysWithAlternates
      keysWithAlternatesLeft = deKeyboardConstants.keysWithAlternatesLeft
      keysWithAlternatesRight = deKeyboardConstants.keysWithAlternatesRight
      aAlternateKeys = deKeyboardConstants.aAlternateKeys
      eAlternateKeys = deKeyboardConstants.eAlternateKeys
      iAlternateKeys = deKeyboardConstants.iAlternateKeys
      oAlternateKeys = deKeyboardConstants.oAlternateKeys
      uAlternateKeys = deKeyboardConstants.uAlternateKeys
      yAlternateKeys = deKeyboardConstants.yAlternateKeys
      sAlternateKeys = deKeyboardConstants.sAlternateKeys
      cAlternateKeys = deKeyboardConstants.cAlternateKeys
      nAlternateKeys = deKeyboardConstants.nAlternateKeys
    } else if controllerLanguage == "Spanish" {
      keysWithAlternates = esKeyboardConstants.keysWithAlternates
      keysWithAlternatesLeft = esKeyboardConstants.keysWithAlternatesLeft
      keysWithAlternatesRight = esKeyboardConstants.keysWithAlternatesRight
      aAlternateKeys = esKeyboardConstants.aAlternateKeys
      eAlternateKeys = esKeyboardConstants.eAlternateKeys
      iAlternateKeys = esKeyboardConstants.iAlternateKeys
      oAlternateKeys = esKeyboardConstants.oAlternateKeys
      uAlternateKeys = esKeyboardConstants.uAlternateKeys
      sAlternateKeys = esKeyboardConstants.sAlternateKeys
      dAlternateKeys = esKeyboardConstants.dAlternateKeys
      cAlternateKeys = esKeyboardConstants.cAlternateKeys
      nAlternateKeys = esKeyboardConstants.nAlternateKeys
    }

    checkLandscapeMode()
    checkDarkModeSetColors()
    setKeyboardLayouts()
    setScribeBtn()
    setPreviewLabel()
    setCommandBtns()
    setConjugationBtns()
    invalidState = false

    keys.forEach {$0.removeFromSuperview()}
    paddingViews.forEach {$0.removeFromSuperview()}

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

    var keyboard: [[String]]

    // Start padding.
    switch keyboardState {
    case .letters:
      keyboard = letterKeys
      buttonWidth = letterButtonWidth
      alternateButtonWidth = buttonWidth * 0.9
      // Auto-capitalization.
      if proxy.documentContextBeforeInput?.count == 0 {
        shiftButtonState = .shift
      }
    case .numbers:
      keyboard = numberKeys
      buttonWidth = numSymButtonWidth
      alternateButtonWidth = buttonWidth * 0.9
    case .symbols:
      keyboard = symbolKeys
      buttonWidth = numSymButtonWidth
      alternateButtonWidth = buttonWidth * 0.9
    }

    if DeviceType.isPhone {
      if isLandscapeView == true {
        btnKeyCornerRadius = buttonWidth / 8
      } else {
        btnKeyCornerRadius = buttonWidth / 4
      }
    } else if DeviceType.isPad {
      if isLandscapeView == true {
        btnKeyCornerRadius = buttonWidth / 12
      } else {
        btnKeyCornerRadius = buttonWidth / 8
      }
    }

    if !conjugateView {
      stackView1.isUserInteractionEnabled = true
      stackView2.isUserInteractionEnabled = true
      stackView3.isUserInteractionEnabled = true
      stackView4.isUserInteractionEnabled = true

      deactivateConjugationDisplay()

      let numRows = keyboard.count
      for row in 0...numRows - 1 {
        for col in 0...keyboard[row].count - 1 {
          let btn = UIButton(type: .custom)
          btn.backgroundColor = keyColor
          btn.setTitleColor(UIColor.label, for: .normal)

          let key = keyboard[row][col]
          var capsKey = ""
          if key != "ß" {
            capsKey = keyboard[row][col].capitalized
          } else {
            capsKey = key
          }
          let keyToDisplay = shiftButtonState == .normal ? key : capsKey
          btn.layer.setValue(key, forKey: "original")
          btn.layer.setValue(keyToDisplay, forKey: "keyToDisplay")
          btn.layer.setValue(false, forKey: "isSpecial")
          btn.setTitle(keyToDisplay, for: .normal) // set button character

          if UITraitCollection.current.userInterfaceStyle == .dark {
            keyboardView.backgroundColor? = UIColor.systemGray5
          } else if UITraitCollection.current.userInterfaceStyle == .light {
            keyboardView.backgroundColor? = UIColor.systemGray4
          }

          btn.layer.borderColor = keyboardView.backgroundColor?.cgColor
          btn.layer.borderWidth = 3
          if DeviceType.isPhone {
            if isLandscapeView == true {
              btn.layer.cornerRadius = btnKeyCornerRadius
              if key == "#+=" || key == "ABC" || key == "123" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.5)
              } else if key == "Leerzeichen" || key == "espacio" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 4)
              } else {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3)
              }
            } else {
              btn.layer.cornerRadius = btnKeyCornerRadius
              if key == "#+=" || key == "ABC" || key == "123" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.75)
              } else if key == "Leerzeichen" || key == "espacio" {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 2)
              } else {
                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.5)
              }
            }
          } else if DeviceType.isPad {
            btn.layer.cornerRadius = btnKeyCornerRadius
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

          styleBtn(btn: scribeBtn, title: "Scribe", radius: btnKeyCornerRadius)
          scribeBtn?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

          if scribeBtnState {
            scribeBtn.setImage(UIImage(named: "escBtn.png"), for: .normal)
            scribeBtn?.setTitle("", for: .normal) // esc
            scribeBtn?.layer.cornerRadius = btnKeyCornerRadius
            scribeBtn?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]

            previewLabel?.backgroundColor = UIColor.clear
            previewLabel?.text = ""

            styleBtn(btn: translateBtn, title: "Translate", radius: btnKeyCornerRadius)
            styleBtn(btn: conjugateBtn, title: "Conjugate", radius: btnKeyCornerRadius)
            styleBtn(btn: pluralBtn, title: "Plural", radius: btnKeyCornerRadius)
          } else {
            if previewState == true {
              scribeBtn.setImage(UIImage(named: "escBtn.png"), for: .normal)
            }
            scribeBtn?.setTitle("", for: .normal)
            deactivateBtn(btn: conjugateBtn)
            deactivateBtn(btn: translateBtn)
            deactivateBtn(btn: pluralBtn)

            previewLabel?.clipsToBounds = true
            previewLabel?.layer.cornerRadius = btnKeyCornerRadius
            previewLabel?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            if DeviceType.isPhone {
              previewLabel?.font = .systemFont(ofSize: letterButtonWidth / 2)
            } else if DeviceType.isPad {
              previewLabel?.font = .systemFont(ofSize: letterButtonWidth / 4)
            }
            previewLabel?.textColor = UIColor.label
            previewLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            if previewState == false {
              previewLabel?.text = ""
            }
            previewLabel?.sizeToFit()
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
    } else {
      stackView1.isUserInteractionEnabled = false
      stackView2.isUserInteractionEnabled = false
      stackView3.isUserInteractionEnabled = false
      stackView4.isUserInteractionEnabled = false

      scribeBtn.setImage(UIImage(named: "escBtn.png"), for: .normal)
      scribeBtn?.setTitle("", for: .normal) // esc
      scribeBtn?.layer.cornerRadius = buttonWidth / 4
      scribeBtn?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

      previewLabel?.backgroundColor = specialKeyColor
      previewLabel?.textColor = UIColor.label

      deactivateBtn(btn: conjugateBtn)
      deactivateBtn(btn: translateBtn)
      deactivateBtn(btn: pluralBtn)

      activateConjugationDisplay()
      setConjugationState()

      styleBtn(btn: conjugateShiftLeftBtn, title: "⟨", radius: btnKeyCornerRadius)
      //      conjugateShiftLeftBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
      styleBtn(btn: conjugateShiftRightBtn, title: "⟩", radius: btnKeyCornerRadius)
      //      conjugateShiftRightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
  }

  func changeKeyboardToNumberKeys() {
    keyboardState = .numbers
    shiftButtonState = .normal
    loadKeys()
  }

  func changeKeyboardToLetterKeys() {
    keyboardState = .letters
    loadKeys()
  }

  func changeKeyboardToSymbolKeys() {
    keyboardState = .symbols
    loadKeys()
  }

  func handlDeleteButtonPressed() {
    if previewState != true {
      proxy.deleteBackward()
    } else if !(previewState == true && allPrompts.contains((previewLabel?.text!)!)) {
      guard
        let text = previewLabel?.text,
        !text.isEmpty
      else {
        return
      }
      previewLabel?.text = previewLabel.text!.deletePriorToCursor()
    } else {
      backspaceTimer?.invalidate()
      backspaceTimer = nil
    }
  }

  func queryTranslation() {
    // Cancel via a return press.
    if previewLabel?.text! == translatePromptAndCursor {
      return
    }
    let word = previewLabel?.text!.substring(with: conjugatePrompt.count..<((previewLabel?.text!.count)!-1))
    let lowerCaseWord = word!.lowercased()
    let wordInDirectory = translations?[lowerCaseWord] != nil
    if wordInDirectory {
      proxy.insertText(translations?[lowerCaseWord] as! String + " ")
    } else {
      invalidState = true
    }
  }

  func queryConjugation() {
    // Cancel via a return press.
    if previewLabel?.text! == conjugatePromptAndCursor {
      return
    }
    verbToConjugate = (previewLabel?.text!.substring(with: conjugatePrompt.count..<((previewLabel?.text!.count)!-1)))!
    let verbInDirectory = verbs?[verbToConjugate] != nil
    if verbInDirectory {
      conjugateView = true
      loadKeys()
    } else {
      invalidState = true
    }
  }

  func queryPlural() {
    // Cancel via a return press.
    if previewLabel?.text! == pluralPromptAndCursor {
      return
    }
    var noun = previewLabel?.text!.substring(with: pluralPrompt.count..<((previewLabel?.text!.count)!-1))
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
        previewLabel?.text = previewPromptSpacing + "Already plural"
        invalidState = true
        isAlreadyPluralState = true
      }
    } else {
      invalidState = true
    }
  }

  func selectedNounAnnotation() {
    var selectedWord = proxy.selectedText
    var queriedWordIsUpperCase: Bool = false
    // Check to see if the input was uppercase to return an uppercase plural.
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
          previewLabel?.textColor = UIColor.previewRedDarkTheme
        } else {
          previewLabel?.textColor = UIColor.previewRedLightTheme
        }
      } else if nounForm == "M" {
        if UITraitCollection.current.userInterfaceStyle == .dark {
          previewLabel?.textColor = UIColor.previewBlueDarkTheme
        } else {
          previewLabel?.textColor = UIColor.previewBlueLightTheme
        }
      } else if nounForm ==  "N" {
        if UITraitCollection.current.userInterfaceStyle == .dark {
          previewLabel?.textColor = UIColor.previewGreenDarkTheme
        } else {
          previewLabel?.textColor = UIColor.previewGreenLightTheme
        }
      } else if nounForm ==  "PL" {
        if UITraitCollection.current.userInterfaceStyle == .dark {
          previewLabel?.textColor = UIColor.previewOrangeDarkTheme
        } else {
          previewLabel?.textColor = UIColor.previewOrangeLightTheme
        }
      } else if nounForm ==  "" {
        invalidState = true
      } else {
        previewLabel?.textColor = UIColor.label
      }

      if invalidState != true {
        if queriedWordIsUpperCase == false {
          previewLabel?.text = previewPromptSpacing + "(\(nounForm ?? "")) " + selectedWord!
        } else {
          previewLabel?.text = previewPromptSpacing + "(\(nounForm ?? "")) " + selectedWord!.capitalized
        }
      }
      previewLabel?.sizeToFit()
      invalidState = false
    }
  }

  func typedNounAnnotation() {
    if proxy.documentContextBeforeInput != nil {
      let wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
      var lastWordTyped = wordsTyped.penultimate()
      var queriedWordIsUpperCase: Bool = false
      // Check to see if the input was uppercase to return an uppercase plural.
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
            previewLabel?.textColor = UIColor.previewRedDarkTheme
          } else {
            previewLabel?.textColor = UIColor.previewRedLightTheme
          }
        } else if nounForm == "M" {
          if UITraitCollection.current.userInterfaceStyle == .dark {
            previewLabel?.textColor = UIColor.previewBlueDarkTheme
          } else {
            previewLabel?.textColor = UIColor.previewBlueLightTheme
          }
        } else if nounForm ==  "N" {
          if UITraitCollection.current.userInterfaceStyle == .dark {
            previewLabel?.textColor = UIColor.previewGreenDarkTheme
          } else {
            previewLabel?.textColor = UIColor.previewGreenLightTheme
          }
        } else if nounForm ==  "PL" {
          if UITraitCollection.current.userInterfaceStyle == .dark {
            previewLabel?.textColor = UIColor.previewOrangeDarkTheme
          } else {
            previewLabel?.textColor = UIColor.previewOrangeLightTheme
          }
        } else if nounForm ==  "" {
          invalidState = true
        } else {
          previewLabel?.textColor = UIColor.label
        }

        if invalidState != true {
          if queriedWordIsUpperCase == false {
            previewLabel?.text = previewPromptSpacing + "(\(nounForm ?? "")) " + lastWordTyped!
          } else {
            previewLabel?.text = previewPromptSpacing + "(\(nounForm ?? "")) " + lastWordTyped!.capitalized
          }
        }
        previewLabel?.sizeToFit()
        invalidState = false
      }
    }
  }

  func selectedPrepositionAnnotation() {
    let selectedWord = proxy.selectedText?.lowercased()
    let isPreposition = prepositions?[selectedWord!] != nil
    if isPreposition {
      let prepositionCase = prepositions?[selectedWord!] as? String
      previewLabel?.text = previewPromptSpacing + "(\(prepositionCase ?? "")) " + selectedWord!
      previewLabel?.sizeToFit()
    }
  }

  func typedPrepositionAnnotation() {
    if controllerLanguage == "German" {
      if proxy.documentContextBeforeInput != nil {
        let wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
        let lastWordTyped = wordsTyped.penultimate()?.lowercased()
        let isPreposition = prepositions?[lastWordTyped!] != nil
        if isPreposition {
          let prepositionCase = prepositions?[lastWordTyped!] as? String
          previewLabel?.text = previewPromptSpacing + "(\(prepositionCase ?? "")) " + lastWordTyped!
          previewLabel?.sizeToFit()
        }
      }
    }
  }

  func clearPreviewLabel() {
    if previewState != true {
      previewLabel?.textColor = UIColor.label
      previewLabel?.text = " "
    }
  }

  @IBAction func keyPressedTouchUp(_ sender: UIButton) {
    guard let originalKey = sender.layer.value(forKey: "original") as? String, let keyToDisplay = sender.layer.value(forKey: "keyToDisplay") as? String else {return}

    guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
    sender.backgroundColor = isSpecial ? specialKeyColor : keyColor

    switch originalKey {
    case "Scribe":
      if proxy.selectedText != nil {
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

    case "Translate":
      scribeBtnState = false
      previewState = true
      loadKeys()
      previewLabel?.text = translatePromptAndCursor
      getTranslation = true

    case "Conjugate":
      scribeBtnState = false
      if shiftButtonState == .shift {
        shiftButtonState = .normal
      }
      previewState = true
      loadKeys()
      previewLabel?.text = conjugatePromptAndCursor
      getConjugation = true

    case "shiftConjugateLeft":
      if controllerLanguage == "German" {
        deConjugationStateLeft()
      } else if controllerLanguage == "Spanish" {
        esConjugationStateLeft()
      }
      loadKeys()

    case "shiftConjugateRight":
      if controllerLanguage == "German" {
        deConjugationStateRight()
      } else if controllerLanguage == "Spanish" {
        esConjugationStateRight()
      }
      loadKeys()

    case "Plural":
      scribeBtnState = false
      if controllerLanguage == "German" {
        if shiftButtonState == .normal {
          shiftButtonState = .shift
        }
      }
      previewState = true
      loadKeys()
      previewLabel?.text = pluralPromptAndCursor
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
      if previewState == true && allPrompts.contains((previewLabel?.text!)!) {
        return
      }
      handlDeleteButtonPressed()
      if proxy.documentContextBeforeInput == nil && previewState != true {
        if keyboardState == .letters && shiftButtonState == .normal {
          shiftButtonState = .shift
          loadKeys()
        }
      }
      clearPreviewLabel()

    case "Leerzeichen":
      if previewState != true {
        proxy.insertText(" ")
      } else {
        previewLabel?.text! = (previewLabel?.text!.insertPriorToCursor(char: " "))!
      }
      typedNounAnnotation()
      typedPrepositionAnnotation()
      if proxy.documentContextBeforeInput?.suffix("  ".count) == "  " {
        clearPreviewLabel()
      }

    case "espacio":
      if previewState != true {
        proxy.insertText(" ")
      } else {
        previewLabel?.text! = (previewLabel?.text!.insertPriorToCursor(char: " "))!
      }
      typedNounAnnotation()
      typedPrepositionAnnotation()
      if proxy.documentContextBeforeInput?.suffix("  ".count) == "  " {
        clearPreviewLabel()
      }

    case "selectKeyboard":
      self.advanceToNextInputMode()

    case "hideKeyboard":
      self.dismissKeyboard()

    case "return":
      if getTranslation && previewState == true {
        queryTranslation()
        getTranslation = false
      }
      if getConjugation && previewState == true {
        // Reset to the most basic conjugations.
        deConjugationState = .indicativePresent
        queryConjugation()
        getConjugation = false
      }
      if getPlural && previewState == true {
        queryPlural()
        getPlural = false
      }
      if previewState == false {
        proxy.insertText("\n")
        clearPreviewLabel()
      } else if invalidState == true {
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
          previewLabel?.text = previewPromptSpacing + "Not in directory"
        }
        previewLabel?.textColor = UIColor.label

        invalidState = false
        isAlreadyPluralState = false
      } else {
        previewState = false
        clearPreviewLabel()
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
      clearPreviewLabel()

    case ".?123":
      changeKeyboardToNumberKeys()
      clearPreviewLabel()

    case "ABC":
      changeKeyboardToLetterKeys()
      clearPreviewLabel()
      proxy.insertText(" ")
      if proxy.documentContextBeforeInput == " " {
        if shiftButtonState == .normal {
          shiftButtonState = .shift
          loadKeys()
        }
      }
      proxy.deleteBackward()

    case "'":
      if previewState != true {
        proxy.insertText("'")
      } else {
        previewLabel?.text! = (previewLabel?.text!.insertPriorToCursor(char: "'"))!
      }
      changeKeyboardToLetterKeys()
      clearPreviewLabel()

    case "#+=":
      changeKeyboardToSymbolKeys()
      clearPreviewLabel()

    case "shift":
      shiftButtonState = shiftButtonState == .normal ? .shift : .normal
      loadKeys()
      clearPreviewLabel()

    default:
      if shiftButtonState == .shift {
        shiftButtonState = .normal
        loadKeys()
      }
      if previewState == false {
        proxy.insertText(keyToDisplay)
        clearPreviewLabel()
      } else {
        previewLabel?.text = previewLabel?.text!.insertPriorToCursor(char: keyToDisplay)
      }
    }
    if self.view.viewWithTag(1001) != nil {
      let viewWithTag = self.view.viewWithTag(1001)
      viewWithTag?.removeFromSuperview()
    }
  }

  @objc func keyMultiPress(_ sender: UIButton, event: UIEvent) {
    guard let originalKey = sender.layer.value(forKey: "original") as? String else {return}

    let touch: UITouch = event.allTouches!.first!
    if touch.tapCount == 2 && originalKey == "shift" {
      shiftButtonState = .caps
      loadKeys()
      clearPreviewLabel()
    }
    // Double space period shortcut.
    if touch.tapCount == 2 && ( originalKey == "Leerzeichen" || originalKey == "espacio" ) && keyboardState == .letters && proxy.documentContextBeforeInput?.count != 1 {
      if proxy.documentContextBeforeInput?.suffix(2) != "  " && previewState != true {
        proxy.deleteBackward()
        proxy.insertText(". ")
        shiftButtonState = .shift
        loadKeys()
      } else if proxy.documentContextBeforeInput?.suffix(2) != "  " && previewState == true {
        previewLabel?.text! = (previewLabel?.text!.deletePriorToCursor())!
        previewLabel?.text! = (previewLabel?.text!.insertPriorToCursor(char: ". "))!
        shiftButtonState = .shift
        loadKeys()
      }
      clearPreviewLabel()
    }
  }

  @objc func aLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    let tapLocation = sender.location(in: self.view)

    let numAlternates = CGFloat(aAlternateKeys.count)
    let viewX = tapLocation.x - 10.0
    var viewWidth = CGFloat(0)
    if numAlternates > 0 {
      viewWidth = CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) + 5.0)
    }

    var alternateBtnStartX = 5.0
    var viewY = 0.0
    var alternatesBtnHeight = 0.0
    var alternatesCharHeight = 0.0
    if DeviceType.isPhone {
      viewY = tapLocation.y - 50.0
      alternatesBtnHeight = buttonWidth * 1.4
      alternatesCharHeight = buttonWidth / 2
    } else if DeviceType.isPad {
      viewY = tapLocation.y - 100.0
      alternatesBtnHeight = buttonWidth
      alternatesCharHeight = buttonWidth / 3
    }

    alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is Already in added than remove and then add.
    if self.view.viewWithTag(1001) != nil {
      alternatesKeyView.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyboardView.backgroundColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = specialKeyColor.cgColor

    for char in aAlternateKeys {
      let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: alternateButtonWidth, height: alternatesBtnHeight))
      if shiftButtonState == .normal {
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

  @objc func eLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    let tapLocation = sender.location(in: self.view)

    let numAlternates = CGFloat(eAlternateKeys.count)
    let viewX = tapLocation.x - 10.0
    var viewWidth = CGFloat(0)
    if numAlternates > 0 {
      viewWidth = CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) + 5.0)
    }

    var alternateBtnStartX = 5.0
    var viewY = 0.0
    var alternatesBtnHeight = 0.0
    var alternatesCharHeight = 0.0
    if DeviceType.isPhone {
      viewY = tapLocation.y - 50.0
      alternatesBtnHeight = buttonWidth * 1.4
      alternatesCharHeight = buttonWidth / 2
    } else if DeviceType.isPad {
      viewY = tapLocation.y - 100.0
      alternatesBtnHeight = buttonWidth
      alternatesCharHeight = buttonWidth / 3
    }

    alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is Already in added than remove and then add.
    if self.view.viewWithTag(1001) != nil {
      alternatesKeyView.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyboardView.backgroundColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = specialKeyColor.cgColor

    for char in eAlternateKeys {
      let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: alternateButtonWidth, height: alternatesBtnHeight))
      if shiftButtonState == .normal {
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

  @objc func iLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    let tapLocation = sender.location(in: self.view)

    let numAlternates = CGFloat(iAlternateKeys.count)
    let viewX = tapLocation.x - CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) - 5.0)
    var viewWidth = CGFloat(0)
    if numAlternates > 0 {
      viewWidth = CGFloat(alternateButtonWidth * numAlternates + (5.0 * numAlternates) + 5.0)
    }

    var alternateBtnStartX = 5.0
    var viewY = 0.0
    var alternatesBtnHeight = 0.0
    var alternatesCharHeight = 0.0
    if DeviceType.isPhone {
      viewY = tapLocation.y - 50.0
      alternatesBtnHeight = buttonWidth * 1.4
      alternatesCharHeight = buttonWidth / 2
    } else if DeviceType.isPad {
      viewY = tapLocation.y - 100.0
      alternatesBtnHeight = buttonWidth
      alternatesCharHeight = buttonWidth / 3
    }

    alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is Already in added than remove and then add.
    if self.view.viewWithTag(1001) != nil {
      alternatesKeyView.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyboardView.backgroundColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = specialKeyColor.cgColor

    for char in iAlternateKeys {
      let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: alternateButtonWidth, height: alternatesBtnHeight))
      if shiftButtonState == .normal {
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

  @objc func oLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    let tapLocation = sender.location(in: self.view)

    let numAlternates = CGFloat(oAlternateKeys.count)
    let viewX = tapLocation.x - CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) - 5.0)
    var viewWidth = CGFloat(0)
    if numAlternates > 0 {
      viewWidth = CGFloat(alternateButtonWidth * numAlternates + (5.0 * numAlternates) + 5.0)
    }

    var alternateBtnStartX = 5.0
    var viewY = 0.0
    var alternatesBtnHeight = 0.0
    var alternatesCharHeight = 0.0
    if DeviceType.isPhone {
      viewY = tapLocation.y - 50.0
      alternatesBtnHeight = buttonWidth * 1.4
      alternatesCharHeight = buttonWidth / 2
    } else if DeviceType.isPad {
      viewY = tapLocation.y - 100.0
      alternatesBtnHeight = buttonWidth
      alternatesCharHeight = buttonWidth / 3
    }

    alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is Already in added than remove and then add.
    if self.view.viewWithTag(1001) != nil {
      alternatesKeyView.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyboardView.backgroundColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = specialKeyColor.cgColor

    for char in oAlternateKeys {
      let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: alternateButtonWidth, height: alternatesBtnHeight))
      if shiftButtonState == .normal {
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

  @objc func uLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    let tapLocation = sender.location(in: self.view)

    let numAlternates = CGFloat(uAlternateKeys.count)
    let viewX = tapLocation.x - CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) - 5.0)
    var viewWidth = CGFloat(0)
    if numAlternates > 0 {
      viewWidth = CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) + 5.0)
    }

    var alternateBtnStartX = 5.0
    var viewY = 0.0
    var alternatesBtnHeight = 0.0
    var alternatesCharHeight = 0.0
    if DeviceType.isPhone {
      viewY = tapLocation.y - 50.0
      alternatesBtnHeight = buttonWidth * 1.4
      alternatesCharHeight = buttonWidth / 2
    } else if DeviceType.isPad {
      viewY = tapLocation.y - 100.0
      alternatesBtnHeight = buttonWidth
      alternatesCharHeight = buttonWidth / 3
    }

    alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is Already in added than remove and then add.
    if self.view.viewWithTag(1001) != nil {
      alternatesKeyView.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyboardView.backgroundColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = specialKeyColor.cgColor

    for char in uAlternateKeys {
      let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: alternateButtonWidth, height: alternatesBtnHeight))
      if shiftButtonState == .normal {
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

  @objc func yLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    let tapLocation = sender.location(in: self.view)

    let numAlternates = CGFloat(yAlternateKeys.count)
    let viewX = tapLocation.x - 10.0
    var viewWidth = CGFloat(0)
    if numAlternates > 0 {
      viewWidth = CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) + 5.0)
    }

    var alternateBtnStartX = 5.0
    var viewY = 0.0
    var alternatesBtnHeight = 0.0
    var alternatesCharHeight = 0.0
    if DeviceType.isPhone {
      viewY = tapLocation.y - 50.0
      alternatesBtnHeight = buttonWidth * 1.4
      alternatesCharHeight = buttonWidth / 2
    } else if DeviceType.isPad {
      viewY = tapLocation.y - 100.0
      alternatesBtnHeight = buttonWidth
      alternatesCharHeight = buttonWidth / 3
    }

    alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is Already in added than remove and then add.
    if self.view.viewWithTag(1001) != nil {
      alternatesKeyView.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyboardView.backgroundColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = specialKeyColor.cgColor

    for char in yAlternateKeys {
      let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: alternateButtonWidth, height: alternatesBtnHeight))
      if shiftButtonState == .normal {
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

  @objc func sLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    let tapLocation = sender.location(in: self.view)

    let numAlternates = CGFloat(sAlternateKeys.count)
    let viewX = tapLocation.x - 10.0
    var viewWidth = CGFloat(0)
    if numAlternates > 0 {
      viewWidth = CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) + 5.0)
    }

    var alternateBtnStartX = 5.0
    var viewY = 0.0
    var alternatesBtnHeight = 0.0
    var alternatesCharHeight = 0.0
    if DeviceType.isPhone {
      viewY = tapLocation.y - 50.0
      alternatesBtnHeight = buttonWidth * 1.4
      alternatesCharHeight = buttonWidth / 2
    } else if DeviceType.isPad {
      viewY = tapLocation.y - 100.0
      alternatesBtnHeight = buttonWidth
      alternatesCharHeight = buttonWidth / 3
    }

    alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is Already in added than remove and then add.
    if self.view.viewWithTag(1001) != nil {
      alternatesKeyView.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyboardView.backgroundColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = specialKeyColor.cgColor

    for char in sAlternateKeys {
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

  @objc func dLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    let tapLocation = sender.location(in: self.view)

    let numAlternates = CGFloat(dAlternateKeys.count)
    let viewX = tapLocation.x - 10.0
    var viewWidth = CGFloat(0)
    if numAlternates > 0 {
      viewWidth = CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) + 5.0)
    }

    var alternateBtnStartX = 5.0
    var viewY = 0.0
    var alternatesBtnHeight = 0.0
    var alternatesCharHeight = 0.0
    if DeviceType.isPhone {
      viewY = tapLocation.y - 50.0
      alternatesBtnHeight = buttonWidth * 1.4
      alternatesCharHeight = buttonWidth / 2
    } else if DeviceType.isPad {
      viewY = tapLocation.y - 100.0
      alternatesBtnHeight = buttonWidth
      alternatesCharHeight = buttonWidth / 3
    }

    alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is Already in added than remove and then add.
    if self.view.viewWithTag(1001) != nil {
      alternatesKeyView.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyboardView.backgroundColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = specialKeyColor.cgColor

    for char in dAlternateKeys {
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

  @objc func cLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    let tapLocation = sender.location(in: self.view)

    let numAlternates = CGFloat(cAlternateKeys.count)
    let viewX = tapLocation.x - 10.0
    var viewWidth = CGFloat(0)
    if numAlternates > 0 {
      viewWidth = CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) + 5.0)
    }

    var alternateBtnStartX = 5.0
    var viewY = 0.0
    var alternatesBtnHeight = 0.0
    var alternatesCharHeight = 0.0
    if DeviceType.isPhone {
      viewY = tapLocation.y - 50.0
      alternatesBtnHeight = buttonWidth * 1.4
      alternatesCharHeight = buttonWidth / 2
    } else if DeviceType.isPad {
      viewY = tapLocation.y - 100.0
      alternatesBtnHeight = buttonWidth
      alternatesCharHeight = buttonWidth / 3
    }

    alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is Already in added than remove and then add.
    if self.view.viewWithTag(1001) != nil {
      alternatesKeyView.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyboardView.backgroundColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = specialKeyColor.cgColor

    for char in cAlternateKeys {
      let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: alternateButtonWidth, height: alternatesBtnHeight))
      if shiftButtonState == .normal {
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

  @objc func nLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
    let tapLocation = sender.location(in: self.view)

    let numAlternates = CGFloat(nAlternateKeys.count)
    let viewX = tapLocation.x - CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) - 5.0)
    var viewWidth = CGFloat(0)
    if numAlternates > 0 {
      viewWidth = CGFloat(alternateButtonWidth * numAlternates + (3.0 * numAlternates) + 5.0)
    }

    var alternateBtnStartX = 5.0
    var viewY = 0.0
    var alternatesBtnHeight = 0.0
    var alternatesCharHeight = 0.0
    if DeviceType.isPhone {
      viewY = tapLocation.y - 50.0
      alternatesBtnHeight = buttonWidth * 1.4
      alternatesCharHeight = buttonWidth / 2
    } else if DeviceType.isPad {
      viewY = tapLocation.y - 100.0
      alternatesBtnHeight = buttonWidth
      alternatesCharHeight = buttonWidth / 3
    }

    alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

    // Only run this code when the state begins.
    if sender.state != UIGestureRecognizer.State.began {
      return
    }
    // If alternateKeysView is Already in added than remove and then add.
    if self.view.viewWithTag(1001) != nil {
      alternatesKeyView.removeFromSuperview()
    }

    alternatesKeyView.backgroundColor = keyboardView.backgroundColor
    alternatesKeyView.layer.cornerRadius = 5
    alternatesKeyView.layer.borderWidth = 1
    alternatesKeyView.tag = 1001
    alternatesKeyView.layer.borderColor = specialKeyColor.cgColor

    for char in nAlternateKeys {
      let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: buttonWidth, height: alternatesBtnHeight))
      if shiftButtonState == .normal {
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

  @objc func keyLongPressed(_ gesture: UIGestureRecognizer) {
    // Prevent the preview state prompt from being deleted.
    if previewState == true && allPrompts.contains((previewLabel?.text!)!) {
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

  @objc func keyUntouched(_ sender: UIButton) {
    guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
    sender.backgroundColor = isSpecial ? specialKeyColor : keyColor
  }

  @objc func keyTouchDown(_ sender: UIButton) {
    sender.backgroundColor = keyPressedColor
  }

  override func textWillChange(_ textInput: UITextInput?) {
    // The app is about to change the document's contents. Perform any preparation here.
  }

  override func textDidChange(_ textInput: UITextInput?) {
    // The app has just changed the document's contents, the document context has been updated.
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    // Trait collection has already changed
  }

  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    // Trait collection will change. Use this one so you know what the state is changing to.
  }
}
