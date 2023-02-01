//
//  InformationToolTipData.swift
//

import Foundation
import UIKit

enum InformationToolTipData {

  static let wikiDataExplanation = NSMutableAttributedString(
      string: "Wikidata is a collaboratively edited knowledge graph that's maintained by the Wikimedia Foundation. It serves as a source of open data for projects like Wikipedia.",
      attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.75)]
  )
  
  static let wikiDataContationOrigin = NSMutableAttributedString(
    string: "Scribe uses Wikidata's language data for many of its core features. We get information like noun genders, verb conjugations and much more!",
    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.75)]
  )
  
  static let howToContribute = NSMutableAttributedString(
    string: "You can make an account at wikidata.org to join the community that's supporting Scribe and so many other projects. Help us bring free information to the world!",
    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: DeviceType.isPhone ? letterKeyWidth / 2 : letterKeyWidth / 2.75)]
  )
  
  static func getContent() -> [NSMutableAttributedString] {
    [
      InformationToolTipData.wikiDataExplanation,
      InformationToolTipData.wikiDataContationOrigin,
      InformationToolTipData.howToContribute
    ]
  }

}
