// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Class for a setting component with a heading, description and switch.
 */

import UIKit

final class InfoChildTableViewCell: UITableViewCell {

  // MARK: Constants

  static let reuseIdentifier = String(describing: InfoChildTableViewCell.self)

  // MARK: Properties

  @IBOutlet var titleLabelPhone: UILabel!
  @IBOutlet var titleLabelPad: UILabel!
  var titleLabel: UILabel!

  @IBOutlet var subLabelPhone: UILabel!
  @IBOutlet var subLabelPad: UILabel!
  var subLabel: UILabel!

  @IBOutlet var iconImageViewPhone: UIImageView!
  @IBOutlet var iconImageViewPad: UIImageView!
  var iconImageView: UIImageView!

  @IBOutlet var toggleSwitchPhone: UISwitch!
  @IBOutlet var toggleSwitchPad: UISwitch!
  var toggleSwitch: UISwitch!

  @IBOutlet var descriptionLabelPhone: UILabel!
  @IBOutlet var descriptionLabelPad: UILabel!
  var descriptionLabel: UILabel!

  var section: Section?
  var parentSection: Section?

  func setTableView() {
    if DeviceType.isPad {
      titleLabel = titleLabelPad
      subLabel = subLabelPad
      iconImageView = iconImageViewPad
      toggleSwitch = toggleSwitchPad
      descriptionLabel = descriptionLabelPad

      titleLabelPhone.removeFromSuperview()
      subLabelPhone.removeFromSuperview()
      iconImageViewPhone.removeFromSuperview()
      toggleSwitchPhone.removeFromSuperview()
      descriptionLabelPhone.removeFromSuperview()
    } else {
      titleLabel = titleLabelPhone
      subLabel = subLabelPhone
      iconImageView = iconImageViewPhone
      toggleSwitch = toggleSwitchPhone
      descriptionLabel = descriptionLabelPhone

      titleLabelPad.removeFromSuperview()
      subLabelPad.removeFromSuperview()
      iconImageViewPad.removeFromSuperview()
      toggleSwitchPad.removeFromSuperview()
      descriptionLabelPad.removeFromSuperview()
    }
  }

  let userDefaults = UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")!

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

  // MARK: Functions

  func configureCell(for section: Section) {
    self.section = section
    selectionStyle = .none

    setTableView()
    titleLabel.text = section.sectionTitle

    if let shortDescription = section.shortDescription {
        descriptionLabel.text = shortDescription
        descriptionLabel.isHidden = false
    } else {
        descriptionLabel.text = nil
        descriptionLabel.isHidden = true
    }

    if section.hasToggle {
      accessoryType = .none
      toggleSwitch.isHidden = false

      fetchSwitchStateForCell()

      toggleSwitch.onTintColor = .init(ScribeColor.scribeCTA).withAlphaComponent(0.4)
      toggleSwitch.thumbTintColor = toggleSwitch.isOn ? .init(.scribeCTA) : .lightGray
    } else {
      iconImageView.image = UIImage(
        systemName: preferredLanguage.prefix(2) == "ar" ? "chevron.left": "chevron.right"
      )
      iconImageView.tintColor = menuOptionColor
      toggleSwitch.isHidden = true
    }

    if section.sectionState == .translateLang {
      var langTranslateLanguage = "English"
      if let selectedLang = userDefaults.string(forKey: languageCode + "TranslateLanguage") {
        langTranslateLanguage = getKeyInDict(givenValue: selectedLang, dict: languagesAbbrDict)
      } else {
        userDefaults.set("en", forKey: languageCode + "TranslateLanguage")
      }
      let currentLang = "i18n.app._global." + langTranslateLanguage.lowercased()
      subLabel.text = NSLocalizedString(currentLang, value: langTranslateLanguage, comment: "")
      subLabel.textColor = menuOptionColor
    } else {
      subLabel.removeFromSuperview()
    }
  }

  @IBAction func switchDidChange(_: UISwitch) {
    switch togglePurpose {
    case .toggleCommaAndPeriod:
      let dictionaryKey = languageCode + "CommaAndPeriod"
      userDefaults.setValue(toggleSwitch.isOn, forKey: dictionaryKey)

    case .toggleAccentCharacters:
      let dictionaryKey = languageCode + "AccentCharacters"
      userDefaults.setValue(toggleSwitch.isOn, forKey: dictionaryKey)

    case .doubleSpacePeriods:
      let dictionaryKey = languageCode + "DoubleSpacePeriods"
      userDefaults.setValue(toggleSwitch.isOn, forKey: dictionaryKey)

    case .autosuggestEmojis:
      let dictionaryKey = languageCode + "EmojiAutosuggest"
      userDefaults.setValue(toggleSwitch.isOn, forKey: dictionaryKey)

    case .toggleWordForWordDeletion:
      let dictionaryKey = languageCode + "WordForWordDeletion"
      userDefaults.setValue(toggleSwitch.isOn, forKey: dictionaryKey)

    case .colonToEmoji:
      let dictionaryKey = languageCode + "ColonToEmoji"
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
        toggleSwitch.isOn = false  // Default value
      }

    case .toggleAccentCharacters:
      let dictionaryKey = languageCode + "AccentCharacters"
      if let toggleValue = userDefaults.object(forKey: dictionaryKey) as? Bool {
        toggleSwitch.isOn = toggleValue
      } else {
        toggleSwitch.isOn = false  // Default value
      }

    case .doubleSpacePeriods:
      let dictionaryKey = languageCode + "DoubleSpacePeriods"
      if let toggleValue = userDefaults.object(forKey: dictionaryKey) as? Bool {
        toggleSwitch.isOn = toggleValue
      } else {
        toggleSwitch.isOn = true  // Default value
      }

    case .autosuggestEmojis:
      let dictionaryKey = languageCode + "EmojiAutosuggest"
      if let toggleValue = userDefaults.object(forKey: dictionaryKey) as? Bool {
        toggleSwitch.isOn = toggleValue
      } else {
        toggleSwitch.isOn = true  // Default value
      }

    case .toggleWordForWordDeletion:
      let dictionaryKey = languageCode + "WordForWordDeletion"
      if let toggleValue = userDefaults.object(forKey: dictionaryKey) as? Bool {
        toggleSwitch.isOn = toggleValue
      } else {
        toggleSwitch.isOn = false // Default value
      }

    case .colonToEmoji:
      let dictionaryKey = languageCode + "ColonToEmoji"
      if let toggleValue = userDefaults.object(forKey: dictionaryKey) as? Bool {
        toggleSwitch.isOn = toggleValue
      } else {
        toggleSwitch.isOn = true // Default value
      }

    case .none: break
    }
  }
}
