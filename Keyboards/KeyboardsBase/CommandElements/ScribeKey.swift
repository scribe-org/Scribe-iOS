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

  class func instanceFromNib() -> UIView {
      return UINib(nibName: "Keyboard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
  }

  var shadow: UIButton!

  /// Converts the Scribe key to an escape key to return to the base keyboard view.
  func toEscape() {
    self.setTitle("", for: .normal)
    var selectKeyboardIconConfig = UIImage.SymbolConfiguration(
      pointSize: annotationHeight * 0.75,
      weight: .light,
      scale: .medium
    )
    if DeviceType.isPad {
      selectKeyboardIconConfig = UIImage.SymbolConfiguration(
        pointSize: annotationHeight * 1.1,
        weight: .light,
        scale: .medium
      )
    }
    self.setImage(UIImage(systemName: "xmark", withConfiguration: selectKeyboardIconConfig), for: .normal)
    self.tintColor = keyCharColor
  }

  /// Assigns the icon and sets up the Scribe button.
  func set() {
    self.setImage(scribeKeyIcon, for: .normal)
    setBtn(btn: self, color: commandKeyColor, name: "Scribe", canCapitalize: false, isSpecial: false)
    self.layer.borderColor = commandBarBorderColor
    self.layer.borderWidth = 1.0
    self.contentMode = .center
    self.imageView?.contentMode = .scaleAspectFit
    self.shadow.isUserInteractionEnabled = false
  }
}
