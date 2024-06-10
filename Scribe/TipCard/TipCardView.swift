//
//  TipCardView.swift
//  Scribe
//
//  Created by Kailash Bora on 20/05/24.
//

import SwiftUI

struct TipCardView: View {
  private let buttonHeight = 70.0
  private let multiplicityPadding = 0.5
  private let leadingPadding = 40.0
  private let cardCornerRadius: CGFloat = 10
  @Binding var isVisible: Bool
  @State var infoText: String

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
            isVisible = false
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
      .shadow(radius: cardCornerRadius)
      .opacity(isVisible ? 1.0 : 0)
      .edgesIgnoringSafeArea(.all)
    }
}
