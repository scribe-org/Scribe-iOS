//
//  SettingsTableData.swift
//

import Foundation

struct SettingsTableData {
  static var settingsTableData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: "App language",
      section: [
        Section(sectionTitle: "System language", imageString: "globe", hasToggle: false, sectionState: .appLang),
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: "Select installed keyboard",
      section: [
        //        Section(sectionTitle: "All keyboards", imageString: "globe", hasToggle: false, sectionState: .specificLang("all")),
      ],
      hasDynamicData: .installedKeyboards
    ),
  ]
  
  static var languageSettingsData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: "Layout",
      section: [
        Section(
          sectionTitle: "Period and comma on ABC",
          imageString: "info.circle",
          hasToggle: true,
          sectionState: .none(.toggleCommaAndPeriod)
        ),
       Section(
          sectionTitle: "Disable accent characters",
          imageString: "info.circle",
          hasToggle: true,
          sectionState: .none(.toggleAccentCharacters)
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: "Functionality",
      section: [
        Section(
          sectionTitle: "Autosuggest emojis",
          imageString: "info.circle",
          hasToggle: true,
          sectionState: .none(.autosuggestEmojis)
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
      let newSection = Section(
        sectionTitle: language,
        imageString: "globe",
        hasToggle: false,
        sectionState: .specificLang(languagesAbbrDict[language]!)
      )

      sections.append(newSection)
    }

    return sections
  }
}


