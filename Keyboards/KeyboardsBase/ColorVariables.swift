//
//  ColorVariables.swift
//
//  Variables assosciated with coloration for Scribe.
//

import UIKit

var keyColor = UIColor.white
var specialKeyColor = UIColor.systemGray2
var keyPressedColor = UIColor.systemGray5

/// Extends UIColor with branding colors as well as those for annotating nouns.
extension UIColor {
  static let scribeBlue = UIColor(red: 97.0/255.0, green: 200.0/255.0, blue: 245.0/255.0, alpha: 1.0)

  static let previewRedLightTheme = UIColor(red: 170.0/255.0, green: 40.0/255.0, blue: 45.0/255.0, alpha: 1.0)
  static let previewBlueLightTheme = UIColor(red: 30.0/255.0, green: 55.0/255.0, blue: 155.0/255.0, alpha: 1.0)
  static let previewGreenLightTheme = UIColor(red: 65.0/255.0, green: 125.0/255.0, blue: 60.0/255.0, alpha: 1.0)
  static let previewOrangeLightTheme = UIColor(red: 155.0/255.0, green: 85.0/255.0, blue: 30.0/255.0, alpha: 1.0)

  static let previewRedDarkTheme = UIColor(red: 230.0/255.0, green: 70.0/255.0, blue: 75.0/255.0, alpha: 1.0)
  static let previewBlueDarkTheme = UIColor(red: 50.0/255.0, green: 100.0/255.0, blue: 220.0/255.0, alpha: 1.0)
  static let previewGreenDarkTheme = UIColor(red: 90.0/255.0, green: 195.0/255.0, blue: 85.0/255.0, alpha: 1.0)
  static let previewOrangeDarkTheme = UIColor(red: 205.0/255.0, green: 105.0/255.0, blue: 50.0/255.0, alpha: 1.0)
}
