/**
 * Adds Scribe colors to the UIColor pool.
 *
 * Copyright (C) 2023 Scribe
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

extension UIColor {
  // MARK: - Init from ScribeColor

  /// Creates `UIColor` from passed `ScribeColor`
  /// - Parameter color: The `UIColor`.
  ///
  /// Defaults to `UIColor.red` if passed color was not found in assets.
  convenience init(_ color: ScribeColor) {
    if UIColor(named: color.rawValue) != nil {
      self.init(named: color.rawValue)!
    } else {
      print("Unable to find color named: \(color.rawValue)")
      self.init(red: 1, green: 0, blue: 0, alpha: 1)
    }
  }

  /// Convenience computed property for light mode variant of the color.
  var light: UIColor {
    resolvedColor(with: .init(userInterfaceStyle: .light))
  }

  /// Convenience computed property for dark mode variant of the color.
  var dark: UIColor {
    resolvedColor(with: .init(userInterfaceStyle: .light))
  }
}
