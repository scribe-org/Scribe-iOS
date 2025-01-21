// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Creates tooltips to be used in the ToolTipView.
 */

import Foundation

struct ToolTipViewDatasource: ToolTipViewDatasourceable {
  var theme: ViewThemeable
  private var content: NSMutableAttributedString

  // MARK: Init

  init(content: NSMutableAttributedString, theme: ViewThemeable) {
    self.content = content
    self.theme = theme
  }

  func getCurrentText() -> NSMutableAttributedString {
    content
  }
}
