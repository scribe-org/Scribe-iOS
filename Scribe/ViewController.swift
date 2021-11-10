//
//  ViewController.swift
//

import UIKit

extension UITextView {

  func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
    let style = NSMutableParagraphStyle()
    style.alignment = .left
    let attributedOriginalText = NSMutableAttributedString(string: originalText)
    for (hyperLink, urlString) in hyperLinks {
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
    }

    self.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.blue,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    self.attributedText = attributedOriginalText
  }
}

class ViewController: UIViewController {
	@IBOutlet weak var instructions: UITextView!
	@IBOutlet weak var dismissKeyboardButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupUI()
	}

	func setupUI() {
		instructions.text = """
    Keyboard Installation:

    • Open Settings

    • General -> Keyboard -> Keyboards -> Add New Keyboard

    • Select from the available Scribe keyboards

    • When typing press 🌐 to select keyboards

    Scribe is a fully open-source app. If you'd like to help please visit us at github.com/scribe-org.
    """
        instructions.isEditable = false
        instructions.addHyperLinksToText(originalText: """
    Keyboard Installation:

    • Open Settings

    • General -> Keyboard -> Keyboards -> Add New Keyboard

    • Select from Scribe keyboards

    • Whe typing press 🌐 to select keyboards

    Scribe is a fully open-source application. If you'd like to help please visit us at github.com/scribe-org.
    """, hyperLinks: ["github.com/scribe-org": "https://github.com/scribe-org"])

	}

}
