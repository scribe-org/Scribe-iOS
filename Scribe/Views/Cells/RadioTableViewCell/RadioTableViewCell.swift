// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * DESCRIPTION_OF_THE_PURPOSE_OF_THE_FILE
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
