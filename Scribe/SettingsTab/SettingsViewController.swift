/**
 * Functions for the Settings tab.
 *
 * Copyright (C) 2024 Scribe
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
  // MARK: Constants

  private var sectionHeaderHeight: CGFloat = 0
  private let separatorInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

  private let settingsTipCardState: Bool = {
    let userDefault = UserDefaults.standard
    let state = userDefault.object(forKey: "settingsTipCardState") as? Bool ?? true
    return state
  }()

  func setHeaderHeight() {
    if DeviceType.isPad {
      sectionHeaderHeight = 42
    } else {
      sectionHeaderHeight = 32
    }
  }

  // MARK: Properties

  @IBOutlet var footerFrame: UIView!
  @IBOutlet var footerButton: UIButton!
  @IBOutlet var parentTable: UITableView!

  var tableData = SettingsTableData.settingsTableData

  // MARK: Functions

  override func viewDidLoad() {
    super.viewDidLoad()
    setHeaderHeight()
    showTipCardView()

    title = NSLocalizedString("app.settings.title", value: "Settings", comment: "")
    navigationItem.backButtonTitle = title

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

// MARK: UITableViewDataSource

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

// MARK: UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let tableSection = tableData[indexPath.section]
    let section = tableSection.section[indexPath.row]

    switch section.sectionState {
    case .appLang:
      let preferredLanguages = NSLocale.preferredLanguages
      if preferredLanguages.count == 1 {
        let alert = UIAlertController(
          title: "No languages installed", message: "You only have one language installed on your device. Please install more languages in Settings and then you can select different localizations of Scribe.", preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
      } else {
        openSettingsApp()
      }

    case .specificLang:
      if let viewController = storyboard?.instantiateViewController(
        identifier: "TableViewTemplateViewController"
      ) as? TableViewTemplateViewController {
        // Copy base settings.
        var data = SettingsTableData.languageSettingsData
        // Check if the device is an iPad to remove the Layout Section.
        if DeviceType.isPad {
          for menuOption in data[1].section {
            if menuOption.sectionState == .none(.toggleAccentCharacters) ||
                menuOption.sectionState == .none(.toggleCommaAndPeriod) {
              data[1].section.remove(at: 0)
            }
          }
          if data[1].section.isEmpty {
            data.remove(at: 1)
          }
        } else {
          // Languages where we can disable accent keys.
          let accentKeyLanguages: [String] = [
            languagesStringDict["German"]!,
            languagesStringDict["Spanish"]!,
            languagesStringDict["Swedish"]!
          ]

          let accentKeyOptionIndex = SettingsTableData.languageSettingsData[1].section.firstIndex(where: { s in
            s.sectionTitle.elementsEqual(NSLocalizedString("app.settings.keyboard.layout.disable_accent_characters", value: "Disable accent characters", comment: ""))
          }) ?? -1

          // If there are no accent keys we can remove the `Disable accent characters` option.
          if accentKeyLanguages.firstIndex(of: section.sectionTitle) == nil && accentKeyOptionIndex != -1 {
            data[1].section.remove(at: accentKeyOptionIndex)
          } else if accentKeyLanguages.firstIndex(of: section.sectionTitle) != nil && accentKeyOptionIndex == -1 {
            data[1].section.insert(SettingsTableData.languageSettingsData[2].section[2], at: 1)
          }
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

    let label = UILabel(
      frame: CGRect(
        x: preferredLanguage.prefix(2) == "ar" ? -1 * headerView.bounds.width / 10: 0,
        y: 0,
        width: headerView.bounds.width,
        height: 32
      )
    )

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

// MARK: TipCardView
extension SettingsViewController {
  private func showTipCardView() {
    let overlayView = SettingsTipCardView(
      settingsTipCardState: settingsTipCardState
    )

    let hostingController = UIHostingController(rootView: overlayView)
    hostingController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: -20)
    hostingController.view.backgroundColor = .clear
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false

    let navigationView = navigationController?.navigationBar
    guard let navigationView else { return }
    navigationView.addSubview(hostingController.view)
    navigationView.bringSubviewToFront(hostingController.view)

    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: navigationView.topAnchor, constant: 30),
      hostingController.view.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor)
    ])
    hostingController.didMove(toParent: self)
    startGlowingEffect(on: hostingController.view)
  }

  func startGlowingEffect(on view: UIView, duration: TimeInterval = 1.0) {
    view.layer.shadowColor = UIColor.scribeCTA.cgColor
    view.layer.shadowRadius = 8
    view.layer.shadowOpacity = 0.0
    view.layer.shadowOffset = CGSize(width: 0, height: 0)

    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: [.curveEaseOut, .autoreverse],
      animations: {
        view.layer.shadowOpacity = 0.6
      }, completion: nil)
  }
}
