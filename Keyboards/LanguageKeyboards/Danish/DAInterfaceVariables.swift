//
//  DAInterfaceVariables.swift
//
//  Constants and functions to load the Danish Scribe keyboard.
//

import UIKit

public enum DanishKeyboardConstants {
  // iPhone keyboard layouts.
  static let letterKeysPhone = [
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "æ", "ø"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", "delete"],
    ["123", "selectKeyboard", "space", "return"], // "undo"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "€", "&", "@", "\""],
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
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "æ", "ø", "delete"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ö", "ä", "return"],
    ["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "undo"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "`", "delete"],
    ["@", "#", "kr", "&", "*", "(", ")", "'", "\"", "+", "·", "return"],
    ["#+=", "%", "_", "-", "=", "/", ";", ":", ",", ".", "?", "#+="],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "'", "delete"],
    ["€", "$", "£", "^", "[", "]", "{", "}", "―", "ᵒ", "...", "return"],
    ["123", "§", "|", "~", "≠", "≈", "\\", "<", ">", "!", "?", "123"],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  // Expanded iPad keyboard layouts for wider devices.
  static let letterKeysPadExpanded = [
    ["$", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "'", "delete"],
    [SpecialKeys.indent, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "å", "@", "*"],
    [SpecialKeys.capsLock, "a", "s", "d", "f", "g", "h", "j", "k", "l", "æ", "ø", "'", "return"],
    ["shift", "<", "z", "x", "c", "v", "b", "n", "m", ",", ".", "-", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "microphone", "scribble"
  ]

  static let symbolKeysPadExpanded = [
    ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"],
    [SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|"],
    [SpecialKeys.capsLock, "-", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "~", "return"], // "undo"
    ["shift", "...", ".", ",", "?", "!", "'", "\"", "_", "€", "shift"], // "redo"
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "microphone", "scribble"
  ]

  // Alternate key vars.
  static let keysWithAlternates = ["a", "e", "i", "o", "u", "y", "æ", "ø", "d", "l", "n", "s"]
  static let keysWithAlternatesLeft = ["a", "e", "y", "d", "s"]
  static let keysWithAlternatesRight = ["i", "o", "u", "æ", "ø", "l", "n"]

  static let aAlternateKeys = ["á", "ä", "à", "â", "ã", "ā"]
  static let eAlternateKeys = ["é", "ë"]
  static let iAlternateKeys = ["ï", "í"]
  static let oAlternateKeys = ["ö", "ō", "œ", "õ", "ø", "ò", "ô", "ó"]
  static let uAlternateKeys = ["ū", "ù", "û", "ü", "ú"]
  static let yAlternateKeys = ["ÿ"]
  static let æAlternateKeys = ["ä"]
  static let øAlternateKeys = ["ö"]
  static let dAlternateKeys = ["ð"]
  static let lAlternateKeys = ["ł"]
  static let nAlternateKeys = ["ń", "ñ"]
  static let sAlternateKeys = ["ß", "ś", "š"]
}

/// Gets the keys for the Danish keyboard.
func getDAKeys() {}

/// Provides the Danish keyboard layout.
func setDAKeyboardLayout() {}
