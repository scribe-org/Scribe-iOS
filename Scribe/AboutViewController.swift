//
//  AboutViewController.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 29/05/23.
//

import UIKit

class AboutViewController: UIViewController, UITableViewDataSource {
  
  @IBOutlet weak var communityTable: UITableView!
  @IBOutlet weak var communityTableUIView: UIView!
  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
  

  @IBOutlet weak var topSpace: UIView!
  
  @IBOutlet weak var communityLabel: UILabel!
  
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
    
    hideSeparators()
    styliseCommunityTableView()
    
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
  
  func styliseCommunityTableView() {
    //Label styling
    communityLabel.text = "Community"
    
    // Table View styling
//    communityTable.backgroundColor = .clear
    communityTableUIView.layer.cornerRadius = 27
    applyShadowEffects(elem: communityTableUIView)
    communityTable.clipsToBounds = true
    communityTable.isScrollEnabled = false
//    applyCornerRadius(elem: communityTable, radius: communityTable.frame.height * 0.4 / )
    communityTable.layer.cornerRadius = 27
  }
  
  func hideSeparators() {
    let aboutViewSpacers: [UIView] = [topSpace]
    for view in aboutViewSpacers {
      view.isUserInteractionEnabled = false
      view.backgroundColor = .clear
    }
  }
}
