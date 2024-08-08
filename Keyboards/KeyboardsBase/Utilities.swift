/**
 * Simple utility functions for data extraction and language management.
 *
 * Copyright (C) 2024 Scribe
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

/// Returns the ISO code given a language.
///
/// - Parameters
///   - language: the language an ISO code should be returned for.
func get_iso_code(keyboardLanguage: String) -> String {
  var iso = ""
  switch keyboardLanguage {
  case "French":
    iso = "fr"
  case "German":
    iso = "de"
  case "Italian":
    iso = "it"
  case "Portuguese":
    iso = "pt"
  case "Russian":
    iso = "ru"
  case "Spanish":
    iso = "es"
  case "Swedish":
    iso = "sv"
  default:
    break
  }

  return iso
}

/// Checks if an extra space is needed in the text field when generated text is inserted
func getOptionalSpace() -> String {
  if proxy.documentContextAfterInput?.first == " " {
    return ""
  } else {
    return " "
  }
}
