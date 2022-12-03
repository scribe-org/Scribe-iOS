//
//  InformationToolTipData.swift
//  Scribe
//
//  Created by Gabriel Moraes on 03/12/22.
//

import Foundation

enum InformationToolTipData {
  
  static let wikiDataExplanation = "Wikidata is a collaboratively edited knowledge graph that's maintained by the Wikimedia Foundation. It serves as a source of open data for projects like Wikipedia."
  
  static let wikiDataContationOrigin = "Scribe uses Wikidata's language data for many of its core features. We get information like noun genders, verb conjugations and much more!"
  
  static let howToContribute = "You can make an account at wikidata.org to join the community that's supporting Scribe and so many other projects. Help us bring free information to the world!"
  
  static func getContent() -> [String] {
    [
      InformationToolTipData.wikiDataExplanation,
      InformationToolTipData.wikiDataContationOrigin,
      InformationToolTipData.howToContribute
    ]
  }

}
