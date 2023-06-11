//
//  InfoChildTableViewCell.swift
//

import UIKit

class InfoChildTableViewCell: UITableViewCell {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var iconImageView: UIImageView!

  @IBOutlet var chevronImgView: UIImageView!
  @IBOutlet var toggleSwitch: UISwitch!

  var section: Section?

  func configureCell(for section: Section) {
    self.section = section
    titleLabel.text = section.sectionTitle

    if let image = UIImage(named: section.imageString) {
      iconImageView.image = image
    } else {
      iconImageView.image = UIImage(systemName: section.imageString)
    }

    if !section.hasToggle {
      toggleSwitch.isHidden = true
    } else {
      chevronImgView.isHidden = true
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
    didSet {
      self.invalidateIntrinsicContentSize()
    }
  }

  override func reloadData() {
    super.reloadData()
    invalidateIntrinsicContentSize()
  }
}
