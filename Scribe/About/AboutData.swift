//
//  AboutData.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 04/06/23.
//

import Foundation

/// Struct used for interpolating the parent and children table of the About section.
struct AboutData {
  let headingTitle: String
  let section: [Section]
  
  static let data: [AboutData] = [
    AboutData(
      headingTitle: "Community",
      section: [
        Section(sectionTitle: "See the code on GitHub", imageString: "github"),
        Section(sectionTitle: "Chat with the team on Matrix", imageString: "matrix"),
        Section(sectionTitle: "Wikimedia and Scribe", imageString: "wikimedia"),
        Section(sectionTitle: "Share Scribe", imageString: "square.and.arrow.up")
      ]
    ),
    AboutData(
      headingTitle: "Feedback and support",
      section: [
        Section(sectionTitle: "Rate Scribe", imageString: "star"),
        Section(sectionTitle: "Report a bug", imageString: "ant"),
        Section(sectionTitle: "Send us an email", imageString: "envelope"),
        Section(sectionTitle: "Reset app hints", imageString: "lightbulb")
        ]
    ),
    AboutData(
      headingTitle: "Legal",
      section: [
        Section(sectionTitle: "Privacy policy", imageString: "lock.shield"),
        Section(sectionTitle: "Third-party licenses", imageString: "thirdPartyLicenses")
      ]
    )
  ]
}

struct Section {
  let sectionTitle: String
  let imageString: String
}
