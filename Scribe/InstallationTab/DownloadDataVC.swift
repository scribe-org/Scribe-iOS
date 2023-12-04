//
//  ViewController.swift
//
//  The ViewController for the Download data screen of the Scribe app.
//

import UIKit

class DownloadDataVC: UIViewController {
  @IBOutlet var outerTable: UITableView!

  let tableData = DownloadDataTable.downloadDataTable

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.tintColor = .label
    title = "Download Data"

    let nib = UINib(nibName: "ParentTableViewCell", bundle: nil)
    outerTable.register(nib, forCellReuseIdentifier: "ParentTableViewCell")

    outerTable.dataSource = self
    outerTable.delegate = self

    outerTable.separatorStyle = .none
    outerTable.backgroundColor = .clear
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
}

/// Function implementation conforming to the UITableViewDataSource protocol.
extension DownloadDataVC: UITableViewDataSource {
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

// MARK: UITableViewDelegate

/// Function implementation conforming to the UITableViewDelegate protocol.
extension DownloadDataVC: UITableViewDelegate {}
