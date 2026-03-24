// SPDX-License-Identifier: GPL-3.0-or-later

/*
 * Download button for the Installation tab.
 */

import SwiftUI

struct CardView: View {
    let title: String
    let mainText: String
    let subtitle: String
    let action: () -> Void
    @AppStorage(
        "increaseTextSize", store: UserDefaults(suiteName: "group.be.scri.userDefaultsContainer")
    )
    var increaseTextSize: Bool = false

    var textSizeMultiplier: CGFloat {
        increaseTextSize ? 1.25 : 1.0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 19 * textSizeMultiplier, weight: .semibold))
                .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(mainText)
                        .font(.system(size: 17 * textSizeMultiplier))
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }

                Text(subtitle)
                    .font(.system(size: 15 * textSizeMultiplier))
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .onTapGesture(perform: action)
        }
        .padding(.horizontal)
    }
}

struct InstallationDownload: View {
    var onDownloadTapped: () -> Void
    var body: some View {
        CardView(
            title: NSLocalizedString(
                "i18n.app.download.menu_option.scribe_title", value: "Language data", comment: ""
            ),
            mainText: NSLocalizedString(
                "i18n.app.download.menu_option.scribe_download_data",
                value: "Download keyboard data",
                comment: ""
            ),
            subtitle: NSLocalizedString(
                "i18n.app.download.menu_option.scribe_description",
                value: "Add new data to Scribe keyboards.", comment: ""
            )
        ) {
            onDownloadTapped()
        }
    }
}
