// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Converts strings for colors into the corresponding color.
 */

import UIKit

/// All the colors defined in `Assets.xcassets/Colors`.
enum ScribeColor: String {
  case annotateRed
  case annotateBlue
  case annotatePurple
  case annotateGreen
  case annotateOrange
  case annotateTitle
  case appBtn
  case commandBar
  case commandBarPlaceholder
  case commandKey
  case key
  case keyboardBackground
  case keyChar
  case keyPressed
  case keyShadow
  case keySpecial
  case lightTextDarkCTA
  case lightWhiteDarkBlack
  case linkBlue
  case menuOption
  case scribeAppBackground
  case scribeBlue
  case scribeCTA

  /// `UIColor` object for the given
  var color: UIColor {
    .init(self)
  }
}
