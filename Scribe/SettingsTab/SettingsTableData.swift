//
//  SettingsTableData.swift
//

import Foundation

struct SettingsTableData {
  static let settingsTableData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: "App language",
      section: [
        Section(sectionTitle: "System language", imageString: "globe", hasToggle: false),
      ]
    ),
    ParentTableCellModel(
      headingTitle: "Select installed keyboard",
      section: [
        Section(sectionTitle: "All keyboards", imageString: "globe", hasToggle: false),
      ]
    ),
  ]
}
