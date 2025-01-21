// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Tests for keyboard styling used in Scribe keyboards.
 */

import Foundation
@testable import Scribe
import XCTest

// MARK: styleBtn

class KeyboardStylingTest: XCTestCase {
  func testStyleBtnNormalButton() {
    let button = UIButton(type: .system)
    let title = "return"
    let radius = 4.0

    styleBtn(btn: button, title: title, radius: radius)

    XCTAssertEqual(button.configuration, nil)
    XCTAssertEqual(button.clipsToBounds, false)
    XCTAssertEqual(button.layer.masksToBounds, false)
    XCTAssertEqual(button.layer.cornerRadius, radius)
    XCTAssertEqual(button.titleLabel?.text, title)
    XCTAssertEqual(button.contentHorizontalAlignment, .center)
    XCTAssertEqual(button.titleColor(for: .normal), keyCharColor)
    XCTAssertEqual(button.layer.shadowColor, keyShadowColor)
    XCTAssertEqual(button.layer.shadowOffset, CGSize(width: 0.0, height: 1.0))
    XCTAssertEqual(button.layer.shadowOpacity, 1.0)
    XCTAssertEqual(button.layer.shadowRadius, 0.0)
  }

  func testStyleBtnWithInvalidCommandMsg() {
    let button = UIButton(type: .system)
    let title = "Not in Wikidata"
    let radius = 4.0

    invalidCommandMsg = "Not in Wikidata"
    styleBtn(btn: button, title: title, radius: radius)

    XCTAssertEqual(button.configuration?.baseForegroundColor, UITraitCollection.current.userInterfaceStyle == .light ? specialKeyColor : keyColor)
    XCTAssertEqual(button.configuration?.image, UIImage(systemName: "info.circle.fill"))
    XCTAssertEqual(button.configuration?.imagePlacement, .trailing)
    XCTAssertEqual(button.configuration?.imagePadding, 3)
  }

  func testStyleBtnWitheScribeTitle() {
    let button = UIButton(type: .system)
    let title = "Scribe"
    let radius = 4.0

    styleBtn(btn: button, title: title, radius: radius)

    XCTAssertNotEqual(button.layer.shadowColor, keyShadowColor)
    XCTAssertNotEqual(button.layer.shadowOffset, CGSize(width: 0.0, height: 1.0))
    XCTAssertNotEqual(button.layer.shadowOpacity, 1.0)
    XCTAssertNotEqual(button.layer.shadowRadius, 0.0)
  }

  func testStyleBtnWithEmojisToShow() {
    let button = UIButton(type: .system)
    let title = "return"
    let radius = 4.0

    emojisToShow = .one
    styleBtn(btn: button, title: title, radius: radius)

    XCTAssertEqual(button.layer.shadowOpacity, 0)
  }
}

// MARK: getPhoneIconConfig

extension KeyboardStylingTest {
  func testGetPhoneIconConfigWithInvalidIconNameInPortrait() {
    letterKeyWidth = 100
    isLandscapeView = false
    let iconName = "abc"
    let expected = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 1.75,
      weight: .light,
      scale: .medium
    )

    let result = getPhoneIconConfig(iconName: iconName)

    XCTAssertEqual(expected, result)
  }

  func testGetPhoneIconConfigWithValidIconNameInPortrait() {
    letterKeyWidth = 100
    isLandscapeView = false
    let iconName = "delete.left"
    let expected = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 1.55,
      weight: .light,
      scale: .medium
    )

    let result = getPhoneIconConfig(iconName: iconName)

    XCTAssertEqual(expected, result)
  }

  func testGetPhoneIconConfigWithValidIconNameInLandscape() {
    letterKeyWidth = 100
    isLandscapeView = true
    let iconName = "delete.left"
    let expected = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 3.2,
      weight: .light,
      scale: .medium
    )

    let result = getPhoneIconConfig(iconName: iconName)

    XCTAssertEqual(expected, result)
  }

  func testGetPhoneIconConfigWithInvalidIconNameInLandscape() {
    letterKeyWidth = 100
    isLandscapeView = true
    let iconName = "abc"
    let expected = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 3.5,
      weight: .light,
      scale: .medium
    )

    let result = getPhoneIconConfig(iconName: iconName)

    XCTAssertEqual(expected, result)
  }
}

// MARK: getPadIconConfig

extension KeyboardStylingTest {
  func testGetPadIconConfigWithInvalidIconNameInPortrait() {
    letterKeyWidth = 100
    isLandscapeView = false
    let expected = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 3,
      weight: .light,
      scale: .medium
    )

    let result = getPadIconConfig(iconName: "abc")

    XCTAssertEqual(expected, result)
  }

  func testGetPadIconConfigWithValidIconNameInPortrait() {
    letterKeyWidth = 100
    isLandscapeView = false
    let iconName = "delete.left"
    let expected = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 2.75,
      weight: .light,
      scale: .medium
    )

    let result = getPadIconConfig(iconName: iconName)

    XCTAssertEqual(expected, result)
  }

  func testGetPadIconConfigWithInvalidIconNameInLandscape() {
    letterKeyWidth = 100
    isLandscapeView = true
    let iconName = "abc"
    let expected = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 3.75,
      weight: .light,
      scale: .medium
    )

    let result = getPadIconConfig(iconName: iconName)

    XCTAssertEqual(expected, result)
  }

  func testGetPadIconConfigWithValidIconNameInLandscape() {
    letterKeyWidth = 100
    isLandscapeView = true
    let iconName = "delete.left"
    let expected = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 3.4,
      weight: .light,
      scale: .medium
    )

    let result = getPadIconConfig(iconName: iconName)

    XCTAssertEqual(expected, result)
  }

  func testGetPadIconConfigWithValidIconNameGlobe() {
    letterKeyWidth = 100
    isLandscapeView = false
    let iconName = "globe"
    let expected = UIImage.SymbolConfiguration(
      pointSize: letterKeyWidth / 2.75,
      weight: .light,
      scale: .medium
    )

    let result = getPadIconConfig(iconName: iconName)

    XCTAssertEqual(expected, result)
  }
}

// MARK: styleIconBtn

extension KeyboardStylingTest {
  func testStyleIconBtn() {
    let color = UIColor.black
    let iconName = "delete.left"
    let button = UIButton(type: .system)

    let iconConfig = getPhoneIconConfig(iconName: iconName)
    let image = UIImage(systemName: iconName, withConfiguration: iconConfig)

    styleIconBtn(btn: button, color: color, iconName: iconName)

    XCTAssertEqual(image, button.imageView?.image)
    XCTAssertEqual(button.tintColor, color)
  }
}

// MARK: styleDeleteButton

extension KeyboardStylingTest {
  func testStyleDeleteButton() {
    let pressedButton = UIButton()
    let unpressedButton = UIButton()
    let pressedIconName = "delete.left.fill"
    let unpressedIconName = "delete.left"
    let pressedButtonIconConfig = getPhoneIconConfig(iconName: pressedIconName)
    let unpressedButtonIconConfig = getPhoneIconConfig(iconName: unpressedIconName)
    let pressedButtonImage = UIImage(systemName: pressedIconName, withConfiguration: pressedButtonIconConfig)
    let unpressedButtonImage = UIImage(systemName: unpressedIconName, withConfiguration: unpressedButtonIconConfig)

    styleDeleteButton(pressedButton, isPressed: true)
    styleDeleteButton(unpressedButton, isPressed: false)

    XCTAssertEqual(pressedButton.imageView?.image, pressedButtonImage)
    XCTAssertEqual(unpressedButton.imageView?.image, unpressedButtonImage)
  }
}

// MARK: addPadding

extension KeyboardStylingTest {
  func testAddPadding() {
    let stackView = UIStackView()
    let width = CGFloat(10)
    let key = "@"

    paddingViews = []
    XCTAssertEqual(paddingViews.count, 0)
    XCTAssertEqual(stackView.subviews.count, 0)

    addPadding(to: stackView, width: width, key: key)

    XCTAssertEqual(paddingViews.count, 1)
    XCTAssertEqual(stackView.subviews.count, 1)

    let padding = stackView.subviews.first as! UIButton
    let widthConstraint = padding.constraints.first { $0.firstAttribute == .width }
    XCTAssertEqual(padding.titleColor(for: .normal), .clear)
    XCTAssertEqual(padding.alpha, 0.0)
    XCTAssertEqual(padding.isUserInteractionEnabled, false)
    XCTAssertEqual(widthConstraint?.constant, CGFloat(10))
  }
}
