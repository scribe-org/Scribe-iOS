//
//  InterfaceVariables.swift.swift
//  Scribe
//
// Variables assosciated with Scribe's user interface.
//

import UIKit

// A proxy into which text is typed.
var proxy: UITextDocumentProxy!

// Variables for keyboard appearance.
var keyboardHeight: CGFloat!
var btnKeyCornerRadius: CGFloat!
var buttonWidth = CGFloat(5) // place holder

// View that stores hold-to-select key options.
var alternatesKeyView: UIView!

// Arrays for the possible keyboard views that are loaded with their characters.
var letterKeys = [[String]]()
var numberKeys = [[String]]()
var symbolKeys = [[String]]()

/// States of the keyboard corresponding to layouts found in KeyboardConstants.swift.
enum KeyboardState {
  case letters
  case numbers
  case symbols
}

/// What the keyboard state is in regards to the shift key.
/// - normal: not capitalized
/// - shift: capitalized
/// - caps: caps-lock
enum ShiftButtonState {
  case normal
  case shift
  case caps
}

// Baseline state variables.
var keyboardState: KeyboardState = .letters
var shiftButtonState: ShiftButtonState = .normal
var scribeBtnState: Bool! = false

// Variables and functions to determine display parameters.
var isLandscapeView: Bool = false

struct DeviceType {
  static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
  static let isPad = UIDevice.current.userInterfaceIdiom == .pad
}

/// Determines if the device is in dark mode and sets the color scheme.
func checkDarkModeSetColors() {
  if UITraitCollection.current.userInterfaceStyle == .dark {
    keyColor = UIColor.systemGray2
    specialKeyColor = UIColor.systemGray3
    keyPressedColor = UIColor.systemGray
  } else if UITraitCollection.current.userInterfaceStyle == .light {
    keyColor = .white
    specialKeyColor = UIColor.systemGray2
    keyPressedColor = UIColor.systemGray5
  }
}

func styleBtn(btn: UIButton, title: String, radius: CGFloat) {
  btn.clipsToBounds = true
  btn.layer.masksToBounds = true
  btn.layer.cornerRadius = radius
  btn.setTitle(title, for: .normal)
  btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
  btn.setTitleColor(UIColor.label, for: .normal)
}

func checkLandscapeMode() {
  if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
    isLandscapeView = true
  } else if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
    isLandscapeView = false
  }
}
