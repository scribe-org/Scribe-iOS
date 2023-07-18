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
  var parentSection: Section?

  let userDefaults = UserDefaults(suiteName: "group.scribe.userDefaultsContainer")!

  var languageCode: String {
    guard let parentSection = parentSection,
          case let .specificLang(lang) = parentSection.sectionState else { return "all" }

    return lang
  }

  var togglePurpose: UserInteractiveState {
    guard let section = section,
          case let .none(action) = section.sectionState else { return .none }

    return action
  }

  func configureCell(for section: Section) {
    self.section = section
    titleLabel.text = section.sectionTitle
    iconImageView.image = UIImage.availableIconImage(with: section.imageString)

    if !section.hasToggle {
      toggleSwitch.isHidden = true
    } else {
      chevronImgView.isHidden = true
    }

    fetchSwitchStateForCell()

    toggleSwitch.onTintColor = .init(.commandKey).withAlphaComponent(0.4)
    toggleSwitch.thumbTintColor = toggleSwitch.isOn ? .init(.commandKey) : .lightGray
  }

  @IBAction func switchDidChange(_: UISwitch) {
    switch togglePurpose {
    case .toggleCommaAndPeriod:
      let dictionaryKey = languageCode + "CommaAndPeriod"
      userDefaults.setValue(toggleSwitch.isOn, forKey: dictionaryKey)
    case .none: break
    }

    toggleSwitch.thumbTintColor = toggleSwitch.isOn ? .init(.commandKey) : .lightGray
  }

  func fetchSwitchStateForCell() {
    switch togglePurpose {
    case .toggleCommaAndPeriod:
      let dictionaryKey = languageCode + "CommaAndPeriod"
      toggleSwitch.isOn = userDefaults.bool(forKey: dictionaryKey)
    case .none: break
    }
  }
}
