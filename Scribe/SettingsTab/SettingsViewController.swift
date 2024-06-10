/**
 * Functions for the Settings tab.
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
import SwiftUI

final class SettingsViewController: UIViewController {
  // MARK: - Constants

  private var sectionHeaderHeight: CGFloat = 0
  private let separatorInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

  private let tipCardState: Bool = {
    let userDefault = UserDefaults.standard
    let state = userDefault.object(forKey: "tipCardState") as? Bool ?? true
    return state
  }()

  func setHeaderHeight() {
    if DeviceType.isPad {
      sectionHeaderHeight = 42
    } else {
      sectionHeaderHeight = 32
    }
  }

  // MARK: - Properties

  @IBOutlet var footerFrame: UIView!
  @IBOutlet var footerButton: UIButton!
  @IBOutlet var parentTable: UITableView!

  var tableData = SettingsTableData.settingsTableData

  // MARK: - Functions

  override func viewDidLoad() {
    super.viewDidLoad()
    setHeaderHeight()

    title = NSLocalizedString("settings.title", comment: "The title for the settings screen")
    navigationItem.backButtonTitle = NSLocalizedString(
      "settings.title.backButton", comment: "The back button's title for the settings screen"
    )

    parentTable.register(
      UINib(nibName: "InfoChildTableViewCell", bundle: nil),
      forCellReuseIdentifier: InfoChildTableViewCell.reuseIdentifier
    )
    parentTable.dataSource = self
    parentTable.delegate = self
    parentTable.backgroundColor = .clear
    parentTable.sectionHeaderHeight = sectionHeaderHeight
    parentTable.separatorInset = separatorInset

    setFooterButtonView()

    DispatchQueue.main.async {
      self.parentTable.reloadData()

      self.commonMethodToRefresh()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    commonMethodToRefresh()
    showTipCardView()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeTipCardView()
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

    footerButton.setTitle("Install keyboards", for: .normal)
    footerButton.titleLabel?.font = .systemFont(ofSize: fontSize * 1.5, weight: .bold)

    footerButton.backgroundColor = appBtnColor
    if UITraitCollection.current.userInterfaceStyle == .dark {
      footerButton.layer.borderWidth = 1
      footerButton.layer.borderColor = scribeCTAColor.cgColor
    }
    footerButton.setTitleColor(lightTextDarkCTA, for: .normal)
    footerFrame.layer.cornerRadius = footerFrame.frame.width * 0.025
    footerButton.layer.cornerRadius = footerFrame.frame.width * 0.025
    footerButton.layer.shadowColor = UIColor(red: 0.247, green: 0.247, blue: 0.275, alpha: 0.25).cgColor
    footerButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
    footerButton.layer.shadowOpacity = 1.0
    footerButton.layer.masksToBounds = false

    footerButton.addTarget(self, action: #selector(openSettingsApp), for: .touchUpInside)
    footerButton.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
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
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: InfoChildTableViewCell.reuseIdentifier,
      for: indexPath
    ) as? InfoChildTableViewCell else {
      fatalError("Failed to dequeue InfoChildTableViewCell")
    }

    let section = tableData[indexPath.section]
    let setting = section.section[indexPath.row]

    cell.configureCell(for: setting)
    cell.backgroundColor = lightWhiteDarkBlackColor

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
      if let viewController = storyboard?.instantiateViewController(
        identifier: "TableViewTemplateViewController"
      ) as? TableViewTemplateViewController {
        // Copy base settings.
        var data = SettingsTableData.languageSettingsData

        // Check if the device is an iPad to determine period and comma on the ABC characters option.
        let periodCommaOptionIndex = SettingsTableData.languageSettingsData[0].section.firstIndex(where: { s in
            s.sectionTitle.elementsEqual("Period and comma on ABC")
        }) ?? -1

        if DeviceType.isPad {
          let periodCommaSettings = data[0].section.remove(at: periodCommaOptionIndex)
          print(periodCommaSettings)
        }

        // Languages where we can disable accent keys.
        let accentKeyLanguages: [String] = ["Swedish", "German", "Spanish"]
        let accentKeyOptionIndex = SettingsTableData.languageSettingsData[0].section.firstIndex(where: { s in
          s.sectionTitle.elementsEqual("Disable accent characters")
        }) ?? -1

        if accentKeyLanguages.firstIndex(of: section.sectionTitle) == nil && accentKeyOptionIndex != -1 {
          // As there are no accent keys we can remove the `Disable accent characters` option.
          let accentKeySettings = data[0].section.remove(at: accentKeyOptionIndex)
          print(accentKeySettings)
        } else if accentKeyLanguages.firstIndex(of: section.sectionTitle) != nil && accentKeyOptionIndex == -1 {
          data[0].section.insert(
            Section(
              sectionTitle: "Disable accent characters",
              imageString: "info.circle",
              hasToggle: true,
              sectionState: .none(.toggleAccentCharacters)
            ), at: 1
          )
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
    label.font = UIFont.boldSystemFont(ofSize: fontSize * 1.1)
    label.textColor = keyCharColor
    headerView.addSubview(label)

    return headerView
  }

  /// Function to open the settings app that is targeted by settingsBtn.
  @objc func openSettingsApp() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
      fatalError("Failed to create settings URL.")
    }
    UIApplication.shared.open(settingsURL)
  }

  /// Function to change the key coloration given a touch down.
  ///
  /// - Parameters
  ///  - sender: the button that has been pressed.
  @objc func keyTouchDown(_ sender: UIButton) {
    sender.backgroundColor = .black
    sender.alpha = 0.2

    // Bring sender's opacity back up to fully opaque and replace the background color.
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
      sender.backgroundColor = .clear
      sender.alpha = 1.0
    }
  }
}

// MARK: - TipCardView
extension SettingsViewController {
  private func showTipCardView() {
    let overlayView = TipCardView(infoText: "This is Settings View, where you can set languages setting for Scribe.",
                                  tipCardState: tipCardState)

    let hostingController = UIHostingController(rootView: overlayView)
    hostingController.view.frame = CGRect(x: 0, y: 0,
                                          width: self.view.bounds.width,
                                          height: self.view.bounds.height - 500)
    hostingController.view.backgroundColor = .clear
    addChild(hostingController)
    view.addSubview(hostingController.view)
    hostingController.didMove(toParent: self)
  }

  private func removeTipCardView() {
    if let hostingController = children.first(where: { $0 is UIHostingController<TipCardView> }) {
      hostingController.willMove(toParent: nil)
      hostingController.view.removeFromSuperview()
      hostingController.removeFromParent()
    }
  }
}
