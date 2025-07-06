// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Constants and functions to load the Hebrew Scribe keyboard.
 */

import UIKit

// MARK: Constants

public enum HEKeyboardConstants {
  static let defaultCurrencyKey = "₪"
  static let currencyKeys = ["₪", "€", "£", "$"]
}

struct HEKeyboardProvider: KeyboardProviderProtocol {
  // MARK: iPhone Layouts

  static func genPhoneLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "delete"])
      .addRow(["ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש"])
      .addRow(["ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז"])
      .addRow(["123", "selectKeyboard", "space", "return"])
      .build()
  }

  static func genPhoneNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
      .addRow(["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""])
      .addRow(["#+=", ".", ",", "?", "!", "'", "delete"])
      .addRow(["אבג", "selectKeyboard", "space", "return"])
      .replaceKey(row: 1, column: 6, to: currencyKey)
      .build()
  }

  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["[", "]", "{", "}", "#", "%", "^", "*", "+", "="])
      .addRow(["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"])
      .addRow(["123", ".", ",", "?", "!", "'", "delete"])
      .addRow(["אבג", "selectKeyboard", "space", "return"])

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
      .addRow([",", ".", "פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "delete"])
      .addRow(["ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש"])
      .addRow(["ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז", "return"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"])
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
      .addRow(["!", "@", "#", "&", "_", "-", "'", "\"", "(", ")", "return"])
      .addRow(["#+=", "%", "...", "&", ";", ":", "=", "+", "/", "?", "#+="])
      .addRow(["selectKeyboard", "אבג", "space", "אבג", "hideKeyboard"])
      // .replaceKey(row: 1, column: 4, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"])
      .addRow(["^", "€", "$", "£", "[", "]", "'", "\"", "<", ">", "return"])
      .addRow(["123", "§", "|", "~", "*", "·", "{", "}", "\\", "~", "123"])
      .addRow(["selectKeyboard", "אבג", "space", "אבג", "hideKeyboard"])

    if currencyKeys.count < 3 {
      return keyboardBuilder.build()
    } else {
      return keyboardBuilder
        .replaceKey(row: 1, column: 1, to: currencyKeys[0])
        .replaceKey(row: 1, column: 2, to: currencyKeys[1])
        .replaceKey(row: 1, column: 3, to: currencyKeys[2])
        .build()
    }
  }

  // MARK: Expanded iPad Layouts

  static func genPadExpandedLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["§", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "delete"])
      .addRow([SpecialKeys.indent, "/", "'", "פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "[", "]", "+"])
      .addRow([SpecialKeys.capsLock, "ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש", ",", "\"", "return"])
      .addRow(["⇧", ";", "ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז", ".", "⇧"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"])
      .build()
  }

  static func genPadExpandedSymbolKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
      .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|", "—"])
      .addRow([SpecialKeys.capsLock, "°", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "€", "return"])
      .addRow(["⇧", "…", "?", "!", "~", "≠", "'", "\"", "_", ",", ".", "-", "⇧"])
      .addRow(["selectKeyboard", "אבג", "space", "אבג", "hideKeyboard"])
      .build()
  }
}

// MARK: Get Keys

func getHEKeys() {
  guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
    fatalError("Unable to access shared user defaults")
  }

  var currencyKey = HEKeyboardConstants.defaultCurrencyKey
  var currencyKeys = HEKeyboardConstants.currencyKeys
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
    letterKeys = HEKeyboardProvider.genPhoneLetterKeys()
    numberKeys = HEKeyboardProvider.genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = HEKeyboardProvider.genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["ק", "1", "-", "[", "_"]
    rightKeyChars = ["פ", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      letterKeys = HEKeyboardProvider.genPadExpandedLetterKeys()
      symbolKeys = HEKeyboardProvider.genPadExpandedSymbolKeys()

      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      letterKeys = HEKeyboardProvider.genPadLetterKeys()
      numberKeys = HEKeyboardProvider.genPadNumberKeys(currencyKey: currencyKey)
      symbolKeys = HEKeyboardProvider.genPadSymbolKeys(currencyKeys: currencyKeys)

      letterKeys.removeFirst(1)

      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    leftKeyChars = ["1", "ק"]
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }
}

// MARK: Provide Layout

func setHEKeyboardLayout() {
  getHEKeys()

  currencySymbol = ""
  currencySymbolAlternates = roubleAlternateKeys
  spaceBar = "רווח"
  language = "עברית"
  invalidCommandMsg = "אין מידע"
  baseAutosuggestions = ["אתמ", "אני", "היי"]
  numericAutosuggestions = ["", "", ""]

  translateKeyLbl = "לְתַרְגֵם"
  translatePlaceholder = "לְתַרְגֵם"
  translatePrompt = commandPromptSpacing + "he -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  conjugateKeyLbl = "לְהַטוֹת"
  conjugatePlaceholder = "לְהַטוֹת"
  conjugatePrompt = commandPromptSpacing + " :נְטִיָה"
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  pluralKeyLbl = "רַבִּים"
  pluralPlaceholder = "רַבִּים"
  pluralPrompt = commandPromptSpacing + " :רַבִּים"
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))
  alreadyPluralMsg = "כבר בצורת רבים"
}
