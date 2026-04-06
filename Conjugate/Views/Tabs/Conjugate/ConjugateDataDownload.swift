// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

struct ConjugateDataDownload: View {
  @AppStorage("increaseTextSize", store: UserDefaults(suiteName: "group.be.scri.userDefaultsContainer"))
  var increaseTextSize: Bool = false
  var textSizeMultiplier: CGFloat { increaseTextSize ? 1.25 : 1.0 }

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(NSLocalizedString(
        "i18n.app.download.menu_option.conjugate_title",
        value: "Verb data",
        comment: ""
      ))
      .font(.system(size: 19 * textSizeMultiplier, weight: .semibold))
      .foregroundColor(.primary)

      VStack(alignment: .leading, spacing: 6) {
        HStack {
          Text(NSLocalizedString(
            "i18n.app.download.menu_option.conjugate_download_data_start",
            value: "Download data to start conjugating!",
            comment: ""
          ))
          .font(.system(size: 17 * textSizeMultiplier))
          .foregroundColor(.primary)

          Spacer()

          Image(systemName: "chevron.right")
            .foregroundColor(.gray)
        }

        Text(NSLocalizedString(
          "i18n.app.download.menu_option.conjugate_description",
          value: "Add new data to Scribe Conjugate.",
          comment: ""
        ))
        .font(.system(size: 15 * textSizeMultiplier))
        .foregroundColor(.secondary)
      }
      .padding()
      .background(Color(.systemBackground))
      .cornerRadius(12)
      .onTapGesture {
        // Navigation to download screen.
      }
    }
    .padding(.horizontal)
  }
}
