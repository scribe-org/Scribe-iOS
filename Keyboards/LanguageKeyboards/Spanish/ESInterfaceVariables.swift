//
//  ESInterfaceVariables.swift
//
//  Constants and functions to load the Spanish Scribe keyboard.
//

public class SpanishKeyboardConstants {

  // Keyboard key layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ñ"],
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
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ñ", "return"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "shift"],
    [".?123", "selectKeyboard", "space", ".?123", "hideKeyboard"] // "undoArrow"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["@", "#", "$", "&", "*", "(", ")", "'", "\"", "+", "return"],
    ["#+=", "%", "_", "-", "=", "/", ";", ":", ",", ".", "#+="],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["€", "£", "¥", "^", "[", "]", "{", "}", "ᵒ", "ᵃ", "return"],
    ["123", "§", "|", "~", "¶", "\\", "<", ">", "¡", "¿", "123"],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "s", "d", "c", "n"]
  static let keysWithAlternatesLeft = ["a", "e", "s", "d", "c"]
  static let keysWithAlternatesRight = ["i", "o", "u", "n"]

  static let aAlternateKeys = ["á", "à", "ä", "â", "ã", "å", "ą", "æ", "ā", "ᵃ"]
  static let eAlternateKeys = ["é", "è", "ë", "ê", "ę", "ė", "ē"]
  static let iAlternateKeys = ["ī", "į", "î", "ì", "ï", "í"]
  static let oAlternateKeys = ["ᵒ", "ō", "œ", "ø", "õ", "ô", "ö", "ó", "ò"]
  static let uAlternateKeys = ["ū", "û", "ù", "ü", "ú"]
  static let sAlternateKeys = ["š"]
  static let dAlternateKeys = ["đ"]
  static let cAlternateKeys = ["ç", "ć", "č"]
  static let nAlternateKeys = ["ń"]
}

/// Provides a Spanish keyboard layout.
func setESKeyboardLayout() {
  if DeviceType.isPhone {
    letterKeys = SpanishKeyboardConstants.letterKeysPhone
    numberKeys = SpanishKeyboardConstants.numberKeysPhone
    symbolKeys = SpanishKeyboardConstants.symbolKeysPhone
  } else {
    letterKeys = SpanishKeyboardConstants.letterKeysPad
    numberKeys = SpanishKeyboardConstants.numberKeysPad
    symbolKeys = SpanishKeyboardConstants.symbolKeysPad
  }

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
  currencySymbol = "$"
  currencySymbolAlternates = dollarAlternateKeys
  spaceBar = "espacio"
  invalidCommandMsg = "No en el directorio"

  translateBtnLbl = "Traducir"
  translatePrompt = previewPromptSpacing + "es -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + previewCursor

  conjugateBtnLbl = "Conjugar"
  conjugatePrompt = previewPromptSpacing + "Conjugar: "
  conjugatePromptAndCursor = conjugatePrompt + previewCursor

  pluralBtnLbl = "Plural"
  pluralPrompt = previewPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + previewCursor
}
