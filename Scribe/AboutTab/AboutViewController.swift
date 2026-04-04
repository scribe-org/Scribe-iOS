// SPDX-License-Identifier: GPL-3.0-or-later

/*
 * Functions for the About tab.
 */

import SwiftUI
import UIKit

final class AboutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("i18n.app.about.title", value: "About", comment: "")
        navigationController?.tabBarItem.title = NSLocalizedString("i18n.app.about.title", value: "About", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        let hostingController = UIHostingController(rootView: AboutTab())
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
}
