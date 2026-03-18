// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI

struct AppNavigation<Content: View>: View {
    let content: () -> Content

    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                content()
            }
        } else {
            NavigationView {
                content()
            }
        }
    }
}
