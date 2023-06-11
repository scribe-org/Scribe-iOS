//
//  AboutTableData.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 05/06/23.
//

import Foundation

struct AboutTableData {
  static var aboutTableData = [
    ParentTableCellModel(
      headingTitle: "Community",
      section: [
        Section(sectionTitle: "See the code on GitHub", imageString: "github", hasToggle: false),
        Section(sectionTitle: "Chat with the team on Matrix", imageString: "matrix", hasToggle: false),
        Section(sectionTitle: "Wikimedia and Scribe", imageString: "wikimedia", hasToggle: false),
        Section(sectionTitle: "Share Scribe", imageString: "square.and.arrow.up", hasToggle: false)
      ]
    ),
    ParentTableCellModel(
      headingTitle: "Feedback and support",
      section: [
        Section(sectionTitle: "Rate Scribe", imageString: "star", hasToggle: false),
        Section(sectionTitle: "Report a bug", imageString: "ant", hasToggle: false),
        Section(sectionTitle: "Send us an email", imageString: "envelope", hasToggle: false),
        Section(sectionTitle: "Reset app hints", imageString: "lightbulb", hasToggle: false)
        ]
    ),
    ParentTableCellModel(
      headingTitle: "Legal",
      section: [
        Section(sectionTitle: "Privacy policy", imageString: "lock.shield", hasToggle: false),
        Section(sectionTitle: "Third-party licenses", imageString: "thirdPartyLicenses", hasToggle: false)
      ]
    )
  ]
}
