//
//  ParentTableViewCell.swift
//

import MessageUI
import StoreKit
import UIKit

class ParentTableViewCell: UITableViewCell {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var innerTable: UITableView!
  @IBOutlet var containerView: UIView!

  var data: ParentTableCellModel?
  var parentSection: Section?

  override func awakeFromNib() {
    super.awakeFromNib()

    let nib = UINib(nibName: "InfoChildTableViewCell", bundle: nil)
    innerTable.register(nib, forCellReuseIdentifier: "InfoChildTableViewCell")

    innerTable.dataSource = self
    innerTable.delegate = self
    innerTable.rowHeight = UITableView.automaticDimension
    innerTable.isScrollEnabled = false
    innerTable.reloadData()

    setContainerViewUI()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func configureCell(for data: ParentTableCellModel) {
    self.data = data
    titleLabel.text = data.headingTitle

    if let safeData = self.data {
      if let _ = safeData.hasDynamicData {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadChildTable), name: .keyboardsUpdatedNotification, object: nil)
      }
    }
  }

  func setContainerViewUI() {
    containerView.layer.cornerRadius = containerView.frame.width * 0.05
    innerTable.layer.cornerRadius = innerTable.frame.width * 0.05
    innerTable.clipsToBounds = true
    applyShadowEffects(elem: containerView)
  }

  @objc func reloadChildTable() {
    guard let data = data,
          let dynamicDataState = data.hasDynamicData else { return }

    switch dynamicDataState {
    case .installedKeyboards:
      self.data?.section = SettingsTableData.getInstalledKeyboardsSections()
    }

    DispatchQueue.main.async {
      self.innerTable.reloadData()
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

// MARK: UITableViewDataSource

/// Function implementation conforming to the UITableViewDataSource protocol.
extension ParentTableViewCell: UITableViewDataSource {
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return data?.section.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "InfoChildTableViewCell", for: indexPath) as! InfoChildTableViewCell

    if let parentSection = parentSection {
      cell.parentSection = parentSection
    }

    if let data = data {
      cell.configureCell(for: data.section[indexPath.row])
    }

    return cell
  }
}

// MARK: UITableViewDelegate

/// Function implementation conforming to the UITableViewDelegate protocol.
extension ParentTableViewCell: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let section = data?.section[indexPath.row] {
      switch section.sectionState {
      case .github:
        openURLString(urlString: "https://github.com/scribe-org/Scribe-iOS", withEncoding: false)
      case .matrix:
        openURLString(urlString: "https://matrix.to/#/#scribe_community:matrix.org", withEncoding: true)
      case .wikimedia:
        if let viewController = parentViewController?.storyboard?.instantiateViewController(identifier: "InformationScreenVC") as? InformationScreenVC {
          parentViewController?.navigationController?.pushViewController(viewController, animated: true)
          viewController.section = .wikimedia
        }
      case .shareScribe:
        showShareSheet()
      case .rateScribe:
        showRateScribeUI()
      case .bugReport:
        openURLString(urlString: "https://github.com/scribe-org/Scribe-iOS/issues", withEncoding: false)
      case .email:
        showEmailUI()
//      case .appHints:
//        // reset functionality
//        print("Resets app hints")
      case .privacyPolicy:
        if let viewController = parentViewController?.storyboard?.instantiateViewController(identifier: "InformationScreenVC") as? InformationScreenVC {
          parentViewController?.navigationController?.pushViewController(viewController, animated: true)
          viewController.section = .privacyPolicy
        }
      case .licenses:
        if let viewController = parentViewController?.storyboard?.instantiateViewController(identifier: "InformationScreenVC") as? InformationScreenVC {
          parentViewController?.navigationController?.pushViewController(viewController, animated: true)
          viewController.section = .licenses
        }
      case .appLang: break
      case .specificLang:
        if let viewController = parentViewController?.storyboard?.instantiateViewController(identifier: "TableViewTemplateViewController") as? TableViewTemplateViewController {
          let accentKeyLanguages: [String] = ["Swedish", "German", "Spanish"]; //Languages where we can disable accent keys
          let accentKeyOptionIndex = SettingsTableData.languageSettingsData[0].section.firstIndex(where: {s in s.sectionTitle.elementsEqual("Disable accent characters")}) ?? -1
          if (accentKeyLanguages.firstIndex(of: section.sectionTitle) == nil && accentKeyOptionIndex != -1)
            {
              let accentKeySettings = SettingsTableData.languageSettingsData[0].section.remove(at: accentKeyOptionIndex )//since there are no accent keys we can remove the option.
              print(accentKeySettings)
            }
          else if (accentKeyLanguages.firstIndex(of: section.sectionTitle) != nil && accentKeyOptionIndex == -1)
          {
              SettingsTableData.languageSettingsData[0].section.insert(Section(
                sectionTitle: "Disable accent characters",
                imageString: "info.circle",
                hasToggle: true,
                sectionState: .none(.toggleAccentCharacters)), at: 1)
          }
          viewController.configureTable(for: SettingsTableData.languageSettingsData, parentSection: section)

          parentViewController?.navigationController?.pushViewController(viewController, animated: true)
        }
      case .none: break
      }
    }

    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: false)
    }
  }

  func openURLString(urlString: String, withEncoding: Bool) {
    if withEncoding {
      let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      guard let encodedURLString = encodedString, let url = URL(string: encodedURLString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      guard let url = URL(string: urlString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }

  func showRateScribeUI() {
    if #available(iOS 14.0, *) {
      guard let scene = UIApplication.shared.foregroundActiveScene else { return }
      SKStoreReviewController.requestReview(in: scene)
    } else {
      let alert = UIAlertController(title: "Enjoying Scribe?", message: "Rate Scribe on the App Store.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: openScribeAppStore(alert:)))
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      parentViewController?.present(alert, animated: true)
    }
  }

  func openScribeAppStore(alert _: UIAlertAction) {
    openURLString(urlString: "itms-apps: //itunes.apple.com/app/id1596613886", withEncoding: true)
  }

  func showEmailUI() {
    if MFMailComposeViewController.canSendMail() {
      let mailComposeViewController = MFMailComposeViewController()
      mailComposeViewController.mailComposeDelegate = self
      mailComposeViewController.setToRecipients(["scribe.language@gmail.com"])
      mailComposeViewController.setSubject("Hey Scribe!")

      parentViewController?.present(mailComposeViewController, animated: true, completion: nil)
    } else {
      /// Show alert mentioning the email address
      let alert = UIAlertController(title: "Send us an email?", message: "Reach out to us at scribe.language@gmail.com", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      parentViewController?.present(alert, animated: true)
    }
  }

  func showShareSheet() {
    let urlString = "itms-apps: //itunes.apple.com/app/id1596613886"
    let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    guard let encodedURLString = encodedString, let url = URL(string: encodedURLString) else { return }

    let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

    parentViewController?.present(shareSheetVC, animated: true, completion: nil)
  }
}

// MARK: MFMailComposeViewControllerDelegate

/// Function implementation conforming to the MFMailComposeViewControllerDelegate protocol.
extension ParentTableViewCell: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith _: MFMailComposeResult, error _: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}
