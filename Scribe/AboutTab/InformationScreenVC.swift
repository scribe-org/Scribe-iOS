/**
 * Sets up information views in the About tab
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

class InformationScreenVC: UIViewController {
  @IBOutlet var headingLabel: UILabel!
  @IBOutlet var textView: UITextView!
  @IBOutlet var scrollContainerView: UIView!
  @IBOutlet var contentContainerView: UIView!
  @IBOutlet var viewForApplyingShadow: UIView!

  @IBOutlet var cornerImageView: UIImageView!
  @IBOutlet var iconImageView: UIImageView!

  var text: String = ""
  var section: SectionState = .privacyPolicy

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
    setCornerImageView()

    textView.backgroundColor = .clear
    scrollContainerView.backgroundColor = .clear
    viewForApplyingShadow.backgroundColor = .clear

    contentContainerView.backgroundColor = UIColor(named: "commandBar")
    applyCornerRadius(elem: contentContainerView, radius: contentContainerView.frame.width * 0.05)
    applyShadowEffects(elem: viewForApplyingShadow)

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
    switch Locale.userSystemLanguage {
    case "EN":
      navigationItem.title = enPrivacyPolicyTitle
      headingLabel.attributedText = NSMutableAttributedString(
        string: enPrivacyPolicyPageCaption,
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.2)]
      )
      textView.attributedText = setPrivacyPolicy(fontSize: fontSize, text: enPrivacyPolicyText)
    case "DE":
      navigationItem.title = dePrivacyPolicyTitle
      headingLabel.attributedText = NSMutableAttributedString(
        string: dePrivacyPolicyPageCaption,
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.2)]
      )
      textView.attributedText = setPrivacyPolicy(fontSize: fontSize, text: dePrivacyPolicyText)
    default:
      navigationItem.title = enPrivacyPolicyTitle
      headingLabel.attributedText = NSMutableAttributedString(
        string: enPrivacyPolicyPageCaption,
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.2)]
      )
      textView.attributedText = setPrivacyPolicy(fontSize: fontSize, text: enPrivacyPolicyText)
    }
    textView.textColor = keyCharColor
    iconImageView.image = UIImage.availableIconImage(with: "lock.shield")
    iconImageView.tintColor = keyCharColor
  }

  func setupLicensesPage() {
    switch Locale.userSystemLanguage {
    case "EN":
      navigationItem.title = enThirdPartyLicensesTitle
      headingLabel.attributedText = NSMutableAttributedString(
        string: enThirdPartyLicensesCaption,
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.2)]
      )
      textView.attributedText = setThirdPartyLicenses(fontSize: fontSize, text: enThirdPartyLicensesText, listElements: enThirdPartyLicensesListItems)
    case "DE":
      navigationItem.title = enThirdPartyLicensesTitle
      headingLabel.attributedText = NSMutableAttributedString(
        string: enThirdPartyLicensesCaption,
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.2)]
      )
      textView.attributedText = setThirdPartyLicenses(fontSize: fontSize, text: enThirdPartyLicensesText, listElements: enThirdPartyLicensesListItems)
    default:
      navigationItem.title = enThirdPartyLicensesTitle
      headingLabel.attributedText = NSMutableAttributedString(
        string: enThirdPartyLicensesCaption,
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.2)]
      )
      textView.attributedText = setThirdPartyLicenses(fontSize: fontSize, text: enThirdPartyLicensesText, listElements: enThirdPartyLicensesListItems)
    }
    textView.textColor = keyCharColor
    iconImageView.image = UIImage.availableIconImage(with: "thirdPartyLicenses")
    iconImageView.tintColor = keyCharColor
  }

  func setupWikimediaAndScribePage() {
    switch Locale.userSystemLanguage {
    case "EN":
      navigationItem.title = enWikimediaAndScribeTitle
      headingLabel.attributedText = NSMutableAttributedString(
        string: enWikimediaAndScribeCaption,
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.2)]
      )
      textView.attributedText = setWikimediaAndScribe(text: enWikiMediaAndScribeText, fontSize: fontSize, imageWidth: contentContainerView.frame.width * 0.6)
    case "DE":
      navigationItem.title = enWikimediaAndScribeTitle
      headingLabel.attributedText = NSMutableAttributedString(
        string: enWikimediaAndScribeCaption,
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.2)]
      )
      textView.attributedText = setWikimediaAndScribe(text: enWikiMediaAndScribeText, fontSize: fontSize, imageWidth: contentContainerView.frame.width * 0.6)
    default:
      navigationItem.title = enWikimediaAndScribeTitle
      headingLabel.attributedText = NSMutableAttributedString(
        string: enWikimediaAndScribeCaption,
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.2)]
      )
      textView.attributedText = setWikimediaAndScribe(text: enWikiMediaAndScribeText, fontSize: fontSize, imageWidth: contentContainerView.frame.width * 0.6)
    }
    textView.textColor = keyCharColor
    iconImageView.image = UIImage.availableIconImage(with: "wikimedia")
    iconImageView.tintColor = keyCharColor
  }
}
