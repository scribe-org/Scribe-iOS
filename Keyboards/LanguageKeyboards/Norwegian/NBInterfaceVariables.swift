// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Constants and functions to load the Norwegian Bokmål Scribe keyboard.
 */

import UIKit

// MARK: Constants

public enum NBKeyboardConstants {
  static let defaultCurrencyKey = "kr"
  static let currencyKeys = ["kr", "€", "$", "£", "¥"]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "y", "å", "æ", "ø", "d", "l", "n", "s"]
  static let keysWithAlternatesLeft = ["a", "e", "y", "å", "d", "s"]
  static let keysWithAlternatesRight = ["i", "o", "u", "æ", "ø", "l", "n"]

  static let aAlternateKeys = ["á", "ä", "à", "â", "ã", "ā"]
  static let eAlternateKeys = ["é", "ë", "è", "ê", "ę", "ė", "ē"]
  static let iAlternateKeys = ["ï", "í", "ì", "î", "į", "ī"]
  static let oAlternateKeys = ["ö", "ō", "œ", "õ", "ò", "ô", "ó"]
  static let uAlternateKeys = ["ū", "ù", "û", "ü", "ú"]
  static let yAlternateKeys = ["ÿ"]
  static let åAlternateKeys = ["ä", "ā"]
  static let æAlternateKeys = ["ä"]
  static let øAlternateKeys = ["ö", "ô"]
  static let dAlternateKeys = ["ð"]
  static let lAlternateKeys = ["ł"]
  static let nAlternateKeys = ["ń", "ñ"]
  static let sAlternateKeys = ["ß", "ś", "š"]
}

struct NBKeyboardProvider: KeyboardProviderProtocol {
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
      .addRow(["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"])
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
      .addRow(["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // "undo"
      .build()
  }

  static func genPadNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "`", "delete"])
      .addRow(["@", "#", "kr", "&", "*", "(", ")", "'", "\"", "+", "·", "return"])
      .addRow(["#+=", "%", "_", "-", "=", "/", ";", ":", ",", ".", "?", "#+="])
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) // "undo"
      .replaceKey(row: 1, column: 2, to: currencyKey)
      .build()
  }

  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "'", "delete"])
      .addRow(["€", "$", "£", "^", "[", "]", "{", "}", "―", "ᵒ", "...", "return"])
      .addRow(["123", "§", "|", "~", "≠", "≈", "\\", "<", ">", "!", "?", "123"])
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
      .addRow(["kr", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "´", "delete"])
      .addRow([SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å", "@", "¨"])
      .addRow([SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "ø", "æ", "'", "return"])
      .addRow(["shift", "*", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"])
      .addRow(["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"]) // 
      .build()
  }

  static func genPadExpandedSymbolKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
      .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|", "—"])
      .addRow([SpecialKeys.capsLock, "°", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "~", "return"]) // "undo"
      .addRow(["shift", "…", "?", "!", "≠", "'", "\"", "_", "€", ",", ".", "-", "shift"]) // "redo"
      .addRow(["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"]) 
      .build()
  }
}

// MARK: Get Keys

func getNBKeys() {
  guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
    fatalError("Unable to access shared user defaults")
  }

  var currencyKey = NBKeyboardConstants.defaultCurrencyKey
  var currencyKeys = NBKeyboardConstants.currencyKeys
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
    letterKeys = NBKeyboardProvider.genPhoneLetterKeys()
    numberKeys = NBKeyboardProvider.genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = NBKeyboardProvider.genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())

    leftKeyChars = ["q", "a", "1", "-", "[", "_"]
    rightKeyChars = ["å", "æ", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      letterKeys = NBKeyboardProvider.genPadExpandedLetterKeys()
      symbolKeys = NBKeyboardProvider.genPadExpandedSymbolKeys()
      leftKeyChars = ["kr", "`"]
      rightKeyChars = ["¨", "—"]
      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      letterKeys = NBKeyboardProvider.genPadLetterKeys()
      numberKeys = NBKeyboardProvider.genPadNumberKeys(currencyKey: currencyKey)
      symbolKeys = NBKeyboardProvider.genPadSymbolKeys(currencyKeys: currencyKeys)

      letterKeys.removeFirst(1)
      leftKeyChars = ["q", "a", "1", "@", "€"]
      rightKeyChars = ["delete", "return"]
      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternates = NBKeyboardConstants.keysWithAlternates
  keysWithAlternatesLeft = NBKeyboardConstants.keysWithAlternatesLeft
  keysWithAlternatesRight = NBKeyboardConstants.keysWithAlternatesRight
  aAlternateKeys = NBKeyboardConstants.aAlternateKeys
  eAlternateKeys = NBKeyboardConstants.eAlternateKeys
  iAlternateKeys = NBKeyboardConstants.iAlternateKeys
  oAlternateKeys = NBKeyboardConstants.oAlternateKeys
  uAlternateKeys = NBKeyboardConstants.uAlternateKeys
  yAlternateKeys = NBKeyboardConstants.yAlternateKeys
  dAlternateKeys = NBKeyboardConstants.dAlternateKeys
  lAlternateKeys = NBKeyboardConstants.lAlternateKeys
  nAlternateKeys = NBKeyboardConstants.nAlternateKeys
  sAlternateKeys = NBKeyboardConstants.sAlternateKeys
}
// MARK: Provide Layout

func setNBKeyboardLayout() {
  getNBKeys()

  currencySymbol = "kr"
  currencySymbolAlternates = kronaAlternateKeys
  spaceBar = "mellomrom"
  language = "Norsk"
  invalidCommandMsg = "Ikke i Wikidata"
  baseAutosuggestions = ["jeg", "det", "er"]
  numericAutosuggestions = ["prosent", "millioner", "meter"]
  verbsAfterPronounsArray = ["har", "være", "kan"]
  pronounAutosuggestionTenses = [
    "jeg": "presFPS",
    "du": "presSPS",
    "han": "presTPS",
    "hun": "presTPS",
    "den": "presTPS",
    "det": "presTPS",
    "vi": "presFPP",
    "dere": "presSPP",
    "de": "presTPP"
  ]

  translateKeyLbl = "Oversett"
  translatePlaceholder = "Skriv inn et ord"
  translatePrompt = commandPromptSpacing + "nb → \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  conjugateKeyLbl = "Bøy"
  conjugatePlaceholder = "Skriv inn et verb"
  conjugatePrompt = commandPromptSpacing + "Bøy: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  pluralKeyLbl = "Flertall"
  pluralPlaceholder = "Skriv inn et substantiv"
  pluralPrompt = commandPromptSpacing + "Flertall: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))
  alreadyPluralMsg = "Allerede flertall"
}
