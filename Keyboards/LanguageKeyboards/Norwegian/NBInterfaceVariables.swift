//
//  NBInterfaceVariables.swift
//
//  Constants and functions to load the Norwegian Bokmål Scribe keyboard.
//

import UIKit

public enum NorwegianBokmålKeyboardConstants {
  // iPhone keyboard layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ø", "æ"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "space", "return"], // "undo"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undo"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undo"
  ]

  // iPad keyboard layouts.
  static let letterKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"],
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ø", "æ", "return"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "?", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "undo"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "`", "delete"],
    ["@", "#", "kr", "&", "*", "(", ")", "'", "\"", "+", "·", "return"],
    ["#+=", "%", "_", "-", "=", "/", ";", ":", ",", ".", "≈", "#+="],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"],
    ["€", "$", "£", "^", "[", "]", "{", "}", "―", "ᵒ", "...", "return"],
    ["123", "§", "±", "|", "~", "≠", "\\", "<", ">", "!", "?", "123"],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  // Expanded iPad keyboard layouts for wider devices.
  static let letterKeysPadExpanded = [
    ["'", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "'", "delete"],
    ["indent", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å", "^", "*"],
    ["uppercase", "a", "s", "d", "f", "g", "h", "j", "k", "l", "ø", "æ", "@", "return"],
    ["shift", "<", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "microphone", "scribble"
  ]

  static let symbolKeysPadExpanded = [
    ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"],
    ["indent", "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|"],
    ["uppercase", "-", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "~", "return"], // "undo"
    ["shift", "...", ".", ",", "?", "!", "'", "\"", "_", "€"], // "redo"
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "microphone", "scribble"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "o", "u", "ä", "ö"]
  static let keysWithAlternatesLeft = ["a", "e"]
  static let keysWithAlternatesRight = ["o", "u", "æ", "ø"]

  static let aAlternateKeys = ["à", "ä", "á", "â", "ã", "ā"]
  static let eAlternateKeys = ["ë", "è", "é", "ê", "ę", "ė", "ē"]
  static let oAlternateKeys = ["ō", "œ", "õ", "ó", "ò", "ô"]
  static let uAlternateKeys = ["ū", "ú", "ù", "û", "ü"]
  static let æAlternateKeys = ["ä"]
  static let øAlternateKeys = ["ö"]
}

/// Gets the keys for the Norwegian Bokmål keyboard.
func getNBKeys() {}

/// Provides the Norwegian Bokmål keyboard layout.
func setNBKeyboardLayout() {}
