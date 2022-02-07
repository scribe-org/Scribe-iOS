//
//  CommandBar.swift
//  Scribe
//
//  Class defining the bar into which commands are typed.
//

import UIKit

/// A custom UILabel used to house all the functionality of the command bar.
class CommandBar: UILabel {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  class func instanceFromNib() -> UIView {
      return UINib(nibName: "Keyboard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
  }

  var shadow: UIButton!

  var blend: UILabel!

  func setCornerRadiusAndShadow() {
    self.clipsToBounds = true
    self.layer.cornerRadius = commandKeyCornerRadius
    self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    self.textColor = keyCharColor
    self.lineBreakMode = NSLineBreakMode.byWordWrapping

    self.shadow.backgroundColor = specialKeyColor
    self.shadow.layer.cornerRadius = commandKeyCornerRadius
    self.shadow.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    self.shadow.clipsToBounds = true
    self.shadow.layer.masksToBounds = false
    self.shadow.layer.shadowRadius = 0
    self.shadow.layer.shadowOpacity = 1.0
    self.shadow.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.shadow.layer.shadowColor = keyShadowColor
  }

  func hide() {
    self.backgroundColor = UIColor.clear
    self.layer.borderColor = UIColor.clear.cgColor
    self.text = ""
    self.shadow.backgroundColor = UIColor.clear
    self.blend.backgroundColor = UIColor.clear
  }
}
