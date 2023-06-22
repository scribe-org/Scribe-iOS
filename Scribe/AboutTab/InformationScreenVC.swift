//
//  InformationScreenVC.swift
//

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
  var screenTitle: String = ""
  var section: SectionState = .privacyPolicy

  override func viewDidLoad() {
    super.viewDidLoad()

    setupInformationPageUI()

    if section == .privacyPolicy {
      setupPrivacyPolicyPage()
    } else if section == .licenses {
      setupLicensesPage()
    }
  }

  func setupInformationPageUI() {
    scrollContainerView.backgroundColor = .clear
    viewForApplyingShadow.backgroundColor = .clear

    textView.backgroundColor = UIColor(named: "commandBar")
    contentContainerView.backgroundColor = UIColor(named: "commandBar")
    applyCornerRadius(elem: contentContainerView, radius: contentContainerView.frame.width * 0.05)
    applyShadowEffects(elem: viewForApplyingShadow)

    cornerImageView.clipsToBounds = true
    contentContainerView.clipsToBounds = true

    textView.isEditable = false
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
}
