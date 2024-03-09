/**
 * Commands and functions to load the Russian Scribe keyboard.
 *
 * Copyright (C) 2023 Scribe
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

public enum RussianKeyboardConstants {
  // iPhone keyboard layouts.
  static let letterKeysPhone = [
    ["й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х"],
    ["ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э"],
    ["shift", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", "delete"],
    ["123", "selectKeyboard", "space", "return"], // "undo"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "₽", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["АБВ", "selectKeyboard", "space", "return"], // "undo"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "$", "€", "£", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["АБВ", "selectKeyboard", "space", "return"], // "undo"
  ]

  // iPad keyboard layouts.
  static let letterKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"],
    ["й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х", "delete"],
    ["ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э", "return"],
    ["shift", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", ".", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "undo"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "—", "delete"],
    ["@", "#", "№", "₽", "ʼ", "&", "*", "(", ")", "'", "\"", "return"],
    ["#+=", "%", "_", "-", "+", "=", "≠", ";", ":", ",", ".", "#+="],
    ["selectKeyboard", "АБВ", "space", "АБВ", "hideKeyboard"], // "undo"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "—", "delete"],
    ["$", "€", "£", "¥", "±", "·", "`", "[", "]", "{", "}", "return"],
    ["123", "§", "|", "~", "...", "^", "\\", "<", ">", "!", "?", "123"],
    ["selectKeyboard", "АБВ", "space", "АБВ", "hideKeyboard"], // "undo"
  ]

  // Expanded iPad keyboard layouts for wider devices.
  static let letterKeysPadExpanded = [
    ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "delete"],
    [SpecialKeys.indent, "й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х", "ъ", "+"],
    [SpecialKeys.capsLock, "ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э", "ё", "return"],
    ["shift", "[", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", "/", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "microphone", "scribble"
  ]

  static let symbolKeysPadExpanded = [
    ["§", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"],
    [SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\\", "|", "₽"],
    [SpecialKeys.capsLock, "-", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "~", "return"], // "undo"
    ["shift", "...", ".", ",", "?", "!", "'", "\"", "_", "€"], // "redo"
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "microphone", "scribble"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["е", "ь"]
  static let keysWithAlternatesLeft = ["е"]
  static let keysWithAlternatesRight = ["ь"]

  static let еAlternateKeys = ["ë"]
  static let ьAlternateKeys = ["Ъ"]
}

/// Gets the keys for the Russian keyboard.
func getRUKeys() {
  if DeviceType.isPhone {
    letterKeys = RussianKeyboardConstants.letterKeysPhone
    numberKeys = RussianKeyboardConstants.numberKeysPhone
    symbolKeys = RussianKeyboardConstants.symbolKeysPhone
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["й", "ф", "1", "-", "[", "_"]
    rightKeyChars = ["х", "э", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      letterKeys = RussianKeyboardConstants.letterKeysPadExpanded
      letterKeys = RussianKeyboardConstants.symbolKeysPadExpanded

      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      letterKeys = RussianKeyboardConstants.letterKeysPad
      numberKeys = RussianKeyboardConstants.numberKeysPad
      symbolKeys = RussianKeyboardConstants.symbolKeysPad

      letterKeys.removeFirst(1)

      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    leftKeyChars = ["й", "ф", "1", "@", "$"]
    // TODO: add "х" to rightKeyChar if the keyboard has 4 rows
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = RussianKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = RussianKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = RussianKeyboardConstants.keysWithAlternatesRight
  еAlternateKeys = RussianKeyboardConstants.еAlternateKeys
  ьAlternateKeys = RussianKeyboardConstants.ьAlternateKeys
}

/// Provides the Russian keyboard layout.
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
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  conjugateKeyLbl = "Спрягать"
  conjugatePlaceholder = "Введите глагол"
  conjugatePrompt = commandPromptSpacing + "Спрягать: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  pluralKeyLbl = "Множ-ое"
  pluralPlaceholder = "Введите существительное"
  pluralPrompt = commandPromptSpacing + "Множ-ое: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))
  alreadyPluralMsg = "Уже во множ-ом"
}
