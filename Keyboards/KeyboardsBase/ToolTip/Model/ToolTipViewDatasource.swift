//
//  ToolTipViewDatasource.swift
//  Scribe
//
//  Created by Gabriel Moraes on 03/12/22.
//

import Foundation

struct ToolTipViewDatasource: ToolTipViewDatasourceable {

  var theme: ViewThemeable
  private var content: NSMutableAttributedString
  
  // MARK: - Init
  
  init(content: NSMutableAttributedString, theme: ViewThemeable) {
    self.content = content
    self.theme = theme
  }

  func getCurrentText() -> NSMutableAttributedString {
    content
  }

}
