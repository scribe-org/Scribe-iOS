//
//  RUInterfaceVariables.swift
//
//  Constants and functions to load the Russian Scribe keyboard.
//

import UIKit

public enum RussianKeyboardConstants {

  // Keyboard key layouts.
  static let letterKeysPhone = [
    ["й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х"],
    ["ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э"],
    ["shift", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", "delete"],
    ["123", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "₽", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["АБВ", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "$", "€", "£", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["АБВ", "selectKeyboard", "space", "return"] // "undoArrow"
  ]

  static let letterKeysPad = [
    ["й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х", "delete"],
    ["ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э", "return"],
    ["shift", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", ".", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"] // "undoArrow"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "—", "delete"],
    ["@", "#", "№", "₽", "ʼ", "&", "*", "(", ")", "'", "\"", "return"],
    ["#+=", "%", "_", "-", "+", "=", "≠", ";", ":", ",", ".", "#+="],
    ["selectKeyboard", "АБВ", "space", "АБВ", "hideKeyboard"] // "undoArrow"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "—", "delete"],
    ["$", "€", "£", "¥", "±", "·", "`", "[", "]", "{", "}", "return"],
    ["123", "§", "|", "~", "...", "^", "\\", "<", ">", "!", "?", "123"],
    ["selectKeyboard", "АБВ", "space", "АБВ", "hideKeyboard"] // "undoArrow"
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
    allKeys = Array(letterKeys.joined())  + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["й", "ф", "1", "-", "[", "_"]
    rightKeyChars = ["х", "э", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    letterKeys = RussianKeyboardConstants.letterKeysPad
    numberKeys = RussianKeyboardConstants.numberKeysPad
    symbolKeys = RussianKeyboardConstants.symbolKeysPad
    allKeys = Array(letterKeys.joined())  + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["й", "ф", "1", "@", "$"]
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = RussianKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = RussianKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = RussianKeyboardConstants.keysWithAlternatesRight
  еAlternateKeys = RussianKeyboardConstants.еAlternateKeys
  ьAlternateKeys = RussianKeyboardConstants.ьAlternateKeys
}

/// Provides a Russian keyboard layout.
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
