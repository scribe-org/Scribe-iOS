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
    let showsNewScreen: Bool
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
        DataModel(title: "See the code on GitHub", imageName: "github", showsNewScreen: false),
        DataModel(title: "Chat with the team on Matrix", imageName: "matrix", showsNewScreen: false),
        DataModel(title: "Wikimedia and Scribe", imageName: "wikimedia", showsNewScreen: true),
        DataModel(title: "Share Scribe", imageName: "square.and.arrow.up", showsNewScreen: false)
      ]
    case .feedbackAndSupport:
      return [
        DataModel(title: "Rate Scribe", imageName: "star", showsNewScreen: false),
        DataModel(title: "Report a bug", imageName: "ant", showsNewScreen: false),
        DataModel(title: "Send us an email", imageName: "envelope", showsNewScreen: false),
        DataModel(title: "Reset app hints", imageName: "lightbulb", showsNewScreen: false)
      ]
    case .legal:
      return [
        DataModel(title: "Privacy policy", imageName: "lock.shield", showsNewScreen: true),
        DataModel(title: "Third-party licenses", imageName: "thirdPartyLicenses", showsNewScreen: true)
      ]
    }
  }
}
