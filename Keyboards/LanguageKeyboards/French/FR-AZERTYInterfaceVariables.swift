//
//  FR-AZERTYInterfaceVariables.swift
//
//  Constants and functions to load the AZERTY French Scribe keyboard.
//

import UIKit

public enum FrenchKeyboardConstants {
  // iPhone keyboard layouts.
  static let letterKeysPhone = [
    ["a", "z", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["q", "s", "d", "f", "g", "h", "j", "k", "l", "m"],
    ["shift", "w", "x", "c", "v", "b", "n", "´", "delete"],
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
    ["@", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "°", "–", "delete"],
    ["indent", "a", "z", "e", "r", "t", "y", "u", "i", "o", "p", "^", "$", "*"],
    ["uppercase", "q", "s", "d", "f", "g", "h", "j", "k", "l", "m", "€", "%", "return"],
    ["shift", "/", "w", "x", "c", "v", "b", "n", ",", ".", "<", ">", "shift"],
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
func getFRKeys() {
  if DeviceType.isPhone {
    letterKeys = FrenchKeyboardConstants.letterKeysPhone
    numberKeys = FrenchKeyboardConstants.numberKeysPhone
    symbolKeys = FrenchKeyboardConstants.symbolKeysPhone
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["a", "q", "1", "-", "[", "_"]
    rightKeyChars = ["p", "m", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      letterKeys = FrenchKeyboardConstants.letterKeysPadExpanded
      symbolKeys = FrenchKeyboardConstants.symbolKeysPadExpanded

      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      letterKeys = FrenchKeyboardConstants.letterKeysPad
      numberKeys = FrenchKeyboardConstants.numberKeysPad
      symbolKeys = FrenchKeyboardConstants.symbolKeysPad

      letterKeys.removeFirst(1)

      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    leftKeyChars = ["q", "a", "1", "@", "~"]
    // TODO: add "p" to rightKeyChar if the keyboard has 4 rows.
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
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
}

/// Provides the French keyboard layout.
func setFRKeyboardLayout() {
  getFRKeys()

  currencySymbol = "€"
  currencySymbolAlternates = euroAlternateKeys
  spaceBar = "espace"
  language = "Français"
  invalidCommandMsg = "Pas dans Wikidata"
  baseAutosuggestions = ["je", "il", "le"]
  numericAutosuggestions = ["je", "que", "c’est"]
  verbsAfterPronounsArray = ["être", "avoir", "ne"]
  pronounAutosuggestionTenses = [
    "je": "presFPS",
    "tu": "presSPS",
    "il": "presTPS",
    "elle": "presTPS",
    "on": "presTPS",
    "nous": "presFPP",
    "vous": "presSPP",
    "ils": "presTPP",
    "elles": "presTPP",
  ]

  translateKeyLbl = "Traduire"
  translatePlaceholder = "Entrez un mot"
  translatePrompt = commandPromptSpacing + "fr -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  conjugateKeyLbl = "Conjuguer"
  conjugatePlaceholder = "Entrez un verbe"
  conjugatePrompt = commandPromptSpacing + "Conjuguer: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  pluralKeyLbl = "Pluriel"
  pluralPlaceholder = "Entrez un nom"
  pluralPrompt = commandPromptSpacing + "Pluriel: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))
  alreadyPluralMsg = "Déjà pluriel"
}
