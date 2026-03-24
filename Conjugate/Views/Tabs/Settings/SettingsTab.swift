// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

struct SettingsTab: View {
    var body: some View {
        AppNavigation {
            Text("Settings")
                .font(.largeTitle)
                .navigationTitle("Settings")
        }
    }
}
