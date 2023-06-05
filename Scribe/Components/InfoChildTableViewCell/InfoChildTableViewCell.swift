//
//  InfoChildTableViewCell.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 04/06/23.
//

import UIKit

class InfoChildTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  
  var section: Section?
  
  func configureCell(for section: Section) {
    self.section = section
    self.titleLabel.text = section.sectionTitle
    
    if let image = UIImage(named: section.imageString) {
      self.iconImageView.image = image
    } else {
      self.iconImageView.image = UIImage(systemName: section.imageString)
    }
  }
    
}

/// Need this class so that rows of the child table resize the parent table cell.
/// Works similar to extending the UITableView class.
/// Without this, the child table views will not be visible until we manually specify a height for parent table cell.
class CustomChildTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
      }

      override var contentSize: CGSize {
        didSet{
          self.invalidateIntrinsicContentSize()
        }
      }

      override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
      }
}
