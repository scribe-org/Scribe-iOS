/**
 * Class for a button component with a label, icon and link icon.
 *
 * Copyright (C) 2023 Scribe
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

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var iconImageView: UIImageView!
  @IBOutlet var linkImageView: UIImageView!

  private var section: Section?
  private var parentSection: Section?

  // MARK: - Functions

  func configureCell(for section: Section) {
    selectionStyle = .none

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
      let disclosureIcon = UIImage(systemName: "chevron.right")
      let accessory  = UIImageView(
        frame:CGRect(x:0, y:0, width:(disclosureIcon?.size.width)!, height:(disclosureIcon?.size.height)!)
      )
      accessory.image = disclosureIcon
      accessory.tintColor = menuOptionColor
      accessoryView = accessory
    }
  }
}
