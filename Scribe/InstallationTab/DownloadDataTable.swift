//
//  DownloadDataTable.swift
//  Scribe
//
//  Created by Marek Viktor on 06/11/2023.
//

import Foundation

struct DownloadDataTable {
  static var downloadDataTable = [
    ParentTableCellModel(
      headingTitle: "Data updates",
      section: [
        Section(sectionTitle: "Check for new data", imageString: "checkmark.icloud", hasToggle: false, sectionState: .checkData),
        Section(sectionTitle: "Regularly update Scribe data", imageString: "gear", hasToggle: true, sectionState: .matrix)
      ],
      hasDynamicData: nil
    )
  ]
}

enum InstallationDataTable {
  static var installationDataTable = [
    ParentTableCellModel(
      headingTitle: "Download language data",
      section: [
        Section(sectionTitle: "Add data to scribe keyboards", imageString: "tray", hasToggle: false, sectionState: .downloadData)
      ],
      hasDynamicData: nil
    )
  ]
}
