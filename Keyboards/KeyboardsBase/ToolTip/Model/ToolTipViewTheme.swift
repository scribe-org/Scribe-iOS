// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Attributes for tooltips.
 */

import UIKit

struct ToolTipViewTheme: ViewThemeable {
  var backgroundColor: UIColor
  var textFont: UIFont?
  var textColor: UIColor?
  var textAlignment: NSTextAlignment?
  var cornerRadius: CGFloat?
  var masksToBounds: Bool?
  var maskedCorners: CACornerMask?
}
