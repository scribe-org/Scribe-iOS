//
//  FRInterfaceVariables.swift
//
//  Constants and functions to load the French Scribe keyboard.
//

public enum FrenchKeyboardConstants {

  // Keyboard key layouts.
  static let letterKeysPhone = [
    ["a", "z", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["q", "s", "d", "f", "g", "h", "j", "k", "l", "m"],
    ["shift", "w", "x", "c", "v", "b", "n", "'", "delete"],
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
    ["a", "z", "e", "r", "t", "y", "u", "i", "o", "p", "delete"],
    ["q", "s", "d", "f", "g", "h", "j", "k", "l", "m", "return"],
    ["shift", "w", "x", "c", "v", "b", "n", "'", ",", ".", "shift"],
    [".?123", "selectKeyboard", "space", ".?123", "hideKeyboard"] // "undoArrow"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["@", "#", "&", "\"", "€", "(", "!", ")", "-", "*", "return"],
    ["#+=", "%", "_", "+", "=", "/", ";", ":", ",", ".", "#+="],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["~", "ᵒ", "[", "]", "{", "}", "^", "$", "£", "¥", "return"],
    ["123", "§", "<", ">", "|", "\\", "...", "·", "?", "'", "123"],
    ["ABC", "selectKeyboard", "space", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "y", "c", "n"]
  static let keysWithAlternatesLeft = ["a", "e", "y", "c"]
  static let keysWithAlternatesRight = ["i", "o", "u", "n"]

  static let aAlternateKeys = ["à", "â", "æ", "á", "ä", "ã", "å", "ā", "ᵃ"]
  static let eAlternateKeys = ["é", "è", "ê", "ë", "ę", "ė", "ē"]
  static let iAlternateKeys = ["ī", "į", "í", "ì", "ï", "î"]
  static let oAlternateKeys = ["ᵒ", "ō", "ø", "õ", "ó", "ò", "ö", "œ", "ô"]
  static let uAlternateKeys = ["ū", "ú", "ü", "ù", "û"]
  static let yAlternateKeys = ["ÿ"]
  static let cAlternateKeys = ["ç", "ć", "č"]
  static let nAlternateKeys = ["ń", "ñ"]
}

/// Provides a French keyboard layout.
func setFRKeyboardLayout() {
  if DeviceType.isPhone {
    letterKeys = FrenchKeyboardConstants.letterKeysPhone
    numberKeys = FrenchKeyboardConstants.numberKeysPhone
    symbolKeys = FrenchKeyboardConstants.symbolKeysPhone
  } else {
    letterKeys = FrenchKeyboardConstants.letterKeysPad
    numberKeys = FrenchKeyboardConstants.numberKeysPad
    symbolKeys = FrenchKeyboardConstants.symbolKeysPad
  }

  keysWithAlternates = FrenchKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = FrenchKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = FrenchKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = FrenchKeyboardConstants.aAlternateKeys
  eAlternateKeys = FrenchKeyboardConstants.eAlternateKeys
  iAlternateKeys = FrenchKeyboardConstants.iAlternateKeys
  oAlternateKeys = FrenchKeyboardConstants.oAlternateKeys
  uAlternateKeys = FrenchKeyboardConstants.uAlternateKeys
  yAlternateKeys = FrenchKeyboardConstants.yAlternateKeys
  cAlternateKeys = FrenchKeyboardConstants.cAlternateKeys
  nAlternateKeys = FrenchKeyboardConstants.nAlternateKeys
  currencySymbol = "€"
  currencySymbolAlternates = euroAlternateKeys
  spaceBar = "espace"
  invalidCommandMsg = "Pas dans le répertoire"

  translateBtnLbl = "Traduire"
  translatePrompt = previewPromptSpacing + "fr -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + previewCursor

  conjugateBtnLbl = "Conjuguer"
  conjugatePrompt = previewPromptSpacing + "Conjuguer: "
  conjugatePromptAndCursor = conjugatePrompt + previewCursor

  pluralBtnLbl = "Pluriel"
  pluralPrompt = previewPromptSpacing + "Pluriel: "
  pluralPromptAndCursor = pluralPrompt + previewCursor
}
