/**
 * Functions for the Settings tab
 *
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

import UIKit

final class SettingsViewController: UIViewController {
  // MARK: - Constants

  private let sectionHeaderHeight: CGFloat = 32
  private let separatorInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

  // MARK: - Properties

  @IBOutlet var footerFrame: UIView!
  @IBOutlet var footerButton: UIButton!
  @IBOutlet var parentTable: UITableView!

  var tableData = SettingsTableData.settingsTableData

  // MARK: - Functions

  override func viewDidLoad() {
    super.viewDidLoad()

    title = NSLocalizedString("settings.title", comment: "The title for the settings screen")
    navigationItem.backButtonTitle = NSLocalizedString("settings.title.backButton", comment: "The back button's title for the settings screen")

    parentTable.register(UINib(nibName: "InfoChildTableViewCell", bundle: nil), forCellReuseIdentifier: InfoChildTableViewCell.reuseIdentifier)
    parentTable.dataSource = self
    parentTable.delegate = self
    parentTable.backgroundColor = .clear
    parentTable.sectionHeaderHeight = sectionHeaderHeight
    parentTable.separatorInset = separatorInset
    applyShadowEffects(elem: parentTable)

    setFooterButtonView()

    DispatchQueue.main.async {
      self.parentTable.reloadData()

      self.commonMethodToRefresh()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    commonMethodToRefresh()
  }

  func commonMethodToRefresh() {
    DispatchQueue.main.async {
      self.tableData[1].section = SettingsTableData.getInstalledKeyboardsSections()
      self.parentTable.reloadData()
      self.setFooterButtonView()
    }

    let notification = Notification(name: .keyboardsUpdatedNotification, object: nil, userInfo: nil)
    NotificationCenter.default.post(notification)
  }

  func setFooterButtonView() {
    if tableData.count > 1 && tableData[1].section.count != 0 {
      parentTable.tableFooterView?.isHidden = true
    } else {
      parentTable.tableFooterView?.isHidden = false
    }

    applyShadowEffects(elem: footerFrame)
    footerButton.setTitle("Install keyboard", for: .normal)
    footerButton.titleLabel?.font = .systemFont(ofSize: fontSize * 1.5, weight: .bold)

    footerFrame.layer.cornerRadius = footerFrame.frame.width * 0.05
    footerButton.layer.cornerRadius = footerFrame.frame.width * 0.05
    footerButton.clipsToBounds = true
  }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
  func numberOfSections(in _: UITableView) -> Int {
    tableData.count
  }

  func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    tableData[section].section.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: InfoChildTableViewCell.reuseIdentifier, for: indexPath) as! InfoChildTableViewCell

    let section = tableData[indexPath.section]
    let setting = section.section[indexPath.row]

    cell.configureCell(for: setting)

    return cell
  }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let tableSection = tableData[indexPath.section]
    let section = tableSection.section[indexPath.row]

    switch section.sectionState {
    case .specificLang:
      if let viewController = storyboard?.instantiateViewController(identifier: "TableViewTemplateViewController") as? TableViewTemplateViewController {
        // Copy base settings
        var data = SettingsTableData.languageSettingsData

        // Languages where we can disable accent keys.
        let accentKeyLanguages: [String] = ["Swedish", "German", "Spanish"]
        let accentKeyOptionIndex = SettingsTableData.languageSettingsData[0].section.firstIndex(where: {
          s in s.sectionTitle.elementsEqual("Disable accent characters")
        }) ?? -1

        if accentKeyLanguages.firstIndex(of: section.sectionTitle) == nil && accentKeyOptionIndex != -1 {
          // As there are no accent keys we can remove the `Disable accent characters` option.
          let accentKeySettings = data[0].section.remove(at: accentKeyOptionIndex)
          print(accentKeySettings)
        } else if accentKeyLanguages.firstIndex(of: section.sectionTitle) != nil && accentKeyOptionIndex == -1 {
          data[0].section.insert(Section(
            sectionTitle: "Disable accent characters",
            imageString: "info.circle",
            hasToggle: true,
            sectionState: .none(.toggleAccentCharacters)
          ), at: 1)
        }

        viewController.configureTable(for: data, parentSection: section)

        navigationController?.pushViewController(viewController, animated: true)
      }

    default: break
    }

    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: false)
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView: UIView

    if let reusableHeaderView = tableView.headerView(forSection: section) {
      headerView = reusableHeaderView
    } else {
      headerView = UIView(frame: CGRect(x: 0, y: 0, width: parentTable.bounds.width, height: 32))
    }

    let label = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.bounds.width, height: 32))
    label.text = tableData[section].headingTitle
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.textColor = .black
    headerView.addSubview(label)

    return headerView
  }
}
