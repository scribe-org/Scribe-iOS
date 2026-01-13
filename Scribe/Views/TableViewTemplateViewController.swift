// SPDX-License-Identifier: GPL-3.0-or-later

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
  private let cornerRadius: CGFloat = 12

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

    tableView.register(
      WrapperCell.self,
      forCellReuseIdentifier: WrapperCell.reuseIdentifier
    )

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 250
    tableView.separatorStyle = .none
  }

  func configureTable(for tableData: [ParentTableCellModel], parentSection: Section) {
    self.tableData = tableData
    self.parentSection = parentSection

    title = parentSection.sectionTitle
  }

  // Refreshes to check for changes when a translation language is selected.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    for visibleCell in tableView.visibleCells {
        // Cast to wrapper cell first.
        guard let wrapperCell = visibleCell as? WrapperCell,
          let innerCell = wrapperCell.wrappedCell as? InfoChildTableViewCell else {
          continue
        }

        // Now check if it's a translate lang section.
        guard innerCell.section?.sectionState == .translateLang else {
          continue
        }

      let langTranslateLanguage = getKeyInDict(givenValue: (userDefaults.string(forKey: langCode + "TranslateLanguage") ?? "en"), dict: languagesAbbrDict)
      let currentLang = "i18n.app._global." + langTranslateLanguage.lowercased()
      innerCell.subLabel.text = NSLocalizedString(currentLang, value: langTranslateLanguage, comment: "")
    }
  }
}

// MARK: UITableViewDataSource

extension TableViewTemplateViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: WrapperCell.reuseIdentifier,
      for: indexPath
    ) as? WrapperCell else {
      fatalError("Failed to dequeue WrapperCell")
    }

    let section = dataSet[indexPath.section]
    let setting = section.section[indexPath.row]

    cell.configure(withCellNamed: "InfoChildTableViewCell", section: setting, parentSection: self.parentSection)

    let isFirstRow = indexPath.row == 0
    let isLastRow = indexPath.row == section.section.count - 1
    WrapperCell.applyCornerRadius(to: cell, isFirst: isFirstRow, isLast: isLastRow)

    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let section = dataSet[indexPath.section]
    let setting = section.section[indexPath.row]

    // If there's no description, return a fixed small height
    guard let description = setting.shortDescription else {
        return 54.0
    }

    // Calculate available width for text
    let availableWidth = tableView.bounds.width - 32

    let titleFont: UIFont
    let descFont: UIFont

    if DeviceType.isPad {
      titleFont = UIFont.systemFont(ofSize: 24, weight: .medium)
      descFont = UIFont.systemFont(ofSize: 18)
    } else {
      titleFont = UIFont.systemFont(ofSize: 16, weight: .medium)
      descFont = UIFont.systemFont(ofSize: 14)
    }

    // Calculate actual height needed for title text
    let titleHeight = setting.sectionTitle.boundingRect(
      with: CGSize(width: availableWidth, height: .greatestFiniteMagnitude),
      options: .usesLineFragmentOrigin,
      attributes: [.font: titleFont],
      context: nil
    ).height

    // Calculate actual height needed for description text
    let descHeight = description.boundingRect(
      with: CGSize(width: availableWidth, height: .greatestFiniteMagnitude),
      options: .usesLineFragmentOrigin,
      attributes: [.font: descFont],
      context: nil
    ).height

    // Return total height: title + description + padding buffer
    return ceil(titleHeight + descHeight + 52)
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let tableSection = tableData[indexPath.section]
    let section = tableSection.section[indexPath.row]

    if section.sectionState == .translateLang {
      if let viewController = storyboard?.instantiateViewController(
        identifier: "SelectionViewTemplateViewController"
      ) as? SelectionViewTemplateViewController {
        var data = SettingsTableData.translateLangSettingsData

        // Removes keyboard language from possible translation languages.
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
