/**
 * Controls data displayed in the Settings tab.
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

import Foundation

enum SettingsTableData {
  static let settingsTableData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: NSLocalizedString("settings.appSettings", comment: "The title of the app settings section"),
      section: [
        Section(sectionTitle: NSLocalizedString("settings.appSettings.appLanguage", comment: "Change the language of the Scribe App"), imageString: "globe", hasToggle: false, sectionState: .appLang)
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("settings.installedKeyboards", comment: "The title of the installed keyboards section"),
      section: [
        //        Section(sectionTitle: "All keyboards", imageString: "globe", sectionState: .specificLang("all")),
      ],
      hasDynamicData: .installedKeyboards
    )
  ]

  static let languageSettingsData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: NSLocalizedString("settings.layout", comment: "The title of the layout section"),
      section: [
        Section(
          sectionTitle: NSLocalizedString("settings.layout.periodAndComma", comment: "Toggles period and commas for the selected keyboard"),
          hasToggle: true,
          sectionState: .none(.toggleCommaAndPeriod),
          shortDescription: NSLocalizedString("settings.layout.periodAndComma.description", comment: "")
        ),
        Section(
          sectionTitle: NSLocalizedString("settings.layout.disableAccentCharacters", comment: "Toggles accented characters for the selected keyboard"),
          imageString: "info.circle",
          hasToggle: true,
          sectionState: .none(.toggleAccentCharacters),
          shortDescription: NSLocalizedString("settings.layout.disableAccentCharacters.description", comment: "")
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("settings.functionality", comment: "The title of the functionality section"),
      section: [
        Section(
          sectionTitle: NSLocalizedString("settings.functionality.autoSuggestEmoji", comment: "Toggles the suggestion of Emoji"),
          hasToggle: true,
          sectionState: .none(.autosuggestEmojis),
          shortDescription: NSLocalizedString("settings.layout.autoSuggestEmoji.description", comment: "")
        )
      ],
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
        installedKeyboards.append(lang.capitalize())
      }
    }

    var sections = [Section]()

    for language in installedKeyboards {
      guard let abbreviation = languagesAbbrDict[language] else {
        fatalError("Abbreviation not found for language: \(language)")
      }
      let newSection = Section(
        sectionTitle: language,
        sectionState: .specificLang(abbreviation)
      )

      sections.append(newSection)
    }

    return sections
  }
}
