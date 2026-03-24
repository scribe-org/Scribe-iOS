// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * A grouped section container used in the About tab.
 */

import SwiftUI

struct AboutSectionView<Content: View>: View {
  let heading: String
  @ViewBuilder let content: () -> Content

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(heading)
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.primary)
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 10)

      VStack(spacing: 0) {
        content()
      }
      .background(Color("lightWhiteDarkBlack"))
      .cornerRadius(12)
      .padding(.horizontal, 20)
    }
  }
}
