//
//  ColorVariables.swift
//
//  Variables associated with coloration for Scribe.
//

import UIKit

var keyColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var keyCharColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.8)

var specialKeyColor = UIColor(red: 174.0/255.0, green: 179.0/255.0, blue: 190.0/255.0, alpha: 1.0)
var keyPressedColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
var commandKeyColor = UIColor.scribeBlueLight
var keyboardBackColor = UIColor(red: 206.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)

var keyShadowColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.35).cgColor

// Annotation colors.
var previewRed = UIColor(red: 170.0/255.0, green: 40.0/255.0, blue: 45.0/255.0, alpha: 1.0)
var previewBlue = UIColor(red: 30.0/255.0, green: 55.0/255.0, blue: 155.0/255.0, alpha: 1.0)
var previewPurple = UIColor(red: 170.0/255.0, green: 40.0/255.0, blue: 170.0/255.0, alpha: 1.0)
var previewGreen = UIColor(red: 65.0/255.0, green: 125.0/255.0, blue: 60.0/255.0, alpha: 1.0)
var previewOrange = UIColor(red: 155.0/255.0, green: 85.0/255.0, blue: 30.0/255.0, alpha: 1.0)

/// Determines if the device is in dark mode and sets the color scheme.
func checkDarkModeSetColors() {
  if UITraitCollection.current.userInterfaceStyle == .dark {
    keyColor = UIColor.keyColorDark
    keyCharColor = UIColor.keyCharColorDark

    specialKeyColor = UIColor.specialKeyColorDark
    keyPressedColor = UIColor.keyPressedColorDark
    commandKeyColor = UIColor.commandKeyColorDark
    keyboardBackColor = UIColor.keyboardBackColorDark
    keyShadowColor = UIColor.keyShadowColorDark

    previewRed = UIColor.previewRedDark
    previewBlue = UIColor.previewBlueDark
    previewPurple = UIColor.previewPurpleDark
    previewGreen = UIColor.previewGreenDark
    previewOrange = UIColor.previewOrangeDark
  } else if UITraitCollection.current.userInterfaceStyle == .light {
    keyColor = UIColor.keyColorLight
    keyCharColor = UIColor.keyCharColorLight

    specialKeyColor = UIColor.specialKeyColorLight
    keyPressedColor = UIColor.keyPressedColorLight
    commandKeyColor = UIColor.commandKeyColorLight
    keyboardBackColor = UIColor.keyboardBackColorLight
    keyShadowColor = UIColor.keyShadowColorLight

    previewRed = UIColor.previewRedLight
    previewBlue = UIColor.previewBlueLight
    previewPurple = UIColor.previewPurpleLight
    previewGreen = UIColor.previewGreenLight
    previewOrange = UIColor.previewOrangeLight
  }
}

/// Extends UIColor with branding colors as well as those for annotating nouns.
extension UIColor {
  static let scribeGrey = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 0.9)

  static let scribeBlueLight = UIColor(red: 134.0/255.0, green: 195.0/255.0, blue: 234.0/255.0, alpha: 1.0)

  static let previewRedLight = UIColor(red: 177.0/255.0, green: 27.0/255.0, blue: 39.0/255.0, alpha: 0.9)
  static let previewBlueLight = UIColor(red: 56.0/255.0, green: 101.0/255.0, blue: 168.0/255.0, alpha: 0.9)
  static let previewPurpleLight = UIColor(red: 114.0/255.0, green: 5.0/255.0, blue: 118.0/255.0, alpha: 0.9)
  static let previewGreenLight = UIColor(red: 72.0/255.0, green: 132.0/255.0, blue: 82.0/255.0, alpha: 0.9)
  static let previewOrangeLight = UIColor(red: 249.0/255.0, green: 106.0/255.0, blue: 78.0/255.0, alpha: 0.9)

  static let keyColorLight = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  static let keyCharColorLight = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.9)

  static let specialKeyColorLight = UIColor(red: 174.0/255.0, green: 179.0/255.0, blue: 190.0/255.0, alpha: 1.0)
  static let keyPressedColorLight = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
  static let commandKeyColorLight = UIColor.scribeBlueLight
  static let keyboardBackColorLight = UIColor(red: 206.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)
  static let keyShadowColorLight = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.35).cgColor

  static let scribeBlueDark = UIColor(red: 100.0/255.0, green: 156.0/255.0, blue: 196.0/255.0, alpha: 1.0)

  static let previewRedDark = UIColor(red: 248.0/255.0, green: 89.0/255.0, blue: 94.0/255.0, alpha: 1.0)
  static let previewBlueDark = UIColor(red: 71.0/255.0, green: 169.0/255.0, blue: 194.0/255.0, alpha: 1.0)
  static let previewPurpleDark = UIColor(red: 164.0/255.0, green: 92.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  static let previewGreenDark = UIColor(red: 120.0/255.0, green: 188.0/255.0, blue: 97.0/255.0, alpha: 1.0)
  static let previewOrangeDark = UIColor(red: 254.0/255.0, green: 148.0/255.0, blue: 72.0/255.0, alpha: 1.0)

  static let keyColorDark = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
  static let keyCharColorDark = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.9)

  static let specialKeyColorDark = UIColor(red: 63.0/255.0, green: 63.0/255.0, blue: 63.0/255.0, alpha: 1.0)
  static let keyPressedColorDark = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)
  static let commandKeyColorDark = UIColor.scribeBlueDark
  static let keyboardBackColorDark = UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0)
  static let keyShadowColorDark = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.9).cgColor
}
