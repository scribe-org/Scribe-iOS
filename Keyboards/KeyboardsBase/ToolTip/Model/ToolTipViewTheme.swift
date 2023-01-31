//
//  ToolTipViewTheme.swift
//  Scribe
//
//  Created by Gabriel Moraes on 03/12/22.
//

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
