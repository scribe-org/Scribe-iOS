/**
 * Extensions with helper functions for Scribe keyboards.
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

import UIKit

/// Extension to access the second to last element of an array.
extension Array {
  func secondToLast() -> Element? {
    if count < 2 {
      return nil
    }
    let index = count - 2
    return self[index]
  }
}

extension Sequence where Iterator.Element: Hashable {
  func unique() -> [Iterator.Element] {
    var seen: [Iterator.Element: Bool] = [:]
    return filter { seen.updateValue(true, forKey: $0) == nil }
  }
}

/// Extensions to String to allow for easier indexing, substring extraction and checking for certain characteristics.
extension String {
  func index(fromIdx: Int) -> Index {
    return index(startIndex, offsetBy: fromIdx)
  }

  func substring(fromIdx: Int) -> String {
    let fromIndex = index(fromIdx: fromIdx)
    return String(self[fromIndex...])
  }

  func substring(toIdx: Int) -> String {
    let toIndex = index(fromIdx: toIdx)
    return String(self[..<toIndex])
  }

  func substring(with range: Range<Int>) -> String {
    let startIndex = index(fromIdx: range.lowerBound)
    let endIndex = index(fromIdx: range.upperBound)
    return String(self[startIndex ..< endIndex])
  }

  func insertPriorToCursor(char: String) -> String {
    return substring(toIdx: count - 1) + char + commandCursor
  }

  func deletePriorToCursor() -> String {
    return substring(toIdx: count - 2) + commandCursor
  }

  var isLowercase: Bool {
    return self == lowercased()
  }

  var isUppercase: Bool {
    return self == uppercased()
  }

  var isCapitalized: Bool {
    return self == prefix(1).uppercased() + lowercased().dropFirst()
  }

  func count(of char: Character) -> Int {
    return reduce(0) {
      $1 == char ? $0 + 1 : $0
    }
  }

  func capitalize() -> String {
    return prefix(1).uppercased() + lowercased().dropFirst()
  }

  var isNumeric: Bool {
    return Double(self) != nil
  }
}

/// Adds the ability to efficiently trim whitespace at the end of a string.
extension StringProtocol {
  @inline(__always)
  var trailingSpacesTrimmed: Self.SubSequence {
    var view = self[...]

    // Needs to be an explicit boolean comparison.
    while view.last?.isWhitespace == true {
      view = view.dropLast()
    }
    return view
  }
}

extension NSMutableAttributedString {
  func setColorForText(textForAttribute: String, withColor color: UIColor) {
    let range = mutableString.range(of: textForAttribute, options: .caseInsensitive)
    addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
  }
}
