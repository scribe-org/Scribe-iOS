//
//  KeyboardStyling.swift
//
//  Functions to style keyboard elements.
//

import UIKit

/// Styles a button including it's shape and text.
///
/// - Parameters
///  - btn: the button to be styled.
///  - title: the title to be assigned.
///  - radius: the corner radius of the button.
func styleBtn(btn: UIButton, title: String, radius: CGFloat) {
  btn.clipsToBounds = true
  btn.layer.masksToBounds = false
  btn.layer.cornerRadius = radius
  btn.setTitle(title, for: .normal)
  btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
  btn.setTitleColor(keyCharColor, for: .normal)

  if title != "Scribe" {
    btn.layer.shadowColor = keyShadowColor
    btn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    btn.layer.shadowOpacity = 1.0
    btn.layer.shadowRadius = 0.0
  }
}

// The names of symbols whose keys should be slightly larger than the default size.
var keysThatAreSlightlyLarger: [String] = [
  "delete.left",
  "chevron.left",
  "chevron.right",
  "shift",
  "shift.fill",
  "capslock.fill"
]

/// Get the icon configurations for keys if the device is an iPhone.
///
/// - Parameters
///  - iconName: the name of the UIImage systemName icon to be used.
func getPhoneIconConfig(iconName: String) -> UIImage.SymbolConfiguration {
  var iconConfig = UIImage.SymbolConfiguration(
    pointSize: letterKeyWidth / 1.75,
    weight: .light,
    scale: .medium
  )
  if keysThatAreSlightlyLarger.contains(iconName) {
    iconConfig = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 1.55,
      weight: .light,
      scale: .medium
    )
  }
  if isLandscapeView == true {
    iconConfig = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 3.5,
      weight: .light,
      scale: .medium
    )
    if keysThatAreSlightlyLarger.contains(iconName) {
      iconConfig = UIImage.SymbolConfiguration(
        pointSize: letterKeyWidth / 3.2,
        weight: .light,
        scale: .medium
      )
    }
  }
  return iconConfig
}

/// Get the icon configurations for keys if the device is an iPad.
///
/// - Parameters
///  - iconName: the name of the UIImage systemName icon to be used.
func getPadIconConfig(iconName: String) -> UIImage.SymbolConfiguration {
  keysThatAreSlightlyLarger.append("globe")
  var iconConfig = UIImage.SymbolConfiguration(
    pointSize: letterKeyWidth / 3,
    weight: .light,
    scale: .medium
  )
  if keysThatAreSlightlyLarger.contains(iconName) {
    iconConfig = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 2.75,
      weight: .light,
      scale: .medium
    )
  }
  if isLandscapeView == true {
    iconConfig = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 3.75,
      weight: .light,
      scale: .medium
    )
    if keysThatAreSlightlyLarger.contains(iconName) {
      iconConfig = UIImage.SymbolConfiguration(
        pointSize: letterKeyWidth / 3.4,
        weight: .light,
        scale: .medium
      )
    }
  }
  keysThatAreSlightlyLarger.removeAll { $0 == "globe" }
  return iconConfig
}

/// Styles buttons that have icon keys.
///
/// - Parameters
///  - btn: the button to be styled.
///  - color: the tint color for the icon on the key.
///  - iconName: the name of the UIImage systemName icon to be used.
func styleIconBtn(btn: UIButton, color: UIColor, iconName: String) {
  btn.setTitle("", for: .normal)
  var iconConfig = getPhoneIconConfig(iconName: iconName)
  if DeviceType.isPad {
    iconConfig = getPadIconConfig(iconName: iconName)
  }

  btn.setImage(UIImage(systemName: iconName, withConfiguration: iconConfig), for: .normal)
  btn.tintColor = color
}

/// Adds padding to keys to position them.
///
/// - Parameters
///  - to: the stackView in which the button is found.
///  - width: the width of the padding.
///  - key: the key associated with the button.
func addPadding(to stackView: UIStackView, width: CGFloat, key: String) {
  let padding = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
  padding.setTitleColor(.clear, for: .normal)
  padding.alpha = 0.0
  padding.widthAnchor.constraint(equalToConstant: width).isActive = true
  padding.isUserInteractionEnabled = false

  paddingViews.append(padding)
  stackView.addArrangedSubview(padding)
}

// Variables that define which keys are positioned on the very left, right or in the center of the keyboard.
// The purpose of these is to define which key pop up functions should be ran.
var centralKeyChars: [String] = [String]()
var leftKeyChars: [String] = [String]()
var rightKeyChars: [String] = [String]()

/// Creates the shape that allows left most buttons to pop up after being pressed.
///
/// - Parameters
///   - startX: the x-axis starting point.
///   - startY: the y-axis starting point.
///   - keyWidth: the width of the key.
///   - keyHeight: the height of the key.
///   - char: the character of the key.
func leftKeyPopPath(
  startX: CGFloat,
  startY: CGFloat,
  keyWidth: CGFloat,
  keyHeight: CGFloat,
  char: String) -> UIBezierPath {
  // Starting positions need to be updated.
  let horizStart = startX
  let vertStart = startY + keyHeight

  // Path is clockwise from bottom left.
  let path = UIBezierPath()
  path.move(to: CGPoint(x: horizStart, y: vertStart))

  // Curve up past bottom left, path up, and curve right past the top left.

  // Path right, curve down past the top right, and path down.

  // Curve in to the left, go down, and curve down past bottom left.

  return path
}

/// Creates the shape that allows right most buttons to pop up after being pressed.
///
/// - Parameters
///   - startX: the x-axis starting point.
///   - startY: the y-axis starting point.
///   - keyWidth: the width of the key.
///   - keyHeight: the height of the key.
///   - char: the character of the key.
func rightKeyPopPath(
  startX: CGFloat,
  startY: CGFloat,
  keyWidth: CGFloat,
  keyHeight: CGFloat,
  char: String) -> UIBezierPath {
  // Starting positions need to be updated.
  let horizStart = startX
  let vertStart = startY + keyHeight

  // Path is clockwise from bottom left.
  let path = UIBezierPath()
  path.move(to: CGPoint(x: horizStart, y: vertStart))

  // Curve up past bottom left, path up, and curve out to the left.

  // Path up and curve right past the top left.

  // Path right, curve down past the top right, and path down.

  // Curve down past bottom left.

  return path
}

/// Creates the shape that allows central buttons to pop up after being pressed.
///
/// - Parameters
///   - startX: the x-axis starting point.
///   - startY: the y-axis starting point.
///   - keyWidth: the width of the key.
///   - keyHeight: the height of the key.
///   - char: the character of the key.
func centerKeyPopPath(
  startX: CGFloat,
  startY: CGFloat,
  keyWidth: CGFloat,
  keyHeight: CGFloat,
  char: String) -> UIBezierPath {
  // Starting positions need to be updated.
  let horizStart = startX
  let vertStart = startY + keyHeight
  var widthMultiplier = 0.0
  if DeviceType.isPhone && [".", ",", "?", "!", "'"].contains(char) {
    widthMultiplier = 0.2
  } else {
    widthMultiplier = 0.4
  }

  // Path is clockwise from bottom left.
  let path = UIBezierPath()
  path.move(to: CGPoint(x: horizStart + ( keyWidth * 0.075 ), y: vertStart))

  // Curve up past bottom left, path up, and curve out to the left.
  path.addCurve(to: CGPoint(
    x: horizStart,
    y: vertStart - ( keyHeight * 0.075 )),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * 0.075 ), y: vertStart - ( keyHeight * 0.005 )),
    controlPoint2: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.005 )))
  path.addLine(to: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.85 )))
  path.addCurve(to: CGPoint(
    x: horizStart - ( keyWidth * widthMultiplier ),
    y: vertStart - ( keyHeight * 1.2 )),
    controlPoint1: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.9 )),
    controlPoint2: CGPoint(x: horizStart - ( keyWidth * widthMultiplier ), y: vertStart - ( keyHeight * 1.05 )))

  // Path up and curve right past the top left.
  path.addLine(to: CGPoint(x: horizStart - ( keyWidth * widthMultiplier ), y: vertStart - ( keyHeight * 1.8 )))
  path.addCurve(to: CGPoint(
    x: horizStart + ( keyWidth * 0.075 ),
    y: vertStart - ( keyHeight * 2.125 )),
    controlPoint1: CGPoint(x: horizStart - ( keyWidth * widthMultiplier ), y: vertStart - ( keyHeight * 2 )),
    controlPoint2: CGPoint(x: horizStart - ( keyWidth * 0.25 ), y: vertStart - ( keyHeight * 2.125 )))

  // Path right, curve down past the top right, and path down.
  path.addLine(to: CGPoint(x: horizStart + ( keyWidth * 0.925 ), y: vertStart - ( keyHeight * 2.125 )))
  path.addCurve(to: CGPoint(
    x: horizStart + ( keyWidth * ( 1 + widthMultiplier ) ),
    y: vertStart - ( keyHeight * 1.8 )),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * 1.25 ), y: vertStart - ( keyHeight * 2.125 )),
    controlPoint2: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier ) ), y: vertStart - ( keyHeight * 2 )))
  path.addLine(to: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier ) ), y: vertStart - ( keyHeight * 1.2 )))

  // Curve in to the left, go down, and curve down past bottom left.
  path.addCurve(to: CGPoint(
    x: horizStart + keyWidth,
    y: vertStart - ( keyHeight * 0.85 )),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier ) ), y: vertStart - ( keyHeight * 1.05 )),
    controlPoint2: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.9 )))
  path.addLine(to: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.075 )))
  path.addCurve(to: CGPoint(
    x: horizStart + ( keyWidth * 0.925 ),
    y: vertStart),
    controlPoint1: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.005 )),
    controlPoint2: CGPoint(x: horizStart + ( keyWidth * 0.925 ), y: vertStart - ( keyHeight * 0.005 )))

  path.close()
  return path
}

/// Creates and styles the pop up animation of a key.
///
/// - Parameters
///   - key: the key pressed.
///   - layer: the layer to be set.
///   - char: the character of the key.
///   - displayChar: the character to display on the pop up.
func genKeyPop(key: UIButton, layer: CAShapeLayer, char: String, displayChar: String) {
  if DeviceType.isPhone {
    if shiftButtonState == .shift || shiftButtonState == .caps {
      if isLandscapeView == true {
        keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.25)
        keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.25)
      } else {
        keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 1)
        keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 1)
      }
    } else {
      if isLandscapeView == true {
        keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2)
        keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2)
      } else {
        keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 0.9)
        keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 0.9)
      }
    }
  } else if DeviceType.isPad {
    if shiftButtonState == .shift || shiftButtonState == .caps {
      if isLandscapeView == true {
        keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 3)
        keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 3)
      } else {
        keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.5)
        keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.5)
      }
    } else {
      if isLandscapeView == true {
        keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.75)
        keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.75)
      } else {
        keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.25)
        keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.25)
      }
    }
  }

  let popLbls: [UILabel] = [keyPopChar, keyHoldPopChar]
  for lbl in popLbls {
    lbl.text = displayChar
    lbl.backgroundColor = .clear
    lbl.textAlignment = .center
    lbl.textColor = keyCharColor
    lbl.sizeToFit()
  }

  // Get the frame in respect to the superview.
  let frame: CGRect = (key.superview?.convert(key.frame, to: nil))!

  if centralKeyChars.contains(char) {
    layer.path = centerKeyPopPath(
      startX: frame.origin.x,
      startY: frame.origin.y,
      keyWidth: key.frame.width,
      keyHeight: key.frame.height,
      char: char).cgPath
    keyPopChar.center = CGPoint(
      x: frame.origin.x + key.frame.width / 2,
      y: frame.origin.y - key.frame.height / 1.75)
    keyHoldPopChar.center = CGPoint(
      x: frame.origin.x + key.frame.width / 2,
      y: frame.origin.y - key.frame.height / 1.75)
  } else if leftKeyChars.contains(char) {
    layer.path = leftKeyPopPath(
      startX: frame.origin.x,
      startY: frame.origin.y,
      keyWidth: key.frame.width,
      keyHeight: key.frame.height,
      char: char).cgPath
  } else if rightKeyChars.contains(char) {
    layer.path = rightKeyPopPath(
      startX: frame.origin.x,
      startY: frame.origin.y,
      keyWidth: key.frame.width,
      keyHeight: key.frame.height,
      char: char).cgPath
  }

  layer.strokeColor = keyShadowColor
  layer.fillColor = keyColor.cgColor
  layer.lineWidth = 1.0
}
