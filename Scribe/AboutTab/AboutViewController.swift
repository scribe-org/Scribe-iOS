//
//  AboutViewController.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 29/05/23.
//

import UIKit

class AboutViewController: UIViewController {
  
  @IBOutlet weak var outerTable: UITableView!
  
  let tableData = AboutTableData.aboutTableData

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "About Scribe"
  
    let nib = UINib(nibName: "ParentTableViewCell", bundle: nil)
    outerTable.register(nib, forCellReuseIdentifier: "ParentTableViewCell")
    
    outerTable.dataSource = self
    outerTable.delegate = self
    
    outerTable.separatorStyle = .none
    outerTable.backgroundColor = .clear
  }
}


// MARK: UITableViewDataSource
/// Function implementation conforming to the UITableViewDataSource protocol.
extension AboutViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
extension AboutViewController: UITableViewDelegate { }
