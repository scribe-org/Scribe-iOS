//
//  FR-QWERTYInterfaceVariables.swift
//
//  Constants and functions to load the QWERTY French Scribe keyboard.
//

public enum FrenchQWERTYKeyboardConstants {
  // iPhone keyboard layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "´"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "space", "return"], // "undo"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undo"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undo"
  ]

  // iPad keyboard layouts.
  static let letterKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"],
    ["a", "z", "e", "r", "t", "y", "u", "i", "o", "p", "delete"],
    ["q", "s", "d", "f", "g", "h", "j", "k", "l", "m", "return"],
    ["shift", "w", "x", "c", "v", "b", "n", "´", ",", ".", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "undo"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["@", "#", "&", "\"", "€", "(", "!", ")", "-", "*", "return"],
    ["#+=", "%", "_", "+", "=", "/", ";", ":", ",", ".", "#+="],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["~", "ᵒ", "[", "]", "{", "}", "^", "$", "£", "¥", "return"],
    ["123", "§", "<", ">", "|", "\\", "...", "·", "?", "'", "123"],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  // Expanded iPad keyboard layouts for wider devices.
  static let letterKeysPadExpanded = [
    ["/", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "delete"],
    ["indent", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "^", "ç", ":"],
    ["uppercase", "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "è", "à", "return"],
    ["shift", "ù", "z", "x", "c", "v", "b", "n", "m", ",", ".", "é", "shift"],
    ["selectKeyboard", ".?123", "microphone", "space", ".?123", "hideKeyboard"], // "microphone", "scribble"
  ]

  static let symbolKeysPadExpanded = [
    ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"],
    ["indent", "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|", "~"],
    ["uppercase", "-", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "~", "return"], // "undo"
    ["shift", "...", ".", ",", "?", "!", "'", "\"", "_", "€"], // "redo"
    ["selectKeyboard", "ABC", "microphone", "space", "ABC", "hideKeyboard"], // "microphone", "scribble"
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
func getFRQWERTYKeys() {
  if DeviceType.isPhone {
    letterKeys = FrenchQWERTYKeyboardConstants.letterKeysPhone
    numberKeys = FrenchQWERTYKeyboardConstants.numberKeysPhone
    symbolKeys = FrenchQWERTYKeyboardConstants.symbolKeysPhone
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["a", "q", "1", "-", "[", "_"]
    rightKeyChars = ["p", "m", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    if (usingExpandedKeyboard)
    {
      letterKeys = FrenchQWERTYKeyboardConstants.letterKeysPadExpanded;
      symbolKeys = FrenchQWERTYKeyboardConstants.symbolKeysPadExpanded;
    }
    else
    {
      letterKeys = FrenchQWERTYKeyboardConstants.letterKeysPad
      numberKeys = FrenchQWERTYKeyboardConstants.numberKeysPad
      symbolKeys = FrenchQWERTYKeyboardConstants.symbolKeysPad
    }

    // If the iPad is too small to have a numbers row.
    letterKeys.removeFirst(1)

    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "a", "1", "@", "~"]
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = FrenchQWERTYKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = FrenchQWERTYKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = FrenchQWERTYKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = FrenchQWERTYKeyboardConstants.aAlternateKeys
  eAlternateKeys = FrenchQWERTYKeyboardConstants.eAlternateKeys
  iAlternateKeys = FrenchQWERTYKeyboardConstants.iAlternateKeys
  oAlternateKeys = FrenchQWERTYKeyboardConstants.oAlternateKeys
  uAlternateKeys = FrenchQWERTYKeyboardConstants.uAlternateKeys
  yAlternateKeys = FrenchQWERTYKeyboardConstants.yAlternateKeys
  cAlternateKeys = FrenchQWERTYKeyboardConstants.cAlternateKeys
  nAlternateKeys = FrenchQWERTYKeyboardConstants.nAlternateKeys
}
