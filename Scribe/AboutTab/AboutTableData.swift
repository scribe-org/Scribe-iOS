//
//  AboutTableData.swift
//

import Foundation

struct AboutTableData {
  static var aboutTableData = [
    ParentTableCellModel(
      headingTitle: "Community",
      section: [
        Section(sectionTitle: "See the code on GitHub", imageString: "github", hasToggle: false, sectionState: .github),
        Section(sectionTitle: "Chat with the team on Matrix", imageString: "matrix", hasToggle: false, sectionState: .matrix),
        Section(sectionTitle: "Wikimedia and Scribe", imageString: "wikimedia", hasToggle: false, sectionState: .wikimedia),
        Section(sectionTitle: "Share Scribe", imageString: "square.and.arrow.up", hasToggle: false, sectionState: .shareScribe),
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: "Feedback and support",
      section: [
        Section(sectionTitle: "Rate Scribe", imageString: "star", hasToggle: false, sectionState: .rateScribe),
        Section(sectionTitle: "Report a bug", imageString: "ant", hasToggle: false, sectionState: .bugReport),
        Section(sectionTitle: "Send us an email", imageString: "envelope", hasToggle: false, sectionState: .email),
//        Section(sectionTitle: "Reset app hints", imageString: "lightbulb", hasToggle: false, sectionState: .appHints)
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: "Legal",
      section: [
        Section(sectionTitle: "Privacy policy", imageString: "lock.shield", hasToggle: false, sectionState: .privacyPolicy),
        Section(sectionTitle: "Third-party licenses", imageString: "thirdPartyLicenses", hasToggle: false, sectionState: .licenses),
      ],
      hasDynamicData: nil
    ),
  ]
}
