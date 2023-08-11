//
//  HEInterfaceVariables.swift
//
//  Constants and functions to load the Hebrew Scribe keyboard.
//

import UIKit

public enum HebrewKeyboardConstants {
  // iPhone keyboard layouts.
  static let letterKeysPhone = [
    ["פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "delete"],
    ["ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש"],
    ["ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז"],
    ["123", "selectKeyboard", "space", "return"], // "undo", "accent"
  ]

  static let numberKeysPhone = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
    ["#+=", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undo", "accent"
  ]

  static let symbolKeysPhone = [
    ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
    ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"],
    ["123", ".", ",", "?", "!", "'", "delete"],
    ["ABC", "selectKeyboard", "space", "return"], // "undo", "accent"
  ]

  // iPad keyboard layouts.
  static let letterKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "+"],
    [",", ".", "פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "delete"],
    ["ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש"],
    ["ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז", "return"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "undo"
  ]

  static let numberKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "delete"],
    ["!", "@", "#", "&", "_", "-", "'", "\"", "(", ")", "return"],
    ["#+=", "%", "...", "&", ";", ":", "=", "+", "/", "?", "#+="],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  static let symbolKeysPad = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "delete"],
    ["^", "€", "$", "£", "[", "]", "'", "\"", "<", ">", "return"],
    ["123", "§", "|", "~", "*", "·", "{", "}", "\\", "~", "123"],
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "undo"
  ]

  // Expanded iPad keyboard layouts for wider devices.
  static let letterKeysPadExpanded = [
    ["§", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "=", "delete"],
    ["indent", "/", "'", "פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "[", "]", "+"],
    ["uppercase", "ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש", ",", "\"", "return"], // "accent"
    ["shift", ";", "ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז", ".", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "microphone", "scribble"
  ]

  static let symbolKeysPadExpanded = [
    ["±", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"],
    ["indent", "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|"],
    ["uppercase", "-", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "~", "return"], // "undo"
    ["shift", "...", ".", ",", "?", "!", "'", "\"", "_", "€"], // "redo"
    ["selectKeyboard", "ABC", "space", "ABC", "hideKeyboard"], // "microphone", "scribble"
  ]

  // Alternate key vars.
  static let keysWithAlternates = [""]
  static let keysWithAlternatesLeft = [""]
  static let keysWithAlternatesRight = [""]
}

/// Gets the keys for the Hebrew keyboard.
func getHEKeys() {}

/// Provides the Hebrew keyboard layout.
func setHEKeyboardLayout() {}
