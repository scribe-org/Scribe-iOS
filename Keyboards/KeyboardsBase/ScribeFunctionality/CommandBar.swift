/**
 * Class defining the bar into which commands are typed
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

/// A custom UILabel used to house all the functionality of the command bar.
class CommandBar: UILabel {
  // MARK: - Internal Properties

  /// Button that is shown on the trailing edge of the command bar.
  let infoButton = UIButton(type: .system)
  /// The tap handler triggered when tapping `trailingButton`.
  var infoButtonTapHandler: (() -> Void)?
  /// Determines whether or not the trailing `infoButton` should be shown on the command bar.
  var isShowingInfoButton = false {
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
    backgroundColor = commandBarColor
    blend.backgroundColor = commandBarColor
    layer.borderColor = commandBarBorderColor
    layer.borderWidth = 1.0
    textAlignment = NSTextAlignment.left
    if DeviceType.isPhone {
      font = .systemFont(ofSize: frame.height * 0.4725)
    } else if DeviceType.isPad {
      font = .systemFont(ofSize: frame.height * 0.57375)
    }
    shadow.isUserInteractionEnabled = false

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
      infoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
    ])
  }

  /// Triggered when tapping on `trailingButton`.
  @objc func tappedButton() {
    infoButtonTapHandler?()
  }

  /// Sets up the command bar's radius and shadow.
  func setCornerRadiusAndShadow() {
    clipsToBounds = true
    layer.cornerRadius = commandKeyCornerRadius
    layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    lineBreakMode = NSLineBreakMode.byWordWrapping

    shadow.backgroundColor = specialKeyColor
    shadow.layer.cornerRadius = commandKeyCornerRadius
    shadow.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    shadow.clipsToBounds = true
    shadow.layer.masksToBounds = false
    shadow.layer.shadowRadius = 0
    shadow.layer.shadowOpacity = 1.0
    shadow.layer.shadowOffset = CGSize(width: 0, height: 1)
    shadow.layer.shadowColor = keyShadowColor
  }

  // Hides the command bar when command buttons will be showed.
  func hide() {
    backgroundColor = UIColor.clear
    layer.borderColor = UIColor.clear.cgColor
    text = ""
    shadow.backgroundColor = UIColor.clear
    blend.backgroundColor = UIColor.clear
  }

  // Removes the placeholder text for a command and replaces it with just the prompt and cursor.
  func conditionallyRemovePlaceholder() {
    if text == translatePromptAndPlaceholder {
      text = translatePromptAndCursor
    } else if text == conjugatePromptAndPlaceholder {
      text = conjugatePromptAndCursor
    } else if text == pluralPromptAndPlaceholder {
      text = pluralPromptAndCursor
    }
  }

  // Changes the command bar text to an attributed string with a placeholder if there is no entered characters.
  func conditionallyAddPlaceholder() {
    if [.translate, .conjugate, .plural].contains(commandState) {
      // self.text check required as attributed text changes to text when shiftButtonState == .shift.
      if commandState == .translate && (text == translatePromptAndCursor || text == translatePromptAndPlaceholder) {
        attributedText = colorizePrompt(for: translatePromptAndPlaceholder)
      } else if commandState == .conjugate && (text == conjugatePromptAndCursor || text == conjugatePromptAndPlaceholder) {
        attributedText = colorizePrompt(for: conjugatePromptAndPlaceholder)
      } else if commandState == .plural && (text == pluralPromptAndCursor || text == pluralPromptAndPlaceholder) {
        attributedText = colorizePrompt(for: pluralPromptAndPlaceholder)
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
