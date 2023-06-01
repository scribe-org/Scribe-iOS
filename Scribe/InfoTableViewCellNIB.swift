//
//  InforNIBTableViewCell.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 01/06/23.
//

import UIKit

class InfoTableViewCellNIB: UITableViewCell {
  
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var infoImage: UIImageView!

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
    
}
