/**
 * Variables associated with coloration for scribe.
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

// The Scribe key icon that changes based on light and dark mode as well as device.
var scribeKeyIcon = UIImage(named: "scribeKeyIcon")

// Initialize all colors.
var keyColor = UIColor(.key)
var keyCharColor = UIColor(.keyChar)
var specialKeyColor = UIColor(.keySpecial)
var keyPressedColor = UIColor(.keyPressed)

var commandKeyColor = UIColor(.commandKey)
var commandBarColor = UIColor(.commandBar)
var commandBarBorderColor = UIColor(.commandBarBorder).cgColor

var keyboardBgColor = UIColor(.keyboardBackground)
var keyShadowColor = UIColor(.keyShadow).cgColor

// annotate colors.
var annotateRed = UIColor(.annotateRed)
var annotateBlue = UIColor(.annotateBlue)
var annotatePurple = UIColor(.annotatePurple)
var annotateGreen = UIColor(.annotateGreen)
var annotateOrange = UIColor(.annotateOrange)
