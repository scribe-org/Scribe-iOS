//
//  SettingsTableData.swift
//

import Foundation

struct SettingsTableData {

  static let settingsTableData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: NSLocalizedString("settings.appLanguage", comment: "The title of the app language section"),
      section: [
        Section(sectionTitle: NSLocalizedString("settings.appLanguage.system", comment: "Use the system language"), imageString: "globe", hasToggle: false, sectionState: .appLang),
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("settings.installedKeyboards", comment: "The title of the installed keyboards section"),
      section: [
        //        Section(sectionTitle: "All keyboards", imageString: "globe", hasToggle: false, sectionState: .specificLang("all")),
      ],
      hasDynamicData: .installedKeyboards
    ),
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
        ),
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
        ),
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
      let newSection = Section(
        sectionTitle: language,
        hasToggle: false,
        sectionState: .specificLang(languagesAbbrDict[language]!)
      )

      sections.append(newSection)
    }

    return sections
  }
}
