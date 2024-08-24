/**
 * Constants and functions to load the Italian Scribe keyboard.
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

public enum ItalianKeyboardConstants {
  static let defaultCurrencyKey = "€"
  static let currencyKeys = ["€", "$", "£", "¥"]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "c", "n", "s"]
  static let keysWithAlternatesLeft = ["a", "e", "s", "c"]
  static let keysWithAlternatesRight = ["i", "o", "u", "n"]

  static let aAlternateKeys = ["à", "á", "ä", "â", "æ", "ã", "å", "ā", "ᵃ"]
  static let eAlternateKeys = ["é", "è", "ə", "ê", "ë", "ę", "ė", "ē"]
  static let iAlternateKeys = ["ī", "į", "ï", "î", "í", "ì"]
  static let oAlternateKeys = ["ᵒ", "ō", "ø", "œ", "õ", "ö", "ô", "ó", "ò"]
  static let uAlternateKeys = ["ū", "ü", "û", "ú", "ù"]
  static let cAlternateKeys = ["ç", "ć", "č"]
  static let nAlternateKeys = ["ñ"]
  static let sAlternateKeys = ["ß", "ś", "š"]
}

struct ItalianKeyboardProvider: KeyboardProviderProtocol {
  // iPhone keyboard layouts.
  static func genPhoneLetterKeys() -> [[String]] {
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
      .addRow(["-", "/", ":", ";", "(", ")", "€", "&", "@", "\""])
      .addRow(["#+=", ".", ",", "?", "!", "'", "delete"])
      .addRow(["ABC", "selectKeyboard", "space", "return"]) // "undo"
      .replaceKey(row: 1, column: 6, to: currencyKey)
      .build()
  }

  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder =  KeyboardBuilder()
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
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "delete"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "return"])
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "undo"
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
      .addRow(["@", "#", "€", "&", "*", "(", ")", "'", "\"", "return"])
      .addRow(["#+=", "%", "-", "+", "=", "/", ";", ":", ",", ".", "#+="])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "undo"
      .replaceKey(row: 1, column: 2, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
      .addRow(["$", "£", "¥", "_", "^", "[", "]", "{", "}", "return"])
      .addRow(["123", "§", "|", "~", "...", "\\", "<", ">", "!", "?", "123"])
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
      .addRow(["\\", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "‘", "ì", "delete"])
      .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "è", "+", "*"])
      .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "ò", "à", "ù", "return"])
      .addRow(["shift", "'", "z", "x", "c", "v", "b", "n", "m", "-", ",", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }

  static func genPadExpandedSymbolKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
      .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|", "§"])
      .addRow([SpecialKeys.capsLock, "°", "/", ":", ";", "(", ")", "&", "@", "$", "£", "¥", "~", "return"]) // "undo"
      .addRow(["shift", "…", "?", "!", "≠", "'", "\"", "_", "€", "-", ",", ".", "shift"]) // "shift"
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }
}

/// Gets the keys for the Italian keyboard.
func getITKeys() {
  guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
    fatalError()
  }

  var currencyKey = ItalianKeyboardConstants.defaultCurrencyKey
  var currencyKeys = ItalianKeyboardConstants.currencyKeys
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
    letterKeys = ItalianKeyboardProvider.genPhoneLetterKeys()
    numberKeys = ItalianKeyboardProvider.genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = ItalianKeyboardProvider.genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "1", "-", "[", "_"]
    rightKeyChars = ["p", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      letterKeys = ItalianKeyboardProvider.genPadExpandedLetterKeys()
      symbolKeys = ItalianKeyboardProvider.genPadExpandedSymbolKeys()

      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      letterKeys = ItalianKeyboardProvider.genPadLetterKeys()
      numberKeys = ItalianKeyboardProvider.genPadNumberKeys(currencyKey: currencyKey)
      symbolKeys = ItalianKeyboardProvider.genPadSymbolKeys(currencyKeys: currencyKeys)

      letterKeys.removeFirst(1)

      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    leftKeyChars = ["q", "1"]
    // TODO: add "p" to rightKeyChar if the keyboard has 4 rows.
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = ItalianKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = ItalianKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = ItalianKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = ItalianKeyboardConstants.aAlternateKeys
  eAlternateKeys = ItalianKeyboardConstants.eAlternateKeys
  iAlternateKeys = ItalianKeyboardConstants.iAlternateKeys
  oAlternateKeys = ItalianKeyboardConstants.oAlternateKeys
  uAlternateKeys = ItalianKeyboardConstants.uAlternateKeys
  sAlternateKeys = ItalianKeyboardConstants.sAlternateKeys
  cAlternateKeys = ItalianKeyboardConstants.cAlternateKeys
  nAlternateKeys = ItalianKeyboardConstants.nAlternateKeys
}

/// Provides the Italian keyboard layout.
func setITKeyboardLayout() {
  getITKeys()

  currencySymbol = "€"
  currencySymbolAlternates = euroAlternateKeys
  spaceBar = "spazio"
  language = "Italiano"
  invalidCommandMsg = "Non in Wikidata"
  baseAutosuggestions = ["ho", "non", "ma"]
  numericAutosuggestions = ["utenti", "anni", "e"]

  translateKeyLbl = "Tradurre"
  translatePlaceholder = "Inserisci una parola"
  translatePrompt = commandPromptSpacing + "it -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  conjugateKeyLbl = "Coniugare"
  conjugatePlaceholder = "Inserisci un verbo"
  conjugatePrompt = commandPromptSpacing + "Coniugare: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  pluralKeyLbl = "Plurale"
  pluralPlaceholder = "Inserisci un nome"
  pluralPrompt = commandPromptSpacing + "Plurale: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))
  alreadyPluralMsg = "Già plurale"
}
