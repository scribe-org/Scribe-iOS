//
//  ScribeKey.swift
//
//  Class defining the Scribe key that is used to access keyboard commands.
//

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
      return UINib(nibName: "Keyboard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
  }


  /// Converts the Scribe key to an escape key to return to the base keyboard view.
  func toEscape() {
    self.setTitle("", for: .normal)
    var selectKeyboardIconConfig = UIImage.SymbolConfiguration(
      pointSize: scribeKeyHeight * 0.515,
      weight: .light,
      scale: .medium
    )
    if DeviceType.isPad {
      selectKeyboardIconConfig = UIImage.SymbolConfiguration(
        pointSize: scribeKeyHeight * 0.6,
        weight: .light,
        scale: .medium
      )
    }
    self.setImage(UIImage(systemName: "xmark", withConfiguration: selectKeyboardIconConfig), for: .normal)
    self.tintColor = keyCharColor
    self.layer.cornerRadius = commandKeyCornerRadius
    self.layer.masksToBounds = true
  }


  /// Assigns the icon and sets up the Scribe key.
  func set() {
    self.setImage(scribeKeyIcon, for: .normal)
    setBtn(btn: self, color: commandKeyColor, name: "Scribe", canCap: false, isSpecial: false)
    self.layer.borderColor = commandBarBorderColor
    self.layer.borderWidth = 1.0
    self.contentMode = .center
    self.imageView?.contentMode = .scaleAspectFit
    self.shadow.isUserInteractionEnabled = false
  }


  /// Sets the corner radius for just the left side of the Scribe key.
  func setPartialCornerRadius() {
    self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
  }


  /// Sets the corner radius for all sides of the Scribe key.
  func setFullCornerRadius() {
    self.layer.borderColor = UIColor.clear.cgColor // border is set by the shadow
    self.layer.maskedCorners = [
      .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner
    ]
  }


  var shadow: UIButton!


  /// Sets the shadow of the Scribe key.
  func setPartialShadow() {
    self.shadow.backgroundColor = specialKeyColor
    self.shadow.layer.cornerRadius = commandKeyCornerRadius
    self.shadow.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    self.shadow.clipsToBounds = true
    self.shadow.layer.masksToBounds = false
    self.shadow.layer.shadowRadius = 0
    self.shadow.layer.shadowOpacity = 1.0
    self.shadow.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.shadow.layer.shadowColor = keyShadowColor
  }
  

  /// Sets the shadow of the Scribe key when it's an escape key.
  func setFullShadow() {
    self.shadow.backgroundColor = specialKeyColor
    self.shadow.layer.cornerRadius = commandKeyCornerRadius
    self.shadow.layer.maskedCorners = [
      .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner
    ]
    self.shadow.clipsToBounds = true
    self.shadow.layer.masksToBounds = false
    self.shadow.layer.shadowRadius = 0
    self.shadow.layer.shadowOpacity = 1.0
    self.shadow.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.shadow.layer.shadowColor = keyShadowColor
  }
}
