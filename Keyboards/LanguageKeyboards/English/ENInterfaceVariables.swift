/**
 * Constants and functions to load the English Scribe keyboard.
 *
 * Copyright (C) 2024 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import UIKit

public enum EnglishKeyboardConstants {
  static let defaultCurrencyKey = "$"
  static let currencyKeys = ["$", "€", "£", "¥"]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "y", "c", "l", "n", "s", "z"]
  static let keysWithAlternatesLeft = ["a", "e", "y", "c", "s", "z"]
  static let keysWithAlternatesRight = ["i", "o", "u", "l", "n"]

  static let aAlternateKeys = ["à", "á", "â", "ä", "æ", "ã", "å", "ā"]
  static let eAlternateKeys = ["è", "é", "ê", "ë", "ē", "ė", "ę"]
  static let iAlternateKeys = ["ì", "į", "ī", "í", "ï", "î"]
  static let oAlternateKeys = ["õ", "ō", "ø", "œ", "ó", "ò", "ö", "ô"]
  static let uAlternateKeys = ["ū", "ú", "ù", "ü", "û"]
  static let cAlternateKeys = ["ç", "ć", "č"]
  static let lAlternateKeys = ["ł"]
  static let nAlternateKeys = ["ń", "ñ"]
  static let sAlternateKeys = ["ś", "š"]
  static let zAlternateKeys = ["ž", "ź", "ż"]
}

// MARK: iPhone keyboard layouts.
func genPhoneLetterKeys() -> [[String]] {
  return KeyboardBuilder()
    .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"])
    .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l"])
    .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", "delete"])
    .addRow(["123", "selectKeyboard", "space", "return"]) // "undo"
    .build()
}

func genPhoneNumberKeys(currencyKey: String) -> [[String]] {
  return KeyboardBuilder()
    .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
    .addRow(["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""])
    .addRow(["#+=", ".", ",", "?", "!", "'", "delete"])
    .addRow(["ABC", "selectKeyboard", "space", "return"]) // "undo"
    .replaceKey(row: 1, column: 6, to: currencyKey)
    .build()
}

func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
  let keyboardBuilder = KeyboardBuilder()
    .addRow(["[", "]", "{", "}", "#", "%", "^", "*", "+", "="])
    .addRow(["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"])
    .addRow(["123", ".", ",", "?", "!", "'", "delete"])
    .addRow(["ABC", "selectKeyboard", "space", "return"]) // "undo"

  if currencyKeys.count < 3 {
    return keyboardBuilder.build()
  } else {
    // Replace currencies
    return keyboardBuilder
      .replaceKey(row: 1, column: 6, to: currencyKeys[0])
      .replaceKey(row: 1, column: 7, to: currencyKeys[1])
      .replaceKey(row: 1, column: 8, to: currencyKeys[2])
      .build()
  }
}

// MARK: iPad keyboard layouts.
func genPadLetterKeys() -> [[String]] {
  return KeyboardBuilder()
    .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"])
    .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "delete"])
    .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "return"])
    .addRow(["shift", "w", "x", "c", "v", "b", "n", "m", ",", ".", "shift"])
    .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "undo"
    .build()
}

func genPadNumberKeys() -> [[String]] {
  return KeyboardBuilder()
    .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
    .addRow(["@", "#", "$", "&", "*", "(", ")", "'", "\"", "return"])
    .addRow(["#+=", "%", "_", "+", "=", "/", ";", ":", ",", ".", "#+="])
    .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "undo"
    .build()
}

func genPadSymbolKeys() -> [[String]] {
  return KeyboardBuilder()
    .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
    .addRow(["€", "£", "¥", "_", "^", "[", "]", "{", "}", "return"])
    .addRow(["123", "§", "|", "~", "...", "\\", "<", ">", "!", "?", "123"])
    .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "undo"
    .build()
}

func genPadExpandedLetterKeys() -> [[String]] {
  return KeyboardBuilder()
    .addRow(["~", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "delete"])
    .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "\\"])
    .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", ":", ";", "'", "return"])
    .addRow(["shift", "-", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "shift"])
    .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "microphone", "scribble"
    .build()
}

func genPadExpandedSymbolKeys() -> [[String]] {
  return KeyboardBuilder()
    .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
    .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "—", "~", "°"])
    .addRow([SpecialKeys.capsLock, "-", "\\", ":", ";", "(", ")", "&", "@", "$", "£", "¥", "€", "return"]) // "undo"
    .addRow(["shift", "…", "?", "!", "≠", "'", "\"", "|", "_", ".", ",", "/", "shift"]) // "redo"
    .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "microphone", "scribble"
    .build()
}

// MARK: Generate and set keyboard

/// Gets the keys for the English keyboard.
func getENKeys() {
  if DeviceType.isPhone {
    guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
      fatalError()
    }

    var currencyKeys = EnglishKeyboardConstants.currencyKeys
    var currencyKey = EnglishKeyboardConstants.defaultCurrencyKey
    let dictionaryKey = controllerLanguage + "defaultCurrencySymbol"
    if let currencyValue = userDefaults.string(forKey: dictionaryKey) {
      currencyKey = currencyValue
    } else {
      userDefaults.setValue(currencyKey, forKey: dictionaryKey)
    }
    if let index = currencyKeys.firstIndex(of: currencyKey) {
      currencyKeys.remove(at: index)
    }

    letterKeys = genPhoneLetterKeys()
    numberKeys = genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "1", "-", "[", "_"]
    rightKeyChars = ["p", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      letterKeys = genPadExpandedLetterKeys()
      symbolKeys = genPadExpandedSymbolKeys()

      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      letterKeys = genPadLetterKeys()
      numberKeys = genPadNumberKeys()
      symbolKeys = genPadSymbolKeys()

      letterKeys.removeFirst(1)

      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    leftKeyChars = ["q", "1"]
    // TODO: add "p" to rightKeyChar if the keyboard has 4 rows.
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = EnglishKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = EnglishKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = EnglishKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = EnglishKeyboardConstants.aAlternateKeys
  eAlternateKeys = EnglishKeyboardConstants.eAlternateKeys
  iAlternateKeys = EnglishKeyboardConstants.iAlternateKeys
  oAlternateKeys = EnglishKeyboardConstants.oAlternateKeys
  uAlternateKeys = EnglishKeyboardConstants.uAlternateKeys
  sAlternateKeys = EnglishKeyboardConstants.sAlternateKeys
  lAlternateKeys = EnglishKeyboardConstants.lAlternateKeys
  zAlternateKeys = EnglishKeyboardConstants.zAlternateKeys
  cAlternateKeys = EnglishKeyboardConstants.cAlternateKeys
  nAlternateKeys = EnglishKeyboardConstants.nAlternateKeys
}

/// Provides the English keyboard layout.
func setENKeyboardLayout() {
  getENKeys()

  currencySymbol = "$"
  currencySymbolAlternates = dollarAlternateKeys
  spaceBar = "space"
  invalidCommandMsg = "Not in Wikidata"
  baseAutosuggestions = ["I", "I'm", "we"]
  numericAutosuggestions = ["is", "to", "and"]
  verbsAfterPronounsArray = ["have", "be", "can"]
  pronounAutosuggestionTenses = [
    "I": "presSimp",
    "you": "presSimp",
    "he": "presTPS",
    "she": "presTPS",
    "it": "presTPS",
    "we": "presSimp",
    "they": "presSimp"
  ]

  translateKeyLbl = "Translate"
  translatePrompt = commandPromptSpacing + "Currently not utilized" // "en -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt // + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor // + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  conjugateKeyLbl = "Conjugate"
  conjugatePrompt = commandPromptSpacing + "Conjugate: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  pluralKeyLbl = "Plural"
  pluralPrompt = commandPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))
  alreadyPluralMsg = "Already plural"
}
