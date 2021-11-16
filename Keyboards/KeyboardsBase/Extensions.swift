//
//  Extensiosns.swift
//

import UIKit

/// Get the second to last element of an array.
extension Array {
  func penultimate() -> Element? {
    if self.count < 2 {
      return nil
    }
    let index = self.count - 2
    return self[index]
  }
}

/// Extensions to String to allow for easier indexing and extraction of substrings.
extension String {
  func index(fromIdx: Int) -> Index {
    return self.index(startIndex, offsetBy: fromIdx)
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
    return String(self[startIndex..<endIndex])
  }

  func insertPriorToCursor(char: String) -> String {
    return substring(toIdx: self.count - 1) + char + previewCursor
  }

  func deletePriorToCursor() -> String {
    return substring(toIdx: self.count - 2) + previewCursor
  }

  var isLowercase: Bool {
      return self == self.lowercased()
  }

  var isUppercase: Bool {
      return self == self.uppercased()
  }
}
