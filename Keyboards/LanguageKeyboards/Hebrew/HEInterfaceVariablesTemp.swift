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
      .addRow(["פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "delete"])
      .addRow(["ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש"])
      .addRow(["ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז"])
      .addRow(["123", "selectKeyboard", "space", "return"]) // "undo", "accent"
      .build()
  }
  
  // add rest of iphone keyboards here
  
}

//  Created by Daniel Geva on 2024/08/30.
//
