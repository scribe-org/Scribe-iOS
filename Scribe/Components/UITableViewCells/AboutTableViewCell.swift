/**
 * Class for a button component with a label, icon and link icon.
 *
 * Copyright (C) 2024 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import UIKit

final class AboutTableViewCell: UITableViewCell {

  // MARK: - Constants

  static let reuseIdentifier = String(describing: InfoChildTableViewCell.self)

  // MARK: - Properties

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

  // MARK: - Functions

  func configureCell(for section: Section) {
    selectionStyle = .none

    setTableView()
    titleLabel.text = section.sectionTitle

    if let icon = section.imageString {
      iconImageView.image = UIImage.availableIconImage(with: icon)
    } else {
      iconImageView.image = nil
    }
    if let link = section.externalLink {
      if link {
        linkImageView.image = UIImage.availableIconImage(with: "externalLink")
      } else {
        linkImageView.image = nil
      }
    } else {
      linkImageView.image = nil
    }

    if section.hasNestedNavigation {
      let resetIcon = UIImage(systemName: "arrow.circlepath")
      let disclosureIcon = UIImage(systemName: "chevron.right")
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
