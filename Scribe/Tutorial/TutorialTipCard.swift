// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

/// The tip card shown at the top of the tutorial entry screen (Tutorial - Light - 0.0).
struct TutorialTipCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(Color.scribeCTA)
                .font(.body)
                .padding(.top, 2)

            Text(NSLocalizedString(
                "i18n.app.tutorial.tip",
                value: "Make sure you select the desired Scribe keyboard by pressing 🌐 when typing.",
                comment: ""
            ))
            .font(.footnote)
            .foregroundColor(.primary)

            Spacer()

            Button {
                // dismiss tip
            } label: {
                Text(NSLocalizedString("i18n._global.ok", value: "OK", comment: ""))
                    .font(.footnote.bold())
                    .foregroundColor(Color.scribeCTA)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}
