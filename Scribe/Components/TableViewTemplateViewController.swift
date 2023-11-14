//
//  TableViewTemplateViewController.swift
//

import UIKit

final class TableViewTemplateViewController: UIViewController {
  @IBOutlet var mainTable: UITableView!

  var screenTitle: String = ""
  var tableData: [ParentTableCellModel] = []
  var parentSection: Section?

  var langCode: String {
    if let section = parentSection {
      guard case let .specificLang(lang) = section.sectionState else { return "de" }

      return lang
    }

    return ""
  }

  func configureTable(for tableData: [ParentTableCellModel], parentSection: Section) {
    self.tableData = tableData
    self.parentSection = parentSection
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = parentSection?.sectionTitle ?? "Unknown"

    mainTable.register(UINib(nibName: "InfoChildTableViewCell", bundle: nil), forCellReuseIdentifier: "InfoChildTableViewCell")
    mainTable.dataSource = self
    mainTable.delegate = self
    mainTable.rowHeight = UITableView.automaticDimension
    mainTable.sectionHeaderHeight = 32
    mainTable.estimatedRowHeight = 250
    mainTable.separatorStyle = .none
    mainTable.backgroundColor = .clear
  }
}

// MARK: - UITableViewDataSource

extension TableViewTemplateViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    tableData.count
  }

  func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableData[section].section.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "InfoChildTableViewCell", for: indexPath) as! InfoChildTableViewCell

    if let parentSection = parentSection {
      cell.parentSection = parentSection
    }

    cell.configureCell(for: tableData[indexPath.section].section[indexPath.row])

    return cell
  }
}

// MARK: - UITableViewDelegate

extension TableViewTemplateViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView: UIView

    if let reusableHeaderView = tableView.headerView(forSection: section) {
      headerView = reusableHeaderView
    } else {
      headerView = UIView(frame: CGRect(x: 0, y: 0, width: mainTable.bounds.width, height: 32))
    }

    let label = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.bounds.width, height: 32))
    label.text = tableData[section].headingTitle
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.textColor = .black
    headerView.addSubview(label)

    return headerView
  }
}
