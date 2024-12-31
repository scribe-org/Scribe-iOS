/**
 * Extensions for the Scribe app.
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
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
