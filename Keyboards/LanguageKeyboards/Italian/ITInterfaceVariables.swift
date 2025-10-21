// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Constants and functions to load the Italian Scribe keyboard.
 */

import UIKit

// MARK: Constants

public enum ITKeyboardConstants {
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

struct ITKeyboardProvider: KeyboardProviderProtocol {
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
      .addRow(["-", "/", ":", ";", "(", ")", "€", "&", "@", "\""])
      .addRow(["#+=", ".", ",", "?", "!", "'", "delete"])
      .addRow(["ABC", "selectKeyboard", "space", "return"])
      .replaceKey(row: 1, column: 6, to: currencyKey)
      .build()
  }

  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder =  KeyboardBuilder()
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
      .addRow(["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "delete"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "return"])
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"])
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
      .addRow(["@", "#", "€", "&", "*", "(", ")", "'", "\"", "return"])
      .addRow(["#+=", "%", "-", "+", "=", "/", ";", ":", ",", ".", "#+="])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"])
      .replaceKey(row: 1, column: 2, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
      .addRow(["$", "£", "¥", "_", "^", "[", "]", "{", "}", "return"])
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

 // MARK: Expanded iPad Layouts

  static func genPadExpandedLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["\\", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "‘", "ì", "delete"])
      .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "è", "+", "*"])
      .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "ò", "à", "ù", "return"])
      .addRow(["shift", "'", "z", "x", "c", "v", "b", "n", "m", "-", ",", ".", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"])
      .build()
  }

  static func genPadExpandedSymbolKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
      .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|", "§"])
      .addRow([SpecialKeys.capsLock, "°", "/", ":", ";", "(", ")", "&", "@", "$", "£", "¥", "~", "return"])
      .addRow(["shift", "…", "?", "!", "≠", "'", "\"", "_", "€", "-", ",", ".", "shift"]) // "shift"
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"])
      .build()
  }
}

// MARK: Get Keys

func getITKeys() {
  guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
    fatalError("Unable to access shared user defaults")
  }

  var currencyKey = ITKeyboardConstants.defaultCurrencyKey
  var currencyKeys = ITKeyboardConstants.currencyKeys
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
    letterKeys = ITKeyboardProvider.genPhoneLetterKeys()
    numberKeys = ITKeyboardProvider.genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = ITKeyboardProvider.genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "1", "-", "[", "_"]
    rightKeyChars = ["p", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      letterKeys = ITKeyboardProvider.genPadExpandedLetterKeys()
      symbolKeys = ITKeyboardProvider.genPadExpandedSymbolKeys()

      leftKeyChars = ["\\", "`"]
      rightKeyChars = ["*", "§"]
      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      letterKeys = ITKeyboardProvider.genPadLetterKeys()
      numberKeys = ITKeyboardProvider.genPadNumberKeys(currencyKey: currencyKey)
      symbolKeys = ITKeyboardProvider.genPadSymbolKeys(currencyKeys: currencyKeys)

      letterKeys.removeFirst(1)

      leftKeyChars = ["q", "1"]
      rightKeyChars = []
      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = ITKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = ITKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = ITKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = ITKeyboardConstants.aAlternateKeys
  eAlternateKeys = ITKeyboardConstants.eAlternateKeys
  iAlternateKeys = ITKeyboardConstants.iAlternateKeys
  oAlternateKeys = ITKeyboardConstants.oAlternateKeys
  uAlternateKeys = ITKeyboardConstants.uAlternateKeys
  sAlternateKeys = ITKeyboardConstants.sAlternateKeys
  cAlternateKeys = ITKeyboardConstants.cAlternateKeys
  nAlternateKeys = ITKeyboardConstants.nAlternateKeys
}

// MARK: Provide Layout

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
