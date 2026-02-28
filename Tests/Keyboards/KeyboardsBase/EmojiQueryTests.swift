// SPDX-License-Identifier: GPL-3.0-or-later

import Foundation
import XCTest

@testable import Scribe

class EmojiQueryTests: XCTestCase {

    override func setUpWithError() throws {
        controllerLanguage = "English"
    }

    func testQueryEmojisPatternMatchingWithCommonKeyword() {
        // This test assumes the database is populated with some emojis.
        // If not, it might return empty, which we also handle.
        let keyword = "happ"
        let results = LanguageDBManager.shared.queryEmojisPatternMatching(of: keyword)

        XCTAssertEqual(
            results.count, 9, "Should always return 9 elements (including empty strings)"
        )
    }

    func testQueryEmojisPatternMatchingWithEmptyKeyword() {
        let results = LanguageDBManager.shared.queryEmojisPatternMatching(of: "")
        XCTAssertEqual(results.count, 9)
    }

    func testQueryEmojisPatternMatchingWithNonExistentKeyword() {
        let results = LanguageDBManager.shared.queryEmojisPatternMatching(
            of: "nonexistentkeyword12345"
        )
        XCTAssertEqual(results.count, 9)
        XCTAssertEqual(results[0], "")
        XCTAssertEqual(results[1], "")
        XCTAssertEqual(results[2], "")
        XCTAssertEqual(results[3], "")
        XCTAssertEqual(results[4], "")
        XCTAssertEqual(results[5], "")
        XCTAssertEqual(results[6], "")
        XCTAssertEqual(results[7], "")
        XCTAssertEqual(results[8], "")
    }
}
