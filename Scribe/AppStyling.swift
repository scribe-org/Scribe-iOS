/**
 * Functions to style app elements
 *
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

/// Applies a shadow to a given UI element.
///
/// - Parameters
///  - elem: the element to have shadows added to.
func applyShadowEffects(elem: AnyObject) {
  elem.layer.shadowColor = UIColor(.keyShadow).light.cgColor
  elem.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
  elem.layer.shadowOpacity = 1.0
  elem.layer.shadowRadius = 3.0
}

/// Applies a corner radius to a given UI element.
///
/// - Parameters
///  - elem: the element to have shadows added to.
func applyCornerRadius(elem: AnyObject, radius: CGFloat) {
  elem.layer.masksToBounds = false
  elem.layer.cornerRadius = radius
}
