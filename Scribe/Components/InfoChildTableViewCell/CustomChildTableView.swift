//
//  CustomChildTableView.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 30/06/23.
//

import UIKit

/// Need this class so that rows of the child table resize the parent table cell.
/// Works similar to extending the UITableView class.
/// Without this, the child table views will not be visible until we manually specify a height for parent table cell.
class CustomChildTableView: UITableView {
  override var intrinsicContentSize: CGSize {
    self.layoutIfNeeded()
    return self.contentSize
  }

  override var contentSize: CGSize {
    didSet {
      self.invalidateIntrinsicContentSize()
    }
  }

  override func reloadData() {
    super.reloadData()
    invalidateIntrinsicContentSize()
  }
}
