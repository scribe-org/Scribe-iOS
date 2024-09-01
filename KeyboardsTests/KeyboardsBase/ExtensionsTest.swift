import Foundation
@testable import Scribe
import XCTest

// MARK: secondToLast

class ExtensionTest: XCTestCase {
  func testSecondToLast_notNil() {
    let array = [1, 2, 3, 4, 5]

    let result = array.secondToLast()!

    XCTAssertEqual(result, 4)
  }

  func testSecondToLast_nil() {
    let array = [String]()

    let result = array.secondToLast()

    XCTAssertEqual(result, nil)
  }
}

// MARK: unique

extension ExtensionTest {
  func testUnique_uniqueElements_withoutDuplicates() {
    let array = [1, 2, 3, 4, 5]
    let expectedResult = [1, 2, 3, 4, 5]

    let result = array.unique()

    XCTAssertEqual(result, expectedResult)
  }

  func testUnique_uniqueElements_withDuplicates() {
    let array = [1, 2, 2, 4, 5]
    let expectedResult = [1, 2, 4, 5]

    let result = array.unique()

    XCTAssertEqual(result, expectedResult)
  }
}

// MARK: index

extension ExtensionTest {
  func testIndex_correctIndex_withValidIndex() {
    let string = "Hello, World!"
    let index = 5

    let result = string.index(fromIdx: index)

    XCTAssertEqual(result, string.index(string.startIndex, offsetBy: index))
  }
}

// MARK: substring(fromIdx:)

extension ExtensionTest {
  func testSubstringFromIdx_correctString_withValidIndex() {
    let string = "Hello, World!"
    let index = 7

    let result = string.substring(fromIdx: index)

    XCTAssertEqual(result, "World!")
  }

  func testSubstringToIdx_correctString_withValidIndex() {
    let string = "Hello, World!"
    let index = 5

    let result = string.substring(toIdx: index)

    XCTAssertEqual(result, "Hello")
  }

  func testSubstringWithRange_correctString_withValidRange() {
    let string = "Hello, World!"
    let range = Range(2 ... 4)

    let result = string.substring(with: range)

    XCTAssertEqual(result, "llo")
  }
}
