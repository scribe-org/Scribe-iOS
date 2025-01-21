// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * A base table view controller for testing Scribe.
 */

import Foundation
@testable import Scribe
import XCTest

final class BaseTableViewControllerTest: XCTestCase {
  private var sut: BaseTableViewController!

  override func setUp() {
    super.setUp()
    sut = BaseTableViewController()
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testNumberOfSectionsZero() {
    let result = sut.numberOfSections(in: sut.tableView)

    XCTAssertEqual(result, 0)
  }
}
