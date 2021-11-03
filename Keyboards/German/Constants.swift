//
//  Constants.swift
//

import UIKit

extension UIColor {
    static let scribeGrey = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    static let scribeBlue = UIColor(red: 97.0/255.0, green: 200.0/255.0, blue: 245.0/255.0, alpha: 1.0)

    static let previewRedLightTheme = UIColor(red: 153.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let previewBlueLightTheme = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    static let previewGreenLightTheme = UIColor(red: 0.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let previewOrangeLightTheme = UIColor(red: 153.0/255.0, green: 76.0/255.0, blue: 0.0/255.0, alpha: 1.0)
}

enum Constants{
	static let letterKeysPhone = [
		["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü"],
		["a", "s", "d", "f", "g","h", "j", "k", "l", "ö", "ä"],
		["⇧", "y", "x", "c", "v", "b", "n", "m", "⌫"],
		["123", "🌐", "Leerzeichen", "↵"]
	]

	static let numberKeysPhone = [
		["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
		["-", "/", ":", ";", "(", ")" , "$", "&", "@", "\""],
		["#+=", ".", ",", "?", "!", "\'", "⌫"],
		["ABC", "🌐", "Leerzeichen", "↵"]
	]

	static let symbolKeysPhone = [
		["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
		["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"],
		["123", ".", ",", "?", "!", "\'", "⌫"],
		["ABC", "🌐", "Leerzeichen", "↵"]
	]
    
    static let letterKeysPad = [
        ["q", "w", "e", "r", "t", "z", "u", "i", "o", "p", "ü", "⌫"],
        ["a", "s", "d", "f", "g","h", "j", "k", "l", "ö", "ä", "↵"],
        ["⇧", "y", "x", "c", "v", "b", "n", "m", ",", ".", "ß", "⇧"],
        [".?123", "🌐", "Leerzeichen", ".?123", "hideKeyboard"]
    ]

    static let numberKeysPad = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "⌫"],
        ["\"", "§", "$", "%", "&", "/", "(", ")" , "=", "'", "#", "↵"],
        ["#+=", "—", "`", "'", "...", "@", ";", ":'", ",", ".", "-", "#+="],
        ["ABC", "🌐", "Leerzeichen", "undoArrow", "ABC", "hideKeyboard"]
    ]

    static let symbolKeysPad = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "⌫"],
        ["€", "£", "¥", "¿", "―", "\\", "[", "]", "{", "}", "|", "↵"],
        ["123", "¡", "<", ">", "≠", "·", "^", "~", "!", "?", "_", "123"],
        ["ABC", "🌐", "Leerzeichen", "undoArrow", "ABC", "hideKeyboard"]
    ]
}
