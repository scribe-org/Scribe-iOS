// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * UIKit bridge for presenting the system share sheet in SwiftUI.
 */

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
  let items: [Any]

  func makeUIViewController(context: Context) -> UIActivityViewController {
    UIActivityViewController(activityItems: items, applicationActivities: nil)
  }

  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
