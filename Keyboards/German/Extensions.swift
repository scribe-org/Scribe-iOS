//
//  Extensiosn.swift
//

import Foundation
import UIKit

extension UIButton{

	func pressedColor(color: UIColor){

		let origImage = self.imageView?.image
		let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
		self.setImage(tintedImage, for: .highlighted)
		self.tintColor = color
	}
	func pressedColor(color: UIColor, uiImage: UIImage?,  alphaMultiplier: CGFloat){
		let origImage = uiImage
		let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
		self.setImage(tintedImage, for: .highlighted)
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		self.tintColor = UIColor(red: red, green: green, blue: blue, alpha: alpha * alphaMultiplier)
	}
}
