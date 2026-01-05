// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Download Button for each language.
 */

import SwiftUI

// Define button states
enum ButtonState {
  case ready
  case downloading
  case updated
  case update

  var config: ButtonConfig {
    switch self {
    case .ready:
      return ButtonConfig(
        text: NSLocalizedString("i18n.app._global.download_data", value: "Download data", comment: ""),
        icon: "icloud.and.arrow.down",
        backgroundColor: Color("scribeCTA"),
        foregroundColor: Color("lightTextDarkCTA")
      )
    case .downloading:
      return ButtonConfig(
        text: NSLocalizedString("i18n.app.download.menu_ui.download_data.downloading", value: "Downloading", comment: ""),
        icon: "arrow.clockwise.circle.fill",
        backgroundColor: Color("scribeCTA"),
        foregroundColor: Color("lightTextDarkCTA")
      )
    case .updated:
      return ButtonConfig(
        text: NSLocalizedString("i18n.app.download.menu_ui.download_data.up_to_date", value: "Up to date", comment: ""),
        icon: "icloud.and.arrow.down",
        backgroundColor: .annotateGreen,
        foregroundColor: Color("lightTextDarkCTA")
      )
    case .update:
      return ButtonConfig(
        text: NSLocalizedString("i18n.app.download.menu_ui.download_data.update", value: "Update", comment: ""),
        icon: "checkmark.circle.fill",
        backgroundColor: Color("scribeCTA"),
        foregroundColor: Color("lightTextDarkCTA")
      )
    }
  }
}

struct ButtonConfig {
  let text: String
  let icon: String
  let backgroundColor: Color
  let foregroundColor: Color
}

struct DownloadButton: View {
  let state: ButtonState
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        Text(state.config.text)
        Image(systemName: state.config.icon)
      }
      .font(.system(size: 12, weight: .semibold))
      .foregroundColor(state.config.foregroundColor)
      .padding(.vertical, 6)
      .padding(.horizontal, 10)
      .background(state.config.backgroundColor)
      .cornerRadius(6)
    }
    .animation(.easeInOut(duration: 0.2), value: state)
  }
}
