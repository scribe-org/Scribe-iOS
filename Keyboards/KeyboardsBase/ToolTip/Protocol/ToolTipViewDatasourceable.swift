//
//  ToolTipViewDatasourceable.swift
//  Scribe
//
//  Created by Gabriel Moraes on 03/12/22.
//

import Foundation

protocol ToolTipViewDatasourceable {
  var theme: ViewThemeable { get set }
  
  func getCurrentText() -> NSMutableAttributedString
}
