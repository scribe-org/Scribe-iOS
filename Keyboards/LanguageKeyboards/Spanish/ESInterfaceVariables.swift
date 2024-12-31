/**
 * Constants and functions to load the Spanish Scribe keyboard.
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

import UIKit

// MARK: Constants

public enum ESKeyboardConstants {
  static let defaultCurrencyKey = "$"
  static let currencyKeys = ["$", "€", "£", "¥"]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "c", "d", "n", "s"]
  static let keysWithAlternatesLeft = ["a", "e", "c", "d", "s"]
  static let keysWithAlternatesRight = ["i", "o", "u", "n"]

  static let aAlternateKeys = ["á", "à", "ä", "â", "ã", "å", "ą", "æ", "ā", "ᵃ"]
  static let eAlternateKeys = ["é", "è", "ë", "ê", "ę", "ė", "ē"]
  static let iAlternateKeys = ["ī", "į", "î", "ì", "ï", "í"]
  static let oAlternateKeys = ["ᵒ", "ō", "œ", "ø", "õ", "ô", "ö", "ó", "ò"]
  static let uAlternateKeys = ["ū", "û", "ù", "ü", "ú"]
  static let cAlternateKeys = ["ç", "ć", "č"]
  static let dAlternateKeys = ["đ"]
  static let nAlternateKeys = ["ń"]
  static let nAlternateKeysDisableAccents = ["ń", "ñ"]
  static let sAlternateKeys = ["š"]
}

struct ESKeyboardProvider: KeyboardProviderProtocol, KeyboardProviderDisableAccentsProtocol {
  // MARK: iPhone Layouts

  static func genPhoneLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "ñ"])
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", "delete"])
      .addRow(["123", "selectKeyboard", "space", "return"]) // "undo"
      .build()
  }

  static func genPhoneDisableAccentsLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l"])
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", "delete"])
      .addRow(["123", "selectKeyboard", "space", "return"]) // "undo"
      .build()
  }

  static func genPhoneNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
      .addRow(["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""])
      .addRow(["#+=", ".", ",", "?", "!", "'", "delete"])
      .addRow(["ABC", "selectKeyboard", "space", "return"]) // "undo"
      .replaceKey(row: 1, column: 6, to: currencyKey)
      .build()
  }

  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["[", "]", "{", "}", "#", "%", "^", "*", "+", "="])
      .addRow(["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"])
      .addRow(["123", ".", ",", "?", "!", "'", "delete"])
      .addRow(["ABC", "selectKeyboard", "space", "return"]) // "undo"

    if currencyKeys.count < 3 {
      return keyboardBuilder.build()
    } else {
      return keyboardBuilder
        .replaceKey(row: 1, column: 6, to: currencyKeys[0])
        .replaceKey(row: 1, column: 7, to: currencyKeys[1])
        .replaceKey(row: 1, column: 8, to: currencyKeys[2])
        .build()
    }
  }

  // MARK: iPad Layouts

  static func genPadLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"])
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "delete"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "ñ", "return"])
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "undo"
      .build()
  }

  static func genPadDisableAccentsLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"])
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "delete"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "return"])
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "undo"
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
      .addRow(["@", "#", "$", "&", "*", "(", ")", "'", "\"", "+", "return"])
      .addRow(["#+=", "%", "_", "-", "=", "/", ";", ":", ",", ".", "#+="])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "undo"
      .replaceKey(row: 1, column: 2, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
      .addRow(["€", "£", "¥", "^", "[", "]", "{", "}", "ᵒ", "ᵃ", "return"])
      .addRow(["123", "§", "|", "~", "¶", "\\", "<", ">", "¡", "¿", "123"])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "undo"

    if currencyKeys.count < 3 {
      return keyboardBuilder.build()
    } else {
      return keyboardBuilder
        .replaceKey(row: 1, column: 0, to: currencyKeys[0])
        .replaceKey(row: 1, column: 1, to: currencyKeys[1])
        .replaceKey(row: 1, column: 2, to: currencyKeys[2])
        .build()
    }
  }

  // MARK: Expanded iPad Layouts

  static func genPadExpandedLetterKeys() -> [[String]] {
    return KeyboardBuilder()
    .addRow(["|", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "?", "¿", "delete"])
    .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "´", "+", "*"])
    .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "ñ", "{", "}", "return"])
    .addRow(["shift", "'", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"])
    .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "microphone", "scribble"
    .build()
  }

  static func genPadExpandedDisableAccentsLetterKeys() -> [[String]] {
    return KeyboardBuilder()
    .addRow(["|", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "?", "¿", "delete"])
    .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "´", "+", "*"])
    .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "~", "{", "}", "return"])
    .addRow(["shift", "'", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"])
    .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "microphone", "scribble"
    .build()
}

static func genPadExpandedSymbolKeys() -> [[String]] {
  return KeyboardBuilder()
    .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
    .addRow([SpecialKeys.indent, "(", ")", "{", "}", "#", "%", "^", "*", "+", "=", "\\", "|", "§"])
    .addRow([SpecialKeys.capsLock, "—", "/", ":", ";", "&", "@", "$", "£", "¥", "~", "[", "]", "return"]) // "undo"
    .addRow(["shift", "…", "?", "!", "≠", "'", "\"", "_", "€", ",", ".", "-", "shift"]) // "redo"
    .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "microphone", "scribble"
    .build()
}
}

// MARK: Get Keys

func getESKeys() {
  guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
    fatalError()
  }

  var currencyKey = ESKeyboardConstants.defaultCurrencyKey
  var currencyKeys = ESKeyboardConstants.currencyKeys
  let dictionaryKey = controllerLanguage + "defaultCurrencySymbol"
  if let currencyValue = userDefaults.string(forKey: dictionaryKey) {
    currencyKey = currencyValue
  } else {
    userDefaults.setValue(currencyKey, forKey: dictionaryKey)
  }
  if let index = currencyKeys.firstIndex(of: currencyKey) {
    currencyKeys.remove(at: index)
  }

  if DeviceType.isPhone {
    if userDefaults.bool(forKey: "esAccentCharacters") {
      letterKeys = ESKeyboardProvider.genPhoneDisableAccentsLetterKeys()
    } else {
      letterKeys = ESKeyboardProvider.genPhoneLetterKeys()
    }
    numberKeys = ESKeyboardProvider.genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = ESKeyboardProvider.genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "a", "1", "-", "[", "_"]
    if userDefaults.bool(forKey: "esAccentCharacters") {
      rightKeyChars = ["p", "l", "0", "\"", "=", "·"]
    } else {
      rightKeyChars = ["p", "ñ", "0", "\"", "=", "·"]
    }
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      if userDefaults.bool(forKey: "esAccentCharacters") {
        letterKeys = ESKeyboardProvider.genPadExpandedDisableAccentsLetterKeys()
      } else {
        letterKeys = ESKeyboardProvider.genPadExpandedLetterKeys()
      }
      symbolKeys = ESKeyboardProvider.genPadExpandedSymbolKeys()

      leftKeyChars = ["|", "`"]
      rightKeyChars = ["*", "§"]
      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      if userDefaults.bool(forKey: "esAccentCharacters") {
        letterKeys = ESKeyboardProvider.genPadDisableAccentsLetterKeys()
      } else {
        letterKeys = ESKeyboardProvider.genPadLetterKeys()
      }
      numberKeys = ESKeyboardProvider.genPadNumberKeys(currencyKey: currencyKey)
      symbolKeys = ESKeyboardProvider.genPadSymbolKeys(currencyKeys: currencyKeys)

      letterKeys.removeFirst(1)

      leftKeyChars = ["q", "a", "1", "@", "€"]
      rightKeyChars = []
      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = ESKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = ESKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = ESKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = ESKeyboardConstants.aAlternateKeys
  eAlternateKeys = ESKeyboardConstants.eAlternateKeys
  iAlternateKeys = ESKeyboardConstants.iAlternateKeys
  oAlternateKeys = ESKeyboardConstants.oAlternateKeys
  uAlternateKeys = ESKeyboardConstants.uAlternateKeys
  sAlternateKeys = ESKeyboardConstants.sAlternateKeys
  dAlternateKeys = ESKeyboardConstants.dAlternateKeys
  cAlternateKeys = ESKeyboardConstants.cAlternateKeys

  if userDefaults.bool(forKey: "esAccentCharacters") {
    nAlternateKeys = ESKeyboardConstants.nAlternateKeysDisableAccents
  } else {
    nAlternateKeys = ESKeyboardConstants.nAlternateKeys
  }
}

// MARK: Provide Layout

func setESKeyboardLayout() {
  getESKeys()

  currencySymbol = "$"
  currencySymbolAlternates = dollarAlternateKeys
  spaceBar = "espacio"
  language = "Español"
  invalidCommandMsg = "No en Wikidata"
  baseAutosuggestions = ["el", "la", "no"]
  numericAutosuggestions = ["que", "de", "en"]
  verbsAfterPronounsArray = ["ser", "REFLEXIVE_PRONOUN", "no"]
  pronounAutosuggestionTenses = [
    "yo": "presFPS",
    "tú": "presSPS",
    "él": "presTPS",
    "ella": "presTPS",
    "nosotros": "presFPP",
    "nosotras": "presFPP",
    "vosotros": "presSPP",
    "vosotras": "presSPP",
    "ellos": "presTPP",
    "ellas": "presTPP",
    "ustedes": "presTPP"
  ]

  translateKeyLbl = "Traducir"
  translatePlaceholder = "Ingrese una palabra"
  translatePrompt = commandPromptSpacing + "es -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  conjugateKeyLbl = "Conjugar"
  conjugatePlaceholder = "Ingrese un verbo"
  conjugatePrompt = commandPromptSpacing + "Conjugar: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  pluralKeyLbl = "Plural"
  pluralPlaceholder = "Ingrese un sustantivo"
  pluralPrompt = commandPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))
  alreadyPluralMsg = "Ya en plural"
}
