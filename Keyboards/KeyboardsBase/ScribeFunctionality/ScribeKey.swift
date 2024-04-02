/**
 * Class defining the Scribe key that is used to access keyboard commands.
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

/// The main UI element that allows for accessing other commands and triggering annotation.
class ScribeKey: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  /// Allows the class to be accessed from Keyboard.xib.
  class func instanceFromNib() -> UIView {
    guard let nibContents = UINib(nibName: "Keyboard", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView else {
      fatalError("Failed to instantiate view from nib.")
    }
    return nibContents
  }

  /// Converts the Scribe key to an escape key to return to the base keyboard view.
  func toEscape() {
    setTitle("", for: .normal)
    var selectKeyboardIconConfig = UIImage.SymbolConfiguration(
      pointSize: frame.height * 0.515,
      weight: .light,
      scale: .medium
    )
    if DeviceType.isPad {
      selectKeyboardIconConfig = UIImage.SymbolConfiguration(
        pointSize: frame.height * 0.6,
        weight: .light,
        scale: .medium
      )
    }
    setImage(UIImage(systemName: "xmark", withConfiguration: selectKeyboardIconConfig), for: .normal)
    tintColor = keyCharColor
    layer.cornerRadius = commandKeyCornerRadius
    layer.masksToBounds = true
  }

  /// Assigns the icon and sets up the Scribe key.
  func set() {
    setImage(scribeKeyIcon, for: .normal)
    setBtn(btn: self, color: commandKeyColor, name: "Scribe", canBeCapitalized: false, isSpecial: false)
    layer.borderColor = commandBarBorderColor
    layer.borderWidth = 1.0
    contentMode = .center
    imageView?.contentMode = .scaleAspectFit
    shadow.isUserInteractionEnabled = false
  }

  /// Sets the corner radius for just the left side of the Scribe key.
  func setPartialCornerRadius() {
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
  }

  /// Sets the corner radius for all sides of the Scribe key.
  func setFullCornerRadius() {
    layer.borderColor = UIColor.clear.cgColor // border is set by the shadow
    layer.maskedCorners = [
      .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner,
    ]
  }

  var shadow: UIButton!

  /// Sets the shadow of the Scribe key.
  func setPartialShadow() {
    shadow.backgroundColor = specialKeyColor
    shadow.layer.cornerRadius = commandKeyCornerRadius
    shadow.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    shadow.clipsToBounds = true
    shadow.layer.masksToBounds = false
    shadow.layer.shadowRadius = 0
    shadow.layer.shadowOpacity = 1.0
    shadow.layer.shadowOffset = CGSize(width: 0, height: 1)
    shadow.layer.shadowColor = keyShadowColor
  }

  /// Sets the shadow of the Scribe key when it's an escape key.
  func setFullShadow() {
    shadow.backgroundColor = specialKeyColor
    shadow.layer.cornerRadius = commandKeyCornerRadius
    shadow.layer.maskedCorners = [
      .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner,
    ]
    shadow.clipsToBounds = true
    shadow.layer.masksToBounds = false
    shadow.layer.shadowRadius = 0
    shadow.layer.shadowOpacity = 1.0
    shadow.layer.shadowOffset = CGSize(width: 0, height: 1)
    shadow.layer.shadowColor = keyShadowColor
  }
}
