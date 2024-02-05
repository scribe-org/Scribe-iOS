//
//  KeyboardKey.swift
//
//  Classes and variables that define keys for Scribe keyboards.
//

import UIKit

// The keys collection as well as one for the padding for placements.
var keyboardKeys: [UIButton] = []
var paddingViews: [UIButton] = []

/// Class of UIButton that allows the tap area to be increased so that edges between keys can still receive user input.
class KeyboardKey: UIButton {
  // Properties for the touch area - passing negative values will expand the touch area.
  var topShift = CGFloat(0)
  var leftShift = CGFloat(0)
  var bottomShift = CGFloat(0)
  var rightShift = CGFloat(0)

  /// Allows the bounds of the key to be expanded.
  override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
    return bounds.inset(by: UIEdgeInsets(
      top: topShift,
      left: leftShift,
      bottom: bottomShift,
      right: rightShift
    )
    ).contains(point)
  }

  var row: Int!
  var idx: Int!
  var key: String!

  /// Styles the key with a color, corner radius and shadow.
  func style() {
    backgroundColor = keyColor
    layer.cornerRadius = keyCornerRadius
    layer.shadowColor = keyShadowColor
    layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 0.0
    layer.masksToBounds = false
  }

  /// Sets the character of the key and defines its capitalized state.
  func setChar() {
    key = keyboard[row][idx]

    if key == "space" {
      key = showKeyboardLanguage ? languageTextForSpaceBar : spaceBar
      layer.setValue(true, forKey: "isSpecial")
    }
    var capsKey = ""

    if key != "ß"
      && key != "´"
      && key != spaceBar
      && key != languageTextForSpaceBar
      && key != "ABC"
      && key != "АБВ"
    {
      capsKey = keyboard[row][idx].capitalized
    } else {
      capsKey = key
    }
    let keyToDisplay = shiftButtonState == .shift || capsLockButtonState == .locked ? capsKey : key
    setTitleColor(keyCharColor, for: .normal)
    layer.setValue(key, forKey: "original")
    layer.setValue(keyToDisplay, forKey: "keyToDisplay")
    layer.setValue(false, forKey: "isSpecial")
    setTitle(keyToDisplay, for: .normal) // set button character

    if showKeyboardLanguage && key == languageTextForSpaceBar {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.layer.setValue(spaceBar, forKey: "original")
        self.layer.setValue(spaceBar, forKey: "keyToDisplay")
        self.setTitle(spaceBar, for: .normal)

        showKeyboardLanguage = false
      }
    }
  }

  /// Sets the character size of a capital key if the device is an iPhone given the orientation.
  func setPhoneCapCharSize() {
    if isLandscapeView {
      if key == "#+="
        || key == "ABC"
        || key == "АБВ"
        || key == "123"
      {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 3.5)
      } else if key == spaceBar || key == languageTextForSpaceBar {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 4)
      } else {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 2.9)
      }
    } else {
      if key == "#+="
        || key == "ABC"
        || key == "АБВ"
        || key == "123"
      {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 1.75)
      } else if key == spaceBar || key == languageTextForSpaceBar {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 2)
      } else {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 1.5)
      }
    }
  }

  /// Checks if the character is a lower case letter and adjusts it if so.
  func checkSetPhoneLowerCharSize() {
    guard let isSpecial = layer.value(forKey: "isSpecial") as? Bool else { return }

    if keyboardState == .letters
      && !isSpecial
      && !["123", "´", spaceBar, languageTextForSpaceBar].contains(key)
      && shiftButtonState == .normal
    {
      titleEdgeInsets = UIEdgeInsets(top: -4.0, left: 0.0, bottom: 0.0, right: 0.0)

      if isLandscapeView {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 2.4)
      } else {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 1.35)
      }
    } else {
      titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
  }

  /// Sets the character size of a key if the device is an iPhone.
  func setPhoneCharSize() {
    setPhoneCapCharSize()
    checkSetPhoneLowerCharSize()
  }

  /// Sets the character size of a key if the device is an iPad given the orientation.
  func setPadCapCharSize() {
    if isLandscapeView {
      if key == "#+="
        || key == "ABC"
        || key == "АБВ"
        || key == "hideKeyboard"
      {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 3.75)
      } else if key == spaceBar || key == languageTextForSpaceBar {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 4.25)
      } else if key == ".?123" {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 4.5)
      } else {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 3.75)
      }
    } else {
      if key == "#+="
        || key == "ABC"
        || key == "АБВ"
        || key == "hideKeyboard"
      {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 3.25)
      } else if key == spaceBar || key == languageTextForSpaceBar {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 3.5)
      } else if key == ".?123" {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 4)
      } else {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 3)
      }
    }
  }

  /// Sets the character size of a key if the device is an iPad given the orientation.
  func checkSetPadLowerCharSize() {
    guard let isSpecial = layer.value(forKey: "isSpecial") as? Bool else { return }

    if keyboardState == .letters
      && !isSpecial
      && ![".?123", spaceBar, languageTextForSpaceBar, "ß", "´", ",", ".", "'", "-"].contains(key)
      && shiftButtonState == .normal
    {
      titleEdgeInsets = UIEdgeInsets(top: -4.0, left: 0.0, bottom: 0.0, right: 0.0)

      if isLandscapeView {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 3.35)
      } else {
        titleLabel?.font = .systemFont(ofSize: letterKeyWidth / 2.75)
      }
    } else {
      titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
  }

  /// Sets the character size of a key if the device is an iPad.
  func setPadCharSize() {
    setPadCapCharSize()
    checkSetPadLowerCharSize()
  }

  /// Sets the key character sizes depending on device type and orientation.
  func setCharSize() {
    if DeviceType.isPhone {
      setPhoneCharSize()
    } else if DeviceType.isPad {
      setPadCharSize()
    }
  }

  /// Adjusts the width of a key if it's one of the special characters on the iPhone keyboard.
  func adjustPhoneKeyWidth() {
    if key == "ABC" || key == "АБВ" {
      layer.setValue(true, forKey: "isSpecial")
      widthAnchor.constraint(equalToConstant: numSymKeyWidth * 2).isActive = true
    } else if key == "delete"
      || key == "#+="
      || key == "shift"
      || key == "selectKeyboard"
    {
      // Cancel Russian keyboard key resizing if translating as the keyboard is English.
      if controllerLanguage == "Russian"
        && keyboardState == .letters
        && commandState != .translate
      {
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * 1).isActive = true
      } else {
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * 1.5).isActive = true
      }
    } else if key == "123"
      || key == ".?123"
      || key == "return"
      || key == "hideKeyboard"
    {
      if row == 2 {
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * 1.5).isActive = true
      } else if row != 2 {
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * 2).isActive = true
      }
    } else if (keyboardState == .numbers || keyboardState == .symbols)
      && row == 2
    {
      // Make second row number and symbol keys wider for iPhones.
      widthAnchor.constraint(equalToConstant: numSymKeyWidth * 1.4).isActive = true
    } else if key != spaceBar && key != languageTextForSpaceBar {
      widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
    }
  }

  /// Adjusts the width of a key if it's one of the special characters on the iPad keyboard.
  func adjustPadKeyWidth() {
    if usingExpandedKeyboard {
      accentCharactersDisabledandKeyboardStateNotSymbols = (disableAccentCharacters && keyboardState != .symbols)
      // Switch case for controller language
      switch (controllerLanguage){
      case "Spanish":
        scalarCapsLockKeyWidth = accentCharactersDisabledandKeyboardStateNotSymbols  ? 2.0 : 1.2
        scalarSpecialKeysWidth = accentCharactersDisabledandKeyboardStateNotSymbols  ? 2.2 : 1.0
        scalarReturnKeyWidth = accentCharactersDisabledandKeyboardStateNotSymbols  ? 1.7 : 1.3
        scalarShiftKeyWidth = 1.8
      case "German", "Swedish":
        scalarCapsLockKeyWidth = 1.8
        scalarReturnKeyWidth = 1.3
        scalarSpecialKeysWidth = accentCharactersDisabledandKeyboardStateNotSymbols  ? 2.2 : 1.0
        scalarReturnKeyWidth = accentCharactersDisabledandKeyboardStateNotSymbols  ? 2.2 : 1.0
      case "French":
        scalarCapsLockKeyWidth = 1.2
        scalarReturnKeyWidth = accentCharactersDisabledandKeyboardStateNotSymbols  ? 1.4 : 1.0
        scalarShiftKeyWidth = 1.8
      case "Italian":
        scalarSpecialKeysWidth = accentCharactersDisabledandKeyboardStateNotSymbols  ? 2.2 : 1.0
        scalarReturnKeyWidth = accentCharactersDisabledandKeyboardStateNotSymbols  ? 1.5 : 1.0
        scalarCapsLockKeyWidth = 1.3
        scalarShiftKeyWidth = 1.8
      default:
        scalarSpecialKeysWidth = accentCharactersDisabledandKeyboardStateNotSymbols  ? 2.2 : 1.0
        scalarReturnKeyWidth = accentCharactersDisabledandKeyboardStateNotSymbols  ? 2.2 : 1.0
      }
      if key == "ABC" || key == "АБВ" {
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * 1).isActive = true
      } else if ["delete", "#+=", "selectKeyboard"].contains(key) { 
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * scalarSpecialKeysWidth).isActive = true
      } else if [SpecialKeys.capsLock].contains(key) {
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * scalarCapsLockKeyWidth).isActive = true
      } else if [SpecialKeys.indent].contains(key) {
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * scalarIndentKeyWidth).isActive = true
      } else if ["shift"].contains(key) {
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * scalarShiftKeyWidth).isActive = true
      } else if ["return"].contains(key) {
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * scalarReturnKeyWidth).isActive = true
      } else if ["123", ".?123", "return", "hideKeyboard"].contains(key) {
        if key == "return"
          && (controllerLanguage == "Portuguese" || controllerLanguage == "Italian" || commandState == .translate)
          && row == 1
          && DeviceType.isPad
        {
          layer.setValue(true, forKey: "isSpecial")
          widthAnchor.constraint(equalToConstant: numSymKeyWidth * scalarReturnKeyWidth).isActive = true
        } else {
          layer.setValue(true, forKey: "isSpecial")
          widthAnchor.constraint(equalToConstant: numSymKeyWidth * 1).isActive = true
        }
      } else if key != spaceBar && key != languageTextForSpaceBar {
        widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
      }
    } else {
      if key == "ABC" || key == "АБВ" {
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * 1).isActive = true
      } else if ["delete", "#+=", "shift", "selectKeyboard", SpecialKeys.indent, SpecialKeys.capsLock].contains(key) {
        layer.setValue(true, forKey: "isSpecial")
        widthAnchor.constraint(equalToConstant: numSymKeyWidth * 1).isActive = true
      } else if ["123", ".?123", "return", "hideKeyboard"].contains(key) {
        if key == "return"
          && (controllerLanguage == "Portuguese" || controllerLanguage == "Italian" || commandState == .translate)
          && row == 1
          && DeviceType.isPad
        {
          layer.setValue(true, forKey: "isSpecial")
          widthAnchor.constraint(equalToConstant: numSymKeyWidth * 1.5).isActive = true
        } else {
          layer.setValue(true, forKey: "isSpecial")
          widthAnchor.constraint(equalToConstant: numSymKeyWidth * 1).isActive = true
        }
      } else if key != spaceBar && key != languageTextForSpaceBar {
        widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
      }
    }
  }

  /// Adjusts the width of a key if it's one of the special characters on the keyboard.
  func adjustKeyWidth() {
    if DeviceType.isPhone {
      adjustPhoneKeyWidth()
    } else if DeviceType.isPad {
      adjustPadKeyWidth()
    }
  }

  /// Adjusts the style of the button based on different states.
  func adjustButtonStyle() {
    guard let isSpecial = layer.value(forKey: "isSpecial") as? Bool else { return }

    switch key {
    case SpecialKeys.indent:
      backgroundColor = specialKeyColor

    case SpecialKeys.capsLock:
      switch capsLockButtonState {
      case .normal:
        backgroundColor = specialKeyColor
        styleIconBtn(btn: self, color: UIColor.label, iconName: "capslock")

      case .locked:
        backgroundColor = keyPressedColor
        styleIconBtn(btn: self, color: UIColor.label, iconName: "capslock.fill")
      }

    case "shift":
      if shiftButtonState == .shift {
        backgroundColor = keyPressedColor

        styleIconBtn(btn: self, color: UIColor.label, iconName: "shift.fill")
      } else if DeviceType.isPhone && capsLockButtonState == .locked {
        // We need to style the SHIFT button instead of the CAPSLOCK since the keyboard is smaller.
        backgroundColor = keyPressedColor

        styleIconBtn(btn: self, color: UIColor.label, iconName: "capslock.fill")
      } else {
        backgroundColor = specialKeyColor
      }

    case "return":
      if [.translate, .conjugate, .plural].contains(commandState) {
        // Color the return key depending on if it's being used as enter for commands.
        backgroundColor = commandKeyColor
      } else {
        backgroundColor = specialKeyColor
      }

    default:
      if isSpecial {
        backgroundColor = specialKeyColor
      }
    }
  }
}

/// Sets a button's values that are displayed and inserted into the proxy as well as assigning a color.
///
/// - Parameters
///   - btn: the button to be set up.
///   - color: the color to assign to the background.
///   - name: the name of the value for the key.
///   - canBeCapitalized: whether the key receives a capitalized character for the shift state.
///   - isSpecial: whether the btn should be marked as special to be colored accordingly.
func setBtn(btn: UIButton, color: UIColor, name: String, canBeCapitalized: Bool, isSpecial: Bool) {
  btn.backgroundColor = color
  btn.layer.setValue(name, forKey: "original")

  let charsWithoutShiftState = ["ß"]

  var capsKey = ""
  if canBeCapitalized {
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
}
