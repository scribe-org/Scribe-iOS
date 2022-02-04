//
//  AppUISymbols.swift
//
//  Functions returning symbols for the app UI.
//

import UIKit

/// Formats and returns the settings symbol for the app UI.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func getSettingsSymbol(fontSize: CGFloat) -> UIImage {
  var settingsSymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.2, weight: .medium, scale: .medium)
  if DeviceType.isPad {
    if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
      settingsSymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.05, weight: .medium, scale: .medium)
    } else {
      settingsSymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.15, weight: .medium, scale: .medium)
    }
  }
  let settingsSymbol: UIImage = UIImage(systemName: "gear", withConfiguration: settingsSymbolConfig)!

  return settingsSymbol
}

/// Formats and returns the privacy symbol for the app UI.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func getPrivacySymbol(fontSize: CGFloat) -> UIImage {
  var privacySymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.25, weight: .medium, scale: .medium)
  if DeviceType.isPad {
    if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
      privacySymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.15, weight: .medium, scale: .medium)
    } else {
      privacySymbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize * 0.2, weight: .medium, scale: .medium)
    }
  }
  let privacySymbol: UIImage = UIImage(systemName: "lock.shield", withConfiguration: privacySymbolConfig)!

  return privacySymbol
}
