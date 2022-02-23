//
//  ITInterfaceVariables.swift
//
//  Constants and functions to load the Italian Scribe keyboard.
//

public enum ItalianKeyboardConstants {

  // Keyboard key layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "€", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "$", "£", "¥", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let letterKeysPad = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "return"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "shift"],
    [".?123", "selectKeyboard", "space", ".?123", "hideKeyboard"] // "undoArrow"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["@", "#", "€", "&", "*", "(", ")", "'", "\"", "return"],
    ["#+=", "%", "-", "+", "=", "/", ";", ":", ",", ".", "#+="],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["$", "£", "¥", "_", "^", "[", "]", "{", "}", "return"],
    ["123", "§", "|", "~", "...", "\\", "<", ">", "!", "?", "123"],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "s", "c", "n"]
  static let keysWithAlternatesLeft = ["a", "e", "s", "c"]
  static let keysWithAlternatesRight = ["i", "o", "u", "n"]

  static let aAlternateKeys = ["à", "á", "ä", "â", "æ", "ã", "å", "ā", "ᵃ"]
  static let eAlternateKeys = ["é", "è", "ə", "ê", "ë", "ę", "ė", "ē"]
  static let iAlternateKeys = ["ī", "į", "ï", "î", "í", "ì"]
  static let oAlternateKeys = ["ᵒ", "ō", "ø", "œ", "õ", "ö", "ô", "ó", "ò"]
  static let uAlternateKeys = ["ū", "ü", "û", "ú", "ù"]
  static let sAlternateKeys = ["ß", "ś", "š"]
  static let cAlternateKeys = ["ç", "ć", "č"]
  static let nAlternateKeys = ["ñ"]
}

/// Gets the keys for the Italian keyboard.
func getITKeys() {
  if DeviceType.isPhone {
    letterKeys = ItalianKeyboardConstants.letterKeysPhone
    numberKeys = ItalianKeyboardConstants.numberKeysPhone
    symbolKeys = ItalianKeyboardConstants.symbolKeysPhone
    allKeys = Array(letterKeys.joined())  + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "1", "-", "[", "_"]
    rightKeyChars = ["p", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) || !rightKeyChars.contains($0) }
  } else {
    letterKeys = ItalianKeyboardConstants.letterKeysPad
    numberKeys = ItalianKeyboardConstants.numberKeysPad
    symbolKeys = ItalianKeyboardConstants.symbolKeysPad
    allKeys = Array(letterKeys.joined())  + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "1"]
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) || !rightKeyChars.contains($0) }
  }

  keysWithAlternates = ItalianKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = ItalianKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = ItalianKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = ItalianKeyboardConstants.aAlternateKeys
  eAlternateKeys = ItalianKeyboardConstants.eAlternateKeys
  iAlternateKeys = ItalianKeyboardConstants.iAlternateKeys
  oAlternateKeys = ItalianKeyboardConstants.oAlternateKeys
  uAlternateKeys = ItalianKeyboardConstants.uAlternateKeys
  sAlternateKeys = ItalianKeyboardConstants.sAlternateKeys
  cAlternateKeys = ItalianKeyboardConstants.cAlternateKeys
  nAlternateKeys = ItalianKeyboardConstants.nAlternateKeys
}

/// Provides a Italian keyboard layout.
func setITKeyboardLayout() {
  getITKeys()

  currencySymbol = "€"
  currencySymbolAlternates = euroAlternateKeys
  spaceBar = "spazio"
  invalidCommandMsg = "Non nella directory"

  translateKeyLbl = "Tradurre"
  translatePrompt = commandPromptSpacing + "it -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor

  conjugateKeyLbl = "Coniugare"
  conjugatePrompt = commandPromptSpacing + "Coniugare: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor

  pluralKeyLbl = "Plurale"
  pluralPrompt = commandPromptSpacing + "Plurale: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  isAlreadyPluralMessage = "Già plurale"
}
