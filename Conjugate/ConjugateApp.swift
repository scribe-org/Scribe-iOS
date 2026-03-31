// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

@main
struct ConjugateApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("increaseTextSize") private var increaseTextSize = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .dynamicTypeSize(increaseTextSize ? .xLarge : .medium)
        }
    }
}
