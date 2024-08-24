/**
 * Building a keyboard layout using a builder pattern.
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

protocol KeyboardBuilderProtocol {
  func addRow(_ row: [String]) -> KeyboardBuilder
  func build() -> [[String]]
  func replaceKey(row: Int, column: Int, to newKey: String) -> KeyboardBuilder
  func replaceKey(form oldKey: String, to newKey: String) -> KeyboardBuilder
}

class KeyboardBuilder: KeyboardBuilderProtocol {
  private var rows: [[String]] = []

  func addRow(_ row: [String]) -> KeyboardBuilder {
    rows.append(row)
    return self
  }

  func build() -> [[String]] {
    return rows
  }

  func replaceKey(row: Int, column: Int, to newKey: String) -> KeyboardBuilder {
    guard row < rows.count && column < rows[row].count else { return self }
    rows[row][column] = newKey

    return self
  }

  func replaceKey(form oldKey: String, to newKey: String) -> KeyboardBuilder {
    for (rowIndex, row) in rows.enumerated() {
        if let symbolIndex = row.firstIndex(of: oldKey) {
            rows[rowIndex][symbolIndex] = newKey
        }
    }
    return self
  }
}
