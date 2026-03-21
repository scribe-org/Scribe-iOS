// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

struct AboutTab: View {
    var body: some View {
        AppNavigation {
            Text("About")
                .font(.largeTitle)
                .navigationTitle("About")
        }
    }
}
