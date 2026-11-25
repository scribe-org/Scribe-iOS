// SPDX-License-Identifier: GPL-3.0-or-later

/*
 * Functions for the Settings tab.
 */

import SwiftUI
import UIKit

final class SettingsViewController: UIViewController {
    // MARK: Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSwiftUI()
        
        // Match the navigation style of the rest of the app.
        title = NSLocalizedString("i18n.app.settings.title", value: "Settings", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupSwiftUI() {
        let settingsHomeView = SettingsHomeView()
        let hostingController = UIHostingController(rootView: settingsHomeView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        
        // Ensure the background matches the app theme.
        hostingController.view.backgroundColor = .clear
    }
}
