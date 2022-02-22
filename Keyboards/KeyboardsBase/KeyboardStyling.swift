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
func leftKeyPopPath( startX: CGFloat, startY: CGFloat, keyWidth: CGFloat, keyHeight: CGFloat) -> UIBezierPath {
  // Starting positions need to be updated.
//  let horizStart = startX
//  let vertStart = startY + keyHeight

  // Path is clockwise from bottom left.
  let path = UIBezierPath()

  return path
}

/// Creates the shape that allows right most buttons to pop up after being pressed.
func rightKeyPopPath( startX: CGFloat, startY: CGFloat, keyWidth: CGFloat, keyHeight: CGFloat) -> UIBezierPath {
  // Starting positions need to be updated.
//  let horizStart = startX
//  let vertStart = startY + keyHeight

  // Path is clockwise from bottom left.
  let path = UIBezierPath()

  return path
}

/// Creates the shape that allows central buttons to pop up after being pressed.
func centerKeyPopPath( startX: CGFloat, startY: CGFloat, keyWidth: CGFloat, keyHeight: CGFloat) -> UIBezierPath {
  // Starting positions need to be updated.
  let horizStart = startX
  let vertStart = startY + keyHeight

  // Path is clockwise from bottom left.
  let path = UIBezierPath()
  path.move(to: CGPoint(x: horizStart, y: vertStart))

  // Go up and curve out to the left.
  path.addLine(to: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.95 )))
  path.addLine(to: CGPoint(x: horizStart - ( keyWidth * 0.4 ), y: vertStart - ( keyHeight * 0.95 )))
  //  path.addCurve(to: CGPoint(
  //    x: horizStart  - ( keyWidth * 0.75 / 2 ),
  //    y: vertStart + ( keyHeight * 1.1 )),
  //    controlPoint1: CGPoint(x: horizStart - ( keyWidth * 0.75 ), y: vertStart + ( keyHeight * 0.75 )),
  //    controlPoint2: CGPoint(x: horizStart, y: vertStart + ( keyHeight * 0.75 )))

  // Path to top left, top right and back down.
  path.addLine(to: CGPoint(x: horizStart - ( keyWidth * 0.4 ), y: vertStart - ( keyHeight * 2.125 )))
  path.addLine(to: CGPoint(x: horizStart + ( keyWidth * 1.4 ), y: vertStart - ( keyHeight * 2.125 )))
  path.addLine(to: CGPoint(x: horizStart + ( keyWidth * 1.4 ), y: vertStart - ( keyHeight * 0.95 )))

  // Curve in to the left and go down to bottom right.
  path.addLine(to: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.95 )))
  //  path.addCurve(to: CGPoint(
  //    x: horizStart + keyWidth,
  //    y: vertStart + ( keyHeight * 0.7 )),
  //    controlPoint1: CGPoint(x: horizStart + keyWidth - ( keyWidth * 0.25 ), y: vertStart + ( keyHeight * 0.75 )),
  //    controlPoint2: CGPoint(x: horizStart + keyWidth + ( keyWidth * 0.25 ), y: vertStart + ( keyHeight * 0.75 )))
  path.addLine(to: CGPoint(x: horizStart + keyWidth, y: vertStart))

  path.close()
  return path
}

/// Creates and styles the pop up animation of a key.
///
/// - Parameters
///   - key: the key pressed.
///   - layer: the layer to be set.
///   - char: the character of the key.
func genKeyPop(key: UIButton, layer: CAShapeLayer, char: String) {
  // Get the frame in respect to the superview.
  let frame: CGRect = (key.superview?.convert(key.frame, to: nil))!

  if centralKeyChars.contains(char) {
    layer.path = centerKeyPopPath(
      startX: frame.origin.x,
      startY: frame.origin.y,
      keyWidth: key.frame.width,
      keyHeight: key.frame.height).cgPath
  } else if leftKeyChars.contains(char) {
    layer.path = leftKeyPopPath(
      startX: frame.origin.x,
      startY: frame.origin.y,
      keyWidth: key.frame.width,
      keyHeight: key.frame.height).cgPath
  } else if rightKeyChars.contains(char) {
    layer.path = rightKeyPopPath(
      startX: frame.origin.x,
      startY: frame.origin.y,
      keyWidth: key.frame.width,
      keyHeight: key.frame.height).cgPath
  }

  layer.strokeColor = keyShadowColor
  layer.fillColor = keyColor.cgColor
  layer.lineWidth = 1.0
}
