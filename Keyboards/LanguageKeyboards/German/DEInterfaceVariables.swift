//
//  DEInterfaceVariables.swift
//
//  Constants and functions to load the German Scribe keyboard.
//

import UIKit

public enum GermanKeyboardConstants {
  // iPhone keyboard layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "space", "return"], // "undo"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "€", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undo"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "$", "£", "¥", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undo"
  ]

  // iPad keyboard layouts.
  static let letterKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"],
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "return"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "ß", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "undo"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "delete"],
    ["\"", "§", "€", "%", "&", "/", "(", ")", "=", "'", "#", "return"],
    ["#+=", "—", "`", "'", "...", "@", ";", ":", ",", ".", "-", "#+="],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"],
    ["$", "£", "¥", "¿", "―", "\\", "[", "]", "{", "}", "|", "return"],
    ["123", "¡", "<", ">", "≠", "·", "^", "~", "!", "?", "_", "123"],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  // Expanded iPad keyboard layouts for wider devices.
  static let letterKeysPadExpanded = [
    ["^", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "ß", "´", "delete"],
    ["indent", "q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü", "+", "*"],
    ["uppercase", "a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "#", "return"],
    ["shift", "<", "y", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "microphone", "scribble"
  ]

  static let symbolKeysPadExpanded = [
    ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"],
    ["indent", "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|", "§"],
    ["uppercase", "-", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "~", "return"], // "undo"
    ["shift", "...", ".", ",", "?", "!", "'", "\"", "_", "€"], // "redo"
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "microphone", "scribble"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "y", "c", "l", "n", "s", "z"]
  static let keysWithAlternatesLeft = ["a", "e", "y", "c", "s", "z"]
  static let keysWithAlternatesRight = ["i", "o", "u", "l", "n"]

  static let aAlternateKeys = ["à", "á", "â", "æ", "ã", "å", "ā", "ą"]
  static let eAlternateKeys = ["é", "è", "ê", "ë", "ė", "ę"]
  static let iAlternateKeys = ["ì", "ī", "í", "î", "ï"]
  static let oAlternateKeys = ["ō", "ø", "œ", "õ", "ó", "ò", "ô"]
  static let uAlternateKeys = ["ū", "ú", "ù", "û"]
  static let yAlternateKeys = ["ÿ"]
  static let cAlternateKeys = ["ç", "ć", "č"]
  static let lAlternateKeys = ["ł"]
  static let nAlternateKeys = ["ń", "ñ"]
  static let sAlternateKeys = ["ß", "ś", "š"]
  static let zAlternateKeys = ["ź", "ż"]
}

/// Gets the keys for the German keyboard.
func getDEKeys() {
  if DeviceType.isPhone {
    letterKeys = GermanKeyboardConstants.letterKeysPhone
    numberKeys = GermanKeyboardConstants.numberKeysPhone
    symbolKeys = GermanKeyboardConstants.symbolKeysPhone
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "a", "1", "-", "[", "_"]
    rightKeyChars = ["ü", "ä", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    if (usingExpandedKeyboard)
    {
      letterKeys = GermanKeyboardConstants.letterKeysPadExpanded;
      symbolKeys = GermanKeyboardConstants.symbolKeysPadExpanded;
    }
    else
    {
      letterKeys = GermanKeyboardConstants.letterKeysPad
      numberKeys = GermanKeyboardConstants.numberKeysPad
      symbolKeys = GermanKeyboardConstants.symbolKeysPad
    }

    // If the iPad is too small to have a numbers row.
    letterKeys.removeFirst(1)
    letterKeys[0].append("delete")

    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "a", "1", "\"", "$"]
    // TODO: add "ü" to rightKeyChar if the keyboard has 4 rows.
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = GermanKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = GermanKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = GermanKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = GermanKeyboardConstants.aAlternateKeys
  eAlternateKeys = GermanKeyboardConstants.eAlternateKeys
  iAlternateKeys = GermanKeyboardConstants.iAlternateKeys
  oAlternateKeys = GermanKeyboardConstants.oAlternateKeys
  uAlternateKeys = GermanKeyboardConstants.uAlternateKeys
  yAlternateKeys = GermanKeyboardConstants.yAlternateKeys
  sAlternateKeys = GermanKeyboardConstants.sAlternateKeys
  lAlternateKeys = GermanKeyboardConstants.lAlternateKeys
  zAlternateKeys = GermanKeyboardConstants.zAlternateKeys
  cAlternateKeys = GermanKeyboardConstants.cAlternateKeys
  nAlternateKeys = GermanKeyboardConstants.nAlternateKeys
}

/// Provides the German keyboard layout.
func setDEKeyboardLayout() {
  getDEKeys()

  currencySymbol = "€"
  currencySymbolAlternates = euroAlternateKeys
  spaceBar = "Leerzeichen"
  language = "Deutsch"
  invalidCommandMsg = "Nicht in Wikidata"
  baseAutosuggestions = ["ich", "die", "das"]
  numericAutosuggestions = ["Prozent", "Milionen", "Meter"]
  verbsAfterPronounsArray = ["haben", "sein", "können"]
  pronounAutosuggestionTenses = [
    "ich": "presFPS",
    "du": "presSPS",
    "er": "presTPS",
    "sie": "presTPS",
    "es": "presTPS",
    "wir": "presFPP",
    "ihr": "presSPP",
    "Sie": "presTPP",
  ]

  translateKeyLbl = "Übersetzen"
  translatePlaceholder = "Wort eingeben"
  translatePrompt = commandPromptSpacing + "de -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  conjugateKeyLbl = "Konjugieren"
  conjugatePlaceholder = "Verb eingeben"
  conjugatePrompt = commandPromptSpacing + "Konjugieren: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  pluralKeyLbl = "Plural"
  pluralPlaceholder = "Nomen eingeben"
  pluralPrompt = commandPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))
  alreadyPluralMsg = "Schon Plural"
}
