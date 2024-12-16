/**
 * Commands and functions to load the Russian Scribe keyboard.
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

public enum ruKeyboardConstants {
  static let defaultCurrencyKey = "₽"
  static let currencyKeys = ["₽", "$", "€", "£"]

  // Alternate key vars.
  static let keysWithAlternates = ["е", "ь"]
  static let keysWithAlternatesLeft = ["е"]
  static let keysWithAlternatesRight = ["ь"]

  static let еAlternateKeys = ["ë"]
  static let ьAlternateKeys = ["Ъ"]
}

struct ruKeyboardProvider: KeyboardProviderProtocol {
  // MARK: iPhone Layouts

  static func genPhoneLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х"])
      .addRow(["ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э"])
      .addRow(["shift", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", "delete"])
      .addRow(["123", "selectKeyboard", "space", "return"]) // "undo"
      .build()
  }

  static func genPhoneNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
      .addRow(["-", "/", ":", ";", "(", ")", "₽", "&", "@", "\""])
      .addRow(["#+=", ".", ",", "?", "!", "'", "delete"])
      .addRow(["АБВ", "selectKeyboard", "space", "return"]) // "undo"
      .replaceKey(row: 1, column: 6, to: currencyKey)
      .build()
  }

  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder =  KeyboardBuilder()
      .addRow(["[", "]", "{", "}", "#", "%", "^", "*", "+", "="])
      .addRow(["_", "\\", "|", "~", "<", ">", "$", "€", "£", "·"])
      .addRow(["123", ".", ",", "?", "!", "'", "delete"])
      .addRow(["АБВ", "selectKeyboard", "space", "return"]) // "undo"

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
      .addRow(["й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х", "delete"])
      .addRow(["ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э", "return"])
      .addRow(["shift", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "undo"
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "—", "delete"])
      .addRow(["@", "#", "№", "₽", "ʼ", "&", "*", "(", ")", "'", "\"", "return"])
      .addRow(["#+=", "%", "_", "-", "+", "=", "≠", ";", ":", ",", ".", "#+="])
      .addRow(["selectKeyboard", "АБВ", "space", "АБВ", "hideKeyboard"]) // "undo"
      .replaceKey(row: 1, column: 3, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "—", "delete"])
      .addRow(["$", "€", "£", "¥", "±", "·", "`", "[", "]", "{", "}", "return"])
      .addRow(["123", "§", "|", "~", "...", "^", "\\", "<", ">", "!", "?", "123"])
      .addRow(["selectKeyboard", "АБВ", "space", "АБВ", "hideKeyboard"]) // "undo"

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
      .addRow(["§", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "delete"])
      .addRow([SpecialKeys.indent, "й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х", "ъ", "+"])
      .addRow([SpecialKeys.capsLock, "ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э", "ё", "return"])
      .addRow(["shift", "'", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", "/", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }

  static func genPadExpandedSymbolKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
      .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\\", "|", "₽"])
      .addRow([SpecialKeys.capsLock, "—", "/", ":", ";", "(", ")", "&", "@", "$", "£", "¥", "~", "return"]) // "undo"
      .addRow(["shift", "…", "?", "!", "≠", "'", "\"", "_", "€", "-", ",", ".", "shift"]) // "redo"
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }
}

// MARK: Get Keys

func getRUKeys() {
  guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
    fatalError()
  }

  var currencyKey = ruKeyboardConstants.defaultCurrencyKey
  var currencyKeys = ruKeyboardConstants.currencyKeys
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
    letterKeys = ruKeyboardProvider.genPhoneLetterKeys()
    numberKeys = ruKeyboardProvider.genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = ruKeyboardProvider.genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["й", "ф", "1", "-", "[", "_"]
    rightKeyChars = ["х", "э", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      letterKeys = ruKeyboardProvider.genPadExpandedLetterKeys()
      symbolKeys = ruKeyboardProvider.genPadExpandedSymbolKeys()

      leftKeyChars = ["§", "`"]
      rightKeyChars = ["+", "₽"]
      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      letterKeys = ruKeyboardProvider.genPadLetterKeys()
      numberKeys = ruKeyboardProvider.genPadNumberKeys(currencyKey: currencyKey)
      symbolKeys = ruKeyboardProvider.genPadSymbolKeys(currencyKeys: currencyKeys)

      letterKeys.removeFirst(1)

      leftKeyChars = ["й", "ф", "1", "@", "$"]
      rightKeyChars = []
      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = ruKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = ruKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = ruKeyboardConstants.keysWithAlternatesRight
  еAlternateKeys = ruKeyboardConstants.еAlternateKeys
  ьAlternateKeys = ruKeyboardConstants.ьAlternateKeys
}

// MARK: Provide Layout

func setRUKeyboardLayout() {
  getRUKeys()

  currencySymbol = "₽"
  currencySymbolAlternates = roubleAlternateKeys
  spaceBar = "Пробел"
  language = "Pусский"
  invalidCommandMsg = "Нет в Викиданных"
  baseAutosuggestions = ["я", "а", "в"]
  numericAutosuggestions = ["в", "и", "я"]

  translateKeyLbl = "Перевести"
  translatePlaceholder = "Введите слово"
  translatePrompt = commandPromptSpacing + "ru -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  conjugateKeyLbl = "Спрягать"
  conjugatePlaceholder = "Введите глагол"
  conjugatePrompt = commandPromptSpacing + "Спрягать: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  pluralKeyLbl = "Множ-ое"
  pluralPlaceholder = "Введите существительное"
  pluralPrompt = commandPromptSpacing + "Множ-ое: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))
  alreadyPluralMsg = "Уже во множ-ом"
}
