// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Confirmation Dialog tooltip.
 */

import SwiftUI

struct ConfirmDialogView: View {
  private let cardCornerRadius: CGFloat = 10
  private let iconSize: CGFloat = 30.0
  private let cardPadding: CGFloat = 16
  private let externalPadding: CGFloat = 5
  private let shadowColor = Color(red: 63/255, green: 63/255, blue: 70/255).opacity(0.25)

  var infoText: String
  var changeButtonText: String
  var confirmButtonText: String

  var body: some View {
    VStack(spacing: 10) {
      HStack(alignment: .center) {
        Image(systemName: "info.circle")
          .resizable()
          .frame(width: iconSize, height: iconSize)
          .foregroundColor(Color.scribeCTA)

        Text(infoText)
          .font(.system(size: DeviceType.isPad ? 22 : 0))
          .fixedSize(horizontal: false, vertical: true)
      }

      HStack {
        Spacer()
        Button(
            action: {},
            label: {
                Text(changeButtonText)
                .foregroundColor(Color.keyChar)
                })
          .buttonStyle(.borderedProminent)
          .tint(Color.keySpecial)
          .shadow(
            color: shadowColor,
            radius: 1,
            x: 0,
            y: 3
          )
        Button(
            action: {},
            label: {
                Text(confirmButtonText)
                .foregroundColor(Color.keyChar)
                })
          .buttonStyle(.borderedProminent)
          .tint(Color.scribeBlue)
          .shadow(
            color: shadowColor,
            radius: 3,
            x: 0,
            y: 3
          )
      }
    }
    .padding(cardPadding)
    .background(
        RoundedRectangle(cornerRadius: cardCornerRadius)
            .fill(Color.lightWhiteDarkBlack)
            .shadow(
              color: shadowColor,
              radius: 3,
              x: 0,
              y: 4
            )
    )
    .padding(externalPadding)
  }
}

struct ConfirmTranslationSource: View {
  var body: some View {
    ConfirmDialogView(infoText: "The data you will download will allow you to translate from  English to German. Do you want to change the language you'll translate  from?", changeButtonText: "Change language", confirmButtonText: "Use English")
  }
}
