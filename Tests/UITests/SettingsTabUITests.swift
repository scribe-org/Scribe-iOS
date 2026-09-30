// SPDX-License-Identifier: GPL-3.0-or-later

/*
 * UI tests for the Settings tab screen.
 */

import XCTest

final class SettingsTabUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Settings"].tap()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testSettingsTabIsSelected() {
        XCTAssertTrue(app.tabBars.buttons["Settings"].isSelected)
    }

    func testSettingsNavigationBarIsVisible() {
        let navBar = app.navigationBars["Settings"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 3))
    }

    func testSettingsTableViewIsVisible() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 3))
    }

    func testSettingsTableHasCells() {
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 3))
        XCTAssertGreaterThan(tableView.cells.count, 0)
    }
}
