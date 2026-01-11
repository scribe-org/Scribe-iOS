// SPDX-License-Identifier: GPL-3.0-or-later

import Foundation
@testable import Scribe
import XCTest

class EmojiQueryTests: XCTestCase {

    func testQueryEmojisPatternMatchingWithCommonKeyword() {
        // This test assumes the database is populated with some emojis.
        // If not, it might return empty, which we also handle.
        let keyword = "happ"
        let results = LanguageDBManager.shared.queryEmojisPatternMatching(of: keyword)

        XCTAssertEqual(results.count, 3, "Should always return 3 elements (including empty strings)")
    }

    func testQueryEmojisPatternMatchingWithEmptyKeyword() {
        let results = LanguageDBManager.shared.queryEmojisPatternMatching(of: "")
        XCTAssertEqual(results.count, 3)
    }

    func testQueryEmojisPatternMatchingWithNonExistentKeyword() {
        let results = LanguageDBManager.shared.queryEmojisPatternMatching(of: "nonexistentkeyword12345")
        XCTAssertEqual(results.count, 3)
        XCTAssertEqual(results[0], "")
        XCTAssertEqual(results[1], "")
        XCTAssertEqual(results[2], "")
    }
}
