// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Tip card shown at the top of the About tab.
 */

import SwiftUI

struct AboutTipCardView: View {
  let infoText: String
  @Binding var isVisible: Bool
  var onDismiss: (() -> Void)?

  private let cardCornerRadius: CGFloat = 10

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: cardCornerRadius)
        .fill(Color("lightWhiteDarkBlack"))
      HStack(spacing: 12) {
        Image(systemName: "lightbulb.max")
          .resizable()
          .scaledToFit()
          .frame(width: 28, height: 28)
          .foregroundColor(Color("scribeCTA"))
          .padding(.leading, 12)

        Text(infoText)
          .font(.subheadline)
          .foregroundColor(.primary)

        Spacer()

        Button {
          withAnimation(.easeInOut(duration: 0.2)) {
            isVisible = false
          }
          onDismiss?()
        } label: {
          Text("OK")
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .background(Color("scribeBlue"))
            .cornerRadius(cardCornerRadius)
        }
        .padding(.trailing, 12)
      }
    }
    .frame(maxWidth: .infinity)
    .frame(height: 70)
    .shadow(color: Color("keyShadow").opacity(0.4), radius: 5, x: 0, y: 2)
  }
}

