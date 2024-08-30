//
//  HEInterfaceVariablesTemp.swift
//  Scribe

import UIKit

public enum HebrewKeyboardConstants {
  static let defaultCurrencyKey = "₪"
  static let currencyKeys = ["₪", "€", "£", "$"]

  // Alternate key vars.
  // Add "sofit" letters here
  static let keysWithAlternates = ["ך","ח", "נ", "צ", "ק", "ת", "פ", "א"]
    static let keysWithAlternatesLeft = ["ח", "נ", "פ"]
    static let keysWithAlternatesRight = ["צ", "ק", "ת"]
    
    static let alephAlternateKeys = ["א׳"]
    static let memAlternateKeys = ["ם"]
    static let nunAlternateKeys = ["ן"]
    static let tzadiAlternateKeys = ["ץ"]
    static let kafAlternateKeys = ["ק"]
    static let kafSofitAlternateKeys = ["ך"]
    static let tavAlternateKeys = ["ת"]
    static let peySofitAlternateKeys = ["פ׳"]
  
}

struct HebrewKeyboardProvider: KeyboardProviderProtocol {
  // iPhone keyboard layouts.
  static func genPhoneLetterKeys() -> [[String]] {
    return KeyboardBuilder()
      .addRow(["פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "❌"])
      .addRow(["ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש"])
      .addRow(["ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז"])
      .addRow(["123", "selectKeyboard", "רווח", "הכנס"])
      .build()
  }

  static func genPhoneNumberKeys(currencyKey: String) -> [[String]] {
    return KeyboardBuilder()
      .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"])
      .addRow(["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""])
      .addRow(["#+=", ".", ",", "?", "!", "'", "❌"])
      .addRow(["אבג", "selectKeyboard", "רווח", "הכנס"])
      .replaceKey(row: 1, column: 6, to: currencyKey)
      .build()
  }

  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]] {
    let keyboardBuilder = KeyboardBuilder()
      .addRow(["[", "]", "{", "}", "#", "%", "^", "*", "+", "="])
      .addRow(["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"])
      .addRow(["123", ".", ",", "?", "!", "'", "❌"])
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
       .addRow([",", ".", "פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "❌"])
       .addRow(["ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש"])
       .addRow(["ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז", "הכנס"])
       .addRow(["selectKeyboard", ".?123", "רווח", ".?123", "hideKeyboard"])
       .build()
   }

   static func genPadNumberKeys(currencyKey: String) -> [[String]] {
     return KeyboardBuilder()
       .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "❌"])
       .addRow(["!", "@", "#", "&", "_", "-", "'", "\"", "(", ")", "הכנס"])
       .addRow(["#+=", "%", "...", "&", ";", ":", "=", "+", "/", "?", "#+="])
       .addRow(["selectKeyboard", "אבג", "רווח", "אבג", "hideKeyboard"])
       // .replaceKey(row: 1, column: 4, to: currencyKey)
       .build()
   }

   static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]] {
     let keyboardBuilder = KeyboardBuilder()
       .addRow(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "❌"])
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
        .addRow(["§", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "❌"])
        .addRow([SpecialKeys.indent, "/", "'", "פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "[", "]", "+"])
        .addRow([SpecialKeys.capsLock, "ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש", ",", "\"", "הכנס"])
        .addRow(["⇧", ";", "ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז", ".", "⇧"])
        .addRow(["selectKeyboard", ".?123", "רווח", ".?123", "hideKeyboard"])
        .build()
    }

    static func genPadExpandedSymbolKeys() -> [[String]] {
      return KeyboardBuilder()
        .addRow(["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "❌"])
        .addRow([SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|", "—"])
        .addRow([SpecialKeys.capsLock, "°", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "€", "הכנס"])
        .addRow(["⇧", "…", "?", "!", "~", "≠", "'", "\"", "_", ",", ".", "-", "⇧"])
        .addRow(["selectKeyboard", "אבג", "רווח", "אבג", "hideKeyboard"])
        .build()
    }
  }


//  Created by Daniel Geva on 2024/08/30.
//
