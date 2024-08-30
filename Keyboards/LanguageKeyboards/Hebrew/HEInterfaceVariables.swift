/**
 * Constants and functions to load the Hebrew Scribe keyboard.
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

//  HEInterfaceVariablesTemp.swift
//  Scribe

import UIKit

public enum HebrewKeyboardConstants {
  static let defaultCurrencyKey = "₪"
  static let currencyKeys = ["₪", "€", "£", "$"]

  
}

struct HebrewKeyboardProvider: KeyboardProviderProtocol {
  // iPhone keyboard layouts.
  static func genPhoneLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "delete"])
      .addRow(["ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש"])
      .addRow(["ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז"])
      .addRow(["123", "selectKeyboard", "רווח", "הכנס"])
      .build()
  }

  static func genPhoneNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
      .addRow(["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""])
      .addRow(["#+=", ".", ",", "?", "!", "'", "delete"])
      .addRow(["אבג", "selectKeyboard", "רווח", "הכנס"])
      .replaceKey(row: 1, column: 6, to: currencyKey)
      .build()
  }

  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["[", "]", "{", "}", "#", "%", "^", "*", "+", "="])
      .addRow(["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"])
      .addRow(["123", ".", ",", "?", "!", "'", "delete"])
      .addRow(["אבג", "selectKeyboard", "רווח", "הכנס"])

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
  
  // iPad keyboard layouts.
   static func genPadLetterKeys() -> [[String]] {
     return KeyboardBuilder()
       .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"])
       .addRow([",", ".", "פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "delete"])
       .addRow(["ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש"])
       .addRow(["ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז", "הכנס"])
       .addRow(["selectKeyboard", ".?123", "רווח", ".?123", "hideKeyboard"])
       .build()
   }

   static func genPadNumberKeys(currencyKey: String) -> [[String]] {
     return KeyboardBuilder()
       .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"])
       .addRow(["!", "@", "#", "&", "_", "-", "'", "\"", "(", ")", "הכנס"])
       .addRow(["#+=", "%", "...", "&", ";", ":", "=", "+", "/", "?", "#+="])
       .addRow(["selectKeyboard", "אבג", "רווח", "אבג", "hideKeyboard"])
       // .replaceKey(row: 1, column: 4, to: currencyKey)
       .build()
   }

   static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
     let keyboardBuilder = KeyboardBuilder()
       .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"])
       .addRow(["^", "€", "$", "£", "[", "]", "'", "\"", "<", ">", "הכנס"])
       .addRow(["123", "§", "|", "~", "*", "·", "{", "}", "\\", "~", "123"])
       .addRow(["selectKeyboard", "אבג", "רווח", "אבג", "hideKeyboard"])

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
  
  // Expanded iPad keyboard layouts for wider devices.
    static func genPadExpandedLetterKeys() -> [[String]] {
      return KeyboardBuilder()
        .addRow(["§", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "delete"])
        .addRow([SpecialKeys.indent, "/", "'", "פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "[", "]", "+"])
        .addRow([SpecialKeys.capsLock, "ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש", ",", "\"", "הכנס"])
        .addRow(["⇧", ";", "ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז", ".", "⇧"])
        .addRow(["selectKeyboard", ".?123", "רווח", ".?123", "hideKeyboard"])
        .build()
    }

    static func genPadExpandedSymbolKeys() -> [[String]] {
      return KeyboardBuilder()
        .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"])
        .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|", "—"])
        .addRow([SpecialKeys.capsLock, "°", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "€", "הכנס"])
        .addRow(["⇧", "…", "?", "!", "~", "≠", "'", "\"", "_", ",", ".", "-", "⇧"])
        .addRow(["selectKeyboard", "אבג", "רווח", "אבג", "hideKeyboard"])
        .build()
    }
  }

/// Gets the keys for the Hebrew keyboard.


func getHEKeys() {
  guard let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer") else {
    fatalError()
  }
  
  var currencyKey = HebrewKeyboardConstants.defaultCurrencyKey
  var currencyKeys = HebrewKeyboardConstants.currencyKeys
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
    letterKeys = HebrewKeyboardProvider.genPhoneLetterKeys()
    numberKeys = HebrewKeyboardProvider.genPhoneNumberKeys(currencyKey: currencyKey)
    symbolKeys = HebrewKeyboardProvider.genPhoneSymbolKeys(currencyKeys: currencyKeys)
    allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    
    leftKeyChars = ["ק", "1", "-", "[", "_"]
    rightKeyChars = ["פ", "0", "\"", "=", "·"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  } else {
    // Use the expanded keys layout if the iPad is wide enough and has no home button.
    if usingExpandedKeyboard {
      letterKeys = HebrewKeyboardProvider.genPadExpandedLetterKeys()
      symbolKeys = HebrewKeyboardProvider.genPadExpandedSymbolKeys()
      
      allKeys = Array(letterKeys.joined()) + Array(symbolKeys.joined())
    } else {
      letterKeys = HebrewKeyboardProvider.genPadLetterKeys()
      numberKeys = HebrewKeyboardProvider.genPadNumberKeys(currencyKey: currencyKey)
      symbolKeys = HebrewKeyboardProvider.genPadSymbolKeys(currencyKeys: currencyKeys)
      
      letterKeys.removeFirst(1)
      
      allKeys = Array(letterKeys.joined()) + Array(numberKeys.joined()) + Array(symbolKeys.joined())
    }
    
    leftKeyChars = ["1", "ק"]
    rightKeyChars = ["הכנס", "hideKeyboard"]
    centralKeyChars = allKeys.filter { !leftKeyChars.contains($0) && !rightKeyChars.contains($0) }
  }
}


func setHEKeyboardLayout() {
  getHEKeys()

  currencySymbol = ""
  currencySymbolAlternates = roubleAlternateKeys
  spaceBar = "רווח"
  language = "עברית"
  invalidCommandMsg = "אין מידע"
  baseAutosuggestions = ["אתמ", "אני", "היי"]
  numericAutosuggestions = ["", "", ""]

  translateKeyLbl = "Translate"
  translatePlaceholder = "Translate"
  translatePrompt = commandPromptSpacing + "he -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  conjugateKeyLbl = "Conjugate"
  conjugatePlaceholder = "Conjugate"
  conjugatePrompt = commandPromptSpacing + "Conjucation: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))

  pluralKeyLbl = "Plural"
  pluralPlaceholder = "Plural"
  pluralPrompt = commandPromptSpacing + "Plural: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarPlaceholderColorCG))
  alreadyPluralMsg = "Already in plural form"
}


//  Created by Daniel Geva on 2024/08/30.
