// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Define protocol for keyboard provider.
 */

import Foundation

protocol KeyboardProviderProtocol {
  static func genPhoneLetterKeys() -> [[String]]
  static func genPhoneNumberKeys(currencyKey: String) -> [[String]]
  static func genPhoneSymbolKeys(currencyKeys: [String]) -> [[String]]

  static func genPadLetterKeys() -> [[String]]
  static func genPadNumberKeys(currencyKey: String) -> [[String]]
  static func genPadSymbolKeys(currencyKeys: [String]) -> [[String]]

  static func genPadExpandedLetterKeys() -> [[String]]
  static func genPadExpandedSymbolKeys() -> [[String]]
}

protocol KeyboardProviderDisableAccentsProtocol {
  static func genPhoneDisableAccentsLetterKeys() -> [[String]]
  static func genPadDisableAccentsLetterKeys() -> [[String]]
  static func genPadExpandedDisableAccentsLetterKeys() -> [[String]]
}
