// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Constants and functions to load the AZERTY French Scribe keyboard.
 */

import UIKit

// MARK: Constants

public enum FRKeyboardConstants {
  static let defaultCurrencyKey = "€"
  static let currencyKeys = ["€", "$", "£", "¥"]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "y", "c", "n"]
  static let keysWithAlternatesLeft = ["a", "e", "y", "c"]
  static let keysWithAlternatesRight = ["i", "o", "u", "n"]

  static let aAlternateKeys = ["à", "â", "æ", "á", "ä", "ã", "å", "ā", "ᵃ"]
  static let eAlternateKeys = ["é", "è", "ê", "ë", "ę", "ė", "ē"]
  static let iAlternateKeys = ["ī", "į", "í", "ì", "ï", "î"]
  static let oAlternateKeys = ["ᵒ", "ō", "ø", "õ", "ó", "ò", "ö", "œ", "ô"]
  static let uAlternateKeys = ["ū", "ú", "ü", "ù", "û"]
  static let yAlternateKeys = ["ÿ"]
  static let cAlternateKeys = ["ç", "ć", "č"]
  static let nAlternateKeys = ["ń", "ñ"]
}

struct FRKeyboardProvider: KeyboardProviderProtocol {
  // MARK: iPhone Layouts

  static func genPhoneLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["a", "z", "e", "r", "t", "y", "u", "i", "o", "p"])
      .addRow(["q", "s", "d", "f", "g", "h", "j", "k", "l", "m"])
      .addRow(["shift", "w", "x", "c", "v", "b", "n", "´", "delete"])
      .addRow(["123", "selectKeyboard", "space", "return"])
      .build()
  }

  static func genPhoneNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
      .addRow(["-", "/", ":", ";", "(", ")", "€", "&", "@", "\""])
      .addRow(["#+=", ".", ",", "?", "!", "'", "delete"])
      .addRow(["ABC", "selectKeyboard", "space", "return"])
      .replaceKey(row: 1, column: 6, to: currencyKey)
      .build()
  }

  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["[", "]", "{", "}", "#", "%", "^", "*", "+", "="])
      .addRow(["_", "\\", "|", "~", "<", ">", "$", "£", "¥", "·"])
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
      .addRow(["a", "z", "e", "r", "t", "y", "u", "i", "o", "p", "delete"])
      .addRow(["q", "s", "d", "f", "g", "h", "j", "k", "l", "m", "return"])
      .addRow(["shift", "w", "x", "c", "v", "b", "n", "´", ",", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"])
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
      .addRow(["@", "#", "&", "\"", "€", "(", "!", ")", "-", "*", "return"])
      .addRow(["#+=", "%", "_", "+", "=", "/", ";", ":", ",", ".", "#+="])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"])
      .replaceKey(row: 1, column: 4, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
      .addRow(["~", "ᵒ", "[", "]", "{", "}", "^", "$", "£", "¥", "return"])
      .addRow(["123", "§", "<", ">", "|", "\\", "...", "·", "?", "'", "123"])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"])

    if currencyKeys.count < 3 {
      return keyboardBuilder.build()
    } else {
      return keyboardBuilder
        .replaceKey(row: 1, column: 7, to: currencyKeys[0])
        .replaceKey(row: 1, column: 8, to: currencyKeys[1])
        .replaceKey(row: 1, column: 9, to: currencyKeys[2])
        .build()
    }
  }

  // MARK: Expanded iPad Layouts

  static func genPadExpandedLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["@", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "ç", "à", "delete"])
      .addRow([SpecialKeys.indent, "a", "z", "e", "r", "t", "y", "u", "i", "o", "p", "^", "+", "*"])
      .addRow([SpecialKeys.capsLock, "q", "s", "d", "f", "g", "h", "j", "k", "l", "m", "ù", "#", "return"])
      .addRow(["shift", "/", "w", "x", "c", "v", "b", "n", ":", "-", ",", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"])
      .build()
  }

  static func genPadExpandedSymbolKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
      .addRow([SpecialKeys.indent, "\"", "|", "§", "[", "]", "{", "}", "-", "%", "=", "^", "+", "*"])
      .addRow([SpecialKeys.capsLock, "/", "…", "_", "(", ")", "&", "$", "£", "¥", "€", "@", "#", "return"])
      .addRow(["shift", "'", "?", "!", "~", "≠", "°", ";", ":", "-", ",", ".", "shift"])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"])
      .build()
  }
}

// MARK: Get Keys

func getFRKeys() {
  guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
    fatalError("Unable to access shared user defaults")
  }

  var currencyKey = FRKeyboardConstants.defaultCurrencyKey
  var currencyKeys = FRKeyboardConstants.currencyKeys
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
    letterKeys = FRKeyboardProvider.genPhoneLetterKeys()
    numberKeys = FRKeyboardProvider.genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = FRKeyboardProvider.genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["a", "q", "1", "-", "[", "_"]
    rightKeyChars = ["p", "m", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      letterKeys = FRKeyboardProvider.genPadExpandedLetterKeys()
      symbolKeys = FRKeyboardProvider.genPadExpandedSymbolKeys()

      leftKeyChars = ["@", "`"]
      rightKeyChars = ["*"]
      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      letterKeys = FRKeyboardProvider.genPadLetterKeys()
      numberKeys = FRKeyboardProvider.genPadNumberKeys(currencyKey: currencyKey)
      symbolKeys = FRKeyboardProvider.genPadSymbolKeys(currencyKeys: currencyKeys)

      letterKeys.removeFirst(1)

      leftKeyChars = ["q", "a", "1", "@", "~"]
      rightKeyChars = []
      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = FRKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = FRKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = FRKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = FRKeyboardConstants.aAlternateKeys
  eAlternateKeys = FRKeyboardConstants.eAlternateKeys
  iAlternateKeys = FRKeyboardConstants.iAlternateKeys
  oAlternateKeys = FRKeyboardConstants.oAlternateKeys
  uAlternateKeys = FRKeyboardConstants.uAlternateKeys
  yAlternateKeys = FRKeyboardConstants.yAlternateKeys
  cAlternateKeys = FRKeyboardConstants.cAlternateKeys
  nAlternateKeys = FRKeyboardConstants.nAlternateKeys
}

// MARK: Provide Layout

func setFRKeyboardLayout() {
  getFRKeys()

  currencySymbol = "€"
  currencySymbolAlternates = euroAlternateKeys
  spaceBar = "espace"
  language = "Français"
  invalidCommandMsg = "Pas dans Wikidata"
  baseAutosuggestions = ["je", "il", "le"]
  numericAutosuggestions = ["je", "que", "c’est"]
  verbsAfterPronounsArray = ["être", "avoir", "ne"]
  pronounAutosuggestionTenses = [
    "je": "presFPS",
    "tu": "presSPS",
    "il": "presTPS",
    "elle": "presTPS",
    "on": "presTPS",
    "nous": "presFPP",
    "vous": "presSPP",
    "ils": "presTPP",
    "elles": "presTPP"
  ]

  translateKeyLbl = "Traduire"
  translatePlaceholder = "Entrez un mot"
  translatePrompt = commandPromptSpacing + "fr -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  conjugateKeyLbl = "Conjuguer"
  conjugatePlaceholder = "Entrez un verbe"
  conjugatePrompt = commandPromptSpacing + "Conjuguer: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  pluralKeyLbl = "Pluriel"
  pluralPlaceholder = "Entrez un nom"
  pluralPrompt = commandPromptSpacing + "Pluriel: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))
  alreadyPluralMsg = "Déjà pluriel"
}
