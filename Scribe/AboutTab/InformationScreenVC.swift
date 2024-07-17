/**
 * Sets up information views in the About tab.
 *
 * Copyright (C) 2024 Scribe
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

class InformationScreenVC: UIViewController {
  @IBOutlet var scrollViewPhone: UIScrollView!
  @IBOutlet var scrollViewPad: UIScrollView!

  @IBOutlet var scrollContainerViewPhone: UIView!
  @IBOutlet var scrollContainerViewPad: UIView!
  var scrollContainerView: UIView!

  @IBOutlet var relativeViewPhone: UIView!
  @IBOutlet var relativeViewPad: UIView!
  var relativeView: UIView!

  @IBOutlet var contentContainerViewPhone: UIView!
  @IBOutlet var contentContainerViewPad: UIView!
  var contentContainerView: UIView!

  @IBOutlet var headingLabelPhone: UILabel!
  @IBOutlet var headingLabelPad: UILabel!
  var headingLabel: UILabel!

  @IBOutlet var textViewPhone: UITextView!
  @IBOutlet var textViewPad: UITextView!
  var textView: UITextView!

  @IBOutlet var cornerImageViewPhone: UIImageView!
  @IBOutlet var cornerImageViewPad: UIImageView!
  var cornerImageView: UIImageView!

  @IBOutlet var iconImageViewPhone: UIImageView!
  @IBOutlet var iconImageViewPad: UIImageView!
  var iconImageView: UIImageView!

  var text: String = ""
  var section: SectionState = .privacyPolicy

  func setAppTextView() {
    if DeviceType.isPad {
      scrollContainerView = scrollContainerViewPad
      relativeView = relativeViewPad
      contentContainerView = contentContainerViewPad
      headingLabel = headingLabelPad
      textView = textViewPad
      cornerImageView = cornerImageViewPad
      iconImageView = iconImageViewPad

      scrollViewPhone.removeFromSuperview()
      scrollContainerViewPhone.removeFromSuperview()
      relativeViewPhone.removeFromSuperview()
      contentContainerViewPhone.removeFromSuperview()
      headingLabelPhone.removeFromSuperview()
      textViewPhone.removeFromSuperview()
      cornerImageViewPhone.removeFromSuperview()
      iconImageViewPhone.removeFromSuperview()

    } else {
      scrollContainerView = scrollContainerViewPhone
      relativeView = relativeViewPhone
      contentContainerView = contentContainerViewPhone
      headingLabel = headingLabelPhone
      textView = textViewPhone
      cornerImageView = cornerImageViewPhone
      iconImageView = iconImageViewPhone

      scrollViewPad.removeFromSuperview()
      scrollContainerViewPad.removeFromSuperview()
      relativeViewPad.removeFromSuperview()
      contentContainerViewPad.removeFromSuperview()
      headingLabelPad.removeFromSuperview()
      textViewPad.removeFromSuperview()
      cornerImageViewPad.removeFromSuperview()
      iconImageViewPad.removeFromSuperview()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupInformationPageUI()

    if section == .privacyPolicy {
      setupPrivacyPolicyPage()
    } else if section == .licenses {
      setupLicensesPage()
    } else {
      setupWikimediaAndScribePage()
    }
  }

  /// Needed since Wikimedia and Scribe have an image as an attachment in the text.
  /// Thus, it doesn't dynamically switch on theme change like a UIImage would.
  /// Therefore, monitor for theme change and manually re-render textView.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      if section == .wikimedia {
        textView.attributedText = switchAttachmentOnThemeChange(for: textView.attributedText)
      }
    }
  }

  func setupInformationPageUI() {
    setAppTextView()
    setCornerImageView()

    textView.backgroundColor = .clear
    scrollContainerView.backgroundColor = .clear
    relativeView.backgroundColor = .clear

    contentContainerView.backgroundColor = lightWhiteDarkBlackColor
    applyCornerRadius(elem: contentContainerView, radius: contentContainerView.frame.width * 0.05)

    cornerImageView.clipsToBounds = true
    contentContainerView.clipsToBounds = true

    textView.isEditable = false
  }

  func setCornerImageView() {
    if DeviceType.isPhone {
      for constraint in cornerImageView.constraints {
        if constraint.identifier == "cornerImageView" {
          constraint.constant = 70
        }
      }
    } else if DeviceType.isPad {
      for constraint in cornerImageView.constraints {
        if constraint.identifier == "cornerImageView" {
          constraint.constant = 125
        }
      }
    }
  }

  func setupPrivacyPolicyPage() {
    navigationItem.title = NSLocalizedString("app.about.privacyPolicy", value: "Privacy policy", comment: "")
    headingLabel.attributedText = NSMutableAttributedString(
      string: NSLocalizedString("app.about.privacyPolicy.caption", value: "Keeping you safe", comment: ""),
      attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.1)]
    )
    textView.attributedText = setPrivacyPolicy(fontSize: fontSize, text: "\n" + NSLocalizedString("app.about.privacyPolicy.body", value: "Please set the app language to English and return to this view", comment: ""))
    textView.textColor = keyCharColor
    textView.linkTextAttributes = [
      NSAttributedString.Key.foregroundColor: linkBlueColor
    ]

    iconImageView.image = UIImage.availableIconImage(with: "lock.shield")
    iconImageView.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? scribeCTAColor : keyCharColor
  }

  func setupLicensesPage() {
      navigationItem.title = thirdPartyLicensesTitle
      headingLabel.attributedText = NSMutableAttributedString(
        string: thirdPartyLicensesCaption,
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.1)]
      )
      textView.attributedText = setThirdPartyLicenses(
        fontSize: fontSize, text: thirdPartyLicensesText, listElements: thirdPartyLicensesListItems
      )
    textView.textColor = keyCharColor
    textView.linkTextAttributes = [
      NSAttributedString.Key.foregroundColor: linkBlueColor
    ]

    iconImageView.image = UIImage.availableIconImage(with: "doc.text")
    iconImageView.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? scribeCTAColor : keyCharColor
  }

  func setupWikimediaAndScribePage() {
    navigationItem.title = wikimediaAndScribeTitle
    headingLabel.attributedText = NSMutableAttributedString(
      string: wikimediaAndScribeCaption,
      attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.1)]
    )
    textView.attributedText = setWikimediaAndScribe(
      text: wikimediaAndScribeText, fontSize: fontSize, imageWidth: contentContainerView.frame.width * 0.6
    )
    textView.textColor = keyCharColor
    iconImageView.image = UIImage.availableIconImage(with: "wikimediaInfoPage")
  }
}
