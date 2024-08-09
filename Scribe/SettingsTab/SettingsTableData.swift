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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import Foundation

enum SettingsTableData {
  static let settingsTableData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.settings.appSettings", value: "App settings", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.settings.appSettings.appLanguage", value: "App language", comment: ""),
          hasToggle: false,
          sectionState: .appLang
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.settings.installedKeyboards", value: "Select installed keyboard", comment: ""),
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
          sectionTitle: NSLocalizedString("app.settings.translation.translationLang", value: "Translation language", comment: ""),
          sectionState: .translateLang
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.settings.layout", value: "Layout", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.settings.layout.periodAndComma", value: "Period and comma on ABC", comment: ""),
          hasToggle: true,
          sectionState: .none(.toggleCommaAndPeriod),
          shortDescription: NSLocalizedString("app.settings.layout.periodAndComma.description", value: "Include comma and period keys on the main keyboard for convenient typing.", comment: "")
        ),
        Section(
          sectionTitle: NSLocalizedString("app.settings.layout.disableAccentCharacters", value: "Disable accent characters", comment: ""),
          imageString: "info.circle",
          hasToggle: true,
          sectionState: .none(.toggleAccentCharacters),
          shortDescription: NSLocalizedString("app.settings.layout.disableAccentCharacters.description", value: "Include accented letter keys on the primary keyboard layout.", comment: "")
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.settings.functionality", value: "Functionality", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.settings.functionality.autoSuggestEmoji", value: "Autosuggest emojis", comment: ""),
          hasToggle: true,
          sectionState: .none(.autosuggestEmojis),
          shortDescription: NSLocalizedString("app.settings.layout.autoSuggestEmoji.description", value: "Turn on emoji suggestions and completions for more expressive typing.", comment: "")
        )
      ],
      hasDynamicData: nil
    )
  ]

  static let translateLangSettingsData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.settings.translation.translationLang.caption", value: "Choose a language to translate from", comment: ""),
      section: getTranslateLanguages(),
      hasDynamicData: nil
    )
  ]

  static func getInstalledKeyboardsSections() -> [Section] {
    var installedKeyboards = [String]()

    guard let appBundleIdentifier = Bundle.main.bundleIdentifier else { return [] }

    guard let keyboards = UserDefaults.standard.dictionaryRepresentation()["AppleKeyboards"] as? [String] else { return [] }

    let customKeyboardExtension = appBundleIdentifier + "."
    for keyboard in keyboards {
      if keyboard.hasPrefix(customKeyboardExtension) {
        let lang = keyboard.replacingOccurrences(of: customKeyboardExtension, with: "")
        installedKeyboards.append(lang.capitalized)
      }
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
