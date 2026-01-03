// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * The app tip views for the application tabs.
 */

import SwiftUI

struct TipCardView: View {
  private let buttonHeight = 70.0
  private let multiplicityPadding = 0.5
  private let leadingPadding = 40.0
  private let cardCornerRadius: CGFloat = 10
  var infoText: String
  @Binding var tipCardState: Bool
  var onDismiss: (() -> Void)?
  let ok = "OK"
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: cardCornerRadius)
        .fill(Color.lightWhiteDarkBlack)
      HStack {
        Image(systemName: "lightbulb.max")
          .resizable()
          .frame(width: leadingPadding, height: leadingPadding)
          .foregroundColor(Color.scribeCTA)
          .padding(.horizontal)
        Text(infoText)
          .font(Font.system(size: DeviceType.isPad ? 22 : 0, weight: .medium))
        Spacer()
        Button {
          tipCardState = false
          self.onDismiss?()
        } label: {
          Text(ok)
            .foregroundColor(.white)
        }
        .frame(width: leadingPadding, height: leadingPadding)
        .background(Color.scribeBlue)
        .cornerRadius(cardCornerRadius)
        .padding(.horizontal)
      }
    }
    .frame(
      width: UIScreen.main.bounds.size.width - leadingPadding * multiplicityPadding,
      height: buttonHeight
    )
    .shadow(color: Color.keyShadow, radius: cardCornerRadius / 2)
    .opacity(tipCardState ? 1.0 : 0)
    .edgesIgnoringSafeArea(.all)
  }
}

struct InstallationTipCardView: View {
  @AppStorage("installationTipCardState", store: .standard) var installationTipCardState: Bool = true

  var body: some View {
    TipCardView(
      infoText: NSLocalizedString("i18n.app.installation.app_hint_tooltip",
                                  value: "Follow the directions below to install Scribe keyboards on your device.",
                                  comment: ""),
      tipCardState: $installationTipCardState
    )
  }
}

struct SettingsTipCardView: View {
  @AppStorage("settingsTipCardState", store: .standard) var settingsTipCardState: Bool = true
  var onDismiss: (() -> Void)?

  var body: some View {
    TipCardView(
      infoText: NSLocalizedString("i18n.app.settings.app_hint_tooltip", value: "Settings for the app and installed language keyboards are found here.", comment: ""),
      tipCardState: $settingsTipCardState,
      onDismiss: onDismiss
    )
  }
}

struct AboutTipCardView: View {
  @AppStorage("aboutTipCardState", store: .standard) var aboutTipCardState: Bool = true

  var body: some View {
    TipCardView(
      infoText: NSLocalizedString("i18n.app.about.app_hint_tooltip", value: "Here's where you can learn more about Scribe and its community.", comment: ""),
      tipCardState: $aboutTipCardState
    )
  }
}
