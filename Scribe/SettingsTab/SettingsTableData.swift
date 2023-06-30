//
//  SettingsTableData.swift
//

import Foundation

struct SettingsTableData {
  static let settingsTableData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: "App language",
      section: [
        Section(sectionTitle: "System language", imageString: "globe", hasToggle: false, sectionState: .appLang),
      ]
    ),
    ParentTableCellModel(
      headingTitle: "Select installed keyboard",
      section: [
        Section(sectionTitle: "All keyboards", imageString: "globe", hasToggle: false, sectionState: .specificLang("all")),
      ]
    ),
  ]
  
  static var languageSettingsData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: "Layout",
      section: [
        Section(sectionTitle: "Period and comma on ABC", imageString: "info.circle", hasToggle: true, sectionState: .none(.toggleCommaAndPeriod))
      ]
    )
  ]
}
