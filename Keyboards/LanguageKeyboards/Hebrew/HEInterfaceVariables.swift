/**
 * Constants and functions to load the Hebrew Scribe keyboard.
 *
 * Copyright (C) 2023 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

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
    [SpecialKeys.indent, "/", "'", "פ", "ם", "ן", "ו", "ט", "א", "ר", "ק", "[", "]", "+"],
    [SpecialKeys.capsLock, "ף", "ך", "ל", "ח", "י", "ע", "כ", "ג", "ד", "ש", ",", "\"", "return"], // "accent"
    ["shift", ";", "ץ", "ת", "צ", "מ", "נ", "ה", "ב", "ס", "ז", ".", "shift"],
    ["selectKeyboard", ".?123", "space", ".?123", "hideKeyboard"], // "microphone", "scribble"
  ]

  static let symbolKeysPadExpanded = [
    ["±", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "<", ">", "delete"],
    [SpecialKeys.indent, "[", "]", "{", "}", "#", "%", "^", "*", "+", "=", "\"", "|"],
    [SpecialKeys.capsLock, "-", "/", ":", ";", "(", ")", "$", "&", "@", "£", "¥", "~", "return"], // "undo"
    ["shift", "...", ".", ",", "?", "!", "'", "\"", "_", "€", "shift"], // "redo"
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
