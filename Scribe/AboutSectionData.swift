//
//  AboutSectionData.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 01/06/23.
//

import Foundation

struct AboutSectionData {
  
  struct DataModel {
    let title: String
    let imageName: String
  }
  
  enum AboutSections {
    case community
    case feedbackAndSupport
    case legal
  }
  
  func getCellTitleAndImage(forSection section: AboutSections) -> [DataModel] {
    switch section {
    case .community:
      return [
        DataModel(title: "See the code on GitHub", imageName: "github"),
        DataModel(title: "Chat with the team on Matrix", imageName: "matrix"),
        DataModel(title: "Wikimedia and Scribe", imageName: "wikimedia"),
        DataModel(title: "Share Scribe", imageName: "square.and.arrow.up")
      ]
    case .feedbackAndSupport:
      return [
        DataModel(title: "Rate Scribe", imageName: "star"),
        DataModel(title: "Report a bug", imageName: "ant"),
        DataModel(title: "Send us an email", imageName: "envelope"),
        DataModel(title: "Reset app hints", imageName: "lightbulb")
      ]
    case .legal:
      return [
        DataModel(title: "Privacy policy", imageName: "lock.shield"),
        DataModel(title: "Third-party licenses", imageName: "thirdPartyLicenses")
      ]
    }
  }
}
