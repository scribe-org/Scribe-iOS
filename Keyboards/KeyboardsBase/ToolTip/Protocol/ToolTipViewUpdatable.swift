// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Controls the ToolTipViewUpdatable protocol.
 */

import Foundation

protocol ToolTipViewUpdatable {
  var didUpdatePage: ((ConjViewShiftButtonsState) -> Void)? { get set }

  func updateNext()
  func updatePrevious()
  func updateText(index: Int)
}
