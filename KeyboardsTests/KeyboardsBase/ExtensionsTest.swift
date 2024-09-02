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

// MARK: substring

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

// MARK: insertPriorToCursor

extension ExtensionTest {
  func testInsertPriorToCursor() {
    let string = "Hello"
    let char = "Scribe"
    let expectedResult = "HellScribe│"

    let result = string.insertPriorToCursor(char: char)

    XCTAssertEqual(result, expectedResult)
  }
}

// MARK: deletePriorToCursor

extension ExtensionTest {
  func testDeletePriorToCursor() {
    let string = "Hello"
    let expectedResult = "Hel│"

    let result = string.deletePriorToCursor()

    XCTAssertEqual(result, expectedResult)
  }
}

// MARK: isLowercase

extension ExtensionTest {
  func testIsLowercase() {
    XCTAssertEqual("hello".isLowercase, true)
    XCTAssertEqual("HELLO".isLowercase, false)
    XCTAssertEqual("Hello".isLowercase, false)
    // XCTAssertEqual("".isLowercase, false)
    XCTAssertEqual("👋🏻hello".isLowercase, true)
  }
}

// MARK: isUppercase

extension ExtensionTest {
  func testIsUppercase() {
    XCTAssertEqual("HELLO".isUppercase, true)
    XCTAssertEqual("Hello".isUppercase, false)
    XCTAssertEqual("hello".isUppercase, false)
    // XCTAssertEqual("".isUppercase, false)
    XCTAssertEqual("👋🏻HELLO".isUppercase, true)
  }
}

// MARK: isCapitalized

extension ExtensionTest {
  func testIsCapitalized() {
    XCTAssertEqual("Hello".isCapitalized, true)
    XCTAssertEqual("hello".isCapitalized, false)
    XCTAssertEqual("HELLO".isCapitalized, false)
    // XCTAssertEqual("".isCapitalized, false)
    XCTAssertEqual("👋🏻HELLO".isCapitalized, false)
  }
}

// MARK: count

extension ExtensionTest {
  func testCount() {
    XCTAssertEqual("Hello!World!".count(of: "!"), 2)
    XCTAssertEqual("Hello!World!".count(of: ","), 0)
    XCTAssertEqual("Hello!World!".count(of: "l"), 3)
    XCTAssertEqual("".count(of: "!"), 0)
    XCTAssertEqual("👋🏻".count(of: "👋🏻"), 1)
  }
}

// MARK: capitalize

extension ExtensionTest {
  func testCapitalize() {
    XCTAssertEqual("hello".capitalize(), "Hello")
    XCTAssertEqual("HELLO".capitalize(), "Hello")
    XCTAssertEqual("hELLO".capitalize(), "Hello")
    XCTAssertEqual("".capitalize(), "")
    XCTAssertEqual("👋🏻hello".capitalize(), "👋🏻hello")
  }
}

// MARK: isNumeric

extension ExtensionTest {
  func testIsNumberic() {
    XCTAssertEqual("123".isNumeric, true)
    XCTAssertEqual("0123".isNumeric, true)
    XCTAssertEqual("hello".isNumeric, false)
    XCTAssertEqual("👋🏻".isNumeric, false)
  }
}

// MARK: trailingSpacesTrimmed

extension ExtensionTest {
  func testTrailingSpacesTrimmed() {
    XCTAssertEqual("".trailingSpacesTrimmed, "")
    XCTAssertEqual("Hello ".trailingSpacesTrimmed, "Hello")
    XCTAssertEqual("Hello".trailingSpacesTrimmed, "Hello")
  }
}

// MARK: setColorForText

extension ExtensionTest {
  func testSetColorForText() {
    let string = "Hello, World!"
    let attributedString = NSMutableAttributedString(string: string)
    let textForAttribute = "World"
    let color = UIColor.scribeBlue

    attributedString.setColorForText(textForAttribute: textForAttribute, withColor: color)

    let range = (attributedString.string as NSString).range(of: textForAttribute, options: .caseInsensitive)

    attributedString.enumerateAttribute(.foregroundColor, in: range, options: []) { value, _, _ in
      XCTAssertEqual(value as! UIColor, color)
    }
  }

  func testSetColor_doNotSetColor_withNonExistingText() {
    let string = "Hello, World!"
    let attributedString = NSMutableAttributedString(string: string)
    let textForAttribute = "Universe"
    let color = UIColor.red

    attributedString.setColorForText(textForAttribute: textForAttribute, withColor: color)

    let range = (attributedString.string as NSString).range(of: textForAttribute, options: .caseInsensitive)
    XCTAssertEqual(range.location, NSNotFound)
  }
}
