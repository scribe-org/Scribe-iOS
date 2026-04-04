// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * The About tab for the Scribe keyboard app.
 */

import MessageUI
import StoreKit
import SwiftUI

struct AboutTab: View {
    @State private var showShareSheet = false
    @State private var showAppHintsConfirmation = false
    @State private var showMailCompose = false
    @State private var showMailAlert = false
    @State private var tipCardVisible: Bool = {
        UserDefaults.standard.object(forKey: "aboutTipCardState") as? Bool ?? true
    }()

    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color("scribeAppBackground")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    if tipCardVisible {
                        AboutTipCardView(
                            infoText: NSLocalizedString(
                                "i18n.app.about.app_hint_tooltip",
                                value: "Here's where you can learn more about Scribe and its community.",
                                comment: ""
                            ),
                            isVisible: $tipCardVisible,
                            onDismiss: {
                                UserDefaults.standard.set(false, forKey: "aboutTipCardState")
                            }
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    // MARK: Community

                    AboutSectionView(
                        heading: NSLocalizedString(
                            "i18n.app.about.community.title", value: "Community", comment: "")
                    ) {
                        AboutRowView(
                            icon: "github",
                            isCustomImage: true,
                            title: NSLocalizedString(
                                "i18n.app.about.community.github",
                                value: "See the code on GitHub", comment: ""),
                            hasExternalLink: true
                        ) { openURL("https://github.com/scribe-org/Scribe-iOS") }

                        Divider().padding(.leading, 54)

                        AboutRowView(
                            icon: "matrix",
                            isCustomImage: true,
                            title: NSLocalizedString(
                                "i18n.app.about.community.matrix",
                                value: "Chat with the team on Matrix", comment: ""),
                            hasExternalLink: true
                        ) {
                            openURL(
                                "https://matrix.to/#/#scribe_community:matrix.org",
                                encoded: true)
                        }

                        Divider().padding(.leading, 54)

                        AboutRowView(
                            icon: "mastodon",
                            isCustomImage: true,
                            title: NSLocalizedString(
                                "i18n.app.about.community.mastodon",
                                value: "Follow us on Mastodon", comment: ""),
                            hasExternalLink: true
                        ) { openURL("https://wikis.world/@scribe") }

                        Divider().padding(.leading, 54)

                        AboutRowView(
                            icon: "Bluesky",
                            isCustomImage: true,
                            title: NSLocalizedString(
                                "i18n.app.about.community.bluesky",
                                value: "Follow us on Bluesky", comment: ""),
                            hasExternalLink: true,
                            invertIconInDarkMode: true
                        ) { openURL("https://bsky.app/profile/scribe-org.bsky.social") }

                        Divider().padding(.leading, 54)

                        AboutRowView(
                            icon: "globe",
                            isCustomImage: false,
                            title: NSLocalizedString(
                                "i18n.app.about.community.visit_website",
                                value: "Visit the Scribe website", comment: ""),
                            hasExternalLink: true
                        ) { openURL("https://scri.be/") }

                        Divider().padding(.leading, 54)

                        AboutRowView(
                            icon: "square.and.arrow.up",
                            isCustomImage: false,
                            title: NSLocalizedString(
                                "i18n.app.about.community.share_scribe",
                                value: "Share Scribe", comment: ""),
                            hasExternalLink: true
                        ) { showShareSheet = true }

                        Divider().padding(.leading, 54)

                        AboutRowView(
                            icon: "wikimedia",
                            isCustomImage: true,
                            title: NSLocalizedString(
                                "i18n.app.about.community.wikimedia",
                                value: "Wikimedia and Scribe", comment: ""),
                            hasNestedNavigation: true
                        ) {}
                        .overlay(
                            NavigationLink(destination: AboutInfoView(section: .wikimedia)) {
                                Color.clear
                            }
                        )
                    }

                    // MARK: Feedback and support

                    AboutSectionView(
                        heading: NSLocalizedString(
                            "i18n.app.about.feedback.title", value: "Feedback and support",
                            comment: "")
                    ) {
                        AboutRowView(
                            icon: "star.fill",
                            isCustomImage: false,
                            title: NSLocalizedString(
                                "i18n.app.about.feedback.rate_scribe",
                                value: "Rate Scribe", comment: ""),
                            hasExternalLink: true
                        ) { rateApp() }

                        Divider().padding(.leading, 54)

                        AboutRowView(
                            icon: "ladybug",
                            isCustomImage: false,
                            title: NSLocalizedString(
                                "i18n.app.about.feedback.bug_report", value: "Report a bug",
                                comment: ""),
                            hasExternalLink: true
                        ) { openURL("https://github.com/scribe-org/Scribe-iOS/issues") }

                        Divider().padding(.leading, 54)

                        AboutRowView(
                            icon: "envelope",
                            isCustomImage: false,
                            title: NSLocalizedString(
                                "i18n.app.about.feedback.send_email", value: "Send us an email",
                                comment: ""),
                            hasExternalLink: true
                        ) { sendEmail() }

                        Divider().padding(.leading, 54)

                        AboutRowView(
                            icon: "bookmark",
                            isCustomImage: false,
                            title: String(
                                format: NSLocalizedString(
                                    "i18n.app.about.feedback.version", value: "Version %@",
                                    comment: ""),
                                appVersion
                            ),
                            hasExternalLink: true
                        ) { openURL("https://github.com/scribe-org/Scribe-iOS/releases") }

                        Divider().padding(.leading, 54)

                        AboutRowView(
                            icon: "lightbulb.max",
                            isCustomImage: false,
                            title: NSLocalizedString(
                                "i18n.app.about.feedback.reset_app_hints",
                                value: "Reset app hints", comment: ""),
                            isReset: true
                        ) { showAppHintsConfirmation = true }
                    }

                    // MARK: Legal

                    AboutSectionView(
                        heading: NSLocalizedString(
                            "i18n._global.legal", value: "Legal", comment: "")
                    ) {
                        AboutRowView(
                            icon: "lock.shield",
                            isCustomImage: false,
                            title: NSLocalizedString(
                                "i18n._global.privacy_policy", value: "Privacy policy",
                                comment: ""),
                            hasNestedNavigation: true
                        ) {}
                        .overlay(
                            NavigationLink(destination: AboutInfoView(section: .privacyPolicy)) {
                                Color.clear
                            }
                        )

                        Divider().padding(.leading, 54)

                        AboutRowView(
                            icon: "doc.text",
                            isCustomImage: false,
                            title: NSLocalizedString(
                                "i18n.app.about.legal.third_party",
                                value: "Third-party licenses", comment: ""),
                            hasNestedNavigation: true
                        ) {}
                        .overlay(
                            NavigationLink(destination: AboutInfoView(section: .licenses)) {
                                Color.clear
                            }
                        )
                    }

                    Spacer(minLength: 32)
                }
                .padding(.top, 8)
                .animation(.easeInOut(duration: 0.2), value: tipCardVisible)
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [scribeShareURL()])
        }
        .sheet(isPresented: $showMailCompose) {
            MailComposeView(recipients: ["team@scri.be"], subject: "Hey Scribe!")
        }
        .alert(
            NSLocalizedString(
                "i18n.app.about.feedback.send_email", value: "Send us an email", comment: ""),
            isPresented: $showMailAlert
        ) {
            Button(NSLocalizedString("i18n._global.cancel", value: "Cancel", comment: ""), role: .cancel) {}
        } message: {
            Text("Reach out to us at team@scri.be")
        }
        .alert(
            NSLocalizedString(
                "i18n.app.about.feedback.reset_app_hints", value: "Reset app hints", comment: ""),
            isPresented: $showAppHintsConfirmation
        ) {
            Button(
                NSLocalizedString("i18n._global.cancel", value: "Cancel", comment: ""),
                role: .cancel
            ) {}
            Button(NSLocalizedString("i18n._global.reset", value: "Reset", comment: "")) {
                resetAppHints()
            }
        } message: {
            Text(
                NSLocalizedString(
                    "i18n.app.about.feedback.reset_app_hints.message",
                    value: "This will reset all app hints to their default visible state.",
                    comment: ""
                ))
        }
    }

    // MARK: - Actions

    private func openURL(_ urlString: String, encoded: Bool = false) {
        let target = encoded
            ? (urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString)
            : urlString
        guard let url = URL(string: target) else { return }
        UIApplication.shared.open(url)
    }

    private func rateApp() {
        guard
            let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else { return }
        SKStoreReviewController.requestReview(in: scene)
    }

    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            showMailCompose = true
        } else {
            showMailAlert = true
        }
    }

    private func resetAppHints() {
        UserDefaults.standard.set(true, forKey: "installationTipCardState")
        UserDefaults.standard.set(true, forKey: "settingsTipCardState")
        UserDefaults.standard.set(true, forKey: "aboutTipCardState")
        withAnimation { tipCardVisible = true }
    }

    private func scribeShareURL() -> URL {
        URL(string: "itms-apps://itunes.apple.com/app/id1596613886")!
    }
}
