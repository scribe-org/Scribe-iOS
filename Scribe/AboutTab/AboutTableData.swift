// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Controls data displayed in the About tab.
 */

import Foundation

struct AboutTableData {
  static var aboutTableData = [
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.about.community.title", value: "Community", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.about.community.github", value: "See the code on GitHub", comment: ""),
          imageString: "github",
          sectionState: .github,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.community.matrix", value: "Chat with the team on Matrix", comment: ""),
          imageString: "matrix",
          sectionState: .matrix,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.community.mastodon", value: "Follow us on Mastodon", comment: ""),
          imageString: "mastodon",
          sectionState: .mastodon,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.community.share_scribe", value: "Share Scribe", comment: ""),
          imageString: "square.and.arrow.up",
          sectionState: .shareScribe,
          externalLink: true
        ),
//        Section(
//          sectionTitle: NSLocalizedString("app.about.community.view_apps", value: "View all Scribe apps", comment: ""),
//          imageString: "scribeIcon",
//          sectionState: .scribeApps,
//          externalLink: true
//        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.community.wikimedia", value: "Wikimedia and Scribe", comment: ""),
          imageString: "wikimedia",
          hasNestedNavigation: true,
          sectionState: .wikimedia
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.about.feedback.title", value: "Feedback and support", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.about.feedback.rate_scribe", value: "Rate Scribe", comment: ""),
          imageString: "star.fill",
          sectionState: .rateScribe,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.feedback.bug_report", value: "Report a bug", comment: ""),
          imageString: "ladybug",
          sectionState: .bugReport,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.feedback.email", value: "Send us an email", comment: ""),
          imageString: "envelope",
          sectionState: .email,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.feedback.version", value: "Check version", comment: ""),
          imageString: "bookmark",
          sectionState: .version,
          externalLink: true
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.feedback.app_hints", value: "Reset app hints", comment: ""),
          imageString: "lightbulb.max",
          hasNestedNavigation: true,
          sectionState: .appHints
        )
      ],
      hasDynamicData: nil
    ),
    ParentTableCellModel(
      headingTitle: NSLocalizedString("app.about.legal.title", value: "Legal", comment: ""),
      section: [
        Section(
          sectionTitle: NSLocalizedString("app.about.legal.privacy_policy", value: "Privacy policy", comment: ""),
          imageString: "lock.shield",
          hasNestedNavigation: true,
          sectionState: .privacyPolicy
        ),
        Section(
          sectionTitle: NSLocalizedString("app.about.legal.third_party", value: "Third-party licenses", comment: ""),
          imageString: "doc.text",
          hasNestedNavigation: true,
          sectionState: .licenses
        )
      ],
      hasDynamicData: nil
    )
  ]
}
