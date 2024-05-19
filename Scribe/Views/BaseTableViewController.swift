/**
 * Base for table view in the Scribe app.
 *
 * Copyright (C) 2023 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import SwipeableTabBarController
import UIKit

class BaseTableViewController: UITableViewController {
  // MARK: - Constants

  private let sectionHeaderHeight: CGFloat = 32
  private let separatorInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

  // MARK: - Properties

  var dataSet: [ParentTableCellModel] {
    []
  }

  // MARK: - Functions

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.sectionHeaderHeight = sectionHeaderHeight
    tableView.register(
      UINib(nibName: "InfoChildTableViewCell", bundle: nil),
      forCellReuseIdentifier: "InfoChildTableViewCell"
    )
    tableView.separatorInset = separatorInset
    if let tabBarController = tabBarController as? SwipeableTabBarController {
      tabBarController.isCyclingEnabled = true
    }
  }
}

// MARK: - UITableViewDataSource

extension BaseTableViewController {
  override func numberOfSections(in _: UITableView) -> Int {
    dataSet.count
  }

  override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSet[section].section.count
  }
}

// MARK: - UITableViewDelegate

extension BaseTableViewController {
  override func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    headerView(for: section)
  }

  private func headerView(for section: Int) -> UIView? {
    let headerView: UIView

    if let reusableHeaderView = tableView.headerView(forSection: section) {
      headerView = reusableHeaderView
    } else {
      headerView = UIView(
        frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight)
      )
    }

    let label = UILabel(
      frame: CGRect(x: 0, y: 0, width: headerView.bounds.width, height: sectionHeaderHeight)
    )
    label.text = dataSet[section].headingTitle
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.textColor = keyCharColor
    headerView.addSubview(label)

    return headerView
  }
}
