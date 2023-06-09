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
  }

  func setContainerViewUI() {
    let containerViewHeightWidthRatio = containerView.frame.height / containerView.frame.width

    containerView.layer.cornerRadius = 36 * containerViewHeightWidthRatio
    innerTable.layer.cornerRadius = 36 * containerViewHeightWidthRatio
    innerTable.clipsToBounds = true
    applyShadowEffects(elem: containerView)
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

    // Configure the child cell
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
    print(data?.section[indexPath.row].sectionTitle ?? "")
    
    if let section = data?.section[indexPath.row] {
      switch section.sectionState {
      case .github:
        openURLString(urlString: "https://github.com/scribe-org/Scribe-iOS", withEncoding: false)
      case .matrix:
        openURLString(urlString: "https://matrix.to/#/#scribe_community:matrix.org", withEncoding: true)
      case .wikimedia:
        // Push a new screen
        print("Details about Wikimedia and Scribe")
      case .shareScribe: break
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
        // Push a new screen
        print("Scribe privacy policy page")
      case .licenses:
        // Push a new screen
        print("Licenses page")
      case .appLang: break
      case .specificLang: break
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
  
  func openScribeAppStore(alert: UIAlertAction) {
    guard let url = URL(string: "itms-apps: //itunes.apple.com/app/id1596613886") else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  func showEmailUI() {
    if MFMailComposeViewController.canSendMail() {
      let mailComposeViewController = MFMailComposeViewController()
      mailComposeViewController.mailComposeDelegate = self
      mailComposeViewController.setToRecipients(["scribe.language@gmail.com"])
      
      parentViewController?.present(mailComposeViewController, animated: true, completion: nil)
    } else {
      /// Show alert mentioning the email address
      let alert = UIAlertController(title: "Send us an email?", message: "Reach out to us at scribe.language@gmail.com", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      parentViewController?.present(alert, animated: true)
    }
  }
}

// MARK: MFMailComposeViewControllerDelegate
/// Function implementation conforming to the MFMailComposeViewControllerDelegate protocol.
extension ParentTableViewCell: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}
