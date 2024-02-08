//
//  AboutData.swift
//

import Foundation

/// Struct used for interpolating the parent and children table of the About section.
struct ParentTableCellModel {
  let headingTitle: String
  var section: [Section]
  let hasDynamicData: DynamicDataTableInstance?
}

struct Section {

  let sectionTitle: String
  let imageString: String?
  let hasToggle: Bool
  let hasNestedNavigation: Bool
  let sectionState: SectionState
  let shortDescription: String?
  let externalLink: Bool?

  init(sectionTitle: String, imageString: String? = nil, hasToggle: Bool = false, hasNestedNavigation: Bool = false, sectionState: SectionState, shortDescription: String? = nil, externalLink: Bool? = false) {
    self.sectionTitle = sectionTitle
    self.imageString = imageString
    self.hasToggle = hasToggle
    self.hasNestedNavigation = hasNestedNavigation
    self.sectionState = sectionState
    self.shortDescription = shortDescription
    self.externalLink = externalLink
  }
}

enum SectionState: Equatable {
  case github
  case matrix
  case wikimedia
  case shareScribe
  case rateScribe
  case bugReport
  case email
//    case appHints
  case privacyPolicy
  case licenses
  case appLang
  case specificLang(String)
  case none(UserInteractiveState)
  case externalLink
}

enum UserInteractiveState {
  case toggleCommaAndPeriod
  case autosuggestEmojis
  case toggleAccentCharacters
  case none
}

enum DynamicDataTableInstance {
  case installedKeyboards
}
