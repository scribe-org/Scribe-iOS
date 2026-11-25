// SPDX-License-Identifier: GPL-3.0-or-later

/*
 * UI tests for app launch and tab bar navigation.
 */

import XCTest

final class AppLaunchUITests: XCTestCase {
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

    func testAppLaunchesSuccessfully() {
        XCTAssertTrue(app.state == .runningForeground)
    }

    func testTabBarHasThreeTabs() {
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists)
        XCTAssertEqual(tabBar.buttons.count, 3)
    }

    func testInstallationTabIsSelectedOnLaunch() {
        let installationTab = app.tabBars.buttons["Installation"]
        XCTAssertTrue(installationTab.isSelected)
    }

    func testNavigateToSettingsTab() {
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.tabBars.buttons["Settings"].isSelected)
    }

    func testNavigateToAboutTab() {
        app.tabBars.buttons["About"].tap()
        XCTAssertTrue(app.tabBars.buttons["About"].isSelected)
    }

    func testTabBarNavigationCycle() {
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.tabBars.buttons["Settings"].isSelected)

        app.tabBars.buttons["About"].tap()
        XCTAssertTrue(app.tabBars.buttons["About"].isSelected)

        app.tabBars.buttons["Installation"].tap()
        XCTAssertTrue(app.tabBars.buttons["Installation"].isSelected)
    }
}
