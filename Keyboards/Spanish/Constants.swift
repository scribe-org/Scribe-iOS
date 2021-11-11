//
//  Constants.swift
//

import UIKit

extension UIColor {
  static let scribeGrey = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
  static let scribeBlue = UIColor(red: 97.0/255.0, green: 200.0/255.0, blue: 245.0/255.0, alpha: 1.0)

  static let previewRedLightTheme = UIColor(red: 170.0/255.0, green: 40.0/255.0, blue: 45.0/255.0, alpha: 1.0)
  static let previewBlueLightTheme = UIColor(red: 30.0/255.0, green: 55.0/255.0, blue: 155.0/255.0, alpha: 1.0)
  static let previewGreenLightTheme = UIColor(red: 65.0/255.0, green: 125.0/255.0, blue: 60.0/255.0, alpha: 1.0)
  static let previewOrangeLightTheme = UIColor(red: 155.0/255.0, green: 85.0/255.0, blue: 30.0/255.0, alpha: 1.0)

  static let previewRedDarkTheme = UIColor(red: 230.0/255.0, green: 70.0/255.0, blue: 75.0/255.0, alpha: 1.0)
  static let previewBlueDarkTheme = UIColor(red: 50.0/255.0, green: 100.0/255.0, blue: 220.0/255.0, alpha: 1.0)
  static let previewGreenDarkTheme = UIColor(red: 90.0/255.0, green: 195.0/255.0, blue: 85.0/255.0, alpha: 1.0)
  static let previewOrangeDarkTheme = UIColor(red: 205.0/255.0, green: 105.0/255.0, blue: 50.0/255.0, alpha: 1.0)
}

enum Constants {
  static let letterKeys = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ñ"],
    ["⇧", "z", "x", "c", "v", "b", "n", "m", "⌫"],
    ["123", "🌐", "espacio", "↵"]
  ]

  static let numberKeys = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "\'", "⌫"],
    ["ABC", "🌐", "espacio", "↵"]
  ]

  static let symbolKeys = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"],
    ["123", ".", ",", "?", "!", "\'", "⌫"],
    ["ABC", "🌐", "espacio", "↵"]
  ]

  static let letterKeysPad = [
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "⌫"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ñ", "↵"],
    ["⇧", "y", "x", "c", "v", "b", "n", "m", ",", ".", "⇧"],
    [".?123", "🌐", "espacio", ".?123", "hideKeyboard"]
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "⌫"],
    ["@", "#", "$", "&", "*", "(", ")", "'", "\"", "+", "↵"],
    ["#+=", "%", "_", "-", "=", "/", ";", ":'", ",", ".", "#+="],
    ["ABC", "🌐", "espacio", "undoArrow", "ABC", "hideKeyboard"]
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "⌫"],
    ["€", "£", "¥", "^", "[", "]", "{", "}", "ᵒ", "ᵃ", "↵"],
    ["123", "§", "|", "~", "¶", "\\", "<", ">", "¡", "¿", "123"],
    ["ABC", "🌐", "espacio", "undoArrow", "ABC", "hideKeyboard"]
  ]

  // Variables for alternate key views.
  static let keysWithAlternates = ["a", "e", "s", "y", "c", "u", "i", "o", "n"]
  static let keysWithAlternatesLeft = ["a", "e", "s", "d", "c"]
  static let keysWithAlternatesRight = ["u", "i", "o", "n"]

  static let aAlternateKeys = ["á", "à", "ä", "â", "ã", "å", "ą", "æ", "ā", "ᵃ"]

  static let eAlternateKeys = ["é", "è", "ë", "ê", "ę", "ė", "ē"]

  static let iAlternateKeys = ["ī", "į", "î", "ì", "ï", "í"]

  static let oAlternateKeys = ["ᵒ", "ō", "œ", "ø", "õ", "ô", "ö", "ó", "ò"]

  static let uAlternateKeys = ["ū", "û", "ù", "ü", "ú"]

  static let sAlternateKeys = ["š"]

  static let dAlternateKeys = ["đ"]

  static let cAlternateKeys = ["ç", "ć", "č"]

  static let nAlternateKeys = ["ń"]
}
