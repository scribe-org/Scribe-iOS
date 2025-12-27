// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Constants and functions to load the English Scribe keyboard.
 */

import UIKit

// MARK: Constants

public enum ENKeyboardConstants {
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

struct ENKeyboardProvider: KeyboardProviderProtocol {
  // MARK: iPhone Layouts

  static func genPhoneLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l"])
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", "delete"])
      .addRow(["123", "selectKeyboard", "space", "return"])
      .build()
  }

  static func genPhoneNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
      .addRow(["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""])
      .addRow(["#+=", ".", ",", "?", "!", "'", "delete"])
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
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "delete"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "return"])
      .addRow(["shift", "w", "x", "c", "v", "b", "n", "m", ",", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"])
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
      .addRow(["@", "#", "$", "&", "*", "(", ")", "'", "\"", "return"])
      .addRow(["#+=", "%", "_", "+", "=", "/", ";", ":", ",", ".", "#+="])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"])
      .replaceKey(row: 1, column: 2, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
      .addRow(["€", "£", "¥", "_", "^", "[", "]", "{", "}", "return"])
      .addRow(["123", "§", "|", "~", "...", "\\", "<", ">", "!", "?", "123"])
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

  static func genPadExpandedLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["~", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "delete"])
      .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "\\"])
      .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", ":", ";", "'", "return"])
      .addRow(["shift", "-", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"])
      .build()
  }

  static func genPadExpandedSymbolKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
      .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "—", "~", "°"])
      .addRow([SpecialKeys.capsLock, "-", "\\", ":", ";", "(", ")", "&", "@", "$", "£", "¥", "€", "return"])
      .addRow(["shift", "…", "?", "!", "≠", "'", "\"", "|", "_", ".", ",", "/", "shift"])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"])
      .build()
  }
}

// MARK: Generate and set keyboard

// MARK: Get Keys

func getENKeys() {
  guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
    fatalError("Unable to access shared user defaults")
  }

  var currencyKey = ENKeyboardConstants.defaultCurrencyKey
  var currencyKeys = ENKeyboardConstants.currencyKeys
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
    letterKeys = ENKeyboardProvider.genPhoneLetterKeys()
    numberKeys = ENKeyboardProvider.genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = ENKeyboardProvider.genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "1", "-", "[", "_"]
    rightKeyChars = ["p", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      letterKeys = ENKeyboardProvider.genPadExpandedLetterKeys()
      symbolKeys = ENKeyboardProvider.genPadExpandedSymbolKeys()

      leftKeyChars = ["~", "`"]
      rightKeyChars = ["\\", "°"]
      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      letterKeys = ENKeyboardProvider.genPadLetterKeys()
      numberKeys = ENKeyboardProvider.genPadNumberKeys(currencyKey: currencyKey)
      symbolKeys = ENKeyboardProvider.genPadSymbolKeys(currencyKeys: currencyKeys)

      letterKeys.removeFirst(1)

      leftKeyChars = ["q", "1"]
      rightKeyChars = []
      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = ENKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = ENKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = ENKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = ENKeyboardConstants.aAlternateKeys
  eAlternateKeys = ENKeyboardConstants.eAlternateKeys
  iAlternateKeys = ENKeyboardConstants.iAlternateKeys
  oAlternateKeys = ENKeyboardConstants.oAlternateKeys
  uAlternateKeys = ENKeyboardConstants.uAlternateKeys
  sAlternateKeys = ENKeyboardConstants.sAlternateKeys
  lAlternateKeys = ENKeyboardConstants.lAlternateKeys
  zAlternateKeys = ENKeyboardConstants.zAlternateKeys
  cAlternateKeys = ENKeyboardConstants.cAlternateKeys
  nAlternateKeys = ENKeyboardConstants.nAlternateKeys
}

// MARK: Provide Layout

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
  translatePlaceholder = "Enter a word"
  translatePrompt = commandPromptSpacing + "en -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  conjugateKeyLbl = "Conjugate"
  conjugatePlaceholder = "Enter a verb"
  conjugatePrompt = commandPromptSpacing + "Conjugate: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  pluralKeyLbl = "Plural"
  pluralPlaceholder = "Enter a noun"
  pluralPrompt = commandPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))
  alreadyPluralMsg = "Already plural"
}
