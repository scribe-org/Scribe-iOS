//
//  InterfaceVariables.swift.swift
//
//  Variables associated with the base keyboard interface.
//

import UIKit

// A proxy into which text is typed.
var proxy: UITextDocumentProxy!

// MARK: Display Variables

// Variables for keyboard appearance.
var keyboardHeight: CGFloat!
var keyCornerRadius: CGFloat!
var commandKeyCornerRadius: CGFloat!
var buttonWidth = CGFloat(0)
var letterButtonWidth = CGFloat(0)
var numSymButtonWidth = CGFloat(0)

// Keyboard elements.
var spaceBar = String()

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
/// - caps: caps-lock
enum ShiftButtonState {
  case normal
  case shift
  case caps
}

// Baseline state variables.
var keyboardState: KeyboardState = .letters
var shiftButtonState: ShiftButtonState = .normal
var scribeBtnState: Bool = false

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

/// Returns the abbreviation of the language for use in commands.
func getControllerLanguageAbbr() -> String {
  if controllerLanguage == "French" {
    return "fr"
  } else if controllerLanguage == "German" {
    return "de"
  } else if controllerLanguage == "Portuguese" {
    return "pt"
  } else if controllerLanguage == "Russian" {
    return "ru"
  } else if controllerLanguage == "Spanish" {
    return "es"
  } else if controllerLanguage == "Swedish" {
    return "sv"
  } else {
    return ""
  }
}

/// Sets the keyboard layouts given the chosen keyboard and device type.
func setKeyboardLayouts() {
  if controllerLanguage == "French" {
    if switchInput {
      setENKeyboardLayout()
    } else {
      setFRKeyboardLayout()
    }
  } else if controllerLanguage == "German" {
    if switchInput {
      setENKeyboardLayout()
    } else {
      setDEKeyboardLayout()
    }
  } else if controllerLanguage == "Portuguese" {
    if switchInput {
      setENKeyboardLayout()
    } else {
      setPTKeyboardLayout()
    }
  } else if controllerLanguage == "Russian" {
    if switchInput {
      setENKeyboardLayout()
    } else {
      setRUKeyboardLayout()
    }
  } else if controllerLanguage == "Spanish" {
    if switchInput {
      setENKeyboardLayout()
    } else {
      setESKeyboardLayout()
    }
  } else if controllerLanguage == "Swedish" {
    if switchInput {
      setENKeyboardLayout()
    } else {
      setSVKeyboardLayout()
    }
  }

  allPrompts = [translatePromptAndCursor, conjugatePromptAndCursor, pluralPromptAndCursor]

  if DeviceType.isPhone {
    keysWithAlternates += symbolKeysWithAlternatesLeft
    keysWithAlternates += symbolKeysWithAlternatesRight
    keysWithAlternates.append(currencySymbol)
    keysWithAlternatesLeft += symbolKeysWithAlternatesLeft
    keysWithAlternatesRight += symbolKeysWithAlternatesRight
    keysWithAlternatesRight.append(currencySymbol)
  }

  keyAlternatesDict = [
    "a": aAlternateKeys,
    "e": eAlternateKeys,
    "е": еAlternateKeys, // Russian е
    "i": iAlternateKeys,
    "o": oAlternateKeys,
    "u": uAlternateKeys,
    "ä": äAlternateKeys,
    "ö": öAlternateKeys,
    "y": yAlternateKeys,
    "s": sAlternateKeys,
    "l": lAlternateKeys,
    "z": zAlternateKeys,
    "d": dAlternateKeys,
    "c": cAlternateKeys,
    "n": nAlternateKeys,
    "ь": ьAlternateKeys,
    "/": backslashAlternateKeys,
    "?": questionMarkAlternateKeys,
    "!": exclamationAlternateKeys,
    "%": percentAlternateKeys,
    "&": ampersandAlternateKeys,
    "'": apostropheAlternateKeys,
    "\"": quotationAlternateKeys,
    "=": equalSignAlternateKeys,
    currencySymbol: currencySymbolAlternates
  ]
}

// MARK: Alternate Key Varibables
var alternatesKeyView: UIView!
var keysWithAlternates = [String]()

// The main currency symbol that will receive the alternates view for iPhones.
var currencySymbol: String = ""
var currencySymbolAlternates = [String]()
let dollarAlternateKeys = ["₿", "¢", "₽", "₩", "¥", "£", "€"]
let euroAlternateKeys = ["₿", "¢", "₽", "₩", "¥", "£", "$"]
let roubleAlternateKeys = ["₿", "¢", "₩", "¥", "£", "$", "€"]
let kronaAlternateKeys = ["₿", "¢", "₽", "¥", "£", "$", "€"]
// Symbol keys that have consistent alternates for iPhones.
var symbolKeysWithAlternatesLeft = ["/", "?", "!", "%", "&"]
let backslashAlternateKeys = ["\\"]
let questionMarkAlternateKeys = ["¿"]
let exclamationAlternateKeys = ["¡"]
let percentAlternateKeys = ["‰"]
let ampersandAlternateKeys = ["§"]
var symbolKeysWithAlternatesRight = ["'", "\"", "="]
let apostropheAlternateKeys = ["`", "´", "'"]
let quotationAlternateKeys = ["«", "»", "„", "“", "\""]
let equalSignAlternateKeys = ["≈", "±", "≠"]
var keysWithAlternatesLeft = [String]()
var keysWithAlternatesRight = [String]()
var keyAlternatesDict = [String: [String]]()
var aAlternateKeys = [String]()
var eAlternateKeys = [String]()
var еAlternateKeys = [String]() // Russian е
var iAlternateKeys = [String]()
var oAlternateKeys = [String]()
var uAlternateKeys = [String]()
var yAlternateKeys = [String]()
var äAlternateKeys = [String]()
var öAlternateKeys = [String]()
var sAlternateKeys = [String]()
var lAlternateKeys = [String]()
var zAlternateKeys = [String]()
var dAlternateKeys = [String]()
var cAlternateKeys = [String]()
var nAlternateKeys = [String]()
var ьAlternateKeys = [String]()


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

/// Provides an English keyboard layout.
func setENKeyboardLayout() {
  if DeviceType.isPhone {
    letterKeys = EnglishKeyboardConstants.letterKeysPhone
    numberKeys = EnglishKeyboardConstants.numberKeysPhone
    symbolKeys = EnglishKeyboardConstants.symbolKeysPhone
  } else {
    letterKeys = EnglishKeyboardConstants.letterKeysPad
    numberKeys = EnglishKeyboardConstants.numberKeysPad
    symbolKeys = EnglishKeyboardConstants.symbolKeysPad
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
  currencySymbol = "$"
  currencySymbolAlternates = dollarAlternateKeys
  spaceBar = "space"
  invalidCommandMsg = "Not in directory"

  translateKeyLbl = "Translate"
  translatePrompt = previewPromptSpacing + "en -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + previewCursor

  conjugateKeyLbl = "Conjugate"
  conjugatePrompt = previewPromptSpacing + "Conjugate: "
  conjugatePromptAndCursor = conjugatePrompt + previewCursor

  pluralKeyLbl = "Plural"
  pluralPrompt = previewPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + previewCursor
}
