/**
 * Define protocol for keyboard provider.
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
