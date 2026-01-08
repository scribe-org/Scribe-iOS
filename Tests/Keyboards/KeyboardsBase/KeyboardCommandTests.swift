// SPDX-License-Identifier: GPL-3.0-or-later

import Foundation
@testable import Scribe
import XCTest

class KeyboardCommandTests: XCTestCase {
    
    func testColonToEmojiIsEnabled() {
        let keyboard = KeyboardViewController()
        // Default should be true as per the implementation
        XCTAssertTrue(keyboard.colonToEmojiIsEnabled())
    }
    
    // Note: Testing UI state transitions often requires a more complex setup
    // with UIInputViewController and its proxy. Here we test the logic we can.
}
