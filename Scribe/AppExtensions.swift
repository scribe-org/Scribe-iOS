//
//  AppExtensions.swift
//

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
      return UIImage(systemName: imageString) ?? UIImage(systemName: "info.circle")!
    }
  }
}

extension UIView {
  var parentViewController: UIViewController? {
    var parentResponder: UIResponder? = self
    while parentResponder != nil {
      parentResponder = parentResponder!.next
      if parentResponder is UIViewController {
        return parentResponder as? UIViewController
      }
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
