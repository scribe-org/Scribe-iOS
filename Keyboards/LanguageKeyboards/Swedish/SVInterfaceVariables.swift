// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Constants and functions to load the Swedish Scribe keyboard.
 */

import UIKit

// MARK: Constants

public enum SVKeyboardConstants {
  static let defaultCurrencyKey = "kr"
  static let currencyKeys = ["kr", "€", "$", "£"]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "ä", "ö", "c", "n", "s"]
  static let keysWithAlernatesDisableAccents = ["a", "e", "i", "o", "u", "c", "n", "s"]
  static let keysWithAlternatesLeft = ["a", "e", "c", "s"]
  static let keysWithAlternatesRight = ["i", "o", "u", "ä", "ö", "n"]
  static let keysWithAlternatesRightDisableAccents = ["i", "o", "u", "n"]

  static let aAlternateKeys = ["á", "à", "â", "ã", "ā"]
  static let aAlternateKeysDisableAccents = ["á", "à", "â", "ã", "ā", "å"]
  static let eAlternateKeys = ["é", "ë", "è", "ê", "ẽ", "ē", "ę"]
  static let iAlternateKeys = ["ī", "î", "í", "ï", "ì", "ĩ"]
  static let oAlternateKeys = ["ō", "õ", "ô", "ò", "ó", "œ"]
  static let oAlternateKeysDisableAccents = ["ō", "õ", "ô", "ò", "ó", "œ", "ö", "ø"]
  static let uAlternateKeys = ["û", "ú", "ü", "ù", "ũ", "ū"]
  static let äAlternateKeys = ["æ"]
  static let öAlternateKeys = ["ø"]
  static let cAlternateKeys = ["ç"]
  static let nAlternateKeys = ["ñ"]
  static let sAlternateKeys = ["ß", "ś", "š"]
}

struct SVKeyboardProvider: KeyboardProviderProtocol, KeyboardProviderDisableAccentsProtocol {
 // MARK: iPhone Layouts

  static func genPhoneLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "å"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä"])
      .addRow(["shift", "y", "x", "c", "v", "b", "n", "m", "delete"])
      .addRow(["123", "selectKeyboard", "space", "return"]) // "undo"
      .build()
  }

  static func genPhoneDisableAccentsLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["q", "w", "e", "r", "t", "z", "u", "i", "o", "p"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l"])
      .addRow(["shift", "y", "x", "c", "v", "b", "n", "m", "delete"])
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
    let keyboardBuilder =  KeyboardBuilder()
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
      .addRow(["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "å", "delete"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "return"])
      .addRow(["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "?", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "undo"
      .build()
  }

  static func genPadDisableAccentsLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"])
      .addRow(["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "delete"])
      .addRow(["a", "s", "d", "f", "g", "h", "j", "k", "l", "return"])
      .addRow(["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "?", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "undo"
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "`", "delete"])
      .addRow(["@", "#", "kr", "&", "*", "(", ")", "'", "\"", "+", "·", "return"])
      .addRow(["#+=", "%", "≈", "±", "=", "/", ";", ":", ",", ".", "-", "#+="])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "undo"
      .replaceKey(row: 1, column: 2, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder =  KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"])
      .addRow(["€", "$", "£", "^", "[", "]", "{", "}", "―", "ᵒ", "...", "return"])
      .addRow(["123", "§", "|", "~", "≠", "\\", "<", ">", "!", "?", "_", "123"])
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
      .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "'", "return"])
      .addRow(["shift", "'", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }

  static func genPadExpandedDisableAccentsLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["§", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "´", "delete"])
      .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "\"", "^", "*"])
      .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "(", ")", "'", "return"])
      .addRow(["shift", "'", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }

  static func genPadExpandedSymbolKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
      .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "°", "|", "§"])
      .addRow([SpecialKeys.capsLock, "—", "/", ":", ";", "(", ")", "&", "@", "$", "£", "¥", "~", "return"]) // "undo"
      .addRow(["shift", "…", "?", "!", "≠", "'", "\"", "_", "€", ",", ".", "-", "shift"]) // "redo"
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "microphone", "scribble"
      .build()
  }

}

// MARK: Generate and set keyboard

// MARK: Get Keys

func getSVKeys() {
  guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
    fatalError()
  }

  var currencyKey = SVKeyboardConstants.defaultCurrencyKey
  var currencyKeys = SVKeyboardConstants.currencyKeys
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
    if userDefaults.bool(forKey: "svAccentCharacters") {
      letterKeys = SVKeyboardProvider.genPhoneDisableAccentsLetterKeys()
    } else {
      letterKeys = SVKeyboardProvider.genPhoneLetterKeys()
    }
    numberKeys = SVKeyboardProvider.genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = SVKeyboardProvider.genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "a", "1", "-", "[", "_"]
    if userDefaults.bool(forKey: "svAccentCharacters") {
      rightKeyChars = ["p", "l", "0", "\"", "=", "·"]
    } else {
      rightKeyChars = ["å", "ä", "0", "\"", "=", "·"]
    }
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      if userDefaults.bool(forKey: "svAccentCharacters") {
        letterKeys = SVKeyboardProvider.genPadExpandedDisableAccentsLetterKeys()
      } else {
        letterKeys = SVKeyboardProvider.genPadExpandedLetterKeys()
      }
      symbolKeys = SVKeyboardProvider.genPadExpandedSymbolKeys()

      leftKeyChars = ["§", "`"]
      rightKeyChars = ["§", "*"]
      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      if userDefaults.bool(forKey: "svAccentCharacters") {
        letterKeys = SVKeyboardProvider.genPadDisableAccentsLetterKeys()
      } else {
        letterKeys = SVKeyboardProvider.genPadLetterKeys()
      }
      numberKeys = SVKeyboardProvider.genPadNumberKeys(currencyKey: currencyKey)
      symbolKeys = SVKeyboardProvider.genPadSymbolKeys(currencyKeys: currencyKeys)

      letterKeys.removeFirst(1)

      leftKeyChars = ["q", "a", "1", "@", "€"]
      rightKeyChars = []
      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternatesLeft = SVKeyboardConstants.keysWithAlternatesLeft
  eAlternateKeys = SVKeyboardConstants.eAlternateKeys
  iAlternateKeys = SVKeyboardConstants.iAlternateKeys
  uAlternateKeys = SVKeyboardConstants.uAlternateKeys
  sAlternateKeys = SVKeyboardConstants.sAlternateKeys
  cAlternateKeys = SVKeyboardConstants.cAlternateKeys
  nAlternateKeys = SVKeyboardConstants.nAlternateKeys

  if userDefaults.bool(forKey: "svAccentCharacters") {
    keysWithAlternates = SVKeyboardConstants.keysWithAlernatesDisableAccents
    keysWithAlternatesRight = SVKeyboardConstants.keysWithAlternatesRightDisableAccents
    aAlternateKeys = SVKeyboardConstants.aAlternateKeysDisableAccents
    oAlternateKeys = SVKeyboardConstants.oAlternateKeysDisableAccents
  } else {
    keysWithAlternates = SVKeyboardConstants.keysWithAlternates
    keysWithAlternatesRight = SVKeyboardConstants.keysWithAlternatesRight
    aAlternateKeys = SVKeyboardConstants.aAlternateKeys
    oAlternateKeys = SVKeyboardConstants.oAlternateKeys
    äAlternateKeys = SVKeyboardConstants.äAlternateKeys
    öAlternateKeys = SVKeyboardConstants.öAlternateKeys
  }
}

// MARK: Provide Layout

func setSVKeyboardLayout() {
  getSVKeys()

  currencySymbol = "kr"
  currencySymbolAlternates = kronaAlternateKeys
  spaceBar = "mellanslag"
  language = "Svenska"
  invalidCommandMsg = "Inte i Wikidata"
  baseAutosuggestions = ["jag", "det", "men"]
  numericAutosuggestions = ["jag", "det", "och"]

  translateKeyLbl = "Översätt"
  translatePlaceholder = "Ange ett ord"
  translatePrompt = commandPromptSpacing + "sv -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  conjugateKeyLbl = "Konjugera"
  conjugatePlaceholder = "Ange ett verb"
  conjugatePrompt = commandPromptSpacing + "Konjugera: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  pluralKeyLbl = "Plural"
  pluralPlaceholder = "Ange ett substantiv"
  pluralPrompt = commandPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))
  alreadyPluralMsg = "Redan plural"
}
