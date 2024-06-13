//
//  TransparentOverlayViewController.swift
//  Scribe
//
//  Created by Kailash Bora on 11/06/24.
//

import UIKit
import SwiftUI

class TransparentOverlayViewController: UIViewController {
  private let settingsTipCardState: Bool = {
    let userDefault = UserDefaults.standard
    let state = userDefault.object(forKey: "settingsTipCardState") as? Bool ?? true
    return state
  }()

  var rootView = SettingsTipCardView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .clear
    view.alpha = 1

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if settingsTipCardState {
      showTipCardView()
    }
  }

  private func showTipCardView() {
    let overlayView = SettingsTipCardView(
      settingsTipCardState: settingsTipCardState
    )

    let hostingController = UIHostingController(rootView: overlayView)
    hostingController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80)
    hostingController.view.backgroundColor = .clear
    addChild(hostingController)
    view.addSubview(hostingController.view)
    rootView = hostingController.rootView
    hostingController.didMove(toParent: self)
  }

  private func removeTipCardView() {
    if let hostingController = children.first(where: { $0 is UIHostingController<SettingsTipCardView> }) {
      hostingController.willMove(toParent: nil)
      hostingController.view.removeFromSuperview()
      hostingController.removeFromParent()
    }
  }
}
