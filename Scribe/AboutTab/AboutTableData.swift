/**
 * Controls data displayed in the About tab.
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

struct AboutTableData {
  static var aboutTableData = [
    ParentTableCellModel(
      headingTitle: NSLocalizedString("about.community", comment: "Heading for the community category"),
      section: [
        Section(
          sectionTitle: NSLocalizedString("about.github", comment: "Title for the GitHub button"),
          imageString: "github",
          sectionState: .github,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("about.matrix", comment: "Title for the Matrix button"),
          imageString: "matrix",
          sectionState: .matrix,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("about.share", comment: "Title for the share button"),
          imageString: "square.and.arrow.up",
          sectionState: .shareScribe,
          externalLink: true
        ),
//        Section(
//          sectionTitle: NSLocalizedString("about.scribe", comment: "Title for the Scribe Apps section"),
//          imageString: "scribeIcon",
//          sectionState: .scribeApps,
//          externalLink: true
//        ),
        Section(
          sectionTitle: NSLocalizedString("about.wikimedia", comment: "Title for the Wikimedia explanation"),
          imageString: "wikimedia",
          hasNestedNavigation: true,
          sectionState: .wikimedia
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("about.feedback", comment: "Heading for the feedback category"),
      section: [
        Section(
          sectionTitle: NSLocalizedString("about.rate", comment: "Title for the rate button"),
          imageString: "star.fill",
          sectionState: .rateScribe,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("about.bugReport", comment: "Title for the bug report button"),
          imageString: "ladybug",
          sectionState: .bugReport,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("about.email", comment: "Title for the email button"),
          imageString: "envelope",
          sectionState: .email,
          externalLink: true
        )
//        Section(
//          sectionTitle: NSLocalizedString("about.appHints", comment: "Title for the button to reset hints"),
//          imageString: "lightbulb",sectionState: .appHints
//        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("about.legal", comment: "Title for the legal category"),
      section: [
        Section(
          sectionTitle: NSLocalizedString("about.privacyPolicy", comment: "Title for the privacy policy"),
          imageString: "lock.shield",
          hasNestedNavigation: true,
          sectionState: .privacyPolicy
        ),
        Section(
          sectionTitle: NSLocalizedString("about.thirdParty", comment: "Title for the third party licenses"),
          imageString: "doc.text",
          hasNestedNavigation: true,
          sectionState: .licenses
        )
      ],
      hasDynamicData: nil
    )
  ]
}
