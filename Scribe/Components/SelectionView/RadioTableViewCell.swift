/**
 * DESCRIPTION_OF_THE_PURPOSE_OF_THE_FILE
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

final class RadioTableViewCell: UITableViewCell {

  // MARK: - Constants

  static let reuseIdentifier = String(describing: InfoChildTableViewCell.self)

  // MARK: - Properties

  @IBOutlet var titleLabelPhone: UILabel!
  @IBOutlet var titleLabelPad: UILabel!
  var titleLabel: UILabel!

  @IBOutlet var iconImageViewPhone: UIImageView!
  @IBOutlet var iconImageViewPad: UIImageView!
  var iconImageView: UIImageView!

  var section: Section?
  var parentSection: Section?
  var inUse: Bool = false

  func setTableView() {
    if DeviceType.isPad {
      titleLabel = titleLabelPad
      iconImageView = iconImageViewPad

      titleLabelPhone.removeFromSuperview()
      iconImageViewPhone.removeFromSuperview()
    } else {
      titleLabel = titleLabelPhone
      iconImageView = iconImageViewPhone

      titleLabelPad.removeFromSuperview()
      iconImageViewPad.removeFromSuperview()
    }
  }

  var selectedLang: String {
    guard let section = section,
          case let .specificLang(lang) = section.sectionState else { return "n/a" }

    return lang
  }

  var togglePurpose: UserInteractiveState {
    guard let section = section,
          case let .none(action) = section.sectionState else { return .none }

    return action
  }

  // MARK: - Functions

  func configureCell(for section: Section) {
    self.section = section
    selectionStyle = .none

    setTableView()
    titleLabel.text = section.sectionTitle
    iconImageView.image = UIImage(named: "radioButton")
  }
}
