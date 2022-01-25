//
//  ColorVariables.swift
//
//  Variables associated with coloration for Scribe.
//

import UIKit

var keyColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
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
    keyColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    specialKeyColor = UIColor(red: 63.0/255.0, green: 63.0/255.0, blue: 63.0/255.0, alpha: 1.0)
    keyPressedColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    commandKeyColor = UIColor.scribeBlueDark
    keyboardBackColor = UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0)

    previewRed = UIColor.previewRedDarkTheme
    previewBlue = UIColor.previewBlueDarkTheme
    previewPurple = UIColor.previewPurpleDarkTheme
    previewGreen = UIColor.previewGreenDarkTheme
    previewOrange = UIColor.previewOrangeDarkTheme
  } else if UITraitCollection.current.userInterfaceStyle == .light {
    keyColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    specialKeyColor = UIColor(red: 174.0/255.0, green: 179.0/255.0, blue: 190.0/255.0, alpha: 1.0)
    keyPressedColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
    commandKeyColor = UIColor.scribeBlueLight
    keyboardBackColor = UIColor(red: 206.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)

    previewRed = UIColor.previewRedLightTheme
    previewBlue = UIColor.previewBlueLightTheme
    previewPurple = UIColor.previewPurpleLightTheme
    previewGreen = UIColor.previewGreenLightTheme
    previewOrange = UIColor.previewOrangeLightTheme
  }
}

/// Extends UIColor with branding colors as well as those for annotating nouns.
extension UIColor {
  static let scribeGrey = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
  static let scribeBlueDark = UIColor(red: 102.0/255.0, green: 185.0/255.0, blue: 233.0/255.0, alpha: 1.0)
  static let scribeBlueLight = UIColor(red: 145.0/255.0, green: 214.0/255.0, blue: 251.0/255.0, alpha: 1.0)

  static let previewRedLightTheme = UIColor(red: 170.0/255.0, green: 40.0/255.0, blue: 45.0/255.0, alpha: 1.0)
  static let previewBlueLightTheme = UIColor(red: 30.0/255.0, green: 55.0/255.0, blue: 155.0/255.0, alpha: 1.0)
  static let previewPurpleLightTheme = UIColor(red: 170.0/255.0, green: 40.0/255.0, blue: 170.0/255.0, alpha: 1.0)
  static let previewGreenLightTheme = UIColor(red: 65.0/255.0, green: 125.0/255.0, blue: 60.0/255.0, alpha: 1.0)
  static let previewOrangeLightTheme = UIColor(red: 155.0/255.0, green: 85.0/255.0, blue: 30.0/255.0, alpha: 1.0)

  static let previewRedDarkTheme = UIColor(red: 230.0/255.0, green: 70.0/255.0, blue: 75.0/255.0, alpha: 1.0)
  static let previewBlueDarkTheme = UIColor(red: 50.0/255.0, green: 100.0/255.0, blue: 220.0/255.0, alpha: 1.0)
  static let previewPurpleDarkTheme = UIColor(red: 230.0/255.0, green: 70.0/255.0, blue: 230.0/255.0, alpha: 1.0)
  static let previewGreenDarkTheme = UIColor(red: 90.0/255.0, green: 195.0/255.0, blue: 85.0/255.0, alpha: 1.0)
  static let previewOrangeDarkTheme = UIColor(red: 205.0/255.0, green: 105.0/255.0, blue: 50.0/255.0, alpha: 1.0)
}
