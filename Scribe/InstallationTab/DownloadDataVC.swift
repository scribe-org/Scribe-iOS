/**
 * The ViewController for the Download data screen of the Scribe app.
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

// class DownloadDataVC: UIViewController {
//  @IBOutlet var outerTable: UITableView!
//
//  let tableData = DownloadDataTable.downloadDataTable
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    navigationController?.navigationBar.tintColor = .label
//    title = "Download Data"
//
//    let nib = UINib(nibName: "ParentTableViewCell", bundle: nil)
//    outerTable.register(nib, forCellReuseIdentifier: "ParentTableViewCell")
//
//    outerTable.dataSource = self
//    outerTable.delegate = self
//
//    outerTable.separatorStyle = .none
//    outerTable.backgroundColor = .clear
//  }
//
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    navigationController?.setNavigationBarHidden(false, animated: animated)
//  }
// }
//
///// Function implementation conforming to the UITableViewDataSource protocol.
// extension DownloadDataVC: UITableViewDataSource {
//  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
//    return tableData.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "ParentTableViewCell", for: indexPath) as! ParentTableViewCell
//
//    cell.configureCell(for: tableData[indexPath.row])
//
//    cell.backgroundColor = .clear
//    cell.selectionStyle = .none
//
//    return cell
//  }
// }
//

// MARK: - UITableViewDelegate

//
///// Function implementation conforming to the UITableViewDelegate protocol.
// extension DownloadDataVC: UITableViewDelegate {}
