//
//  ColorVariables.swift
//
//  Variables associated with coloration for Scribe.
//

import UIKit

// The Scribe key icon that changes based on light and dark mode as well as device.
var scribeKeyIcon = UIImage(named: "ScribeKeyPhoneBlack.png")

// Initialize all colors.
var keyColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var keyCharColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var specialKeyColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var keyPressedColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

var commandKeyColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var commandBarColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var commandBarBorderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor

var keyboardBackColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var keyShadowColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor

// annotate colors.
var annotateRed = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var annotateBlue = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var annotatePurple = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var annotateGreen = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
var annotateOrange = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

/// Determines if the device is in dark mode and sets the color scheme.
func checkDarkModeSetColors() {
  if UITraitCollection.current.userInterfaceStyle == .light {
    if DeviceType.isPhone {
      scribeKeyIcon = UIImage(named: "ScribeKeyPhoneBlack.png")
    } else if DeviceType.isPad {
      scribeKeyIcon = UIImage(named: "ScribeKeyPadBlack.png")
    }

    keyColor = UIColor.keyColorLight
    keyCharColor = UIColor.keyCharColorLight
    specialKeyColor = UIColor.specialKeyColorLight
    keyPressedColor = UIColor.keyPressedColorLight

    commandKeyColor = UIColor.commandKeyColorLight
    commandBarColor = UIColor.commandBarColorLight
    commandBarBorderColor = UIColor.commandBarBorderColorLight

    keyboardBackColor = UIColor.keyboardBackColorLight
    keyShadowColor = UIColor.keyShadowColorLight

    annotateRed = UIColor.annotateRedLight
    annotateBlue = UIColor.annotateBlueLight
    annotatePurple = UIColor.annotatePurpleLight
    annotateGreen = UIColor.annotateGreenLight
    annotateOrange = UIColor.annotateOrangeLight
  } else if UITraitCollection.current.userInterfaceStyle == .dark {
    if DeviceType.isPhone {
      scribeKeyIcon = UIImage(named: "ScribeKeyPhoneWhite.png")
    } else if DeviceType.isPad {
      scribeKeyIcon = UIImage(named: "ScribeKeyPadWhite.png")
    }

    keyColor = UIColor.keyColorDark
    keyCharColor = UIColor.keyCharColorDark
    specialKeyColor = UIColor.specialKeyColorDark
    keyPressedColor = UIColor.keyPressedColorDark

    commandKeyColor = UIColor.commandKeyColorDark
    commandBarColor = UIColor.commandBarColorDark
    commandBarBorderColor = UIColor.commandBarBorderColorDark

    keyboardBackColor = UIColor.keyboardBackColorDark
    keyShadowColor = UIColor.keyShadowColorDark

    annotateRed = UIColor.annotateRedDark
    annotateBlue = UIColor.annotateBlueDark
    annotatePurple = UIColor.annotatePurpleDark
    annotateGreen = UIColor.annotateGreenDark
    annotateOrange = UIColor.annotateOrangeDark
  }
}

/// Extends UIColor with branding colors as well as those for annotating nouns.
extension UIColor {
  static let scribeGrey = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 0.9)

  // Light theme.
  static let scribeBlueLight = UIColor(red: 117.0/255.0, green: 206.0/255.0, blue: 250.0/255.0, alpha: 0.95)

  static let keyColorLight = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  static let keyCharColorLight = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.9)
  static let specialKeyColorLight = UIColor(red: 174.0/255.0, green: 179.0/255.0, blue: 190.0/255.0, alpha: 1.0)
  static let keyPressedColorLight = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)

  static let commandKeyColorLight = UIColor.scribeBlueLight
  static let commandBarColorLight = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  static let commandBarBorderColorLight = UIColor(
    red: 203.0/255.0, green: 203.0/255.0, blue: 206.0/255.0, alpha: 1.0
  ).cgColor

  static let keyboardBackColorLight = UIColor(red: 206.0/255.0, green: 210.0/255.0, blue: 217.0/255.0, alpha: 1.0)
  static let keyShadowColorLight = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.35).cgColor

  static let annotateRedLight = UIColor(red: 177.0/255.0, green: 27.0/255.0, blue: 39.0/255.0, alpha: 0.9)
  static let annotateBlueLight = UIColor(red: 56.0/255.0, green: 101.0/255.0, blue: 168.0/255.0, alpha: 0.9)
  static let annotatePurpleLight = UIColor(red: 122.0/255.0, green: 5.0/255.0, blue: 147.0/255.0, alpha: 0.9)
  static let annotateGreenLight = UIColor(red: 65.0/255.0, green: 128.0/255.0, blue: 74.0/255.0, alpha: 0.9)
  static let annotateOrangeLight = UIColor(red: 249.0/255.0, green: 106.0/255.0, blue: 78.0/255.0, alpha: 0.9)

  // Dark theme.
  static let scribeBlueDark = UIColor(red: 76.0/255.0, green: 173.0/255.0, blue: 230.0/255.0, alpha: 0.9)

  static let keyColorDark = UIColor(red: 67.0/255.0, green: 67.0/255.0, blue: 67.0/255.0, alpha: 1.0)
  static let keyCharColorDark = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.9)
  static let specialKeyColorDark = UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0)
  static let keyPressedColorDark = UIColor(red: 54.0/255.0, green: 54.0/255.0, blue: 54.0/255.0, alpha: 1.0)

  static let commandKeyColorDark = UIColor.scribeBlueDark
  static let commandBarColorDark = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
  static let commandBarBorderColorDark = UIColor(
    red: 75.0/255.0, green: 75.0/255.0, blue: 75.0/255.0, alpha: 1.0
  ).cgColor

  static let keyboardBackColorDark = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
  static let keyShadowColorDark = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.95).cgColor

  static let annotateRedDark = UIColor(red: 248.0/255.0, green: 89.0/255.0, blue: 94.0/255.0, alpha: 0.9)
  static let annotateBlueDark = UIColor(red: 32.0/255.0, green: 149.0/255.0, blue: 233.0/255.0, alpha: 0.9)
  static let annotatePurpleDark = UIColor(red: 164.0/255.0, green: 92.0/255.0, blue: 235.0/255.0, alpha: 0.9)
  static let annotateGreenDark = UIColor(red: 120.0/255.0, green: 188.0/255.0, blue: 97.0/255.0, alpha: 0.9)
  static let annotateOrangeDark = UIColor(red: 254.0/255.0, green: 148.0/255.0, blue: 72.0/255.0, alpha: 0.9)
}
