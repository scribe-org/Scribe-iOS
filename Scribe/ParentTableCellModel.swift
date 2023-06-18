//
//  AboutData.swift
//

import Foundation

/// Struct used for interpolating the parent and children table of the About section.
struct ParentTableCellModel {
  let headingTitle: String
  let section: [Section]
}

struct Section {
  enum SectionState {
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
    case specificLang
  }

  let sectionTitle: String
  let imageString: String
  let hasToggle: Bool
  let sectionState: SectionState
}
