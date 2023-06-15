//
//  AppExtensions.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 08/06/23.
//

import UIKit

extension UIApplication {
  var foregroundActiveScene: UIWindowScene? {
    connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
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
