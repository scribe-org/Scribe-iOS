//
//  TableViewTemplateViewController.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 30/06/23.
//

import UIKit

class TableViewTemplateViewController: UIViewController {
  @IBOutlet var mainTable: UITableView!
  
  var screenTitle = ""
  var tableData: [ParentTableCellModel] = []
  var parentSection: Section?
  
  var langCode: String {
    if let section = parentSection {
      guard case .specificLang(let lang) = section.sectionState else { return "all"}
      
      print(lang)
    }
    
    return ""
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = screenTitle
    
    let nib = UINib(nibName: "ParentTableViewCell", bundle: nil)
    mainTable.register(nib, forCellReuseIdentifier: "ParentTableViewCell")

    mainTable.dataSource = self
    mainTable.delegate = self

    mainTable.separatorStyle = .none
    mainTable.backgroundColor = .clear
  }
}

extension TableViewTemplateViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ParentTableViewCell", for: indexPath) as! ParentTableViewCell

    cell.configureCell(for: tableData[indexPath.row])

    cell.backgroundColor = .clear
    cell.selectionStyle = .none
    
    if let parentSection = parentSection {
      cell.parentSection = parentSection
    }

    return cell
  }
}

extension TableViewTemplateViewController: UITableViewDelegate { }
