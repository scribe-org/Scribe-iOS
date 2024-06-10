/**
 * Contains structs that control how buttons in the About tab are built.
 *
 * Copyright (C) 2023 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

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

  init(
    sectionTitle: String,
    imageString: String? = nil,
    hasToggle: Bool = false,
    hasNestedNavigation: Bool = false,
    sectionState: SectionState,
    shortDescription: String? = nil,
    externalLink: Bool? = false
  ) {
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
  // case downloadData
  // case checkData
  case appHints
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
