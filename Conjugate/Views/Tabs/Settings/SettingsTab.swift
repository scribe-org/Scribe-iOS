// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

struct SettingsTab: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("increaseTextSize") private var increaseTextSize = false
    @State private var isHighContrast = false

    var language: String {
        let langId = Locale.preferredLanguages.first ?? ""
        let langCode = langId.components(separatedBy: "-").first ?? ""
        let langLocale = Locale(identifier: langCode)

        return langLocale.localizedString(forIdentifier: langCode)?.capitalized
            ?? ""
    }

    var body: some View {
        AppNavigation {
            ZStack(alignment: .top) {
                Color.scribeBlue
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    Text(
                        NSLocalizedString(
                            "i18n.app.settings.menu.title",
                            value: "App settings",
                            comment: ""
                        ),
                    )
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .font(.title3.weight(.semibold))
                    VStack(spacing: 20) {
                        SettingsNavigationRow(
                            title: NSLocalizedString(
                                "i18n.app.settings.menu.app_language",
                                value: "App language",
                                comment: "",
                            ),
                            caption: NSLocalizedString(
                                "i18n.app.settings.menu.app_language_description",
                                value: "Change which language the Scribe app is in.",
                                comment: "",
                            ),
                            value: language
                        )
                        .onTapGesture {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        SettingsToggleRow(
                            title: NSLocalizedString(
                                "i18n.app.settings.menu.app_color_mode",
                                value: "Dark mode",
                                comment: "",
                            ),
                            caption: NSLocalizedString(
                                "i18n.app.settings.menu.app_color_mode_description",
                                value: "Change the application display to dark mode.",
                                comment: "",
                            ),
                            isOn: $isDarkMode,
                        )
                        SettingsToggleRow(
                            title: NSLocalizedString(
                                "i18n.app.settings.menu.increase_text_size",
                                value: "Increase app text size",
                                comment: ""
                            ),
                            caption: NSLocalizedString(
                                "i18n.app.settings.menu.increase_text_size_description",
                                value:
                                    "Increase the size of menu texts for better readability.",
                                comment: ""
                            ),
                            isOn: $increaseTextSize,
                        )
                        SettingsToggleRow(
                            title: NSLocalizedString(
                                "i18n.app.settings.menu.high_color_contrast",
                                value: "High color contrast",
                                comment: "",
                            ),
                            caption: NSLocalizedString(
                                "i18n.app.settings.menu.high_color_contrast_description",
                                value:
                                    "Increase color contrast for improved accessibility and a clearer viewing experience.",
                                comment: ""
                            ),
                            isOn: $isHighContrast,
                        )
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
            }
            .navigationTitle(
                NSLocalizedString(
                    "i18n.app.settings.title",
                    value: "Settings",
                    comment: ""
                ),
            )
        }
    }
}

struct SettingsNavigationRow: View {
    let title: String
    let caption: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            HStack {
                Text(title)
                    .font(.body)

                Spacer()

                HStack {
                    Text(value)
                        .font(.body)
                        .foregroundColor(.secondary)

                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }

            Text(caption)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct SettingsToggleRow: View {
    let title: String
    let caption: String
    @Binding var isOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            HStack {
                Text(title)
                    .font(.body)

                Spacer()

                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .tint(Color.scribeCTA)
            }

            Text(caption)
                .font(.caption)
                .foregroundColor(.secondary)
        }

    }
}
