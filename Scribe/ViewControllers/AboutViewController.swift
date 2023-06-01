//
//  AboutViewController.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 29/05/23.
//

import UIKit

class AboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var communityTable: UITableView!
  @IBOutlet weak var FSTable: UITableView!
  @IBOutlet weak var legalTable: UITableView!
  
  @IBOutlet weak var communityTableUIView: UIView!
  @IBOutlet weak var FSTableUIView: UIView!
  @IBOutlet weak var legalTableUIView: UIView!
  

  @IBOutlet weak var firstSpacer: UIView!
  @IBOutlet weak var secondSpacer: UIView!
  @IBOutlet weak var thirdSpacer: UIView!
  
  @IBOutlet weak var communityLabel: UILabel!
  @IBOutlet weak var FSLabel: UILabel!
  @IBOutlet weak var legalLabel: UILabel!
  
  let data = AboutSectionData()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "About Scribe"
    communityTable.dataSource = self
    FSTable.dataSource = self
    legalTable.dataSource = self
    communityTable.delegate = self
    
    let nib = UINib(nibName: "InfoTableViewCellNIB", bundle: nil)
    communityTable.register(nib, forCellReuseIdentifier: "InfoTableViewCellNIB")
    
    hideSeparators()
    styliseCommunityTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let selectedIndexPath = communityTable.indexPathForSelectedRow {
      communityTable.deselectRow(at: selectedIndexPath, animated: animated)
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == communityTable {
      return data.getCellTitleAndImage(forSection: .community).count
    } else if tableView == FSTable {
      return data.getCellTitleAndImage(forSection: .feedbackAndSupport).count
    } else {
      return data.getCellTitleAndImage(forSection: .legal).count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var rowItem: AboutSectionData.DataModel {
      if tableView == communityTable {
        return data.getCellTitleAndImage(forSection: .community)[indexPath.row]
      } else if tableView == FSTable {
        return data.getCellTitleAndImage(forSection: .feedbackAndSupport)[indexPath.row]
      } else {
        return data.getCellTitleAndImage(forSection: .legal)[indexPath.row]
      }
    }
    
    let cell = communityTable.dequeueReusableCell(withIdentifier: "InfoTableViewCellNIB", for: indexPath) as! InfoTableViewCellNIB
    
    cell.infoLabel.text = rowItem.title
    cell.infoImage.image = getRequiredIconForMenu(fontSize: fontSize * 0.9, imageName: rowItem.imageName)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let selectedRow = communityData[indexPath.row]
    
    if let vc = storyboard?.instantiateViewController(identifier: "InformationScreenVC") as? InformationScreenVC {
      vc.text = "Test description string"
//      vc.screenTitle = selectedRow.title
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  func styliseCommunityTableView() {
    
    let tables: [UITableView] = [communityTable, FSTable, legalTable]
    let tableUIViews: [UIView] = [communityTableUIView, FSTableUIView, legalTableUIView]
    
    //Label styling
    communityLabel.text = "Community"
    FSLabel.text = "Feedback and Support"
    legalLabel.text = "Legal"
    
    // Table View styling
    for i in 0...2 {
      tableUIViews[i].layer.cornerRadius = 27
      applyShadowEffects(elem: tableUIViews[i])
      tables[i].clipsToBounds = true
      tables[i].isScrollEnabled = false
      tables[i].layer.cornerRadius = 27
    }
    
  }
  
  func hideSeparators() {
    let aboutViewSpacers: [UIView] = [firstSpacer, secondSpacer, thirdSpacer]
    for view in aboutViewSpacers {
      view.isUserInteractionEnabled = false
      view.backgroundColor = .clear
    }
  }
}
