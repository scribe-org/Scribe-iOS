// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Base for table view in the Scribe app.
 */

import SwipeableTabBarController
import UIKit

class BaseTableViewController: UITableViewController {
  // MARK: Constants

  private var sectionHeaderHeight: CGFloat = 0
  private let separatorInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

  func setHeaderHeight() {
    if DeviceType.isPad {
      sectionHeaderHeight = 48
    } else {
      sectionHeaderHeight = 32
    }
  }

  // MARK: Properties

  var dataSet: [ParentTableCellModel] {
    []
  }

  // MARK: Functions

  override func viewDidLoad() {
    super.viewDidLoad()
    setHeaderHeight()

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

// MARK: UITableViewDataSource

extension BaseTableViewController {
  override func numberOfSections(in _: UITableView) -> Int {
    dataSet.count
  }

  override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSet[section].section.count
  }
}

// MARK: UITableViewDelegate

extension BaseTableViewController {
  override func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return headerView(for: section)
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

    let label = UILabel()
    label.text = dataSet[section].headingTitle
    label.font = UIFont.boldSystemFont(ofSize: fontSize * 1.1)
    label.textColor = keyCharColor
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.8
    label.textAlignment = .natural

    label.translatesAutoresizingMaskIntoConstraints = false
    headerView.addSubview(label)

    let horizontalPadding: CGFloat = 8
    let verticalPadding: CGFloat = 4

    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: horizontalPadding),
      label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -horizontalPadding),
      label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: verticalPadding),
      label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -verticalPadding)
    ])

    return headerView
  }

  override func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let label = UILabel()
    label.text = dataSet[section].headingTitle
    label.font = UIFont.boldSystemFont(ofSize: fontSize * 1.1)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping

    let horizontalPadding: CGFloat = 32
    let verticalPadding: CGFloat = 24

    let constrainedWidth = tableView.bounds.width - horizontalPadding
    let size = label.sizeThatFits(CGSize(width: constrainedWidth, height: CGFloat.greatestFiniteMagnitude))

    return size.height + verticalPadding
  }
}
