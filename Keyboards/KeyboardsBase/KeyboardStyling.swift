//
//  KeyboardStyling.swift
//
//  Functions to style keyboard elements.
//

import UIKit

/// Styles a button's appearance including it's shape and text.
///
/// - Parameters
///  - btn: the button to be styled.
///  - title: the title to be assigned.
///  - radius: the corner radius of the button.
func styleBtn(btn: UIButton, title: String, radius: CGFloat) {
  btn.clipsToBounds = true
  btn.layer.masksToBounds = false
  btn.layer.cornerRadius = radius
  btn.setTitle(title, for: .normal)
  btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
  btn.setTitleColor(keyCharColor, for: .normal)

  if title != "Scribe" {
    btn.layer.shadowColor = keyShadowColor
    btn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    btn.layer.shadowOpacity = 1.0
    btn.layer.shadowRadius = 0.0
  }
}

/// Styles btns that have icon keys.
///
/// - Parameters
///  - btn: the button to be styled.
///  - iconName: the name of the UIImage systemName icon to be used.
///  - The delete key is made slightly larger.
func styleIconBtn(btn: UIButton, color: UIColor, iconName: String) {
  btn.setTitle("", for: .normal)
  var btnsThatAreSlightlyLarger = [
    "delete.left",
    "chevron.left",
    "chevron.right",
    "shift",
    "shift.fill",
    "capslock.fill"
  ]
  var selectKeyboardIconConfig = UIImage.SymbolConfiguration(
    pointSize: letterButtonWidth / 1.75,
    weight: .light,
    scale: .medium
  )
  if btnsThatAreSlightlyLarger.contains(iconName) {
    selectKeyboardIconConfig = UIImage.SymbolConfiguration(
      pointSize: letterButtonWidth / 1.55,
      weight: .light,
      scale: .medium
    )
  }
  if isLandscapeView == true {
    selectKeyboardIconConfig = UIImage.SymbolConfiguration(
      pointSize: letterButtonWidth / 3.5,
      weight: .light,
      scale: .medium
    )
    if btnsThatAreSlightlyLarger.contains(iconName) {
      selectKeyboardIconConfig = UIImage.SymbolConfiguration(
        pointSize: letterButtonWidth / 3.2,
        weight: .light,
        scale: .medium
      )
    }
  }
  if DeviceType.isPad {
    btnsThatAreSlightlyLarger.append("globe")
    if isLandscapeView == true {
      selectKeyboardIconConfig = UIImage.SymbolConfiguration(
        pointSize: letterButtonWidth / 3.75,
        weight: .light,
        scale: .medium
      )
      if btnsThatAreSlightlyLarger.contains(iconName) {
        selectKeyboardIconConfig = UIImage.SymbolConfiguration(
          pointSize: letterButtonWidth / 3.4,
          weight: .light,
          scale: .medium
        )
      }
    } else {
      selectKeyboardIconConfig = UIImage.SymbolConfiguration(
        pointSize: letterButtonWidth / 3,
        weight: .light,
        scale: .medium
      )
      if btnsThatAreSlightlyLarger.contains(iconName) {
        selectKeyboardIconConfig = UIImage.SymbolConfiguration(
          pointSize: letterButtonWidth / 2.75,
          weight: .light,
          scale: .medium
        )
      }
    }
  }
  btn.setImage(UIImage(systemName: iconName, withConfiguration: selectKeyboardIconConfig), for: .normal)
  btn.tintColor = color
}

/// Adds padding to keys to position them.
///
/// - Parameters
///  - to: the stackView in which the button is found.
///  - width: the width of the padding.
///  - key: the key associated with the button.
func addPadding(to stackView: UIStackView, width: CGFloat, key: String) {
  let padding = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
  padding.setTitleColor(.clear, for: .normal)
  padding.alpha = 0.0
  padding.widthAnchor.constraint(equalToConstant: width).isActive = true
  padding.isUserInteractionEnabled = false

  paddingViews.append(padding)
  stackView.addArrangedSubview(padding)
}
