/**
 * A base table view controller for testing Scribe.
 *
 * Copyright (C) 2024 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
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
