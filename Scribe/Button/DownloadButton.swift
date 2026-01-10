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
        text: NSLocalizedString(
          "i18n.app._global.download_data",
          value: "Download data",
          comment: ""
        ),
        icon: "icloud.and.arrow.down",
        backgroundColor: Color("buttonOrange"),
        foregroundColor: Color("lightTextDarkCTA")
      )
    case .downloading:
      return ButtonConfig(
        text: NSLocalizedString(
          "i18n.app.download.menu_ui.download_data.downloading",
          value: "Downloading",
          comment: ""
        ),
        icon: "arrow.clockwise.circle.fill",
        backgroundColor: Color("buttonOrange"),
        foregroundColor: Color("lightTextDarkCTA")
      )
    case .updated:
      return ButtonConfig(
        text: NSLocalizedString(
          "i18n.app.download.menu_ui.download_data.up_to_date",
          value: "Up to date",
          comment: ""
        ),
        icon: "checkmark.circle.fill",
        backgroundColor: Color("buttonGreen"),
        foregroundColor: Color("lightTextDarkGreen")
      )
    case .update:
      return ButtonConfig(
        text: NSLocalizedString(
          "i18n.app.download.menu_ui.update_data",
          value: "Update data",
          comment: ""
        ),
        icon: "icloud.and.arrow.down",
        backgroundColor: Color("buttonOrange"),
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
  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        Text(state.config.text)
        if state == .downloading {
          ProgressView()
            .tint(state.config.foregroundColor)
            .scaleEffect(0.8)
        } else {
          Image(systemName: state.config.icon)
        }
      }
      .font(.system(size: 12, weight: .semibold))
      .foregroundColor(state.config.foregroundColor)
      .frame(width: 120, height: 20)
      .padding(.vertical, 6)
      .padding(.horizontal, 10)
      .background(state.config.backgroundColor)
      .cornerRadius(6)
      .overlay(
        RoundedRectangle(cornerRadius: 6)
          .stroke(
            colorScheme == .dark ? state.config.foregroundColor : Color.clear,
            lineWidth: 1
          )
      )
    }
    .animation(.easeInOut(duration: 0.2), value: state)
  }
}
