/**
 * Functions returning symbols for the app UI.
 *
 * Copyright (C) 2024 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import UIKit

/// Formats and returns the settings symbol for the app UI.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func getSettingsSymbol(fontSize: CGFloat) -> UIImage {
  var settingsSymbolConfig = UIImage.SymbolConfiguration(
    pointSize: fontSize * 0.2, weight: .medium, scale: .medium
  )
  if DeviceType.isPad {
    if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
      settingsSymbolConfig = UIImage.SymbolConfiguration(
        pointSize: fontSize * 0.05, weight: .medium, scale: .medium
      )
    } else {
      settingsSymbolConfig = UIImage.SymbolConfiguration(
        pointSize: fontSize * 0.15, weight: .medium, scale: .medium
      )
    }
  }
  guard let settingsSymbol = UIImage(systemName: "gearshape", withConfiguration: settingsSymbolConfig) else {
    fatalError("Failed to create settings symbol image.")
  }

  return settingsSymbol
}

/// Formats and returns the privacy symbol for the app UI.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func getPrivacySymbol(fontSize: CGFloat) -> UIImage {
  var privacySymbolConfig = UIImage.SymbolConfiguration(
    pointSize: fontSize * 0.25, weight: .medium, scale: .medium
  )
  if DeviceType.isPad {
    if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
      privacySymbolConfig = UIImage.SymbolConfiguration(
        pointSize: fontSize * 0.15, weight: .medium, scale: .medium
      )
    } else {
      privacySymbolConfig = UIImage.SymbolConfiguration(
        pointSize: fontSize * 0.2, weight: .medium, scale: .medium
      )
    }
  }
  guard let privacySymbol = UIImage(
    systemName: "lock.shield", withConfiguration: privacySymbolConfig
  ) else {
    fatalError("Failed to create privacy symbol image.")
  }

  return privacySymbol
}

func getRequiredIconForMenu(fontSize: CGFloat, imageName: String) -> UIImage {
  if let image = UIImage(named: imageName) {
    return image
  } else {
    var iconSymbolConfig = UIImage.SymbolConfiguration(
      pointSize: fontSize * 0.25, weight: .medium, scale: .medium
    )
    if DeviceType.isPad {
      if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
        iconSymbolConfig = UIImage.SymbolConfiguration(
          pointSize: fontSize * 0.15, weight: .medium, scale: .medium
        )
      } else {
        iconSymbolConfig = UIImage.SymbolConfiguration(
          pointSize: fontSize * 0.2, weight: .medium, scale: .medium
        )
      }
    }

    guard let image = UIImage(systemName: imageName, withConfiguration: iconSymbolConfig) else { return UIImage() }

    return image
  }
}
