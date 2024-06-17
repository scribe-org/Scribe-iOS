/**
 * Constants and functions to load the Swedish Scribe keyboard.
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
//  Constants and functions to load the Swedish Scribe keyboard.
//

import UIKit

public enum SwedishKeyboardConstants {
  // iPhone keyboard layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "å"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "space", "return"] // "undo"
  ]

  static let letterKeysPhoneDisableAccents = [
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "space", "return"] // "undo"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "kr", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"] // "undo"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "€", "$", "£", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"] // "undo"
  ]

  // iPad keyboard layouts.
  static let letterKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"],
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "å", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "return"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "?", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"] // "undo"
  ]

  static let letterKeysPadDisableAccents = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"],
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "return"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "?", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"] // "undo"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "`", "delete"],
    ["@", "#", "kr", "&", "*", "(", ")", "'", "\"", "+", "·", "return"],
    ["#+=", "%", "≈", "±", "=", "/", ";", ":", ",", ".", "-", "#+="],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"] // "undo"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"],
    ["€", "$", "£", "^", "[", "]", "{", "}", "―", "ᵒ", "...", "return"],
    ["123", "§", "|", "~", "≠", "\\", "<", ">", "!", "?", "_", "123"],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"] // "undo"
  ]

  // Expanded iPad keyboard layouts for wider devices.
  static let letterKeysPadExpanded = [
    ["§", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "´", "delete"],
    [SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å", "^", "*"],
    [SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "'", "return"],
    ["shift", "'", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"] // "microphone", "scribble"
  ]

  static let letterKeysPadExpandedDisableAccents = [
    ["§", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "´", "delete"],
    [SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "\"", "^", "*"],
    [SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "(", ")", "'", "return"],
    ["shift", "'", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"] // "microphone", "scribble"
  ]

  static let symbolKeysPadExpanded = [
    ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"],
    [SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "°", "|", "§"],
    [SpecialKeys.capsLock, "—", "/", ":", ";", "(", ")", "&", "@", "$", "£", "¥", "~", "return"], // "undo"
    ["shift", "…", "?", "!", "≠", "'", "\"", "_", "€", ",", ".", "-", "shift"], // "redo"
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"] // "microphone", "scribble"
  ]

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

/// Gets the keys for the Swedish keyboard.
func getSVKeys() {
  let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!

  if DeviceType.isPhone {
    if userDefaults.bool(forKey: "svAccentCharacters") {
      letterKeys = SwedishKeyboardConstants.letterKeysPhoneDisableAccents
    } else {
      letterKeys = SwedishKeyboardConstants.letterKeysPhone
    }
    numberKeys = SwedishKeyboardConstants.numberKeysPhone
    symbolKeys = SwedishKeyboardConstants.symbolKeysPhone
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
        letterKeys = SwedishKeyboardConstants.letterKeysPadExpandedDisableAccents
      } else {
        letterKeys = SwedishKeyboardConstants.letterKeysPadExpanded
      }
      symbolKeys = SwedishKeyboardConstants.symbolKeysPadExpanded

      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      if userDefaults.bool(forKey: "svAccentCharacters") {
        letterKeys = SwedishKeyboardConstants.letterKeysPadDisableAccents
      } else {
        letterKeys = SwedishKeyboardConstants.letterKeysPad
      }
      numberKeys = SwedishKeyboardConstants.numberKeysPad
      symbolKeys = SwedishKeyboardConstants.symbolKeysPad

      letterKeys.removeFirst(1)

      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }

    leftKeyChars = ["q", "a", "1", "@", "€"]
    // TODO: add "å" to rightKeyChar if the keyboard has 4 rows.
    rightKeyChars = []
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }

  keysWithAlternatesLeft = SwedishKeyboardConstants.keysWithAlternatesLeft
  eAlternateKeys = SwedishKeyboardConstants.eAlternateKeys
  iAlternateKeys = SwedishKeyboardConstants.iAlternateKeys
  uAlternateKeys = SwedishKeyboardConstants.uAlternateKeys
  sAlternateKeys = SwedishKeyboardConstants.sAlternateKeys
  cAlternateKeys = SwedishKeyboardConstants.cAlternateKeys
  nAlternateKeys = SwedishKeyboardConstants.nAlternateKeys

  if userDefaults.bool(forKey: "svAccentCharacters") {
    keysWithAlternates = SwedishKeyboardConstants.keysWithAlernatesDisableAccents
    keysWithAlternatesRight = SwedishKeyboardConstants.keysWithAlternatesRightDisableAccents
    aAlternateKeys = SwedishKeyboardConstants.aAlternateKeysDisableAccents
    oAlternateKeys = SwedishKeyboardConstants.oAlternateKeysDisableAccents
  } else {
    keysWithAlternates = SwedishKeyboardConstants.keysWithAlternates
    keysWithAlternatesRight = SwedishKeyboardConstants.keysWithAlternatesRight
    aAlternateKeys = SwedishKeyboardConstants.aAlternateKeys
    oAlternateKeys = SwedishKeyboardConstants.oAlternateKeys
    äAlternateKeys = SwedishKeyboardConstants.äAlternateKeys
    öAlternateKeys = SwedishKeyboardConstants.öAlternateKeys
  }
}

/// Provides the Swedish keyboard layout.
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
