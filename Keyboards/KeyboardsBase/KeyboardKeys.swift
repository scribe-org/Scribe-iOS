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

/// Sets a button's values that are displayed and inserted into the proxy as well as assigning a color.
///
/// - Parameters
///   - btn: the button to be set up.
///   - color: the color to assign to the background.
///   - name: the name of the value for the key.
///   - canCapitalize: whether the key receives a special character for the shift state.
///   - isSpecial: whether the btn should be marked as special to be colored accordingly.
func setBtn(btn: UIButton, color: UIColor, name: String, canCapitalize: Bool, isSpecial: Bool) {
  btn.backgroundColor = color
  btn.layer.setValue(name, forKey: "original")

  let charsWithoutShiftState = ["ß"]

  var capsKey = ""
  if canCapitalize == true {
    if !charsWithoutShiftState.contains(name) {
      capsKey = name.capitalized
    } else {
      capsKey = name
    }
    let shiftChar = shiftButtonState == .normal ? name : capsKey
    btn.layer.setValue(shiftChar, forKey: "keyToDisplay")
  } else {
    btn.layer.setValue(name, forKey: "keyToDisplay")
  }
  btn.layer.setValue(isSpecial, forKey: "isSpecial")
}
