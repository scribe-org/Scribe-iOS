//
//  KeyAnimation.swift
//
//  Functions to pop up key characters and present alternate keys.
// 

import UIKit

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
  char: String
) -> UIBezierPath {
  // Starting positions need to be updated.
  let horizStart = startX
  let vertStart = startY + keyHeight

  // Path is clockwise from bottom left.
  let path = UIBezierPath()
  path.move(to: CGPoint(x: horizStart, y: vertStart))

  // Curve up past bottom left, path up, and curve right past the top left.

  // Path right, curve down past the top right, and path down.

  // Curve in to the left, go down, and curve down past bottom left.

  path.close()
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
  char: String
) -> UIBezierPath {
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

  path.close()
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
  char: String
) -> UIBezierPath {
  // Starting positions need to be updated.
  let horizStart = startX
  let vertStart = startY + keyHeight
  var widthMultiplier = 0.0
  var maxHeightMultiplier = 0.0
  if DeviceType.isPad {
    widthMultiplier = 0.2
    maxHeightMultiplier = 2.05
  } else if DeviceType.isPhone && [".", ",", "?", "!", "'"].contains(char) {
    widthMultiplier = 0.2
    maxHeightMultiplier = 2.125
  } else {
    widthMultiplier = 0.4
    maxHeightMultiplier = 2.125
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
    y: vertStart - ( keyHeight * maxHeightMultiplier )),
                controlPoint1: CGPoint(
                  x: horizStart - ( keyWidth * widthMultiplier ),
                  y: vertStart - ( keyHeight * (maxHeightMultiplier - 0.125) )),
    controlPoint2: CGPoint(x: horizStart - ( keyWidth * 0.25 ), y: vertStart - ( keyHeight * maxHeightMultiplier )))

  // Path right, curve down past the top right, and path down.
  path.addLine(to: CGPoint(x: horizStart + ( keyWidth * 0.925 ), y: vertStart - ( keyHeight * maxHeightMultiplier )))
  path.addCurve(to: CGPoint(
    x: horizStart + ( keyWidth * ( 1 + widthMultiplier ) ),
    y: vertStart - ( keyHeight * 1.8 )),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * 1.25 ), y: vertStart - ( keyHeight * maxHeightMultiplier )),
    controlPoint2: CGPoint(
      x: horizStart + ( keyWidth * ( 1 + widthMultiplier ) ),
      y: vertStart - ( keyHeight * (maxHeightMultiplier - 0.125) )))
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

/// Sizes the character displayed on a key pop for iPhones.
///
/// - Parameters
///   - char: the character of the key.
func setPhoneKeyPopCharSize(char: String) {
  if keyboardState != .letters && !["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(char) {
    if isLandscapeView == true {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.25)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.25)
    } else {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 1.25)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 1.25)
    }
  } else if shiftButtonState == .shift || shiftButtonState == .caps {
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
}

/// Sizes the character displayed on a key pop for iPads.
///
/// - Parameters
///   - char: the character of the key.
func setPadKeyPopCharSize(char: String) {
  if keyboardState != .letters && !["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(char) {
    if isLandscapeView == true {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 3)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 3)
    } else {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.5)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.5)
    }
  } else if keyboardState == .letters && ( shiftButtonState == .shift || shiftButtonState == .caps ) {
    if isLandscapeView == true {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 3)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 3)
    } else {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2)
    }
  } else {
    if isLandscapeView == true {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.75)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.75)
    } else {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 1.75)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 1.75)
    }
  }
}

/// Sizes the character displayed on a key pop.
///
/// - Parameters
///   - char: the character of the key.
func setKeyPopCharSize(char: String) {
  if DeviceType.isPhone {
    setPhoneKeyPopCharSize(char: char)
  } else if DeviceType.isPad {
    setPadKeyPopCharSize(char: char)
  }
}

/// Creates and styles the pop up animation of a key.
///
/// - Parameters
///   - key: the key pressed.
///   - layer: the layer to be set.
///   - char: the character of the key.
///   - displayChar: the character to display on the pop up.
func genKeyPop(key: UIButton, layer: CAShapeLayer, char: String, displayChar: String) {
  setKeyPopCharSize(char: char)

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
