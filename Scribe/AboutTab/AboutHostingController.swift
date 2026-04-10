// SPDX-License-Identifier: GPL-3.0-or-later

import SwiftUI
import UIKit

/// Hosts the SwiftUI AboutTab inside the UIKit storyboard navigation stack.
final class AboutHostingController: UIHostingController<AnyView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AnyView(AboutTab()))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem.title = NSLocalizedString("i18n.app.about.title", value: "About", comment: "")
        navigationController?.tabBarItem.title = NSLocalizedString("i18n.app.about.title", value: "About", comment: "")
    }
}
