/**
 * Controls data displayed in the About tab.
 *
 * Copyright (C) 2024 Scribe
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
      headingTitle: NSLocalizedString("app.about.community", value: "Community", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.about.github", value: "See the code on GitHub", comment: ""),
          imageString: "github",
          sectionState: .github,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.matrix", value: "Chat with the team on Matrix", comment: ""),
          imageString: "matrix",
          sectionState: .matrix,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.mastodon", value: "Follow us on Mastodon", comment: ""),
          imageString: "mastodon",
          sectionState: .mastodon,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.share", value: "Share Scribe", comment: ""),
          imageString: "square.and.arrow.up",
          sectionState: .shareScribe,
          externalLink: true
        ),
//        Section(
//          sectionTitle: NSLocalizedString("app.about.scribe", value: "View all Scribe apps", comment: ""),
//          imageString: "scribeIcon",
//          sectionState: .scribeApps,
//          externalLink: true
//        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.wikimedia", value: "Wikimedia and Scribe", comment: ""),
          imageString: "wikimedia",
          hasNestedNavigation: true,
          sectionState: .wikimedia
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.about.feedback", value: "Feedback and support", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.about.rate", value: "Rate Scribe", comment: ""),
          imageString: "star.fill",
          sectionState: .rateScribe,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.bugReport", value: "Report a bug", comment: ""),
          imageString: "ladybug",
          sectionState: .bugReport,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.email", value: "Send us an email", comment: ""),
          imageString: "envelope",
          sectionState: .email,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.appHints", value: "Reset app hints", comment: ""),
          imageString: "lightbulb.max",
          hasNestedNavigation: true, 
          sectionState: .appHints
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.about.legal", value: "Legal", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.about.privacyPolicy", value: "Privacy policy", comment: ""),
          imageString: "lock.shield",
          hasNestedNavigation: true,
          sectionState: .privacyPolicy
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.thirdParty", value: "Third-party licenses", comment: ""),
          imageString: "doc.text",
          hasNestedNavigation: true,
          sectionState: .licenses
        )
      ],
      hasDynamicData: nil
    )
  ]
}
