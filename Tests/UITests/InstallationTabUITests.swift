// SPDX-License-Identifier: GPL-3.0-or-later

/*
 * UI tests for the Installation tab screens.
 */

import XCTest

final class InstallationTabUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testInstallationHeaderIsVisible() {
        let header = app.staticTexts["Keyboard installation"]
        XCTAssertTrue(header.waitForExistence(timeout: 3))
    }

    func testQuickTutorialButtonIsVisible() {
        let tutorialButton = app.buttons["Quick tutorial"]
        XCTAssertTrue(tutorialButton.waitForExistence(timeout: 3))
    }

    func testDownloadDataCardIsVisible() {
        let downloadText = app.staticTexts["Download keyboard data"]
        XCTAssertTrue(downloadText.waitForExistence(timeout: 3))
    }

    func testTapDownloadDataCardNavigatesToDownloadScreen() {
        let downloadText = app.staticTexts["Download keyboard data"]
        XCTAssertTrue(downloadText.waitForExistence(timeout: 3))
        downloadText.tap()

        let downloadTitle = app.navigationBars["Download data"]
        XCTAssertTrue(downloadTitle.waitForExistence(timeout: 3))
    }

    func testDownloadScreenBackNavigationReturnsToInstallation() {
        let downloadText = app.staticTexts["Download keyboard data"]
        XCTAssertTrue(downloadText.waitForExistence(timeout: 3))
        downloadText.tap()

        XCTAssertTrue(app.navigationBars["Download data"].waitForExistence(timeout: 3))

        app.navigationBars.buttons["Installation"].tap()

        let header = app.staticTexts["Keyboard installation"]
        XCTAssertTrue(header.waitForExistence(timeout: 3))
    }

    func testTappingInstallationTabAgainPopsToRoot() {
        let downloadText = app.staticTexts["Download keyboard data"]
        XCTAssertTrue(downloadText.waitForExistence(timeout: 3))
        downloadText.tap()

        XCTAssertTrue(app.navigationBars["Download data"].waitForExistence(timeout: 3))

        app.tabBars.buttons["Installation"].tap()

        let header = app.staticTexts["Keyboard installation"]
        XCTAssertTrue(header.waitForExistence(timeout: 3))
    }
}
