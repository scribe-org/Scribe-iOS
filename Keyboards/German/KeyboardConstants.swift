//
//  KeyboardConstants.swift
//
// Constants for the keyboard's interface.
//

enum KeyboardConstants {
  // Keyboard key layouts.
	static let letterKeysPhone = [
		["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü"],
		["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä"],
		["shift", "y", "x", "c", "v", "b", "n", "m", "delete"],
		["123", "selectKeyboard", "Leerzeichen", "return"] // "undoArrow"
	]

	static let numberKeysPhone = [
		["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
		["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
		["#+=", ".", ",", "?", "!", "\'", "delete"],
		["ABC", "selectKeyboard", "Leerzeichen", "return"] // "undoArrow"
	]

	static let symbolKeysPhone = [
		["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
		["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"],
		["123", ".", ",", "?", "!", "\'", "delete"],
		["ABC", "selectKeyboard", "Leerzeichen", "return"] // "undoArrow"
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

  // Alternate key vars.
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
