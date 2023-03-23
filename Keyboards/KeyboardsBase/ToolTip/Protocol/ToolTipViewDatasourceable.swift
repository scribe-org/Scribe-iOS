//
//  ToolTipViewDatasourceable.swift
//

import Foundation

protocol ToolTipViewDatasourceable {
  var theme: ViewThemeable { get set }

  func getCurrentText() -> NSMutableAttributedString
}
