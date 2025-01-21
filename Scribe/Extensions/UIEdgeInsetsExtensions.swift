// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Extensions for UIEdgeInsets.
 */

import UIKit

extension UIEdgeInsets {

  // MARK: Initialisation

  init(vertical: CGFloat, horizontal: CGFloat) {
    self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
  }
}
