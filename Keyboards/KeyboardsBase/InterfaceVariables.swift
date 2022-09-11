//
//  InterfaceVariables.swift
//
//  Variables associated with the base keyboard interface.
//

import UIKit

// A proxy into which text is typed.
var proxy: UITextDocumentProxy!

// MARK: Display Variables

// Variables for the keyboard and its appearance.
var keyboard: [[String]] = [[String]]()
var allKeys: [String] = [String]()
var allNonSpecialKeys: [String] = [String]()
var keyboardHeight: CGFloat!
var keyCornerRadius: CGFloat!
var commandKeyCornerRadius: CGFloat!
var keyWidth = CGFloat(0)
var letterKeyWidth = CGFloat(0)
var numSymKeyWidth = CGFloat(0)
var keyboardLoad = false

// Keyboard elements.
var spaceBar = String()

// Arrays for the possible keyboard views that are loaded with their characters.
var letterKeys: [[String]] = [[String]]()
var numberKeys: [[String]] = [[String]]()
var symbolKeys: [[String]] = [[String]]()

/// States of the keyboard corresponding to layouts found in KeyboardConstants.swift.
enum KeyboardState {
  case letters
  case numbers
  case symbols
}

/// What the keyboard state is in regards to the shift key.
/// - normal: not capitalized
/// - shift: capitalized
/// - caps: caps-lock
enum ShiftButtonState {
  case normal
  case shift
  case caps
}

/// States of the keyboard corresponding to which commands the user is executing.
enum CommandState {
  case idle
  case select
  case translate
  case conjugate
  case selectConjugation
  case plural
  case alreadyPlural
  case invalid
}

/// States of the keyboard corresponding to which auto actions should be presented.
enum AutoActionState {
  case complete
  case suggest
}

// Baseline state variables.
var keyboardState: KeyboardState = .letters
var shiftButtonState: ShiftButtonState = .normal
var commandState: CommandState = .idle
var autoActionState: AutoActionState = .suggest

// Variables and functions to determine display parameters.
struct DeviceType {
  static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
  static let isPad = UIDevice.current.userInterfaceIdiom == .pad
}

var isLandscapeView: Bool = false

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
var controllerLanguageAbbr = String()

// Dictionary for accessing language abbreviations.
let languagesAbbrDict: [String: String] = [
  "French": "fr",
  "German": "de",
  "Italian": "it",
  "Portuguese": "pt",
  "Russian": "ru",
  "Spanish": "es",
  "Swedish": "sv"
]

/// Returns the abbreviation of the language for use in commands.
func getControllerLanguageAbbr() -> String {
  guard let abbreviation = languagesAbbrDict[controllerLanguage] else {
    return ""
  }
  return abbreviation
}

// Dictionary for accessing keyboard abbreviations and layouts.
let keyboardLayoutDict: [String: () -> Void] = [
  "French": setFRKeyboardLayout,
  "German": setDEKeyboardLayout,
  "Italian": setITKeyboardLayout,
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
    setENKeyboardLayout()
  } else {
    let setLayoutFxn: () -> Void = keyboardLayoutDict[controllerLanguage]!
    setLayoutFxn()
  }

  // Variable type is String.
  allPrompts = [translatePromptAndCursor, conjugatePromptAndCursor, pluralPromptAndCursor, translatePromptAndPlaceholder, conjugatePromptAndPlaceholder, pluralPromptAndPlaceholder]

  // Variable type is NSAttributedString.
  allColoredPrompts = [translatePromptAndColorPlaceholder, conjugatePromptAndColorPlaceholder, pluralPromptAndColorPlaceholder]
}

// Variables that define which keys are positioned on the very left, right or in the center of the keyboard.
// The purpose of these is to define which key pop up functions should be ran.
var centralKeyChars: [String] = [String]()
var leftKeyChars: [String] = [String]()
var rightKeyChars: [String] = [String]()

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

// MARK: English Interface Variables
// Note: here only until there is an English keyboard.

public enum EnglishKeyboardConstants {
  // Keyboard key layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let letterKeysPad = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "return"],
    ["shift", "w", "x", "c", "v", "b", "n", "m", ",", ".", "shift"],
    [".?123", "selectKeyboard", "space", ".?123", "hideKeyboard"] // "undoArrow"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["@", "#", "$", "&", "*", "(", ")", "'", "\"", "return"],
    ["#+=", "%", "_", "+", "=", "/", ";", ":", ",", ".", "#+="],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["€", "£", "¥", "_", "^", "[", "]", "{", "}", "return"],
    ["123", "§", "|", "~", "...", "\\", "<", ">", "!", "?", "123"],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "y", "s", "l", "z", "c", "n"]
  static let keysWithAlternatesLeft = ["a", "e", "y", "s", "z", "c"]
  static let keysWithAlternatesRight = ["i", "o", "u", "l", "n"]

  static let aAlternateKeys = ["à", "á", "â", "ä", "æ", "ã", "å", "ā"]
  static let eAlternateKeys = ["è", "é", "ê", "ë", "ē", "ė", "ę"]
  static let iAlternateKeys = ["ì", "į", "ī", "í", "ï", "î"]
  static let oAlternateKeys = ["õ", "ō", "ø", "œ", "ó", "ò", "ö", "ô"]
  static let uAlternateKeys = ["ū", "ú", "ù", "ü", "û"]
  static let sAlternateKeys = ["ś", "š"]
  static let lAlternateKeys = ["ł"]
  static let zAlternateKeys = ["ž", "ź", "ż"]
  static let cAlternateKeys = ["ç", "ć", "č"]
  static let nAlternateKeys = ["ń", "ñ"]
}

/// Gets the keys for the English keyboard.
func getENKeys() {
  if DeviceType.isPhone {
    letterKeys = EnglishKeyboardConstants.letterKeysPhone
    numberKeys = EnglishKeyboardConstants.numberKeysPhone
    symbolKeys = EnglishKeyboardConstants.symbolKeysPhone
    allKeys = Array(letterKeys.joined())  + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "1", "-", "[", "_"]
    rightKeyChars = ["p", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    letterKeys = EnglishKeyboardConstants.letterKeysPad
    numberKeys = EnglishKeyboardConstants.numberKeysPad
    symbolKeys = EnglishKeyboardConstants.symbolKeysPad
    allKeys = Array(letterKeys.joined())  + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "1"]
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = EnglishKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = EnglishKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = EnglishKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = EnglishKeyboardConstants.aAlternateKeys
  eAlternateKeys = EnglishKeyboardConstants.eAlternateKeys
  iAlternateKeys = EnglishKeyboardConstants.iAlternateKeys
  oAlternateKeys = EnglishKeyboardConstants.oAlternateKeys
  uAlternateKeys = EnglishKeyboardConstants.uAlternateKeys
  sAlternateKeys = EnglishKeyboardConstants.sAlternateKeys
  lAlternateKeys = EnglishKeyboardConstants.lAlternateKeys
  zAlternateKeys = EnglishKeyboardConstants.zAlternateKeys
  cAlternateKeys = EnglishKeyboardConstants.cAlternateKeys
  nAlternateKeys = EnglishKeyboardConstants.nAlternateKeys
}

/// Provides an English keyboard layout.
func setENKeyboardLayout() {
  getENKeys()

  currencySymbol = "$"
  currencySymbolAlternates = dollarAlternateKeys
  spaceBar = "space"
  invalidCommandMsg = "Not in Wikidata"
  baseAutosuggestions = ["I", "I'm", "we"]
  numericAutosuggestions = ["is", "to", "and"]

  translateKeyLbl = "Translate"
  translatePrompt = commandPromptSpacing + "en -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  conjugateKeyLbl = "Conjugate"
  conjugatePrompt = commandPromptSpacing + "Conjugate: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  pluralKeyLbl = "Plural"
  pluralPrompt = commandPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))
  alreadyPluralMsg = "Already plural"
}
