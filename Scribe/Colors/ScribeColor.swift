/**
 * Converts strings for colors into the corresponding color.
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
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
