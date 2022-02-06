//
//  Extensions.swift
//
//  Extensions for Scribe keyboards.
//

import UIKit

/// Extension to access the second to last element of an array.
extension Array {
  func secondToLast() -> Element? {
    if self.count < 2 {
      return nil
    }
    let index = self.count - 2
    return self[index]
  }
}

/// Extensions to String to allow for easier indexing, substring extraction and checking for certain characteristics.
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
    return substring(toIdx: self.count - 1) + char + commandCursor
  }

  func deletePriorToCursor() -> String {
    return substring(toIdx: self.count - 2) + commandCursor
  }

  var isLowercase: Bool {
    return self == self.lowercased()
  }

  var isUppercase: Bool {
    return self == self.uppercased()
  }

  func count(of char: Character) -> Int {
    return reduce(0) {
      $1 == char ? $0 + 1 : $0
    }
  }
}

/// Adds the ability to efficiently trim whitespace at the end of a string.
extension StringProtocol {
  @inline(__always)
  var trailingSpacesTrimmed: Self.SubSequence {
    var view = self[...]

    while view.last?.isWhitespace == true {
      view = view.dropLast()
    }
    return view
  }
}
