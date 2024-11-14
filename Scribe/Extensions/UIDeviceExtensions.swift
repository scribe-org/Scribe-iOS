/**
 * Checks if the device has a home button or not via safe area checks.
 *
 * Copyright (C) 2024 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
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
