// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Controls the ToolTipViewDatasourceable protocol.
 */

import Foundation

protocol ToolTipViewDatasourceable {
  var theme: ViewThemeable { get set }

  func getCurrentText() -> NSMutableAttributedString
}
