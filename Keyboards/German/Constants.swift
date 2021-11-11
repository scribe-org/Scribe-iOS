//
//  Constants.swift
//

import UIKit

extension UIColor {
  static let scribeGrey = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
  static let scribeBlue = UIColor(red: 97.0/255.0, green: 200.0/255.0, blue: 245.0/255.0, alpha: 1.0)

  static let previewRedLightTheme = UIColor(red: 153.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
  static let previewBlueLightTheme = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 153.0/255.0, alpha: 1.0)
  static let previewGreenLightTheme = UIColor(red: 0.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0)
  static let previewOrangeLightTheme = UIColor(red: 153.0/255.0, green: 76.0/255.0, blue: 0.0/255.0, alpha: 1.0)

  static let previewRedDarkTheme = UIColor(red: 204.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
  static let previewBlueDarkTheme = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 204.0/255.0, alpha: 1.0)
  static let previewGreenDarkTheme = UIColor(red: 50.0/255.0, green: 204.0/255.0, blue: 50.0/255.0, alpha: 1.0)
  static let previewOrangeDarkTheme = UIColor(red: 204.0/255.0, green: 102.0/255.0, blue: 0.0/255.0, alpha: 1.0)
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
