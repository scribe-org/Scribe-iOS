// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Constants and functions to load the Danish Scribe keyboard.
 */

import UIKit

// MARK: Constants

public enum DAKeyboardConstants {
  static let defaultCurrencyKey = "kr"
  static let currencyKeys = ["kr", "€", "$", "£", "¥"]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "y", "æ", "ø", "d", "l", "n", "s"]
  static let keysWithAlternatesLeft = ["a", "e", "y", "d", "s"]
  static let keysWithAlternatesRight = ["i", "o", "u", "æ", "ø", "l", "n"]

  static let aAlternateKeys = ["á", "ä", "à", "â", "ã", "ā"]
  static let eAlternateKeys = ["é", "ë"]
  static let iAlternateKeys = ["ï", "í"]
  static let oAlternateKeys = ["ö", "ō", "œ", "õ", "ø", "ò", "ô", "ó"]
  static let uAlternateKeys = ["ū", "ù", "û", "ü", "ú"]
  static let yAlternateKeys = ["ÿ"]
  static let æAlternateKeys = ["ä"]
  static let øAlternateKeys = ["ö"]
  static let dAlternateKeys = ["ð"]
  static let lAlternateKeys = ["ł"]
  static let nAlternateKeys = ["ń", "ñ"]
  static let sAlternateKeys = ["ß", "ś", "š"]
}

struct DAKeyboardProvider: KeyboardProviderProtocol {
  // MARK: iPhone Layouts

  static func genPhoneLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "æ", "ø"])
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", "delete"])
      .addRow(["123", "selectKeyboard", "space", "return"])
      .build()
  }

  static func genPhoneNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
      .addRow(["-", "/", ":", ";", "(", ")", "kr", "&", "@", "\""])
      .addRow( ["#+=", ".", ",", "?", "!", "'", "delete"])
      .addRow(["ABC", "selectKeyboard", "space", "return"])
      .replaceKey(row: 1, column: 6, to: currencyKey)
      .build()
  }

  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["[", "]", "{", "}", "#", "%", "^", "*", "+", "="])
      .addRow(["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"])
      .addRow(["123", ".", ",", "?", "!", "'", "delete"])
      .addRow(["ABC", "selectKeyboard", "space", "return"])

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
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "æ", "ø", "delete"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "return"])
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"])
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "`", "delete"])
      .addRow(["@", "#", "kr", "&", "*", "(", ")", "'", "\"", "+", "·", "return"])
      .addRow(["#+=", "%", "_", "-", "=", "/", ";", ":", ",", ".", "?", "#+="])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"])
      .replaceKey(row: 1, column: 2, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "'", "delete"])
      .addRow(["€", "$", "£", "^", "[", "]", "{", "}", "―", "ᵒ", "...", "return"])
      .addRow(["123", "§", "|", "~", "≠", "≈", "\\", "<", ">", "!", "?", "123"])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"])

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
      .addRow(["kr", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "´", "delete"])
      .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å", "@", "¨"])
      .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "æ", "ø", "'", "return"])
      .addRow(["shift", "*", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"])
      .build()
  }

  static func genPadExpandedSymbolKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
      .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|", "—"])
      .addRow([SpecialKeys.capsLock, "°", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "~", "return"])
      .addRow(["shift", "…", "?", "!", "≠", "'", "\"", "_", "€", ",", ".", "-", "shift"])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"])
      .build()
  }
}

// MARK: Get Keys

func getDAKeys() {}

// MARK: Provide Layout

func setDAKeyboardLayout() {}
