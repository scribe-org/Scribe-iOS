// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Sets up information views in the About tab.
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

  var text: String = ""
  var section: SectionState = .privacyPolicy

  func setAppTextView() {
    if DeviceType.isPad {
      scrollContainerView = scrollContainerViewPad
      relativeView = relativeViewPad
      contentContainerView = contentContainerViewPad
      headingLabel = headingLabelPad
      textView = textViewPad

      scrollViewPhone.removeFromSuperview()
      scrollContainerViewPhone.removeFromSuperview()
      relativeViewPhone.removeFromSuperview()
      contentContainerViewPhone.removeFromSuperview()
      headingLabelPhone.removeFromSuperview()
      textViewPhone.removeFromSuperview()
    } else {
      scrollContainerView = scrollContainerViewPhone
      relativeView = relativeViewPhone
      contentContainerView = contentContainerViewPhone
      headingLabel = headingLabelPhone
      textView = textViewPhone

      scrollViewPad.removeFromSuperview()
      scrollContainerViewPad.removeFromSuperview()
      relativeViewPad.removeFromSuperview()
      contentContainerViewPad.removeFromSuperview()
      headingLabelPad.removeFromSuperview()
      textViewPad.removeFromSuperview()
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

    textView.backgroundColor = .clear
    scrollContainerView.backgroundColor = .clear
    relativeView.backgroundColor = .clear

    contentContainerView.backgroundColor = lightWhiteDarkBlackColor
    applyCornerRadius(elem: contentContainerView, radius: contentContainerView.frame.width * 0.05)

    contentContainerView.clipsToBounds = true

    textView.isEditable = false
  }

  func setupPrivacyPolicyPage() {
    navigationItem.title = NSLocalizedString("app.about.legal.privacy_policy", value: "Privacy policy", comment: "")
    headingLabel.attributedText = NSMutableAttributedString(
      string: NSLocalizedString("app.about.legal.privacy_policy.caption", value: "Keeping you safe", comment: ""),
      attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.1)]
    )
    textView.attributedText = setPrivacyPolicy(fontSize: fontSize, text: NSLocalizedString("app.about.legal.privacy_policy.text", value: """
Please note that the English version of this policy takes precedence over all other versions.

The Scribe developers (SCRIBE) built the iOS application "Scribe - Language Keyboards" (SERVICE) as an open-source application. This SERVICE is provided by SCRIBE at no cost and is intended for use as is.

This privacy policy (POLICY) is used to inform the reader of the policies for the access, tracking, collection, retention, use, and disclosure of personal information (USER INFORMATION) and usage data (USER DATA) for all individuals who make use of this SERVICE (USERS).

USER INFORMATION is specifically defined as any information related to the USERS themselves or the devices they use to access the SERVICE.

USER DATA is specifically defined as any text that is typed or actions that are done by the USERS while using the SERVICE.

1. Policy Statement

This SERVICE does not access, track, collect, retain, use, or disclose any USER INFORMATION or USER DATA.

2. Do Not Track

USERS contacting SCRIBE to ask that their USER INFORMATION and USER DATA not be tracked will be provided with a copy of this POLICY as well as a link to all source codes as proof that they are not being tracked.

3. Third-Party Data

This SERVICE makes use of third-party data. All data used in the creation of this SERVICE comes from sources that allow its full use in the manner done so by the SERVICE. Specifically, the data for this SERVICE comes from Wikidata, Wikipedia and Unicode. Wikidata states that, "All structured data in the main, property and lexeme namespaces is made available under the Creative Commons CC0 License; text in other namespaces is made available under the Creative Commons Attribution-Share Alike License." The policy detailing Wikidata data usage can be found at https://www.wikidata.org/wiki/Wikidata:Licensing. Wikipedia states that text data, the type of data used by the SERVICE, "… can be used under the terms of the Creative Commons Attribution Share-Alike license". The policy detailing Wikipedia data usage can be found at https://en.wikipedia.org/wiki/Wikipedia:Reusing_Wikipedia_content. Unicode provides permission, "… free of charge, to any person obtaining a copy of the Unicode data files and any associated documentation (the "Data Files") or Unicode software and any associated documentation (the "Software") to deal in the Data Files or Software without restriction…" The policy detailing Unicode data usage can be found at https://www.unicode.org/license.txt.

4. Third-Party Source Code

This SERVICE was based on third-party code. All source code used in the creation of this SERVICE comes from sources that allow its full use in the manner done so by the SERVICE. Specifically, the basis of this project was the project Custom Keyboard by Ethan Sarif-Kattan. Custom Keyboard was released under an MIT license, with this license being available at https://github.com/EthanSK/CustomKeyboard/blob/master/LICENSE.

5. Third-Party Services

This SERVICE makes use of third-party services to manipulate some of the third-party data. Specifically, data has been translated using models from Hugging Face transformers. This service is covered by an Apache License 2.0, which states that it is available for commercial use, modification, distribution, patent use, and private use. The license for the aforementioned service can be found at https://github.com/huggingface/transformers/blob/master/LICENSE.

6. Third-Party Links

This SERVICE contains links to external websites. If USERS click on a third-party link, they will be directed to a website. Note that these external websites are not operated by this SERVICE. Therefore, USERS are strongly advised to review the privacy policy of these websites. This SERVICE has no control over and assumes no responsibility for the content, privacy policies, or practices of any third-party sites or services.

7. Third-Party Images

This SERVICE contains images that are copyrighted by third-parties. Specifically, this app includes a copy of the logos of GitHub, Inc and Wikidata, trademarked by Wikimedia Foundation, Inc. The terms by which the GitHub logo can be used are found on https://github.com/logos, and the terms for the Wikidata logo are found on the following Wikimedia page: https://foundation.wikimedia.org/wiki/Policy:Trademark_policy. This SERVICE uses the copyrighted images in a way that matches these criteria, with the only deviation being a rotation of the GitHub logo that is common in the open-source community to indicate that there is a link to the GitHub website.

8. Content Notice

This SERVICE allows USERS to access linguistic content (CONTENT). Some of this CONTENT could be deemed inappropriate for children and legal minors. Accessing CONTENT using the SERVICE is done in a way that the information is unavailable unless explicitly known. Specifically, USERS "can" translate words, conjugate verbs, and access other grammatical features of CONTENT that may be sexual, violent, or otherwise inappropriate in nature. USERS "cannot" translate words, conjugate verbs, and access other grammatical features of CONTENT that may be sexual, violent, or otherwise inappropriate in nature if they do not already know about the nature of this CONTENT. SCRIBE takes no responsibility for the access of such CONTENT.

9. Changes

This POLICY is subject to change. Updates to this POLICY will replace all prior instances, and if deemed material will further be clearly stated in the next applicable update to the SERVICE. SCRIBE encourages USERS to periodically review this POLICY for the latest information on our privacy practices and to familiarize themselves with any changes.

10. Contact

If you have any questions, concerns, or suggestions about this POLICY, do not hesitate to visit https://github.com/scribe-org or contact SCRIBE at scribe.langauge@gmail.com. The person responsible for such inquiries is Andrew Tavis McAllister.

11. Effective Date

This POLICY is effective as of the 24th of May, 2022.
""", comment: ""))
    textView.textColor = keyCharColor
    textView.linkTextAttributes = [
      NSAttributedString.Key.foregroundColor: linkBlueColor
    ]
  }

  func setupLicensesPage() {
      navigationItem.title = thirdPartyLicensesTitle
      headingLabel.attributedText = NSMutableAttributedString(
        string: thirdPartyLicensesCaption,
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.1)]
      )
      textView.attributedText = setThirdPartyLicenses(
        fontSize: fontSize, text: thirdPartyLicensesText
      )
    textView.textColor = keyCharColor
    textView.linkTextAttributes = [
      NSAttributedString.Key.foregroundColor: linkBlueColor
    ]
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
  }
}
