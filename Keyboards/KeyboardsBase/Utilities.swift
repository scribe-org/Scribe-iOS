//
//  Utilities.swift
//
//  Simple utility functions for data extraction and language management.
//

/// Returns the ISO code given a language.
///
/// - Parameters
///   - language: the language an ISO code should be returned for.
func get_iso_code(keyboardLanguage: String) -> String {
  var iso = ""
  switch keyboardLanguage {
  case "French_AZERTY":
    iso = "fr"
  case "French_QWERTY":
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
