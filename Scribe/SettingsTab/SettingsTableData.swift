//
//  SettingsTableData.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 04/06/23.
//

import Foundation

struct SettingsTableData {
  static let settingsTableData: [ParentTableCellModel] = [
    ParentTableCellModel(
      headingTitle: "App language",
      section: [
        Section(sectionTitle: "System language", imageString: "globe")
      ]
    ),
    ParentTableCellModel(
      headingTitle: "Select installed keyboard",
      section: [
        Section(sectionTitle: "All keyboards", imageString: "globe")
      ]
    )
  ]
}
