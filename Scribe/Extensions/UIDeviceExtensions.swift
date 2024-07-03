//
//  UIDeviceExtensions.swift
//  Scribe
//
//  Created by Admin on 03.07.2024.
//

import UIKit

extension UIDevice {
  public static var hasNotch: Bool {
    if #available(iOS 11.0, *) {
      if UIApplication.shared.windows.count == 0 { return false }
      let top = UIApplication.shared.windows[0].safeAreaInsets.top
      return top > 24
    } else {
      return false
    }
  }
}
