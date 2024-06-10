/**
 * App hints View.
 *
 * Copyright (C) 2023 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import SwiftUI

struct TipCardView: View {
  private let buttonHeight = 70.0
  private let multiplicityPadding = 0.5
  private let leadingPadding = 40.0
  private let cardCornerRadius: CGFloat = 10
  var infoText: String
  @AppStorage("tipCardState", store: .standard) var tipCardState: Bool = true

    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: cardCornerRadius)
          .fill(Color.commandBar)
        HStack {
          Image(systemName: "lightbulb.max")
            .resizable()
            .frame(width: leadingPadding, height: leadingPadding)
            .foregroundColor(Color.scribeCTA)
            .padding(.horizontal)
          Text(infoText)
            .font(Font.system(size: 0, weight: .medium))
          Spacer()
          Button {
            tipCardState = false
          } label: {
            Text("OK")
              .foregroundColor(.white)
          }
          .frame(width: leadingPadding, height: leadingPadding)
          .background(Color.scribeBlue)
          .cornerRadius(cardCornerRadius)
          .padding(.horizontal)
        }
      }
      .frame(width: UIScreen.main.bounds.size.width - leadingPadding * multiplicityPadding,
             height: buttonHeight)
      .shadow(color: Color.keyShadow, radius: cardCornerRadius)
      .opacity(tipCardState ? 1.0 : 0)
      .edgesIgnoringSafeArea(.all)
    }
}
