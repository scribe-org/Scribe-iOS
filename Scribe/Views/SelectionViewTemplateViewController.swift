// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * This file describes
 */

import UIKit
import SwiftUI

final class SelectionViewTemplateViewController: BaseTableViewController {
  // MARK: Properties

  override var dataSet: [ParentTableCellModel] {
    tableData
  }

  private var tableData: [ParentTableCellModel] = []
  private var parentSection: Section?
  private var selectedPath: IndexPath?

  let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!

  private var langCode: String = "de"

  // MARK: Functions

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

    title = NSLocalizedString(
    "i18n.app.settings.keyboard.translation.select_source.title",
    value: "Translation language",
    comment: ""
  )
  }
}

// MARK: UITableViewDataSource

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
    let cell = tableView.cellForRow(at: indexPath) as! RadioTableViewCell
    let oldLang = userDefaults.string(forKey: langCode + "TranslateLanguage") ?? "en"
    let newLang = cell.selectedLang ?? "en"

    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: true)
    }

    // Only show popup if selecting a different language.
    if newLang != oldLang {
        let oldIndexPath = selectedPath
        updateRadioButton(to: indexPath, in: tableView)
        showPopup(oldLang: oldLang, newLang: newLang, oldIndexPath: oldIndexPath, newIndexPath: indexPath, tableView: tableView)
    }
  }

  private func updateRadioButton(to indexPath: IndexPath, in tableView: UITableView) {
    if selectedPath != nil {
      let previousCell = tableView.cellForRow(at: selectedPath!) as! RadioTableViewCell
      previousCell.iconImageView.image = UIImage(named: "radioButton")
    }

    let cell = tableView.cellForRow(at: indexPath) as! RadioTableViewCell
    cell.iconImageView.image = UIImage(named: "radioButtonSelected")
    selectedPath = indexPath
  }

  private func showPopup(oldLang: String, newLang: String, oldIndexPath: IndexPath?, newIndexPath: IndexPath, tableView: UITableView) {
    let oldSourceLanguage = getKeyInDict(givenValue: oldLang, dict: languagesAbbrDict)
    let newSourceLanguage = getKeyInDict(givenValue: newLang, dict: languagesAbbrDict)

    let infoText = NSLocalizedString("i18n.app.settings.keyboard.translation.change_source_tooltip.download_warning", value: "You've changed your source translation language. Would you like to download new data so that you can translate from {source_language}?", comment: "")

    let changeButtonText = NSLocalizedString("i18n.app.settings.keyboard.translation.change_source_tooltip.keep_source_language", value: "Keep {source_language}", comment: "")

    let confirmButtonText = NSLocalizedString("i18n.app._global.download_data", value: "Download data", comment: "")

    let localizedOldSourceLanguage = NSLocalizedString(
          "i18n.app._global." + oldSourceLanguage.lowercased(),
          value: oldSourceLanguage,
          comment: ""
        )
    let localizedNewSourceLanguage = NSLocalizedString(
          "i18n.app._global." + newSourceLanguage.lowercased(),
          value: newSourceLanguage,
          comment: ""
        )

    func onKeep() {
        // Keep old language - revert and dismiss.
        self.dismiss(animated: true) {
            if let oldPath = oldIndexPath {
                self.updateRadioButton(to: oldPath, in: tableView)
            }
        }
    }

    func confirmDownload() {
      self.dismiss(animated: true) {
        let dictionaryKey = self.langCode + "TranslateLanguage"
        self.userDefaults.setValue(newLang, forKey: dictionaryKey)

        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: NSNotification.Name("NavigateToDownloadScreen"), object: nil)
      }
    }

    let popupView = ConfirmTranslationSource(
        infoText: infoText.replacingOccurrences(of: "{source_language}", with: localizedNewSourceLanguage).replacingOccurrences(of: "{source_language}", with: localizedNewSourceLanguage),
        changeButtonText: changeButtonText.replacingOccurrences(of: "{source_language}", with: localizedOldSourceLanguage),
        confirmButtonText: confirmButtonText,
        onDismiss: { onKeep() },
        onChange: { onKeep()},
        onConfirm: { confirmDownload() }
    )

    let hostingController = UIHostingController(rootView: popupView)
    hostingController.modalPresentationStyle = .overFullScreen
    hostingController.modalTransitionStyle = .crossDissolve
    hostingController.view.backgroundColor = .clear

    present(hostingController, animated: true)
  }
}
