// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Extensions for the Scribe app.
 */

import UIKit

extension UIApplication {
  var foregroundActiveScene: UIWindowScene? {
    connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
  }
}

extension UIImage {
  static func availableIconImage(with imageString: String) -> UIImage {
    if let image = UIImage(named: imageString) {
      return image
    } else {
      if let image = UIImage(systemName: imageString) {
        return image
      } else {
        guard let infoCircleSymbol = UIImage(systemName: "info.circle") else {
          fatalError("Failed to create info circle symbol image.")
        }
        return infoCircleSymbol
      }
    }
  }
}

extension UIView {
  var parentViewController: UIViewController? {
    var currentResponder: UIResponder? = self

    while let responder = currentResponder {
      if let viewController = responder as? UIViewController {
        return viewController
      }
      currentResponder = responder.next
    }

    return nil
  }
}

extension Locale {
  static var userSystemLanguage: String {
    return String(Locale.preferredLanguages[0].prefix(2)).uppercased()
  }
}

extension Notification.Name {
  static let keyboardsUpdatedNotification = Notification.Name("keyboardsHaveUpdated")
}
