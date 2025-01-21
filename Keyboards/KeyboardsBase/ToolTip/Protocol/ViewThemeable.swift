// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Controls the ViewThemeable protocol.
 */

import UIKit

protocol ViewThemeable {
  var backgroundColor: UIColor { get set }
  var textFont: UIFont? { get set }
  var textColor: UIColor? { get set }
  var textAlignment: NSTextAlignment? { get set }
  var cornerRadius: CGFloat? { get set }
  var masksToBounds: Bool? { get set }
  var maskedCorners: CACornerMask? { get set }
}
