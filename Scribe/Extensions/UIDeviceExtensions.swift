// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Checks if the device has a home button or not via safe area checks.
 */

import UIKit

extension UIDevice {
    public static var hasNotch: Bool {
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
        return false
      }
      if windowScene.windows.count == 0 { return false }
      let top = scene.windows.first?.safeAreaInsets.top ?? 0
      return top > 24
    }

    private static var scene: UIWindowScene {
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
        fatalError("No connected scenes.")
      }
      return windowScene
    }
}
