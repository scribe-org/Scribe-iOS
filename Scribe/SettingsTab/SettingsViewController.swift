//
//  SettingsViewController.swift
//

import UIKit

class SettingsViewController: UIViewController {
  @IBOutlet var footerFrame: UIView!
  @IBOutlet var footerButton: UIButton!

  @IBOutlet var parentTable: UITableView!

  let tableData = SettingsTableData.settingsTableData

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Scribe Settings"

    let nib = UINib(nibName: "ParentTableViewCell", bundle: nil)
    parentTable.register(nib, forCellReuseIdentifier: "ParentTableViewCell")

    parentTable.dataSource = self
    parentTable.delegate = self

    parentTable.separatorStyle = .none
    parentTable.backgroundColor = .clear

    setFooterButtonView()
  }

  func setFooterButtonView() {
    if tableData[1].section.count > 1 {
      parentTable.tableFooterView?.isHidden = true
    } else {
      parentTable.tableFooterView?.isHidden = false
    }

    applyShadowEffects(elem: footerFrame)
    footerButton.setTitle("Install keyboard", for: .normal)
    footerButton.titleLabel?.font = .systemFont(ofSize: fontSize * 1.5, weight: .bold)

    footerFrame.layer.cornerRadius = footerFrame.frame.height * 0.3
    footerButton.layer.cornerRadius = footerFrame.frame.height * 0.3
    footerButton.clipsToBounds = true
  }
}

extension SettingsViewController: UITableViewDataSource {
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return tableData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ParentTableViewCell", for: indexPath) as! ParentTableViewCell

    cell.configureCell(for: tableData[indexPath.row])

    cell.backgroundColor = .clear
    cell.selectionStyle = .none

    return cell
  }
}

extension SettingsViewController: UITableViewDelegate {}
