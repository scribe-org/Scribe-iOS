//
//  PTInterfaceVariables.swift
//
//  Constants and functions to load the Portuguese Scribe keyboard.
//

public enum PortugueseKeyboardConstants {

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
    ["shift", "z", "x", "c", "v", "b", "n", "m", "!", "?", "shift"],
    [".?123", "selectKeyboard", "space", ".?123", "hideKeyboard"] // "undoArrow"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["@", "#", "$", "&", "*", "(", ")", "'", "\"", "return"],
    ["#+=", "%", "-", "+", "=", "/", ";", ":", ",", ".", "#+="],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["€", "£", "¥", "_", "^", "[", "]", "{", "}", "return"],
    ["123", "§", "|", "~", "...", "\\", "<", ">", "!", "?", "123"],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "c", "n"]
  static let keysWithAlternatesLeft = ["a", "e", "c"]
  static let keysWithAlternatesRight = ["i", "o", "u", "n"]

  static let aAlternateKeys = ["á", "ã", "à", "â", "ä", "å", "æ", "ᵃ"]
  static let eAlternateKeys = ["é", "ê", "è", "ę", "ė", "ē", "ë"]
  static let iAlternateKeys = ["ī", "į", "ï", "ì", "î", "í"]
  static let oAlternateKeys = ["ᵒ", "ō", "ø", "œ", "ö", "ò", "ô", "õ", "ó"]
  static let uAlternateKeys = ["ū", "û", "ù", "ü", "ú"]
  static let cAlternateKeys = ["ç"]
  static let nAlternateKeys = ["ñ"]
}

/// Provides a Portuguese keyboard layout.
func setPTKeyboardLayout() {
  if DeviceType.isPhone {
    letterKeys = PortugueseKeyboardConstants.letterKeysPhone
    numberKeys = PortugueseKeyboardConstants.numberKeysPhone
    symbolKeys = PortugueseKeyboardConstants.symbolKeysPhone
  } else {
    letterKeys = PortugueseKeyboardConstants.letterKeysPad
    numberKeys = PortugueseKeyboardConstants.numberKeysPad
    symbolKeys = PortugueseKeyboardConstants.symbolKeysPad
  }

  keysWithAlternates = PortugueseKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = PortugueseKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = PortugueseKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = PortugueseKeyboardConstants.aAlternateKeys
  eAlternateKeys = PortugueseKeyboardConstants.eAlternateKeys
  iAlternateKeys = PortugueseKeyboardConstants.iAlternateKeys
  oAlternateKeys = PortugueseKeyboardConstants.oAlternateKeys
  uAlternateKeys = PortugueseKeyboardConstants.uAlternateKeys
  cAlternateKeys = PortugueseKeyboardConstants.cAlternateKeys
  nAlternateKeys = PortugueseKeyboardConstants.nAlternateKeys
  currencySymbol = "$"
  currencySymbolAlternates = dollarAlternateKeys
  spaceBar = "espaço"
  invalidCommandMsg = "Não está no diretório"

  translateBtnLbl = "Traduzir"
  translatePrompt = previewPromptSpacing + "pt -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + previewCursor

  conjugateBtnLbl = "Conjugar"
  conjugatePrompt = previewPromptSpacing + "Conjugar: "
  conjugatePromptAndCursor = conjugatePrompt + previewCursor

  pluralBtnLbl = "Plural"
  pluralPrompt = previewPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + previewCursor
}
