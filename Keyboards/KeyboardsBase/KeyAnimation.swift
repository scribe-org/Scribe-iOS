//
//  KeyAnimation.swift
//
//  Functions to animate key pressed with pop up characters.
//

import UIKit

/// Creates the shape that allows left most buttons to pop up after being pressed.
///
/// - Parameters
///   - startX: the x-axis starting point.
///   - startY: the y-axis starting point.
///   - keyHeight: the height of the key.
///   - char: the character of the key.
///   - position: the position of the key.
func setPopPathState(
  startX: CGFloat,
  startY: CGFloat,
  keyHeight: CGFloat,
  char: String,
  position: String
) {
  // Starting positions need to be updated.
  horizStart = startX; vertStart = startY + keyHeight
  if DeviceType.isPad {
    widthMultiplier = 0.2
    maxHeightMultiplier = 2.05
    if isLandscapeView == true {
      maxHeightMultiplier = 1.95
    }
  } else if DeviceType.isPhone && isLandscapeView == true {
    widthMultiplier = 0.2
    maxHeightMultiplier = 2.125
  } else if DeviceType.isPhone && [".", ",", "?", "!", "'"].contains(char) {
    widthMultiplier = 0.2
    maxHeightMultiplier = 2.125
  } else {
    widthMultiplier = 0.4
    maxHeightMultiplier = 2.125
  }
  // Non central characters have a call out that's twice the width in one direction.
  if position != "center" {
    widthMultiplier *= 2
  }
  maxHeight = vertStart - ( keyHeight * maxHeightMultiplier )
  maxHeightCurveControl = vertStart - ( keyHeight * ( maxHeightMultiplier - 0.125 ))
  minHeightCurveControl = vertStart - ( keyHeight * 0.005 )

  if DeviceType.isPhone {
    heightBeforeTopCurves = vertStart - ( keyHeight * 1.8 )
  } else if DeviceType.isPad || ( DeviceType.isPhone && isLandscapeView == true ) {
    heightBeforeTopCurves = vertStart - ( keyHeight * 1.6 )
  }
}

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
  setPopPathState(
    startX: startX, startY: startY, keyHeight: keyHeight, char: char, position: "left"
  )

  // Path is clockwise from bottom left.
  let path = UIBezierPath()
  path.move(to: CGPoint(x: horizStart + ( keyWidth * 0.075 ), y: vertStart))

  // Curve up past bottom left, path up, and curve right past the top left.
  path.addCurve(
    to: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.075 )),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * 0.075 ), y: minHeightCurveControl),
    controlPoint2: CGPoint(x: horizStart, y: minHeightCurveControl)
    )
  path.addLine(to: CGPoint(x: horizStart, y: heightBeforeTopCurves))
  path.addCurve(
    to: CGPoint(x: horizStart + ( keyWidth * 0.35 ), y: maxHeight),
    controlPoint1: CGPoint(x: horizStart, y: maxHeightCurveControl),
    controlPoint2: CGPoint(x: horizStart + ( keyWidth * 0.2 ), y: maxHeight)
  )

  // Path right, curve down past the top right, and path down.
  path.addLine(to: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier * 0.35 )), y: maxHeight))
  path.addCurve(
    to: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier )), y: heightBeforeTopCurves * 1.15),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier * 0.75 )), y: maxHeight),
    controlPoint2: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier )), y: maxHeightCurveControl)
  )
  path.addLine(to: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier )), y: vertStart - ( keyHeight * 1.3 )))

  // Curve in to the left, go down, and curve down past bottom left.
  path.addCurve(
    to: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.5 )),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier )), y: vertStart - ( keyHeight * 1.05 )),
    controlPoint2: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.9 ))
  )
  path.addLine(to: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.075 )))
  path.addCurve(
    to: CGPoint(x: horizStart + ( keyWidth * 0.925 ), y: vertStart),
    controlPoint1: CGPoint(x: horizStart + keyWidth, y: minHeightCurveControl),
    controlPoint2: CGPoint(x: horizStart + ( keyWidth * 0.925 ), y: minHeightCurveControl)
  )

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
  setPopPathState(
    startX: startX, startY: startY, keyHeight: keyHeight, char: char, position: "right"
  )

  // Path is clockwise from bottom left.
  let path = UIBezierPath(); path.move(to: CGPoint(x: horizStart + ( keyWidth * 0.075 ), y: vertStart))

  // Curve up past bottom left, path up, and curve out to the left.
  path.addCurve(
    to: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.075 )),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * 0.075 ), y: minHeightCurveControl),
    controlPoint2: CGPoint(x: horizStart, y: minHeightCurveControl)
  )
  path.addLine(to: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.5 )))
  path.addCurve(
    to: CGPoint(x: horizStart - ( keyWidth * widthMultiplier ), y: vertStart - ( keyHeight * 1.3 )),
    controlPoint1: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.9 )),
    controlPoint2: CGPoint(x: horizStart - ( keyWidth * widthMultiplier ), y: vertStart - ( keyHeight * 1.05 ))
  )

  // Path up and curve right past the top left.
  path.addLine(to: CGPoint(x: horizStart - ( keyWidth * widthMultiplier ), y: heightBeforeTopCurves))
  path.addCurve(
    to: CGPoint(x: horizStart - ( keyWidth * widthMultiplier  * 0.35 ), y: maxHeight),
    controlPoint1: CGPoint(x: horizStart - ( keyWidth * widthMultiplier ), y: maxHeightCurveControl),
    controlPoint2: CGPoint(x: horizStart - ( keyWidth * widthMultiplier * 0.75 ), y: maxHeight)
  )

  // Path right, curve down past the top right, and path down.
  path.addLine(to: CGPoint(x: horizStart + ( keyWidth * 0.5 ), y: maxHeight))
  path.addCurve(
    to: CGPoint(x: horizStart + keyWidth, y: heightBeforeTopCurves),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * 0.95 ), y: maxHeight),
    controlPoint2: CGPoint(x: horizStart + keyWidth, y: maxHeightCurveControl)
  )
  path.addLine(to: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.075 )))

  // Curve down past bottom left.
  path.addCurve(
    to: CGPoint(x: horizStart + ( keyWidth * 0.925 ), y: vertStart),
    controlPoint1: CGPoint(x: horizStart + keyWidth, y: minHeightCurveControl),
    controlPoint2: CGPoint(x: horizStart + ( keyWidth * 0.925 ), y: minHeightCurveControl)
  )

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
  setPopPathState(
    startX: startX, startY: startY, keyHeight: keyHeight, char: char, position: "center"
  )

  // Path is clockwise from bottom left.
  let path = UIBezierPath(); path.move(to: CGPoint(x: horizStart + ( keyWidth * 0.075 ), y: vertStart))

  // Curve up past bottom left, path up, and curve out to the left.
  path.addCurve(
    to: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.075 )),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * 0.075 ), y: minHeightCurveControl),
    controlPoint2: CGPoint(x: horizStart, y: minHeightCurveControl)
  )
  path.addLine(to: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.85 )))
  path.addCurve(
    to: CGPoint(x: horizStart - ( keyWidth * widthMultiplier ), y: vertStart - ( keyHeight * 1.2 )),
    controlPoint1: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.9 )),
    controlPoint2: CGPoint(x: horizStart - ( keyWidth * widthMultiplier ), y: vertStart - ( keyHeight * 1.05 ))
  )

  // Path up and curve right past the top left.
  path.addLine(to: CGPoint(x: horizStart - ( keyWidth * widthMultiplier ), y: heightBeforeTopCurves))
  path.addCurve(
    to: CGPoint(x: horizStart + ( keyWidth * 0.075 ), y: maxHeight),
    controlPoint1: CGPoint(x: horizStart - ( keyWidth * widthMultiplier ), y: maxHeightCurveControl),
    controlPoint2: CGPoint(x: horizStart - ( keyWidth * 0.25 ), y: maxHeight)
  )

  // Path right, curve down past the top right, and path down.
  path.addLine(to: CGPoint(x: horizStart + ( keyWidth * 0.925 ), y: maxHeight))
  path.addCurve(
    to: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier )), y: heightBeforeTopCurves),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * 1.25 ), y: maxHeight),
    controlPoint2: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier )), y: maxHeightCurveControl)
  )
  path.addLine(to: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier )), y: vertStart - ( keyHeight * 1.2 )))

  // Curve in to the left, go down, and curve down past bottom left.
  path.addCurve(
    to: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.85 )),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * ( 1 + widthMultiplier )), y: vertStart - ( keyHeight * 1.05 )),
    controlPoint2: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.9 ))
  )
  path.addLine(to: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.075 )))
  path.addCurve(
    to: CGPoint(x: horizStart + ( keyWidth * 0.925 ), y: vertStart),
    controlPoint1: CGPoint(x: horizStart + keyWidth, y: minHeightCurveControl),
    controlPoint2: CGPoint(x: horizStart + ( keyWidth * 0.925 ), y: minHeightCurveControl)
  )

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
func getKeyPopPath(key: UIButton, layer: CAShapeLayer, char: String, displayChar: String) {
  // Get the frame in respect to the superview.
  let frame: CGRect = (key.superview?.convert(key.frame, to: nil))!
  var labelVertPosition = frame.origin.y - key.frame.height / 1.75
  // non-capital characters should be higher for portrait phone views.
  if displayChar == char && DeviceType.isPhone && isLandscapeView == false
      && !["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].contains(char) {
    labelVertPosition = frame.origin.y - key.frame.height / 1.6
  } else if DeviceType.isPad
      && isLandscapeView == true {
    labelVertPosition = frame.origin.y - key.frame.height / 2
  }

  if centralKeyChars.contains(char) {
    layer.path = centerKeyPopPath(
      startX: frame.origin.x, startY: frame.origin.y,
      keyWidth: key.frame.width, keyHeight: key.frame.height, char: char).cgPath
    keyPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.5, y: labelVertPosition)
    keyHoldPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.5, y: labelVertPosition)
  } else if leftKeyChars.contains(char) {
    layer.path = leftKeyPopPath(
      startX: frame.origin.x, startY: frame.origin.y,
      keyWidth: key.frame.width, keyHeight: key.frame.height, char: char).cgPath
    keyPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.85, y: labelVertPosition)
    keyHoldPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.85, y: labelVertPosition)
    if DeviceType.isPad || ( DeviceType.isPhone && isLandscapeView == true ) {
      keyPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.65, y: labelVertPosition)
      keyHoldPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.65, y: labelVertPosition)
    }
  } else if rightKeyChars.contains(char) {
    layer.path = rightKeyPopPath(
      startX: frame.origin.x, startY: frame.origin.y,
      keyWidth: key.frame.width, keyHeight: key.frame.height, char: char).cgPath
    keyPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.15, y: labelVertPosition)
    keyHoldPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.15, y: labelVertPosition)
    if DeviceType.isPad || ( DeviceType.isPhone && isLandscapeView == true ) {
      keyPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.35, y: labelVertPosition)
      keyHoldPopChar.center = CGPoint(x: frame.origin.x + key.frame.width * 0.35, y: labelVertPosition)
    }
  }

  layer.strokeColor = keyShadowColor
  layer.fillColor = keyColor.cgColor
  layer.lineWidth = 1.0
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
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 1.15)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 1.15)
    }
  } else if shiftButtonState == .shift || shiftButtonState == .caps {
    if isLandscapeView == true {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.15)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.15)
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
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.75)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.75)
    } else {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.5)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.5)
    }
  } else if keyboardState == .letters && ( shiftButtonState == .shift || shiftButtonState == .caps ) {
    if isLandscapeView == true {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.5)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.5)
    } else {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2)
    }
  } else {
    if isLandscapeView == true {
      keyPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.25)
      keyHoldPopChar.font = .systemFont(ofSize: letterKeyWidth / 2.25)
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

  getKeyPopPath(key: key, layer: layer, char: char, displayChar: displayChar)
}
