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
  
  struct InfoCells {
    let title: String
    let imageName: String
  }
  
  let communityData: [InfoCells] = [
    InfoCells(title: "See the code on GitHub", imageName: "text.insert"),
    InfoCells(title: "Share Scribe", imageName: "square.and.arrow.up")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "About Scribe"
    communityTable.dataSource = self
    communityTable.delegate = self
    
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
    return communityData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rowItem = communityData[indexPath.row]
    let cell = communityTable.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as! InfoTableViewCell
    cell.iconImageView.image = UIImage(systemName: rowItem.imageName)
    cell.label.text = rowItem.title
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedRow = communityData[indexPath.row]
    
    if let vc = storyboard?.instantiateViewController(identifier: "InformationScreenVC") as? InformationScreenVC {
      vc.text = "Test description string"
      vc.screenTitle = selectedRow.title
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
      let tableDimensions = tables[i].contentSize
      let height = tableDimensions.height
      
      tableUIViews[i].layer.cornerRadius = 27
      applyShadowEffects(elem: tableUIViews[i])
      tables[i].clipsToBounds = true
      tables[i].isScrollEnabled = false
  //    applyCornerRadius(elem: communityTable, radius: communityTable.frame.height * 0.4 / )
      tables[i].layer.cornerRadius = 27
    }
//    communityTable.backgroundColor = .clear
    
  }
  
  func hideSeparators() {
    let aboutViewSpacers: [UIView] = [firstSpacer, secondSpacer, thirdSpacer]
    for view in aboutViewSpacers {
      view.isUserInteractionEnabled = false
      view.backgroundColor = .clear
    }
  }
}
