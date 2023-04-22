//
//  FR-AZERTYInterfaceVariables.swift
//
//  Constants and functions to load the AZERTY French Scribe keyboard.
//

public enum FrenchAZERTYKeyboardConstants {
  // Keyboard key layouts.
  static let letterKeysPhone = [
    ["a", "z", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["q", "s", "d", "f", "g", "h", "j", "k", "l", "m"],
    ["shift", "w", "x", "c", "v", "b", "n", "´", "delete"],
    ["123", "selectKeyboard", "space", "return"], // "undoArrow"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "€", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undoArrow"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "$", "£", "¥", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undoArrow"
  ]

  static let letterKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0","-", "=", "delete"],
    ["a", "z", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["q", "s", "d", "f", "g", "h", "j", "k", "l", "m", "return"],
    ["shift", "w", "x", "c", "v", "b", "n", "´", ",", ".", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "undoArrow"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["@", "#", "&", "\"", "€", "(", "!", ")", "-", "*", "return"],
    ["#+=", "%", "_", "+", "=", "/", ";", ":", ",", ".", "#+="],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undoArrow"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["~", "ᵒ", "[", "]", "{", "}", "^", "$", "£", "¥", "return"],
    ["123", "§", "<", ">", "|", "\\", "...", "·", "?", "'", "123"],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undoArrow"
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

/// Gets the keys for the French keyboard.
func getFRAZERTYKeys() {
  if DeviceType.isPhone {
    letterKeys = FrenchAZERTYKeyboardConstants.letterKeysPhone
    numberKeys = FrenchAZERTYKeyboardConstants.numberKeysPhone
    symbolKeys = FrenchAZERTYKeyboardConstants.symbolKeysPhone
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["a", "q", "1", "-", "[", "_"]
    rightKeyChars = ["p", "m", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    letterKeys = FrenchAZERTYKeyboardConstants.letterKeysPad
    numberKeys = FrenchAZERTYKeyboardConstants.numberKeysPad
    symbolKeys = FrenchAZERTYKeyboardConstants.symbolKeysPad
    
    //if the ipad is too samll for numbers
    letterKeys.removeFirst(1)
    letterKeys[0].append("delete")
    
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "a", "1", "@", "~"]
    // TODO: add "p" to rightKeyChar if has 4 rows
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = FrenchAZERTYKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = FrenchAZERTYKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = FrenchAZERTYKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = FrenchAZERTYKeyboardConstants.aAlternateKeys
  eAlternateKeys = FrenchAZERTYKeyboardConstants.eAlternateKeys
  iAlternateKeys = FrenchAZERTYKeyboardConstants.iAlternateKeys
  oAlternateKeys = FrenchAZERTYKeyboardConstants.oAlternateKeys
  uAlternateKeys = FrenchAZERTYKeyboardConstants.uAlternateKeys
  yAlternateKeys = FrenchAZERTYKeyboardConstants.yAlternateKeys
  cAlternateKeys = FrenchAZERTYKeyboardConstants.cAlternateKeys
  nAlternateKeys = FrenchAZERTYKeyboardConstants.nAlternateKeys
}
