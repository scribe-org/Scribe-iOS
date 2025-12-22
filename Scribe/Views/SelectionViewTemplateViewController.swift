// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * This file describes
 */

import UIKit

final class SelectionViewTemplateViewController: BaseTableViewController {
  // MARK: - Properties

  override var dataSet: [ParentTableCellModel] {
    tableData
  }

  private var tableData: [ParentTableCellModel] = []
  private var parentSection: Section?
  private var selectedPath: IndexPath?

  let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!

  private var langCode: String = "de"

  // MARK: - Functions

  override func viewDidLoad() {
    super.viewDidLoad()
    edgesForExtendedLayout = .all
    extendedLayoutIncludesOpaqueBars = true
    tableView.register(
      UINib(nibName: "RadioTableViewCell", bundle: nil),
      forCellReuseIdentifier: RadioTableViewCell.reuseIdentifier
    )
  }

  func configureTable(for tableData: [ParentTableCellModel], parentSection: Section, langCode: String) {
    self.tableData = tableData
    self.parentSection = parentSection
    self.langCode = langCode

    title = parentSection.sectionTitle
  }
}

// MARK: - UITableViewDataSource

extension SelectionViewTemplateViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: RadioTableViewCell.reuseIdentifier,
      for: indexPath
    ) as? RadioTableViewCell else {
      fatalError("Failed to dequeue RadioTableViewCell.")
    }
    cell.parentSection = parentSection
    cell.configureCell(for: tableData[indexPath.section].section[indexPath.row])
    cell.backgroundColor = lightWhiteDarkBlackColor
    if cell.selectedLang == userDefaults.string(forKey: langCode + "TranslateLanguage") {
      selectedPath = indexPath
      cell.iconImageView.image = UIImage(named: "radioButtonSelected")
    }

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if selectedPath != nil {
      let previousCell = tableView.cellForRow(at: selectedPath!) as! RadioTableViewCell
      previousCell.iconImageView.image = UIImage(named: "radioButton")
    }

    let cell = tableView.cellForRow(at: indexPath) as! RadioTableViewCell
    cell.iconImageView.image = UIImage(named: "radioButtonSelected")
    selectedPath = indexPath

    let dictionaryKey = langCode + "TranslateLanguage"
    userDefaults.setValue(cell.selectedLang, forKey: dictionaryKey)

    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: true)
    }
    navigationController?.popViewController(animated: true)
  }
}
