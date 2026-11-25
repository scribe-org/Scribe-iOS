// SPDX-License-Identifier: GPL-3.0-or-later

/*
 * UI tests for the About tab screen.
 */

import XCTest

final class AboutTabUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["About"].tap()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testAboutTabIsSelected() {
        XCTAssertTrue(app.tabBars.buttons["About"].isSelected)
    }

    func testAboutNavigationBarIsVisible() {
        let navBar = app.navigationBars["About"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 3))
    }

    func testAboutTableViewIsVisible() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 3))
    }

    func testAboutTableHasCells() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 3))
        XCTAssertGreaterThan(tableView.cells.count, 0)
    }

    func testPrivacyPolicyCellNavigatesToInformationScreen() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 3))

        let privacyCell = tableView.staticTexts["Privacy policy"]
        XCTAssertTrue(privacyCell.waitForExistence(timeout: 3))
        privacyCell.tap()

        let infoNavBar = app.navigationBars["Privacy policy"]
        XCTAssertTrue(infoNavBar.waitForExistence(timeout: 3))
    }
}
