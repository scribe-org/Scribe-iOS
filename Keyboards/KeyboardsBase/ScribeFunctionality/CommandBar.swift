//
//  CommandBar.swift
//
//  Class defining the bar into which commands are typed.
//

import UIKit

/// A custom UILabel used to house all the functionality of the command bar.
class CommandBar: UILabel {

  // MARK: - Internal Properties

  /// Button that is shown on the trailing edge of the command bar.
  let infoButton = UIButton(type: .system)
  /// The tap handler triggered when tapping `trailingButton`.
  var infoButtonTapHandler: (() -> Void)?
  /// Determines whether or not the trailing `infoButton` should be shown on the command bar.
  var isShowingInfoButton: Bool = false {
    didSet {
      infoButton.isHidden = !isShowingInfoButton
      isUserInteractionEnabled = isShowingInfoButton
    }
  }

  // MARK: - Initializer

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

  // MARK: - Internal methods

  /// Sets up the command bar's color and text alignment.
  func set() {
    addInfoButton()
    self.backgroundColor = commandBarColor
    self.blend.backgroundColor = commandBarColor
    self.layer.borderColor = commandBarBorderColor
    self.layer.borderWidth = 1.0
    self.textAlignment = NSTextAlignment.left
    if DeviceType.isPhone {
      self.font = .systemFont(ofSize: scribeKeyHeight * 0.4725)
    } else if DeviceType.isPad {
      self.font = .systemFont(ofSize: scribeKeyHeight * 0.57375)
    }
    self.shadow.isUserInteractionEnabled = false

    if DeviceType.isPhone {
      commandPromptSpacing = String(repeating: " ", count: 2)
    } else if DeviceType.isPad {
      commandPromptSpacing = String(repeating: " ", count: 5)
    }
  }

  /// Adds info button to Command Bar.
  private func addInfoButton() {
    infoButton.removeFromSuperview()
    infoButton.isHidden = true
    infoButton.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
    infoButton.tintColor = UITraitCollection.current.userInterfaceStyle == .light ? specialKeyColor : keyColor
    infoButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    infoButton.translatesAutoresizingMaskIntoConstraints = false

    addSubview(infoButton)
    NSLayoutConstraint.activate([
      infoButton.heightAnchor.constraint(equalTo: heightAnchor),
      infoButton.widthAnchor.constraint(equalTo: heightAnchor),
      infoButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      infoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    ])
  }

  /// Triggered when tapping on `trailingButton`.
  @objc func tappedButton() {
    infoButtonTapHandler?()
  }

  /// Sets up the command bar's radius and shadow.
  func setCornerRadiusAndShadow() {
    self.clipsToBounds = true
    self.layer.cornerRadius = commandKeyCornerRadius
    self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
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

  // Removes the placeholder text for a command and replaces it with just the prompt and cursor.
  func conditionallyRemovePlaceholder() {
    if self.text == translatePromptAndPlaceholder {
      self.text = translatePromptAndCursor
    } else if self.text == conjugatePromptAndPlaceholder {
      self.text = conjugatePromptAndCursor
    } else if self.text == pluralPromptAndPlaceholder {
      self.text = pluralPromptAndCursor
    }
  }

  // Changes the command bar text to an attributed string with a placeholder if there is no entered characters.
  func conditionallyAddPlaceholder() {
    if [.translate, .conjugate, .plural].contains(commandState) {
      // self.text check required as attributed text changes to text when shiftButtonState == .shift.
      if commandState == .translate && (self.text == translatePromptAndCursor || self.text == translatePromptAndPlaceholder) {
        self.attributedText = colorizePrompt(for: translatePromptAndPlaceholder)
      } else if commandState == .conjugate && (self.text == conjugatePromptAndCursor || self.text == conjugatePromptAndPlaceholder) {
        self.attributedText = colorizePrompt(for: conjugatePromptAndPlaceholder)
      } else if commandState == .plural && (self.text == pluralPromptAndCursor || self.text == pluralPromptAndPlaceholder) {
        self.attributedText = colorizePrompt(for: pluralPromptAndPlaceholder)
      }
    }
  }

  // Changes the color of the placeholder text to indicate that it is temporary.
  func colorizePrompt(for prompt: String) -> NSMutableAttributedString {
    let colorPrompt = NSMutableAttributedString(string: prompt)
    if commandState == .translate {
      colorPrompt.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))
    } else if commandState == .conjugate {
      colorPrompt.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))
    } else if commandState == .plural {
      colorPrompt.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))
    }

    return colorPrompt
  }
}
