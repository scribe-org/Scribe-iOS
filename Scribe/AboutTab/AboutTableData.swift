//
//  AboutTableData.swift
//

import Foundation

struct AboutTableData {
  static var aboutTableData = [
    ParentTableCellModel(
      headingTitle: "Community",
      section: [
        Section(sectionTitle: "See the code on GitHub", imageString: "github", sectionState: .github),
        Section(sectionTitle: "Chat with the team on Matrix", imageString: "matrix", sectionState: .matrix),
        Section(sectionTitle: "Wikimedia and Scribe", imageString: "wikimedia", sectionState: .wikimedia),
        Section(sectionTitle: "Share Scribe", imageString: "square.and.arrow.up", sectionState: .shareScribe),
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: "Feedback and support",
      section: [
        Section(sectionTitle: "Rate Scribe", imageString: "star", sectionState: .rateScribe),
        Section(sectionTitle: "Report a bug", imageString: "ant", sectionState: .bugReport),
        Section(sectionTitle: "Send us an email", imageString: "envelope", sectionState: .email),
//        Section(sectionTitle: "Reset app hints", imageString: "lightbulb", sectionState: .appHints)
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: "Legal",
      section: [
        Section(sectionTitle: "Privacy policy", imageString: "lock.shield", hasNestedNavigation: true, sectionState: .privacyPolicy),
        Section(sectionTitle: "Third-party licenses", imageString: "thirdPartyLicenses", hasNestedNavigation: true, sectionState: .licenses),
      ],
      hasDynamicData: nil
    ),
  ]
}
