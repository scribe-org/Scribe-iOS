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
        Section(sectionTitle: "See the code on GitHub", imageString: "github"),
        Section(sectionTitle: "Chat with the team on Matrix", imageString: "matrix"),
        Section(sectionTitle: "Wikimedia and Scribe", imageString: "wikimedia"),
        Section(sectionTitle: "Share Scribe", imageString: "square.and.arrow.up")
      ]
    ),
    ParentTableCellModel(
      headingTitle: "Feedback and support",
      section: [
        Section(sectionTitle: "Rate Scribe", imageString: "star"),
        Section(sectionTitle: "Report a bug", imageString: "ant"),
        Section(sectionTitle: "Send us an email", imageString: "envelope"),
        Section(sectionTitle: "Reset app hints", imageString: "lightbulb")
        ]
    ),
    ParentTableCellModel(
      headingTitle: "Legal",
      section: [
        Section(sectionTitle: "Privacy policy", imageString: "lock.shield"),
        Section(sectionTitle: "Third-party licenses", imageString: "thirdPartyLicenses")
      ]
    )
  ]
}
