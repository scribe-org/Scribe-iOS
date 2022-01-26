//
//  ColorVariables.swift
//
//  Variables associated with coloration for Scribe.
//

import UIKit

// Initialize all colors.
var keyColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var keyCharColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var specialKeyColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var keyPressedColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

var commandKeyColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var previewBarColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var previewBarBorderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor

var keyboardBackColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var keyShadowColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor

// Annotation colors.
var previewRed = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var previewBlue = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var previewPurple = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var previewGreen = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var previewOrange = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

/// Determines if the device is in dark mode and sets the color scheme.
func checkDarkModeSetColors() {
  if UITraitCollection.current.userInterfaceStyle == .light {
    keyColor = UIColor.keyColorLight
    keyCharColor = UIColor.keyCharColorLight
    specialKeyColor = UIColor.specialKeyColorLight
    keyPressedColor = UIColor.keyPressedColorLight

    commandKeyColor = UIColor.commandKeyColorLight
    previewBarColor = UIColor.previewBarColorLight
    previewBarBorderColor = UIColor.previewBarBorderColorLight

    keyboardBackColor = UIColor.keyboardBackColorLight
    keyShadowColor = UIColor.keyShadowColorLight

    previewRed = UIColor.previewRedLight
    previewBlue = UIColor.previewBlueLight
    previewPurple = UIColor.previewPurpleLight
    previewGreen = UIColor.previewGreenLight
    previewOrange = UIColor.previewOrangeLight
  } else if UITraitCollection.current.userInterfaceStyle == .dark {
    keyColor = UIColor.keyColorDark
    keyCharColor = UIColor.keyCharColorDark
    specialKeyColor = UIColor.specialKeyColorDark
    keyPressedColor = UIColor.keyPressedColorDark

    commandKeyColor = UIColor.commandKeyColorDark
    previewBarColor = UIColor.previewBarColorDark
    previewBarBorderColor = UIColor.previewBarBorderColorDark

    keyboardBackColor = UIColor.keyboardBackColorDark
    keyShadowColor = UIColor.keyShadowColorDark

    previewRed = UIColor.previewRedDark
    previewBlue = UIColor.previewBlueDark
    previewPurple = UIColor.previewPurpleDark
    previewGreen = UIColor.previewGreenDark
    previewOrange = UIColor.previewOrangeDark
  }
}

/// Extends UIColor with branding colors as well as those for annotating nouns.
extension UIColor {
  static let scribeGrey = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 0.9)

  // Light theme.
  static let scribeBlueLight = UIColor(red: 117.0/255.0, green: 206.0/255.0, blue: 250.0/255.0, alpha: 1.0)

  static let keyColorLight = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  static let keyCharColorLight = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.9)
  static let specialKeyColorLight = UIColor(red: 174.0/255.0, green: 179.0/255.0, blue: 190.0/255.0, alpha: 1.0)
  static let keyPressedColorLight = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)

  static let commandKeyColorLight = UIColor.scribeBlueLight
  static let previewBarColorLight = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  static let previewBarBorderColorLight = UIColor(red: 203.0/255.0, green: 203.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor

  static let keyboardBackColorLight = UIColor(red: 206.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)
  static let keyShadowColorLight = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.35).cgColor

  static let previewRedLight = UIColor(red: 177.0/255.0, green: 27.0/255.0, blue: 39.0/255.0, alpha: 0.9)
  static let previewBlueLight = UIColor(red: 56.0/255.0, green: 101.0/255.0, blue: 168.0/255.0, alpha: 0.9)
  static let previewPurpleLight = UIColor(red: 122.0/255.0, green: 5.0/255.0, blue: 147.0/255.0, alpha: 0.9)
  static let previewGreenLight = UIColor(red: 65.0/255.0, green: 128.0/255.0, blue: 74.0/255.0, alpha: 0.9)
  static let previewOrangeLight = UIColor(red: 249.0/255.0, green: 106.0/255.0, blue: 78.0/255.0, alpha: 0.9)

  // Dark theme.
  static let scribeBlueDark = UIColor(red: 76.0/255.0, green: 173.0/255.0, blue: 230.0/255.0, alpha: 1.0)

  static let keyColorDark = UIColor(red: 67.0/255.0, green: 67.0/255.0, blue: 67.0/255.0, alpha: 1.0)
  static let keyCharColorDark = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.9)
  static let specialKeyColorDark = UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0)
  static let keyPressedColorDark = UIColor(red: 54.0/255.0, green: 54.0/255.0, blue: 54.0/255.0, alpha: 1.0)

  static let commandKeyColorDark = UIColor.scribeBlueDark
  static let previewBarColorDark = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
  static let previewBarBorderColorDark = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 74.0/255.0, alpha: 1.0).cgColor

  static let keyboardBackColorDark = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
  static let keyShadowColorDark = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.9).cgColor

  static let previewRedDark = UIColor(red: 248.0/255.0, green: 89.0/255.0, blue: 94.0/255.0, alpha: 1.0)
  static let previewBlueDark = UIColor(red: 32.0/255.0, green: 149.0/255.0, blue: 233.0/255.0, alpha: 1.0)
  static let previewPurpleDark = UIColor(red: 164.0/255.0, green: 92.0/255.0, blue: 235.0/255.0, alpha: 1.0)
  static let previewGreenDark = UIColor(red: 120.0/255.0, green: 188.0/255.0, blue: 97.0/255.0, alpha: 1.0)
  static let previewOrangeDark = UIColor(red: 254.0/255.0, green: 148.0/255.0, blue: 72.0/255.0, alpha: 1.0)
}
