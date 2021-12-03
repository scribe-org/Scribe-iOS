//
//  InterfaceVariables.swift.swift
//
//  Variables associated with Scribe's user interface.
//

import UIKit

// A proxy into which text is typed.
var proxy: UITextDocumentProxy!
var controllerLanguage = String()

// Variables for keyboard appearance.
var keyboardHeight: CGFloat!
var keyCornerRadius: CGFloat!
var buttonWidth = CGFloat(0)
var letterButtonWidth = CGFloat(0)
var numSymButtonWidth = CGFloat(0)

// Arrays for the possible keyboard views that are loaded with their characters.
var letterKeys = [[String]]()
var numberKeys = [[String]]()
var symbolKeys = [[String]]()

// View that stores hold-to-select key options and the corresponding key arrays.
var alternatesKeyView: UIView!
var keysWithAlternates = [String]()
var keysWithAlternatesLeft = [String]()
var keysWithAlternatesRight = [String]()
var keyAlternatesDict = [String: Array<String>]()
var aAlternateKeys = [String]()
var eAlternateKeys = [String]()
var iAlternateKeys = [String]()
var oAlternateKeys = [String]()
var uAlternateKeys = [String]()
var yAlternateKeys = [String]()
var sAlternateKeys = [String]()
var dAlternateKeys = [String]()
var cAlternateKeys = [String]()
var nAlternateKeys = [String]()
var ьAlternateKeys = [String]()

/// States of the keyboard corresponding to layouts found in KeyboardConstants.swift.
enum KeyboardState {
  case letters
  case numbers
  case symbols
}

/// What the keyboard state is in regards to the shift key.
/// - normal: not capitalized
/// - shift: capitalized
/// - caps: caps-lock
enum ShiftButtonState {
  case normal
  case shift
  case caps
}

// Baseline state variables.
var keyboardState: KeyboardState = .letters
var shiftButtonState: ShiftButtonState = .normal
var scribeBtnState: Bool! = false

// Variables and functions to determine display parameters.
var isLandscapeView: Bool = false

struct DeviceType {
  static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
  static let isPad = UIDevice.current.userInterfaceIdiom == .pad
}

/// Determines if the device is in dark mode and sets the color scheme.
func checkDarkModeSetColors() {
  if UITraitCollection.current.userInterfaceStyle == .dark {
    keyColor = UIColor.systemGray2
    specialKeyColor = UIColor.systemGray3
    keyPressedColor = UIColor.systemGray
  } else if UITraitCollection.current.userInterfaceStyle == .light {
    keyColor = .white
    specialKeyColor = UIColor.systemGray2
    keyPressedColor = UIColor.systemGray5
  }
}

/// Checks if the device is in landscape mode.
func checkLandscapeMode() {
  if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
    isLandscapeView = true
  } else if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
    isLandscapeView = false
  }
}

// MARK: German interface variables

public enum GermanKeyboardConstants {
  // Keyboard key layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "Leerzeichen", "return"] // "undoArrow"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "€", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "\'", "delete"],
    ["ABC", "selectKeyboard", "Leerzeichen", "return"] // "undoArrow"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "$", "£", "¥", "·"],
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
    ["#+=", "—", "`", "'", "...", "@", ";", ":", ",", ".", "-", "#+="],
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

// MARK: Russian interface variables

public enum RussianKeyboardConstants {
  // Keyboard key layouts.
  static let letterKeysPhone = [
    ["й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х"],
    ["ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э"],
    ["shift", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", "delete"],
    ["123", "selectKeyboard", "Пробел", "return"] // "undoArrow"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "€", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "\'", "delete"],
    ["АБВ", "selectKeyboard", "Пробел", "return"] // "undoArrow"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "$", "£", "¥", "·"],
    ["123", ".", ",", "?", "!", "\'", "delete"],
    ["АБВ", "selectKeyboard", "Пробел", "return"] // "undoArrow"
  ]

  static let letterKeysPad = [
    ["й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х", "delete"],
    ["ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э", "return"],
    ["shift", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", ".", "shift"],
    [".?123", "selectKeyboard", "Пробел", ".?123", "hideKeyboard"] // "undoArrow"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "—", "delete"],
    ["@", "#", "№", "₽", "ʼ", "&", "*", "(", ")", "'", "\"", "return"],
    ["#+=", "%", "_", "-", "+", "=", "≠", ";", ":", ",", ".", "#+="],
    ["АБВ", "selectKeyboard", "Пробел", "АБВ", "hideKeyboard"] // "undoArrow"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "—", "delete"],
    ["$", "€", "£", "¥", "±", "·", "`", "[", "]", "{", "}", "return"],
    ["123", "§", "|", "~", "...",  "^", "\\", "<", ">", "!", "?", "123"],
    ["АБВ", "selectKeyboard", "Пробел", "АБВ", "hideKeyboard"] // "undoArrow"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["е", "ь"]
  static let keysWithAlternatesLeft = ["е"]
  static let keysWithAlternatesRight = ["ь"]

  static let eAlternateKeys = ["ë"]
  static let ьAlternateKeys = ["Ъ"]
}

// MARK: Spanish interface variables

public class SpanishKeyboardConstants {
  // Keyboard key layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ñ"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "espacio", "return"] // "undoArrow"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "\'", "delete"],
    ["ABC", "selectKeyboard", "espacio", "return"] // "undoArrow"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"],
    ["123", ".", ",", "?", "!", "\'", "delete"],
    ["ABC", "selectKeyboard", "espacio", "return"] // "undoArrow"
  ]

  static let letterKeysPad = [
    ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ñ", "return"],
    ["shift", "y", "x", "c", "v", "b", "n", "m", ",", ".", "shift"],
    [".?123", "selectKeyboard", "espacio", ".?123", "hideKeyboard"] // "undoArrow"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["@", "#", "$", "&", "*", "(", ")", "'", "\"", "+", "return"],
    ["#+=", "%", "_", "-", "=", "/", ";", ":", ",", ".", "#+="],
    ["ABC", "selectKeyboard", "espacio", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"],
    ["€", "£", "¥", "^", "[", "]", "{", "}", "ᵒ", "ᵃ", "return"],
    ["123", "§", "|", "~", "¶", "\\", "<", ">", "¡", "¿", "123"],
    ["ABC", "selectKeyboard", "espacio", "ABC", "hideKeyboard"] // "undoArrow"
  ]

  // Alternate key vars.
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
