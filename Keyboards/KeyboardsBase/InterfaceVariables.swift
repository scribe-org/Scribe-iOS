// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Variables associated with the base keyboard interface.
 */

import UIKit

// A proxy into which text is typed.
var proxy: UITextDocumentProxy!

// MARK: Display Variables

// Variables for the keyboard and its appearance.
var keyboard = [[String]]()
var usingExpandedKeyboard = false
var allKeys = [String]()
let specialKeys = [
  SpecialKeys.indent, SpecialKeys.capsLock, "shift", "delete", "ABC", "АБВ", "123", "#+=", "selectKeyboard", "space", "return", ".?123", "hideKeyboard"
]
var allNonSpecialKeys = [String]()
var keyboardHeight: CGFloat!
var keyCornerRadius: CGFloat!
var commandKeyCornerRadius: CGFloat!
var keyWidth = CGFloat(0)
var letterKeyWidth = CGFloat(0)
var numSymKeyWidth = CGFloat(0)
var isFirstKeyboardLoad = false
var disableAccentCharacters = false
// Constants and variables for scaling key widths and heights.
let scalarAlternatesBtnYPad = 0.2
let scalarAlternatesBtnYPhone = 0.15
let scalarCommandKeyCornerRadiusLandscapeViewPad = 7.5
let scalarCommandKeyCornerRadiusLandscapeViewPhone = 5.0
let scalarCommandKeyCornerRadiusPad = 5.0
let scalarCommandKeyCornerRadiusPhone = 3.0
let scalarCommandKeyHeightPad = 0.475
let scalarCommandKeyHeightPhone = 0.435
let scalarEmojiKeyFont = 0.475
let scalarKeyCornerRadiusLandscapeViewPad = 12.0
let scalarKeyCornerRadiusLandscapeViewPhone = 9.0
let scalarKeyCornerRadiusPad = 9.0
let scalarKeyCornerRadiusPhone = 6.0
let scalarFontPad = 0.475
let scalarFontPhone = 0.435
let scalarIndentKeyWidth = 1.65
let scalarLetterNumSymKeyWidth = 0.9
let scalarLetterNumSymKeyWidthLandscapeViewPad = 1.2
let scalarLetterNumSymKeyWidthLandscapeViewPhone = 1.5
var scalarReturnKeyWidth = disableAccentCharacters ? 2.2 : 1.0
var scalarShiftKeyWidth = 1.4
var scalarRightShiftKeyWidth = 2.2
var scalarSpecialKeysWidth = disableAccentCharacters ? 2.2 : 1.0
var scalarDeleteKeyWidth = disableAccentCharacters ? 2.2 : 1.0
var scalarCapsLockKeyWidth = 1.8

// Keyboard elements.
var spaceBar = String()
var language = String()
var languageTextForSpaceBar: String {
  "\(language) (Scribe)"
}

var showKeyboardLanguage = false

// Arrays for the possible keyboard views that are loaded with their characters.
var letterKeys = [[String]]()
var numberKeys = [[String]]()
var symbolKeys = [[String]]()

/// States of the keyboard corresponding to layouts found in KeyboardConstants.swift.
enum KeyboardState {
  case letters
  case numbers
  case symbols
}

/// What the keyboard state is in regards to the shift key.
/// - normal: not capitalized
/// - shift: capitalized
enum ShiftButtonState {
  case normal
  case shift
  case capsLocked
}

/// States of the keyboard corresponding to which commands the user is executing.
enum CommandState {
  case idle
  case selectCommand
  case translate
  case conjugate
  case selectVerbConjugation
  case selectCaseDeclension
  case plural
  case alreadyPlural
  case invalid
  case displayInformation
}

/// States of the keyboard corresponding to which auto actions should be presented.
enum AutoActionState {
  case complete
  case suggest
}

/// States for which conjugation table view shift button should be active.
enum ConjViewShiftButtonsState {
  case bothActive
  case bothInactive
  case leftInactive
  case rightInactive
}

// Baseline state variables.
var keyboardState: KeyboardState = .letters
var shiftButtonState: ShiftButtonState = .normal
var commandState: CommandState = .idle
var autoActionState: AutoActionState = .suggest
var conjViewShiftButtonsState: ConjViewShiftButtonsState = .bothInactive

// Variables and functions to determine display parameters.
enum DeviceType {
  static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
  static let isPad = UIDevice.current.userInterfaceIdiom == .pad
}

var isLandscapeView = false

/// Checks if the device is in landscape mode.
func checkLandscapeMode() {
  if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
    isLandscapeView = true
  } else {
    isLandscapeView = false
  }
}

// Keyboard language variables.
var controllerLanguage = String()

// Dictionary for accessing language abbreviations.
let languagesAbbrDict = [
  // "Danish": "da",
  "English": "en",
  "French": "fr",
  "German": "de",
  // "Indonesian": "id",
  "Italian": "it",
  // "Norwegian": "nb",
  "Portuguese": "pt",
  "Russian": "ru",
  "Spanish": "es",
  "Swedish": "sv"
]

let languagesStringDict = [
  "English": NSLocalizedString("app._global.english", value: "English", comment: ""),
  "French": NSLocalizedString("app._global.french", value: "French", comment: ""),
  "German": NSLocalizedString("app._global.german", value: "German", comment: ""),
  // "Indonesian": NSLocalizedString("app._global.indonesian", value: "Indonesian", comment: ""),
  "Italian": NSLocalizedString("app._global.italian", value: "Italian", comment: ""),
  // "Norwegian": NSLocalizedString("app._global.norwegian", value: "Norwegian", comment: ""),
  "Portuguese": NSLocalizedString("app._global.portuguese", value: "Portuguese", comment: ""),
  "Russian": NSLocalizedString("app._global.russian", value: "Russian", comment: ""),
  "Spanish": NSLocalizedString("app._global.spanish", value: "Spanish", comment: ""),
  "Swedish": NSLocalizedString("app._global.swedish", value: "Swedish", comment: "")
]

func getKeyInDict(givenValue: String, dict: [String: String]) -> String {
  for (key, value) in dict where value == givenValue {
    return key
  }
  return ""
}

/// Returns the abbreviation of the language for use in commands.
func getControllerLanguageAbbr() -> String {
  guard let abbreviation = languagesAbbrDict[controllerLanguage] else {
    return ""
  }
  return abbreviation
}

func getControllerTranslateLangCode() -> String {
  let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!
  let key = getControllerLanguageAbbr() + "TranslateLanguage"
  if let translateLang = userDefaults.string(forKey: key) {
    return translateLang
  } else {
    userDefaults.set("en", forKey: key)
    return "en"
  }
}

// Dictionary for accessing keyboard abbreviations and layouts.
let keyboardLayoutDict: [String: () -> Void] = [
  // Layouts for French checked within setFRKeyboardLayout.
  "English": setENKeyboardLayout,
  "French": setFRKeyboardLayout,
  "German": setDEKeyboardLayout,
  "Indonesian": setIDKeyboardLayout,
  "Italian": setITKeyboardLayout,
  "Norwegian": setNBKeyboardLayout,
  "Portuguese": setPTKeyboardLayout,
  "Russian": setRUKeyboardLayout,
  "Spanish": setESKeyboardLayout,
  "Swedish": setSVKeyboardLayout
]

/// Sets the keyboard layout and its alternate keys.
func setKeyboard() {
  setKeyboardLayout()
  setKeyboardAlternateKeys()
}

/// Sets the keyboard layouts given the chosen keyboard and device type.
func setKeyboardLayout() {
  if commandState == .translate {
    let translateLanguage = getKeyInDict(givenValue: getControllerTranslateLangCode(), dict: languagesAbbrDict)
    if let setLayoutFxn = keyboardLayoutDict[translateLanguage] {
      setLayoutFxn()
    } else {
      setENKeyboardLayout()
    }
  } else if let setLayoutFxn = keyboardLayoutDict[controllerLanguage] {
    setLayoutFxn()
  }

  // Variable type is String.
  allPrompts = [translatePromptAndCursor, conjugatePromptAndCursor, pluralPromptAndCursor, translatePromptAndPlaceholder, conjugatePromptAndPlaceholder, pluralPromptAndPlaceholder]

  // Variable type is NSAttributedString.
  allColoredPrompts = [translatePromptAndColorPlaceholder, conjugatePromptAndColorPlaceholder, pluralPromptAndColorPlaceholder]
}

// Variables that define which keys are positioned on the very left, right or in the center of the keyboard.
// The purpose of these is to define which key pop up functions should be ran.
var centralKeyChars = [String]()
var leftKeyChars = [String]()
var rightKeyChars = [String]()

// Variables for call out positioning.
var horizStart = CGFloat(0)
var vertStart = CGFloat(0)
var widthMultiplier = CGFloat(0)
var maxHeightMultiplier = CGFloat(0)
var maxHeight = CGFloat(0)
var heightBeforeTopCurves = CGFloat(0)
var maxWidthCurveControl = CGFloat(0)
var maxHeightCurveControl = CGFloat(0)
var minHeightCurveControl = CGFloat(0)

var keyPopChar = UILabel()
var keyHoldPopChar = UILabel()
var keyPopLayer = CAShapeLayer()
var keyHoldPopLayer = CAShapeLayer()
