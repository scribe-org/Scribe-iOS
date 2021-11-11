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
	static let letterKeysPhone = [
		["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü"],
		["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä"],
		["shift", "y", "x", "c", "v", "b", "n", "m", "delete"],
		["123", "selectKeyboard", "Leerzeichen", "return"]
	]

	static let numberKeysPhone = [
		["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
		["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
		["#+=", ".", ",", "?", "!", "\'", "delete"],
		["ABC", "selectKeyboard", "Leerzeichen", "return"]
	]

	static let symbolKeysPhone = [
		["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
		["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"],
		["123", ".", ",", "?", "!", "\'", "delete"],
		["ABC", "selectKeyboard", "Leerzeichen", "return"]
	]

  static let letterKeysPad = [
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "return"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "ß", "shift"],
    [".?123", "selectKeyboard", "Leerzeichen", ".?123", "hideKeyboard"] // "undoArrow"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "delete"],
    ["\"", "§", "€", "%", "&", "/", "(", ")", "=", "'", "#", "return"],
    ["#+=", "—", "`", "'", "...", "@", ";", ":'", ",", ".", "-", "#+="],
    ["ABC", "selectKeyboard", "Leerzeichen", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"],
    ["$", "£", "¥", "¿", "―", "\\", "[", "]", "{", "}", "|", "return"],
    ["123", "¡", "<", ">", "≠", "·", "^", "~", "!", "?", "_", "123"],
    ["ABC", "selectKeyboard", "Leerzeichen", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  // Variables for alternate key views.
  static let keysWithAlternates = ["a", "e", "s", "y", "c", "u", "i", "o", "n"]
  static let keysWithAlternatesLeft = ["a", "e", "s", "y", "c"]
  static let keysWithAlternatesRight = ["u", "i", "o", "n"]

  static let aAlternateKeys = ["à", "á", "â", "æ", "ã", "å", "ā"]

  static let eAlternateKeys = ["é", "è", "ê", "ë", "ė"]

  static let iAlternateKeys = ["ì", "ī", "í", "î", "ï"]

  static let oAlternateKeys = ["ō", "ø", "œ", "õ", "ó", "ò", "ô"]

  static let uAlternateKeys = ["ū", "ú", "ù", "û"]

  static let yAlternateKeys = ["ÿ"]

  static let sAlternateKeys = ["ß", "ś", "š"]

  static let cAlternateKeys = ["ç", "ć", "č"]

  static let nAlternateKeys = ["ń", "ñ"]
}
