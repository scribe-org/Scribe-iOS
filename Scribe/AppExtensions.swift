// SPDX-License-Identifier: GPL-3.0-or-later

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
      if imageString == "scribeKeyIcon" {
        let trimmedImage = image.trimTransparentEdges()
        let targetSize = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: 32, height: 32) : CGSize(width: 28, height: 28)
        return trimmedImage.fitInSquareCanvas(size: targetSize)
      }
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

  func trimTransparentEdges() -> UIImage {
    guard let cgImage = self.cgImage else { return self }
    let height = cgImage.height
    let width = cgImage.width
    let bytesPerRow = cgImage.bytesPerRow

    guard let pixelData = cgImage.dataProvider?.data else { return self }
    let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
    var minX = width
    var maxX = 0
    var minY = height
    var maxY = 0

    for y in 0..<height {
      for x in 0..<width {
        let pixelIndex = y * bytesPerRow + x * 4
        let alpha = data[pixelIndex + 3]
        if alpha != 0 {
          minX = min(minX, x)
          maxX = max(maxX, x)
          minY = min(minY, y)
          maxY = max(maxY, y)
        }
      }
    }

    if minX == width { // Entirely transparent
      return self
    }

    let rect = CGRect(x: minX, y: minY, width: maxX - minX + 1, height: maxY - minY + 1)
    if let croppedCGImage = cgImage.cropping(to: rect) {
      return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
    return self
  }

  func fitInSquareCanvas(size: CGSize) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
      let rect = CGRect(origin: .zero, size: size)
      let aspectRatio = self.size.width / self.size.height

      var targetRect: CGRect
      if aspectRatio > 1 { // Landscape
        let scaledWidth = size.width
        let scaledHeight = size.width / aspectRatio
        targetRect = CGRect(x: 0, y: (size.height - scaledHeight) / 2, width: scaledWidth, height: scaledHeight)
      } else { // Portrait or Square
        let scaledHeight = size.height
        let scaledWidth = size.height * aspectRatio
        targetRect = CGRect(x: (size.width - scaledWidth) / 2, y: 0, width: scaledWidth, height: scaledHeight)
      }
      self.draw(in: targetRect)
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
