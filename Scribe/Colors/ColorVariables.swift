/**
 * Variables associated with coloration for Scribe keyboards.
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

// The Scribe key icon that changes based on light and dark mode as well as device.
var scribeKeyIcon = UIImage(named: "scribeKeyIcon")

// Initialize all colors.
var keyColor = UIColor(ScribeColor.key)
var keyCharColor = UIColor(ScribeColor.keyChar)
var specialKeyColor = UIColor(ScribeColor.keySpecial)
var keyPressedColor = UIColor(ScribeColor.keyPressed)

var commandKeyColor = UIColor(ScribeColor.commandKey)
var commandBarColor = UIColor(ScribeColor.commandBar)
var commandBarPlaceholderColor = UIColor(ScribeColor.commandBarPlaceholder)
var commandBarPlaceholderColorCG = UIColor(ScribeColor.commandBarPlaceholder).cgColor

var keyboardBgColor = UIColor(ScribeColor.keyboardBackground)
var keyShadowColor = UIColor(ScribeColor.keyShadow).cgColor

var appBtnColor = UIColor(ScribeColor.appBtn)
var menuOptionColor = UIColor(ScribeColor.menuOption)
var lightTextDarkCTA = UIColor(ScribeColor.lightTextDarkCTA)
var lightWhiteDarkBlackColor = UIColor(ScribeColor.lightWhiteDarkBlack)
var linkBlueColor = UIColor(ScribeColor.linkBlue)
var scribeCTAColor = UIColor(ScribeColor.scribeCTA)
var scribeAppBackgroundColor = UIColor(ScribeColor.scribeAppBackground)

// Annotation colors.
var annotateRed = UIColor(ScribeColor.annotateRed)
var annotateBlue = UIColor(ScribeColor.annotateBlue)
var annotatePurple = UIColor(ScribeColor.annotatePurple)
var annotateGreen = UIColor(ScribeColor.annotateGreen)
var annotateOrange = UIColor(ScribeColor.annotateOrange)
