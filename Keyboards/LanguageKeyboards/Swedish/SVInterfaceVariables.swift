//
//  SVInterfaceVariables.swift
//
//  Constants and functions to load the German Scribe keyboard.
//

public class SwedishKeyboardConstants {

  // Keyboard key layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "å"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "kr", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "€", "$", "£", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let letterKeysPad = [
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "å", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "return"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"],
    [".?123", "selectKeyboard", "space", ".?123", "hideKeyboard"] // "undoArrow"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "`", "delete"],
    ["@", "#", "kr", "&", "*", "(", ")", "'", "\"", "+", "·", "return"],
    ["#+=", "%", "≈", "±", "=", "/", ";", ":", ",", ".", "-", "#+="],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"],
    ["€", "$", "£", "^", "[", "]", "{", "}", "―", "ᵒ", "...", "return"],
    ["123", "§", "|", "~", "≠", "\\", "<", ">", "!", "?", "_", "123"],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "ä", "ö", "s", "c", "n"]
  static let keysWithAlternatesLeft = ["a", "e", "s", "c"]
  static let keysWithAlternatesRight = ["i", "o", "u", "ä", "ö", "n"]

  static let aAlternateKeys = ["á", "à", "â", "ã", "ā"]
  static let eAlternateKeys = ["é", "ë", "è", "ê", "ẽ", "ē", "ę"]
  static let iAlternateKeys = ["ī", "î", "í", "ï", "ì", "ĩ"]
  static let oAlternateKeys = ["ō", "õ", "ô", "ò", "ó", "œ"]
  static let uAlternateKeys = ["û", "ú", "ü", "ù", "ũ", "ū"]
  static let äAlternateKeys = ["æ"]
  static let öAlternateKeys = ["ø"]
  static let sAlternateKeys = ["ß", "ś", "š"]
  static let cAlternateKeys = ["ç"]
  static let nAlternateKeys = ["ñ"]
}

/// Provides a Swedish keyboard layout.
func setSVKeyboardLayout() {
  if DeviceType.isPhone {
    letterKeys = SwedishKeyboardConstants.letterKeysPhone
    numberKeys = SwedishKeyboardConstants.numberKeysPhone
    symbolKeys = SwedishKeyboardConstants.symbolKeysPhone
  } else {
    letterKeys = SwedishKeyboardConstants.letterKeysPad
    numberKeys = SwedishKeyboardConstants.numberKeysPad
    symbolKeys = SwedishKeyboardConstants.symbolKeysPad
  }

  keysWithAlternates = SwedishKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = SwedishKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = SwedishKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = SwedishKeyboardConstants.aAlternateKeys
  eAlternateKeys = SwedishKeyboardConstants.eAlternateKeys
  iAlternateKeys = SwedishKeyboardConstants.iAlternateKeys
  oAlternateKeys = SwedishKeyboardConstants.oAlternateKeys
  uAlternateKeys = SwedishKeyboardConstants.uAlternateKeys
  äAlternateKeys = SwedishKeyboardConstants.äAlternateKeys
  öAlternateKeys = SwedishKeyboardConstants.öAlternateKeys
  sAlternateKeys = SwedishKeyboardConstants.sAlternateKeys
  cAlternateKeys = SwedishKeyboardConstants.cAlternateKeys
  nAlternateKeys = SwedishKeyboardConstants.nAlternateKeys
  currencySymbol = "kr"
  currencySymbolAlternates = kronaAlternateKeys
  spaceBar = "mellanslag"
  invalidCommandMsg = "Inte i katalogen"

  translateKeyLbl = "Översätt"
  translatePrompt = commandPromptSpacing + "sv -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor

  conjugateKeyLbl = "Konjugera"
  conjugatePrompt = commandPromptSpacing + "Konjugera: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor

  pluralKeyLbl = "Plural"
  pluralPrompt = commandPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
}
