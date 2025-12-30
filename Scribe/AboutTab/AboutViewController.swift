// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Functions for the About tab.
 */

import MessageUI
import StoreKit
import UIKit
import SwiftUI

final class AboutViewController: BaseTableViewController {
  override var dataSet: [ParentTableCellModel] {
    AboutTableData.aboutTableData
  }

  private let aboutTipCardState: Bool = {
    let userDefault = UserDefaults.standard
    let state = userDefault.object(forKey: "aboutTipCardState") as? Bool ?? true
    return state
  }()

  private var tipHostingController: UIHostingController<AboutTipCardView>!
  private var tableViewOffset: CGFloat?

  override func viewDidLoad() {
    super.viewDidLoad()
    showTipCardView()
    title = NSLocalizedString("i18n.app.about.title", value: "About", comment: "")

    tableView.register(
      UINib(nibName: "AboutTableViewCell", bundle: nil),
      forCellReuseIdentifier: AboutTableViewCell.reuseIdentifier
    )
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if tableViewOffset == nil && UIDevice.current.userInterfaceIdiom != .pad {
      tableViewOffset = tableView.contentOffset.y
    }
  }
}

// MARK: UITableViewDataSource

extension AboutViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: AboutTableViewCell.reuseIdentifier,
      for: indexPath
    ) as? AboutTableViewCell else {
      fatalError("Failed to dequeue AboutTableViewCell.")
    }
    cell.configureCell(for: dataSet[indexPath.section].section[indexPath.row])
    cell.backgroundColor = lightWhiteDarkBlackColor

    return cell
  }
}

// MARK: UITableViewDelegate

extension AboutViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let tableSection = dataSet[indexPath.section]
    let section = tableSection.section[indexPath.row]

    switch section.sectionState {
    case .github:
      openURLString(urlString: "https://github.com/scribe-org/Scribe-iOS", withEncoding: false)

    case .matrix:
      openURLString(urlString: "https://matrix.to/#/#scribe_community:matrix.org", withEncoding: true)

    case .mastodon:
      openURLString(urlString: "https://wikis.world/@scribe", withEncoding: false)

    case .wikimedia:
      if let viewController = storyboard?.instantiateViewController(
        identifier: "InformationScreenVC"
      ) as? InformationScreenVC {
        navigationController?.pushViewController(viewController, animated: true)
        viewController.section = .wikimedia
      }

    case .shareScribe:
      showShareSheet()

    case .rateScribe:
      showRateScribeUI()

    case .bugReport:
      openURLString(
        urlString: "https://github.com/scribe-org/Scribe-iOS/issues", withEncoding: false
      )
    case .version:
      openURLString(
        urlString: "https://github.com/scribe-org/Scribe-iOS/releases", withEncoding: false
      )

    case .email:
      showEmailUI()

    case .appHints:
      let userDefaults = UserDefaults.standard
      userDefaults.set(true, forKey: "installationTipCardState")
      userDefaults.set(true, forKey: "settingsTipCardState")
      userDefaults.set(true, forKey: "aboutTipCardState")

      startGlowingEffect(on: tipHostingController.view)

    case .privacyPolicy:
      if let viewController = storyboard?.instantiateViewController(
        identifier: "InformationScreenVC"
      ) as? InformationScreenVC {
        navigationController?.pushViewController(viewController, animated: true)
        viewController.section = .privacyPolicy
      }

    case .licenses:
      if let viewController = storyboard?.instantiateViewController(
        identifier: "InformationScreenVC"
      ) as? InformationScreenVC {
        navigationController?.pushViewController(viewController, animated: true)
        viewController.section = .licenses
      }

    default: break
    }

    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedIndexPath, animated: false)
    }
  }

  private func openURLString(urlString: String, withEncoding: Bool) {
    if withEncoding {
      let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      guard let encodedURLString = encodedString, let url = URL(string: encodedURLString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      guard let url = URL(string: urlString) else { return }
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }

  private func showRateScribeUI() {
    guard let scene = UIApplication.shared.foregroundActiveScene else { return }
    SKStoreReviewController.requestReview(in: scene)
  }

  private func openScribeAppStore(alert _: UIAlertAction) {
    openURLString(urlString: "itms-apps: //itunes.apple.com/app/id1596613886", withEncoding: true)
  }

  private func showEmailUI() {
    if MFMailComposeViewController.canSendMail() {
      let mailComposeViewController = MFMailComposeViewController()
      mailComposeViewController.mailComposeDelegate = self
      mailComposeViewController.setToRecipients(["team@scri.be"])
      mailComposeViewController.setSubject("Hey Scribe!")

      present(mailComposeViewController, animated: true, completion: nil)
    } else {
      // Show alert mentioning the email address.
      let alert = UIAlertController(
        title: "Send us an email?", message: "Reach out to us at team@scri.be", preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      present(alert, animated: true)
    }
  }

  private func showShareSheet() {
    let urlString = "itms-apps: //itunes.apple.com/app/id1596613886"
    let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    guard let encodedURLString = encodedString, let url = URL(string: encodedURLString) else { return }

    let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

    present(shareSheetVC, animated: true, completion: nil)
  }
}

// MARK: MFMailComposeViewControllerDelegate

extension AboutViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith _: MFMailComposeResult, error _: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}

// MARK: TipCardView
extension AboutViewController {
  private func showTipCardView() {
    let overlayView = AboutTipCardView(
      aboutTipCardState: aboutTipCardState
    )

    let hostingController = UIHostingController(rootView: overlayView)
    tipHostingController = hostingController
    hostingController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: -40)
    hostingController.view.backgroundColor = .clear
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    hostingController.view.isUserInteractionEnabled = true

    let navigationView = navigationController?.navigationBar
    guard let navigationView else { return }
    navigationView.addSubview(hostingController.view)
    navigationView.bringSubviewToFront(hostingController.view)

    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: navigationView.topAnchor, constant: 30),
      hostingController.view.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor)
    ])
    hostingController.didMove(toParent: self)
    startGlowingEffect(on: hostingController.view)
  }

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let hostingController = tipHostingController,
          let tableViewOffset else { return }

    let currentOffset = scrollView.contentOffset.y

    if currentOffset > tableViewOffset {
      // Scrolling up.
      UIView.animate(withDuration: 0.2) {
        hostingController.view.alpha = 0
      }
    } else if currentOffset == tableViewOffset {
      // Show the view only when scrolled to the top.
      UIView.animate(withDuration: 0.1) {
        hostingController.view.alpha = 1
      }
    }
  }

  func startGlowingEffect(on view: UIView, duration: TimeInterval = 1.0) {
    view.layer.shadowColor = UIColor.scribeCTA.cgColor
    view.layer.shadowRadius = 8
    view.layer.shadowOpacity = 0.0
    view.layer.shadowOffset = CGSize(width: 0, height: 0)

    UIView.animate(withDuration: duration,
                   delay: 0,
                   options: [.curveEaseOut, .autoreverse],
                   animations: {
      view.layer.shadowOpacity = 0.6
    }, completion: nil)
  }
}
