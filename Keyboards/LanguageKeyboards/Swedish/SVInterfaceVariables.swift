//
//  SVInterfaceVariables.swift
//
//  Constants and functions to load the Swedish Scribe keyboard.
//

import UIKit

public enum SwedishKeyboardConstants {
  // iPhone keyboard layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "å"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "space", "return"], // "undo"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "kr", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undo"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "€", "$", "£", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undo"
  ]

  // iPad keyboard layouts.
  static let letterKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"],
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "å", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "return"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "?", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "undo"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "`", "delete"],
    ["@", "#", "kr", "&", "*", "(", ")", "'", "\"", "+", "·", "return"],
    ["#+=", "%", "≈", "±", "=", "/", ";", ":", ",", ".", "-", "#+="],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"],
    ["€", "$", "£", "^", "[", "]", "{", "}", "―", "ᵒ", "...", "return"],
    ["123", "§", "|", "~", "≠", "\\", "<", ">", "!", "?", "_", "123"],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  // Expanded iPad keyboard layouts for wider devices.
  static let letterKeysPadExpanded = [
    ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "'", "delete"],
    ["indent", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å", "^", "*"],
    ["uppercase", "a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "'", "return"],
    ["shift", "<", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "microphone", "scribble"
  ]

  static let symbolKeysPadExpanded = [
    ["§", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"],
    ["indent", "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|"],
    ["uppercase", "-", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "~", "return"], // "undo"
    ["shift", "...", ".", ",", "?", "!", "'", "\"", "_", "€"], // "redo"
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "microphone", "scribble"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "ä", "ö", "c", "n", "s"]
  static let keysWithAlternatesLeft = ["a", "e", "c", "s"]
  static let keysWithAlternatesRight = ["i", "o", "u", "ä", "ö", "n"]

  static let aAlternateKeys = ["á", "à", "â", "ã", "ā"]
  static let eAlternateKeys = ["é", "ë", "è", "ê", "ẽ", "ē", "ę"]
  static let iAlternateKeys = ["ī", "î", "í", "ï", "ì", "ĩ"]
  static let oAlternateKeys = ["ō", "õ", "ô", "ò", "ó", "œ"]
  static let uAlternateKeys = ["û", "ú", "ü", "ù", "ũ", "ū"]
  static let äAlternateKeys = ["æ"]
  static let öAlternateKeys = ["ø"]
  static let cAlternateKeys = ["ç"]
  static let nAlternateKeys = ["ñ"]
  static let sAlternateKeys = ["ß", "ś", "š"]
}

/// Gets the keys for the Swedish keyboard.
func getSVKeys() {
  if DeviceType.isPhone {
    letterKeys = SwedishKeyboardConstants.letterKeysPhone
    numberKeys = SwedishKeyboardConstants.numberKeysPhone
    symbolKeys = SwedishKeyboardConstants.symbolKeysPhone
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "a", "1", "-", "[", "_"]
    rightKeyChars = ["å", "ä", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    //if the iPad is wide enough, and has no home button, use the expanded keys
    if (usingExpandedKeyboard) {
      letterKeys = SwedishKeyboardConstants.letterKeysPadExpanded
      symbolKeys = SwedishKeyboardConstants.symbolKeysPadExpanded
    }
    else
    {
      letterKeys = SwedishKeyboardConstants.letterKeysPad
      numberKeys = SwedishKeyboardConstants.numberKeysPad
      symbolKeys = SwedishKeyboardConstants.symbolKeysPad
    }

    // If the iPad is too small to have a numbers row.
    //letterKeys.removeFirst(1)
    letterKeys[0].append("delete")

    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "a", "1", "@", "€"]
    // TODO: add "å" to rightKeyChar if the keyboard has 4 rows.
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
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
}

/// Provides the Swedish keyboard layout.
func setSVKeyboardLayout() {
  getSVKeys()

  currencySymbol = "kr"
  currencySymbolAlternates = kronaAlternateKeys
  spaceBar = "mellanslag"
  language = "Svenska"
  invalidCommandMsg = "Inte i Wikidata"
  baseAutosuggestions = ["jag", "det", "men"]
  numericAutosuggestions = ["jag", "det", "och"]

  translateKeyLbl = "Översätt"
  translatePlaceholder = "Ange ett ord"
  translatePrompt = commandPromptSpacing + "sv -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  conjugateKeyLbl = "Konjugera"
  conjugatePlaceholder = "Ange ett verb"
  conjugatePrompt = commandPromptSpacing + "Konjugera: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  pluralKeyLbl = "Plural"
  pluralPlaceholder = "Ange ett substantiv"
  pluralPrompt = commandPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))
  alreadyPluralMsg = "Redan plural"
}
