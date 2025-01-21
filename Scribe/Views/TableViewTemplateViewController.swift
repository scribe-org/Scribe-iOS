// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Controls the table views within the app.
 */

import UIKit

final class TableViewTemplateViewController: BaseTableViewController {
  // MARK: Properties

  override var dataSet: [ParentTableCellModel] {
    tableData
  }

  private var tableData: [ParentTableCellModel] = []
  private var parentSection: Section?

  let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!

  private var langCode: String {
    guard let parentSection else {
      return ""
    }

    guard case let .specificLang(lang) = parentSection.sectionState else {
      return "de"
    }

    return lang
  }

  // MARK: Functions

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

  // Refreshes to check for changes when a translation language is selected
  override func viewWillAppear(_ animated: Bool) {
    for cell in tableView.visibleCells as! [InfoChildTableViewCell] where cell.section?.sectionState == .translateLang {
      let langTranslateLanguage = getKeyInDict(givenValue: (userDefaults.string(forKey: langCode + "TranslateLanguage") ?? "en"), dict: languagesAbbrDict)
      let currentLang = "app._global." + langTranslateLanguage.lowercased()
      cell.subLabel.text = NSLocalizedString(currentLang, value: langTranslateLanguage, comment: "")
    }
  }
}

// MARK: UITableViewDataSource

extension TableViewTemplateViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: InfoChildTableViewCell.reuseIdentifier,
      for: indexPath
    ) as? InfoChildTableViewCell else {
      fatalError("Failed to dequeue InfoChildTableViewCell.")
    }
    cell.parentSection = parentSection
    cell.configureCell(for: tableData[indexPath.section].section[indexPath.row])
    cell.backgroundColor = lightWhiteDarkBlackColor

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let tableSection = tableData[indexPath.section]
    let section = tableSection.section[indexPath.row]

    if section.sectionState == .translateLang {
      if let viewController = storyboard?.instantiateViewController(
        identifier: "SelectionViewTemplateViewController"
      ) as? SelectionViewTemplateViewController {
        var data = SettingsTableData.translateLangSettingsData

        // Removes keyboard language from possible translation languages
        let langCodeIndex = SettingsTableData.translateLangSettingsData[0].section.firstIndex(where: { s in
          s.sectionState == .specificLang(langCode)
        }) ?? -1
        data[0].section.remove(at: langCodeIndex)

        viewController.configureTable(for: data, parentSection: section, langCode: langCode)

        navigationController?.pushViewController(viewController, animated: true)
      }
    }
  }
}
