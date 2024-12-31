/**
 * Controls data displayed in the Settings tab.
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

import Foundation

enum SettingsTableData {
  static let settingsTableData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.settings.menu.title", value: "App settings", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.settings.menu.app_language", value: "App language", comment: ""),
          hasToggle: false,
          sectionState: .appLang
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.settings.keyboard.title", value: "Select installed keyboard", comment: ""),
      section: [
        // Section(sectionTitle: "All keyboards", imageString: "globe", sectionState: .specificLang("all")),
      ],
      hasDynamicData: .installedKeyboards
    )
  ]

  static let languageSettingsData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.settings.translation", value: "Translation", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.settings.keyboard.translation.select_source.title", value: "Translation source language", comment: ""),
          sectionState: .translateLang,
          shortDescription: NSLocalizedString("app.settings.keyboard.translation.select_source_description", value: "Change the language to translate from.", comment: "")
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.settings.keyboard.layout.title", value: "Layout", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.settings.keyboard.layout.period_and_comma", value: "Period and comma on ABC", comment: ""),
          hasToggle: true,
          sectionState: .none(.toggleCommaAndPeriod),
          shortDescription: NSLocalizedString("app.settings.keyboard.layout.period_and_comma_description", value: "Include comma and period keys on the main keyboard for convenient typing.", comment: "")
        ),
        Section(
          sectionTitle: NSLocalizedString("app.settings.keyboard.layout.disable_accent_characters", value: "Disable accent characters", comment: ""),
          imageString: "info.circle",
          hasToggle: true,
          sectionState: .none(.toggleAccentCharacters),
          shortDescription: NSLocalizedString("app.settings.keyboard.layout.disable_accent_characters_description", value: "Remove accented letter keys on the primary keyboard layout.", comment: "")
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.settings.keyboard.functionality.title", value: "Functionality", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.settings.keyboard.functionality.double_space_period", value: "Double space periods", comment: ""),
          hasToggle: true,
          sectionState: .none(.doubleSpacePeriods),
          shortDescription: NSLocalizedString("app.settings.keyboard.functionality.double_space_period_description", value: "Automatically insert a period when the space key is pressed twice.", comment: "")
        ),
        Section(
          sectionTitle: NSLocalizedString("app.settings.keyboard.functionality.auto_suggest_emoji", value: "Autosuggest emojis", comment: ""),
          hasToggle: true,
          sectionState: .none(.autosuggestEmojis),
          shortDescription: NSLocalizedString("app.settings.keyboard.functionality.auto_suggest_emoji_description", value: "Turn on emoji suggestions and completions for more expressive typing.", comment: "")
        )
      ],
      hasDynamicData: nil
    )
  ]

  static let translateLangSettingsData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.settings.keyboard.translation.select_source.caption", value: "What the source language is", comment: ""),
      section: getTranslateLanguages(),
      hasDynamicData: nil
    )
  ]

  static func getInstalledKeyboardsSections() -> [Section] {
    var installedKeyboards = [String]()

    guard let appBundleIdentifier = Bundle.main.bundleIdentifier else { return [] }

    guard let keyboards = UserDefaults.standard.dictionaryRepresentation()["AppleKeyboards"] as? [String] else { return [] }

    let customKeyboardExtension = appBundleIdentifier + "."
    for keyboard in keyboards where keyboard.hasPrefix(customKeyboardExtension) {
      let lang = keyboard.replacingOccurrences(of: customKeyboardExtension, with: "")
      installedKeyboards.append(lang.capitalized)
    }

    var sections = [Section]()

    for lang in installedKeyboards {
      guard let abbreviation = languagesAbbrDict[lang] else {
        fatalError("Abbreviation not found for language: \(lang)")
      }
      let newSection = Section(
        sectionTitle: languagesStringDict[lang]!,
        sectionState: .specificLang(abbreviation)
      )

      sections.append(newSection)
    }

    return sections
  }

  static func getTranslateLanguages() -> [Section] {
    var sections = [Section]()

    for lang in languagesAbbrDict.keys.sorted() {
      guard let abbreviation = languagesAbbrDict[lang] else {
        fatalError("Abbreviation not found for language: \(lang)")
      }
      let newSection = Section(
        sectionTitle: languagesStringDict[lang]!,
        sectionState: .specificLang(abbreviation)
      )

      sections.append(newSection)
    }

    return sections
  }
}
