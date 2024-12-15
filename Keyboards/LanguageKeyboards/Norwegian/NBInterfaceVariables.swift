/**
 * Constants and functions to load the Norwegian Bokmål Scribe keyboard.
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

// MARK: Constants

public enum NorwegianBokmålKeyboardConstants {
  static let defaultCurrencyKey = "kr"
  static let currencyKeys = ["kr", "€", "$", "£", "¥"]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "o", "u", "ä", "ö"]
  static let keysWithAlternatesLeft = ["a", "e"]
  static let keysWithAlternatesRight = ["o", "u", "æ", "ø"]

  static let aAlternateKeys = ["à", "ä", "á", "â", "ã", "ā"]
  static let eAlternateKeys = ["ë", "è", "é", "ê", "ę", "ė", "ē"]
  static let oAlternateKeys = ["ō", "œ", "õ", "ó", "ò", "ô"]
  static let uAlternateKeys = ["ū", "ú", "ù", "û", "ü"]
  static let æAlternateKeys = ["ä"]
  static let øAlternateKeys = ["ö"]
}

struct NorwegianBokmålKeyboardProvider: KeyboardProviderProtocol {
  // MARK: iPhone Layouts

  static func genPhoneLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "ø", "æ"])
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", "delete"])
      .addRow(["123", "selectKeyboard", "space", "return"]) // "undo"
      .build()
  }

  static func genPhoneNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
      .addRow(["-", "/", ":", ";", "(", ")", "kr", "&", "@", "\""])
      .addRow(["#+=", ".", ",", "?", "!", "'", "delete"])
      .addRow(["ABC", "selectKeyboard", "space", "return"]) // "undo"
      .replaceKey(row: 1, column: 6, to: currencyKey)
      .build()
  }

  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["[", "]", "{", "}", "#", "%", "^", "*", "+", "="])
      .addRow(["_", "\\", "|", "~", "<", ">", "€", "$", "£", "·"])
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
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å", "delete"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "ø", "æ", "return"])
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "?", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "undo"
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "`", "delete"])
      .addRow(["@", "#", "kr", "&", "*", "(", ")", "'", "\"", "+", "·", "return"])
      .addRow(["#+=", "%", "_", "-", "=", "/", ";", ":", ",", ".", "≈", "#+="])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "undo"
      .replaceKey(row: 1, column: 2, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"])
      .addRow(["€", "$", "£", "^", "[", "]", "{", "}", "―", "ᵒ", "...", "return"])
      .addRow(["123", "§", "±", "|", "~", "≠", "\\", "<", ">", "!", "?", "123"])
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
      .addRow(["§", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "´", "delete"])
      .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å", "^", "*"])
      .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "ø", "æ", "@", "return"])
      .addRow(["shift", "'", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }

  static func genPadExpandedSymbolKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
      .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|", "°"])
      .addRow([SpecialKeys.capsLock, "—", "/", ":", ";", "(", ")", "&", "@", "$", "£", "¥", "~", "return"]) // "undo"
      .addRow(["shift", "…", "?", "!", "≠", "'", "\"", "_", "€", ",", ".", "-", "shift"]) // "redo"
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }
}

// MARK: Get Keys

func getNBKeys() {}

// MARK: Provide Layout

func setNBKeyboardLayout() {}
