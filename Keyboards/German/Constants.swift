//
//  Constants.swift
//

import Foundation
import UIKit

extension UIColor {
    static let defaultSpecialGrey = UIColor(red: 180.0/255.0, green: 184.0/255.0, blue: 193.0/255.0, alpha: 1.0)
}

enum Constants{

	static let keyColor: UIColor = .white
	static let keyPressedColor: UIColor = .lightText
    static let specialKeyColor: UIColor = .defaultSpecialGrey

	static let letterKeys = [
		["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü"],
		["a", "s", "d", "f", "g","h", "j", "k", "l", "ö", "ä"],
		["⇧", "y", "x", "c", "v", "b", "n", "m", "⌫"],
		["123", "🌐", "Leerzeichen", "↵"]
	]

	static let numberKeys = [
		["1", "2", "3", "4", "5", "6", "7", "8", "9", "0",],
		["-", "/", ":", ";", "(", ")" ,",", "$", "&", "@", "\""],
		["#+=",".", ",", "?", "!", "\'", "⌫"],
		["ABC", "🌐", "Leerzeichen", "↵"]
	]

	static let symbolKeys = [
		["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
		["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"],
		["123",".", ",", "?", "!", "\'", "⌫"],
		["ABC", "🌐", "Leerzeichen", "↵"]
	]
}
