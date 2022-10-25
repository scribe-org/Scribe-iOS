//
//  UIColor+ScribeColors.swift
//

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
      print("unable to find color named: \(color.rawValue)")
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
