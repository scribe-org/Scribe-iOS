//
//  InfoChildTableViewCell.swift
//

import UIKit

final class InfoChildTableViewCell: UITableViewCell {

  // MARK: - Constants

  static let reuseIdentifier = String(describing: InfoChildTableViewCell.self)

  // MARK: - Properties

  @IBOutlet var containerView: UIView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
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
  
  // MARK: - Functions

  func configureCell(for section: Section) {
    self.section = section

    selectionStyle = .none

    titleLabel.text = section.sectionTitle

    if let icon = section.imageString {
      iconImageView.image = UIImage.availableIconImage(with: icon)

      containerView.addSubview(iconImageView)

    } else {
      iconImageView.image = nil

      iconImageView.removeFromSuperview()
    }

    if let shortDescription = section.shortDescription {
      descriptionLabel.text = shortDescription

      containerView.addSubview(descriptionLabel)
    } else {
      descriptionLabel.text = nil
      descriptionLabel.removeFromSuperview()
    }

    if !section.hasToggle {
      accessoryType = .disclosureIndicator
      toggleSwitch.isHidden = true
    } else {
      accessoryType = .none
//      chevronImgView.isHidden = true
    }

    fetchSwitchStateForCell()

    toggleSwitch.onTintColor = .init(.scribeCTA).withAlphaComponent(0.4)
    toggleSwitch.thumbTintColor = toggleSwitch.isOn ? .init(.scribeCTA) : .lightGray
  }

  @IBAction func switchDidChange(_: UISwitch) {
    switch togglePurpose {
    case .toggleCommaAndPeriod:
      let dictionaryKey = languageCode + "CommaAndPeriod"
      userDefaults.setValue(toggleSwitch.isOn, forKey: dictionaryKey)

    case .toggleAccentCharacters:
      let dictionaryKey = languageCode + "AccentCharacters"
      userDefaults.setValue(toggleSwitch.isOn, forKey: dictionaryKey)

    case .autosuggestEmojis:
      let dictionaryKey = languageCode + "EmojiAutosuggest"
      userDefaults.setValue(toggleSwitch.isOn, forKey: dictionaryKey)

    case .none: break
    }

    toggleSwitch.thumbTintColor = toggleSwitch.isOn ? .init(.scribeCTA) : .lightGray
  }

  func fetchSwitchStateForCell() {
    switch togglePurpose {
    case .toggleCommaAndPeriod:
      let dictionaryKey = languageCode + "CommaAndPeriod"
      if let toggleValue = userDefaults.object(forKey: dictionaryKey) as? Bool {
        toggleSwitch.isOn = toggleValue
      } else {
        /// Default value
        toggleSwitch.isOn = false
      }

    case .toggleAccentCharacters:
      let dictionaryKey = languageCode + "AccentCharacters"
      if let toggleValue = userDefaults.object(forKey: dictionaryKey) as? Bool {
        toggleSwitch.isOn = toggleValue
      } else {
        /// Default value
        toggleSwitch.isOn = false
      }

    case .autosuggestEmojis:
      let dictionaryKey = languageCode + "EmojiAutosuggest"
      if let toggleValue = userDefaults.object(forKey: dictionaryKey) as? Bool {
        toggleSwitch.isOn = toggleValue
      } else {
        /// Default value
        toggleSwitch.isOn = true
      }

    case .none: break
    }
  }
}
