//
//  BaseTableViewControllerTest.swift
//  Tests
//
//  Created by Kailash Bora on 04/09/24.
//

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
