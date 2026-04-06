// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

struct ConjugateTab: View {
    var body: some View {
      AppNavigation {
            ScrollView {
              VStack(spacing: 20) {
                Image("ScribeLogo")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 200, height: 100)
                  .padding(.top, 30)
                ConjugateDataDownload()
              }
              .padding()
            }
            .background(Color("scribeAppBackground"))
            .navigationBarHidden(true)
          }
    }
}
