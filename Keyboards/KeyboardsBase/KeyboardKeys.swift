//
//  KeyboardKey.swift
//
//  Classes and variables that define keys for Scribe keyboards.

import UIKit

// The keys collection as well as one for the padding for placements.
var keyboardKeys: [UIButton] = []
var paddingViews: [UIButton] = []

/// Class of UIButton that allows the tap area to be increased so that edges between keys can still receive user input.
class KeyboardKey: UIButton {
  // Properties for the touch area - passing negative values will expand the touch area.
  var topShift = CGFloat(0)
  var leftShift = CGFloat(0)
  var bottomShift = CGFloat(0)
  var rightShift = CGFloat(0)

  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return bounds.inset(by: UIEdgeInsets(
      top: topShift,
      left: leftShift,
      bottom: bottomShift,
      right: rightShift)
    ).contains(point)
  }
}
