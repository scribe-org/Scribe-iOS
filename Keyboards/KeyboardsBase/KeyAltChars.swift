//
//  KeyAltChars.swift
//
//  Functions and variables to create alternate key views.
//

import UIKit

/// Sets the alternates for certain keys given the chosen keyboard.
func setKeyboardAlternateKeys() {
  if DeviceType.isPhone {
    keysWithAlternates += symbolKeysWithAlternatesLeft
    keysWithAlternates += symbolKeysWithAlternatesRight
    keysWithAlternates.append(currencySymbol)
    keysWithAlternatesLeft += symbolKeysWithAlternatesLeft
    keysWithAlternatesRight += symbolKeysWithAlternatesRight
    keysWithAlternatesRight.append(currencySymbol)
  }

  keyAlternatesDict = [
    "a": aAlternateKeys,
    "e": eAlternateKeys,
    "е": еAlternateKeys, // Russian е
    "i": iAlternateKeys,
    "o": oAlternateKeys,
    "u": uAlternateKeys,
    "ä": äAlternateKeys,
    "ö": öAlternateKeys,
    "y": yAlternateKeys,
    "s": sAlternateKeys,
    "l": lAlternateKeys,
    "z": zAlternateKeys,
    "d": dAlternateKeys,
    "c": cAlternateKeys,
    "n": nAlternateKeys,
    "ь": ьAlternateKeys,
    "/": backslashAlternateKeys,
    "?": questionMarkAlternateKeys,
    "!": exclamationAlternateKeys,
    "%": percentAlternateKeys,
    "&": ampersandAlternateKeys,
    "'": apostropheAlternateKeys,
    "\"": quotationAlternateKeys,
    "=": equalSignAlternateKeys,
    currencySymbol: currencySymbolAlternates
  ]
}

var alternatesKeyView: UIView!
var alternatesShapeLayer = CAShapeLayer()
var keysWithAlternates = [String]()
var alternateKeys = [String]()

// Variables for alternate key view appearance.
var alternateBtnStartX = CGFloat(0)
var alternatesViewWidth = CGFloat(0)
var alternatesLongWidth = CGFloat(0)
var alternatesViewX = CGFloat(0)
var alternatesViewY = CGFloat(0)
var alternatesBtnHeight = CGFloat(0)
var alternatesCharHeight = CGFloat(0)

// The main currency symbol that will receive the alternates view for iPhones.
var currencySymbol: String = ""
var currencySymbolAlternates = [String]()
let dollarAlternateKeys = ["¢", "₽", "₩", "¥", "£", "€"]
let euroAlternateKeys = ["¢", "₽", "₩", "¥", "£", "$"]
let roubleAlternateKeys = ["¢", "₩", "¥", "£", "$", "€"]
let kronaAlternateKeys = ["¢", "₽", "¥", "£", "$", "€"]

// Symbol keys that have consistent alternates for iPhones.
var symbolKeysWithAlternatesLeft = ["/", "?", "!", "%", "&"]
let backslashAlternateKeys = ["\\"]
let questionMarkAlternateKeys = ["¿"]
let exclamationAlternateKeys = ["¡"]
let percentAlternateKeys = ["‰"]
let ampersandAlternateKeys = ["§"]
var symbolKeysWithAlternatesRight = ["'", "\"", "="]
let apostropheAlternateKeys = ["`", "‘", "’"]
let quotationAlternateKeys = ["«", "»", "„", "“", "”"]
let equalSignAlternateKeys = ["≈", "±", "≠"]
var keysWithAlternatesLeft = [String]()
var keysWithAlternatesRight = [String]()
var keyAlternatesDict = [String: [String]]()
var aAlternateKeys = [String]()
var eAlternateKeys = [String]()
var еAlternateKeys = [String]() // Russian е
var iAlternateKeys = [String]()
var oAlternateKeys = [String]()
var uAlternateKeys = [String]()
var yAlternateKeys = [String]()
var äAlternateKeys = [String]()
var öAlternateKeys = [String]()
var sAlternateKeys = [String]()
var lAlternateKeys = [String]()
var zAlternateKeys = [String]()
var dAlternateKeys = [String]()
var cAlternateKeys = [String]()
var nAlternateKeys = [String]()
var ьAlternateKeys = [String]()

/// Creates the shape that allows left most buttons to pop up after being pressed.
///
/// - Parameters
///   - startX: the x-axis starting point.
///   - startY: the y-axis starting point.
///   - keyHeight: the height of the key.
///   - numAlternates: the number of alternate characters to display.
///   - side: the side of the keyboard that the key is found.
func setAlternatesPathState(
  startY: CGFloat,
  keyWidth: CGFloat,
  keyHeight: CGFloat,
  numAlternates: CGFloat,
  side: String
) {
  if DeviceType.isPad {
    widthMultiplier = 0.2
    maxHeightMultiplier = 2.05
    if isLandscapeView == true {
      maxHeightMultiplier = 1.95
    }
  } else if DeviceType.isPhone {
    widthMultiplier = 0.4
    maxHeightMultiplier = 2.125
    if isLandscapeView == true {
      widthMultiplier = 0.2
    }
  }

  maxHeight = vertStart - ( keyHeight * maxHeightMultiplier )
  maxHeightCurveControl = vertStart - ( keyHeight * ( maxHeightMultiplier - 0.125 ))
  minHeightCurveControl = vertStart - ( keyHeight * 0.005 )

  if DeviceType.isPhone {
    heightBeforeTopCurves = vertStart - ( keyHeight * 1.8 )
    maxWidthCurveControl =  keyWidth * 0.5
  } else if DeviceType.isPad || ( DeviceType.isPhone && isLandscapeView == true ) {
    heightBeforeTopCurves = vertStart - ( keyHeight * 1.6 )
    maxWidthCurveControl =  keyWidth * 0.25
  }
  if side == "left" {
    alternatesLongWidth =  horizStart + ( keyWidth * numAlternates + ( 3.0 * numAlternates ) + 8.0 )
  } else if side == "right" {
    alternatesLongWidth = horizStart + keyWidth - CGFloat(keyWidth * numAlternates + ( 3.0 * numAlternates ) + 8.0)
  }

  alternatesShapeLayer.strokeColor = keyShadowColor
  alternatesShapeLayer.fillColor = keyColor.cgColor
  alternatesShapeLayer.lineWidth = 1.0
}

/// Creates the shape that allows alternate keys to be displayed to the user for keys on the left side of the keyboard.
///
/// - Parameters
///   - startX: the x-axis starting point.
///   - startY: the y-axis starting point.
///   - keyWidth: the width of the key.
///   - keyHeight: the height of the key.
///   - numAlternates: the number of alternate characters to display.
func alternateKeysPathLeft(
  startX: CGFloat,
  startY: CGFloat,
  keyWidth: CGFloat,
  keyHeight: CGFloat,
  numAlternates: CGFloat
) -> UIBezierPath {
  // Starting positions need to be updated.
  horizStart = startX; vertStart = startY + keyHeight

  setAlternatesPathState(
    startY: startY, keyWidth: keyWidth, keyHeight: keyHeight, numAlternates: numAlternates, side: "left"
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
  path.addLine(to: CGPoint(x: alternatesLongWidth - maxWidthCurveControl, y: maxHeight))
  path.addCurve(
    to: CGPoint(x: alternatesLongWidth, y: heightBeforeTopCurves),
    controlPoint1: CGPoint(x: alternatesLongWidth - ( keyWidth * 0.2 ), y: maxHeight),
    controlPoint2: CGPoint(x: alternatesLongWidth, y: maxHeightCurveControl)
  )
  path.addLine(to: CGPoint(x: alternatesLongWidth, y: vertStart - ( keyHeight * 1.15 )))

  // Curve down past the left and path left.
  path.addCurve(
    to: CGPoint(x: alternatesLongWidth - maxWidthCurveControl, y: vertStart - ( keyHeight * 0.95 )),
    controlPoint1: CGPoint(x: alternatesLongWidth, y: vertStart - ( keyHeight * 1.05 )),
    controlPoint2: CGPoint(x: alternatesLongWidth - ( keyWidth * 0.2 ), y: vertStart - ( keyHeight * 0.95 ))
  )
  path.addLine(to: CGPoint(x: horizStart + ( keyWidth * 1.15 ), y: vertStart - ( keyHeight * 0.95 )))

  // Curve in to the left, go down, and curve down past bottom left.
  path.addCurve(
    to: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.85 )),
    controlPoint1: CGPoint(x: horizStart + ( keyWidth * 1.05 ), y: vertStart - ( keyHeight * 0.95 )),
    controlPoint2: CGPoint(x: horizStart + keyWidth, y: vertStart - ( keyHeight * 0.875 ))
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

/// Creates the shape that allows alternate keys to be displayed to the user for keys on the right side of the keyboard.
///
/// - Parameters
///   - startX: the x-axis starting point.
///   - startY: the y-axis starting point.
///   - keyWidth: the width of the key.
///   - keyHeight: the height of the key.
///   - numAlternates: the number of alternate characters to display.
func alternateKeysPathRight(
  startX: CGFloat,
  startY: CGFloat,
  keyWidth: CGFloat,
  keyHeight: CGFloat,
  numAlternates: CGFloat
) -> UIBezierPath {
  // Starting positions need to be updated.
  horizStart = startX; vertStart = startY + keyHeight

  setAlternatesPathState(
    startY: startY, keyWidth: keyWidth, keyHeight: keyHeight, numAlternates: numAlternates, side: "right"
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
    to: CGPoint(x: horizStart - ( keyWidth * 0.15 ), y: vertStart - ( keyHeight * 0.95 )),
    controlPoint1: CGPoint(x: horizStart, y: vertStart - ( keyHeight * 0.875 )),
    controlPoint2: CGPoint(x: horizStart - ( keyWidth * 0.05 ), y: vertStart - ( keyHeight * 0.95 ))
  )

  // Path left and path up past the left.
  path.addLine(to: CGPoint(x: alternatesLongWidth + maxWidthCurveControl, y: vertStart - ( keyHeight * 0.95 )))
  path.addCurve(
    to: CGPoint(x: alternatesLongWidth, y: vertStart - ( keyHeight * 1.15 )),
    controlPoint1: CGPoint(x: alternatesLongWidth + ( keyWidth * 0.2 ), y: vertStart - ( keyHeight * 0.95 )),
    controlPoint2: CGPoint(x: alternatesLongWidth, y: vertStart - ( keyHeight * 1.05 ))
  )

  // Path up and curve up past the top left.
  path.addLine(to: CGPoint(x: alternatesLongWidth, y: heightBeforeTopCurves))
  path.addCurve(
    to: CGPoint(x: alternatesLongWidth + maxWidthCurveControl, y: maxHeight),
    controlPoint1: CGPoint(x: alternatesLongWidth, y: maxHeightCurveControl),
    controlPoint2: CGPoint(x: alternatesLongWidth + ( keyWidth * 0.2 ), y: maxHeight)
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

/// Generates an alternates view to select other characters related to a long held key.
///
/// - Parameters
///   - sender: the long press of the given key.
func genAlternatesView(key: UIButton) {
  // Get the frame in respect to the superview.
  let frame: CGRect = (key.superview?.convert(key.frame, to: nil))!
  let width = key.frame.width

  // Derive which button was pressed and get its alternates.
  let char: String = key.layer.value(forKey: "original") as? String ?? ""
  alternateKeys = keyAlternatesDict[char ] ?? [""]

  // Add the original key given its location on the keyboard.
  if keysWithAlternatesLeft.contains(char) {
    alternateKeys.insert(char, at: 0)
  } else if keysWithAlternatesRight.contains(char) {
    alternateKeys.append(char)
  }
  let numAlternates: CGFloat = CGFloat(alternateKeys.count)

  if keysWithAlternatesLeft.contains(char ) {
    alternatesViewX = frame.origin.x - 4.0
    alternatesShapeLayer.path = alternateKeysPathLeft(
      startX: frame.origin.x, startY: frame.origin.y,
      keyWidth: width, keyHeight: key.frame.height, numAlternates: numAlternates
    ).cgPath
  } else if keysWithAlternatesRight.contains(char ) {
    alternatesViewX = frame.origin.x + width - CGFloat(width * numAlternates + ( 3.0 * numAlternates ) + 2.0)
    alternatesShapeLayer.path = alternateKeysPathRight(
      startX: frame.origin.x, startY: frame.origin.y,
      keyWidth: width, keyHeight: key.frame.height, numAlternates: numAlternates
    ).cgPath
  }

  if numAlternates > 0 {
    alternatesViewWidth = CGFloat(width * numAlternates + ( 3.0 * numAlternates ) + 8.0)
  }

  alternatesViewY = frame.origin.y - key.frame.height * 1.135
  alternatesBtnHeight = key.frame.height * 0.9
  alternatesKeyView = UIView(
    frame: CGRect(
      x: alternatesViewX,
      y: alternatesViewY,
      width: alternatesViewWidth,
      height: key.frame.height * 1.2
    )
  )

  alternatesKeyView.tag = 1001
  key.backgroundColor = keyColor
}
