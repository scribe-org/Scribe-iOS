//
//  CommandBar.swift
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

  /// Allows the class to be accessed from Keyboard.xib.
  class func instanceFromNib() -> UIView {
      return UINib(nibName: "Keyboard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
  }

  var shadow: UIButton!
  var blend: UILabel!

  /// Sets up the command bar's color and text alignment.
  func set() {
    self.backgroundColor = commandBarColor
    self.blend.backgroundColor = commandBarColor
    self.layer.borderColor = commandBarBorderColor
    self.layer.borderWidth = 1.0
    self.textAlignment = NSTextAlignment.left
    if DeviceType.isPhone {
      self.font = .systemFont(ofSize: annotationHeight * 0.7)
    } else if DeviceType.isPad {
      self.font = .systemFont(ofSize: annotationHeight * 0.85)
    }
    self.shadow.isUserInteractionEnabled = false

    if DeviceType.isPhone {
      commandPromptSpacing = String(repeating: " ", count: 2)
    } else if DeviceType.isPad {
      commandPromptSpacing = String(repeating: " ", count: 5)
    }
  }

  /// Sets up the command bar's radius and shadow.
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

  // Hides the command bar when command buttons will be showed.
  func hide() {
    self.backgroundColor = UIColor.clear
    self.layer.borderColor = UIColor.clear.cgColor
    self.text = ""
    self.shadow.backgroundColor = UIColor.clear
    self.blend.backgroundColor = UIColor.clear
  }
  
  func conditionallyRemovePlaceholder() {
    if commandState == true {
      if getTranslation == true && self.text == translatePromptAndPlaceholder {
        self.text = translatePromptAndCursor
      } else if getConjugation == true && self.text == conjugatePromptAndPlaceholder {
        self.text = conjugatePromptAndCursor
      } else if getPlural == true && self.text == pluralPromptAndPlaceholder {
        self.text = pluralPromptAndCursor
      }
    }
  }
  
  func conditionallyPlacePlaceholder() {
    if commandState == true {
      if getTranslation == true && self.text == translatePromptAndCursor {
        self.text = translatePromptAndPlaceholder
      } else if getConjugation == true && self.text == conjugatePromptAndCursor {
        self.text = conjugatePromptAndPlaceholder
      } else if getPlural == true && self.text == pluralPromptAndCursor {
        self.text = pluralPromptAndPlaceholder
      }
    }
  }
}
