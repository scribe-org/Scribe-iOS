// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ConjugateTab()
                .tabItem {
                    Label("Conjugate", systemImage: "character.book.closed")
                }

            SettingsTab()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }

            AboutTab()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
    }
}
