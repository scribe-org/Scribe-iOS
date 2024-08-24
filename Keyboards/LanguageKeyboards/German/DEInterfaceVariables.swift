/**
 * Constants and functions to load the German Scribe keyboard.
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

public enum GermanKeyboardConstants {
  static let defaultCurrencyKey = "€"
  static let currencyKeys = ["€", "$", "£", "¥"]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "y", "c", "l", "n", "s", "z"]
  static let keysWithAlternatesLeft = ["a", "e", "y", "c", "s", "z"]
  static let keysWithAlternatesRight = ["i", "o", "u", "l", "n"]

  static let aAlternateKeys = ["à", "á", "â", "æ", "ã", "å", "ā", "ą"]
  static let aAlternateKeysDisableAccents = ["à", "á", "â", "æ", "ã", "å", "ā", "ą", "ä"]
  static let eAlternateKeys = ["é", "è", "ê", "ë", "ė", "ę"]
  static let iAlternateKeys = ["ì", "ī", "í", "î", "ï"]
  static let oAlternateKeys = ["ō", "ø", "œ", "õ", "ó", "ò", "ô"]
  static let oAlternateKeysDisableAccents = ["ō", "ø", "œ", "õ", "ó", "ò", "ô", "ö"]
  static let uAlternateKeys = ["ū", "ú", "ù", "û"]
  static let uAlternateKeysDisableAccents = ["ū", "ú", "ù", "û", "ü"]
  static let yAlternateKeys = ["ÿ"]
  static let cAlternateKeys = ["ç", "ć", "č"]
  static let lAlternateKeys = ["ł"]
  static let nAlternateKeys = ["ń", "ñ"]
  static let sAlternateKeys = ["ß", "ś", "š"]
  static let zAlternateKeys = ["ź", "ż"]
}

struct GermanKeyboardProvider: KeyboardProviderProtocol, KeyboardProviderDisableAccentsProtocol {
  // iPhone keyboard layouts.
  static func genPhoneLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä"])
      .addRow(["shift", "y", "x", "c", "v", "b", "n", "m", "delete"])
      .addRow(["123", "selectKeyboard", "space", "return"]) // "undo"
      .build()
  }

  static func genPhoneDisableAccentsLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["q", "w", "e", "r", "t", "z", "u", "i", "o", "p"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l"])
      .addRow(["shift", "y", "x", "c", "v", "b", "n", "m", "delete"])
      .addRow(["123", "selectKeyboard", "space", "return"]) // "undo"
      .build()
  }

  static func genPhoneNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
      .addRow(["-", "/", ":", ";", "(", ")", "€", "&", "@", "\""])
      .addRow(["#+=", ".", ",", "?", "!", "'", "delete"])
      .addRow(["ABC", "selectKeyboard", "space", "return"]) // "undo"
      .replaceKey(row: 1, column: 6, to: currencyKey)
      .build()
  }

  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["[", "]", "{", "}", "#", "%", "^", "*", "+", "="])
      .addRow(["_", "\\", "|", "~", "<", ">", "$", "£", "¥", "·"])
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

  // iPad keyboard layouts.
  static func genPadLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"])
      .addRow(["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü", "delete"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "return"])
      .addRow(["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "ß", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "undo"
      .build()
  }

  static func genPadDisableAccentsLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"])
      .addRow(["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "delete"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "return"])
      .addRow(["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "ß", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "undo"
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "delete"])
      .addRow(["\"", "§", "€", "%", "&", "/", "(", ")", "=", "'", "#", "return"])
      .addRow(["#+=", "—", "`", "'", "...", "@", ";", ":", ",", ".", "-", "#+="])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "undo"
      .replaceKey(row: 1, column: 2, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"])
      .addRow(["$", "£", "¥", "¿", "―", "\\", "[", "]", "{", "}", "|", "return"])
      .addRow(["123", "¡", "<", ">", "≠", "·", "^", "~", "!", "?", "_", "123"])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "undo"

    if currencyKeys.count < 3 {
      return keyboardBuilder.build()
    } else {
      // Replace currencies
      return keyboardBuilder
        .replaceKey(row: 1, column: 0, to: currencyKeys[0])
        .replaceKey(row: 1, column: 1, to: currencyKeys[1])
        .replaceKey(row: 1, column: 2, to: currencyKeys[2])
        .build()
    }
  }

  // Expanded iPad keyboard layouts for wider devices.
  static func genPadExpandedLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["^", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "ß", "´", "delete"])
      .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü", "+", "*"])
      .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "#", "return"])
      .addRow(["shift", "'", "y", "x", "c", "v", "b", "n", "m", "-", ",", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }

  static func genPadExpandedDisableAccentsLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["^", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "ß", "´", "delete"])
      .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "=", "+", "*"])
      .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "/", "@", "#", "return"])
      .addRow(["shift", "'", "y", "x", "c", "v", "b", "n", "m", "-", ",", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }

  static func genPadExpandedSymbolKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
      .addRow([SpecialKeys.indent, "\"", "|", "§", "[", "]", "{", "}", "—", "%", "^", "=", "+", "*"])
      .addRow([SpecialKeys.capsLock, ":", ";", "(", ")", "&", "$", "£", "¥", "€", "/", "@", "#", "return"]) // "undo"
      .addRow(["shift", "'", "?", "!", "~", "≠", "°", "…", "_", "-", ",", ".", "shift"]) // "redo"
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }
}

/// Gets the keys for the German keyboard.
func getDEKeys() {
  guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
    fatalError()
  }

  var currencyKey = GermanKeyboardConstants.defaultCurrencyKey
  var currencyKeys = GermanKeyboardConstants.currencyKeys
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
    if userDefaults.bool(forKey: "deAccentCharacters") {
      letterKeys = GermanKeyboardProvider.genPhoneDisableAccentsLetterKeys()
    } else {
      letterKeys = GermanKeyboardProvider.genPhoneLetterKeys()
    }
    numberKeys = GermanKeyboardProvider.genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = GermanKeyboardProvider.genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "a", "1", "-", "[", "_"]
    if userDefaults.bool(forKey: "deAccentCharacters") {
      rightKeyChars = ["p", "l", "0", "\"", "=", "·"]
    } else {
      rightKeyChars = ["ü", "ä", "0", "\"", "=", "·"]
    }
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      if userDefaults.bool(forKey: "deAccentCharacters") {
        letterKeys = GermanKeyboardProvider.genPadExpandedDisableAccentsLetterKeys()
      } else {
        letterKeys = GermanKeyboardProvider.genPadExpandedLetterKeys()
      }
      symbolKeys = GermanKeyboardProvider.genPadExpandedSymbolKeys()

      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      if userDefaults.bool(forKey: "deAccentCharacters") {
        letterKeys = GermanKeyboardProvider.genPadDisableAccentsLetterKeys()
      } else {
        letterKeys = GermanKeyboardProvider.genPadLetterKeys()
      }
      numberKeys = GermanKeyboardProvider.genPadNumberKeys(currencyKey: currencyKey)
      symbolKeys = GermanKeyboardProvider.genPadSymbolKeys(currencyKeys: currencyKeys)

      letterKeys.removeFirst(1)

      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    leftKeyChars = ["q", "a", "1", "\"", "$"]
    // TODO: add "ü" to rightKeyChar if the keyboard has 4 rows.
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = GermanKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = GermanKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = GermanKeyboardConstants.keysWithAlternatesRight
  eAlternateKeys = GermanKeyboardConstants.eAlternateKeys
  iAlternateKeys = GermanKeyboardConstants.iAlternateKeys
  yAlternateKeys = GermanKeyboardConstants.yAlternateKeys
  sAlternateKeys = GermanKeyboardConstants.sAlternateKeys
  lAlternateKeys = GermanKeyboardConstants.lAlternateKeys
  zAlternateKeys = GermanKeyboardConstants.zAlternateKeys
  cAlternateKeys = GermanKeyboardConstants.cAlternateKeys
  nAlternateKeys = GermanKeyboardConstants.nAlternateKeys

  if userDefaults.bool(forKey: "deAccentCharacters") {
    aAlternateKeys = GermanKeyboardConstants.aAlternateKeysDisableAccents
    oAlternateKeys = GermanKeyboardConstants.oAlternateKeysDisableAccents
    uAlternateKeys = GermanKeyboardConstants.uAlternateKeysDisableAccents
  } else {
    aAlternateKeys = GermanKeyboardConstants.aAlternateKeys
    oAlternateKeys = GermanKeyboardConstants.oAlternateKeys
    uAlternateKeys = GermanKeyboardConstants.uAlternateKeys
  }
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
    "Sie": "presTPP"
  ]

  translateKeyLbl = "Übersetzen"
  translatePlaceholder = "Wort eingeben"
  translatePrompt = commandPromptSpacing + "de -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  conjugateKeyLbl = "Konjugieren"
  conjugatePlaceholder = "Verb eingeben"
  conjugatePrompt = commandPromptSpacing + "Konjugieren: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  pluralKeyLbl = "Plural"
  pluralPlaceholder = "Nomen eingeben"
  pluralPrompt = commandPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))
  alreadyPluralMsg = "Schon Plural"
}
