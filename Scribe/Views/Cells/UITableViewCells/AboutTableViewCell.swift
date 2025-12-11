// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Class for a button component with a label, icon and link icon.
 */

import UIKit

final class AboutTableViewCell: UITableViewCell {

  // MARK: Constants

  static let reuseIdentifier = String(describing: InfoChildTableViewCell.self)

  // MARK: Properties

  @IBOutlet var titleLabelPhone: UILabel!
  @IBOutlet var titleLabelPad: UILabel!
  var titleLabel: UILabel!

  @IBOutlet var iconImageViewPhone: UIImageView!
  @IBOutlet var iconImageViewPad: UIImageView!
  var iconImageView: UIImageView!

  @IBOutlet var linkImageViewPhone: UIImageView!
  @IBOutlet var linkImageViewPad: UIImageView!
  var linkImageView: UIImageView!

  private var section: Section?
  private var parentSection: Section?

  func setTableView() {
    if DeviceType.isPad {
      titleLabel = titleLabelPad
      iconImageView = iconImageViewPad
      linkImageView = linkImageViewPad

      titleLabelPhone.removeFromSuperview()
      iconImageViewPhone.removeFromSuperview()
      linkImageViewPhone.removeFromSuperview()
    } else {
      titleLabel = titleLabelPhone
      iconImageView = iconImageViewPhone
      linkImageView = linkImageViewPhone

      titleLabelPad.removeFromSuperview()
      iconImageViewPad.removeFromSuperview()
      linkImageViewPad.removeFromSuperview()
    }
  }

  // MARK: Functions

  func configureCell(for section: Section) {
    selectionStyle = .none

    setTableView()
    titleLabel.text = section.sectionTitle

    // Apply corner radius to fix iOS 26 inconsistent border radius
    contentView.layer.cornerRadius = 12
    contentView.layer.masksToBounds = true
    self.layer.cornerRadius = 12
    self.clipsToBounds = false

    if let icon = section.imageString {
      iconImageView.image = UIImage.availableIconImage(with: icon)
    } else {
      iconImageView.image = nil
    }
    if let link = section.externalLink {
      if link {
        linkImageView.image = UIImage.availableIconImage(
          with: preferredLanguage.prefix(2) == "ar" ? "externalLinkRTL" : "externalLink"
        )
      } else {
        linkImageView.image = nil
      }
    } else {
      linkImageView.image = nil
    }

    if section.hasNestedNavigation {
      let resetIcon = UIImage(systemName: "arrow.circlepath")
      let disclosureIcon = UIImage(
        systemName: preferredLanguage.prefix(2) == "ar" ? "chevron.left": "chevron.right"
      )
      let rightIcon = section.sectionState == .appHints ? resetIcon : disclosureIcon
      let accessory  = UIImageView(
        frame: CGRect(
          x: 0, y: 0, width: (rightIcon?.size.width)!, height: (rightIcon?.size.height)!
        )
      )
      accessory.image = rightIcon
      accessory.tintColor = menuOptionColor
      accessoryView = accessory
    }
  }
}
