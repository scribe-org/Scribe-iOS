//
//  ParentTableViewCell.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 04/06/23.
//

import UIKit

class ParentTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var innerTable: UITableView!
  @IBOutlet weak var containerView: UIView!

  var data: AboutData?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let nib = UINib(nibName: "InfoChildTableViewCell", bundle: nil)
    innerTable.register(nib, forCellReuseIdentifier: "InfoChildTableViewCell")
    
    innerTable.dataSource = self
    innerTable.delegate = self
    innerTable.rowHeight = UITableView.automaticDimension
    innerTable.reloadData()
    
    applyShadowEffects(elem: containerView)
    containerView.layer.cornerRadius = 27
    innerTable.layer.cornerRadius = 27
    innerTable.clipsToBounds = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configureCell(for data: AboutData) {
    self.data = data
    self.titleLabel.text = data.headingTitle
  }
    
}

// MARK: UITableViewDataSource
/// Function implementation conforming to the UITableViewDataSource protocol.
extension ParentTableViewCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data?.section.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "InfoChildTableViewCell", for: indexPath) as! InfoChildTableViewCell
    
    // Configure the child cell
    if let data = data {
      cell.configureCell(for: data.section[indexPath.row])
    }
    
    return cell
  }
}

// MARK: UITableViewDelegate
/// Function implementation conforming to the UITableViewDelegate protocol.
extension ParentTableViewCell: UITableViewDelegate { }
