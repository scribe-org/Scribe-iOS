//
//  ScribeColor.swift
//

import UIKit

/// All the colors defined in `Assets.xcassets/Colors`
enum ScribeColor: String {
  case annotateRed
  case annotateBlue
  case annotatePurple
  case annotateGreen
  case annotateOrange
  case annotateTitle
  case commandBar
  case commandBarBorder
  case commandBarInfoButton
  case commandKey
  case key
  case keyChar
  case keyPressed
  case keyShadow
  case keySpecial
  case keyboardBackground
  case linkBlue
  case scribeBlue
  case scribeCTA
  case scribeGray

  /// `UIColor` object for the given
  var color: UIColor {
    .init(self)
  }
}
