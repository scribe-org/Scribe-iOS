//
//  AboutData.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 04/06/23.
//

import Foundation

/// Struct used for interpolating the parent and children table of the About section.
struct ParentTableCellModel {
  let headingTitle: String
  let section: [Section]
}

struct Section {
  let sectionTitle: String
  let imageString: String
  let hasToggle: Bool
}
