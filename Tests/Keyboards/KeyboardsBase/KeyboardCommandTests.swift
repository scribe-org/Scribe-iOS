// SPDX-License-Identifier: GPL-3.0-or-later

import Foundation
@testable import Scribe
import XCTest

class KeyboardCommandTests: XCTestCase {

    func testColonToEmojiIsEnabled() {
        let keyboard = KeyboardViewController()
        // Default should be true as per the implementation.
        XCTAssertTrue(keyboard.colonToEmojiIsEnabled())
    }
}
