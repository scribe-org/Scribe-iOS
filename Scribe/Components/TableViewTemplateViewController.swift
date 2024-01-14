//
//  TableViewTemplateViewController.swift
//

import UIKit

final class TableViewTemplateViewController: BaseTableViewController {

  // MARK: - Properties

  override var dataSet: [ParentTableCellModel] {
    tableData
  }

  private var tableData: [ParentTableCellModel] = []
  private var parentSection: Section?

  private var langCode: String {
    guard let parentSection else {
      return ""
    }

    guard case let .specificLang(lang) = parentSection.sectionState else {
      return "de"
    }

    return lang
  }

  // MARK: - Functions

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 250
    tableView.separatorStyle = .none
  }

  func configureTable(for tableData: [ParentTableCellModel], parentSection: Section) {
    self.tableData = tableData
    self.parentSection = parentSection

    title = parentSection.sectionTitle
  }
}

// MARK: - UITableViewDataSource

extension TableViewTemplateViewController {

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: InfoChildTableViewCell.reuseIdentifier, for: indexPath) as! InfoChildTableViewCell

    cell.parentSection = parentSection
    cell.configureCell(for: tableData[indexPath.section].section[indexPath.row])

    return cell
  }
}
