// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Building a keyboard layout using a builder pattern.
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
