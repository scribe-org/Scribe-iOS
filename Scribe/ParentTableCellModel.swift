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
  let imageString: String
  let hasToggle: Bool
  let sectionState: SectionState
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
}

enum UserInteractiveState {
  case toggleCommaAndPeriod
  case autosuggestEmojis
  case none
}

enum DynamicDataTableInstance {
  case installedKeyboards
}
