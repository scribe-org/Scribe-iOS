//
//  KeyboardViewController.swift
//

import UIKit
import MessageUI

var proxy : UITextDocumentProxy!

class KeyboardViewController: UIInputViewController {

	@IBOutlet var nextKeyboardButton: UIButton!

	var keyboardView: UIView!
	var keys: [UIButton] = []
	var paddingViews: [UIButton] = []
	var backspaceTimer: Timer?

	enum KeyboardState{
		case letters
		case numbers
		case symbols
	}

	enum ShiftButtonState {
		case normal
		case shift
		case caps
	}

	var keyboardState: KeyboardState = .letters
	var shiftButtonState:ShiftButtonState = .normal

	@IBOutlet weak var stackView1: UIStackView!
	@IBOutlet weak var stackView2: UIStackView!
	@IBOutlet weak var stackView3: UIStackView!
	@IBOutlet weak var stackView4: UIStackView!

	override func updateViewConstraints() {
		super.updateViewConstraints()
		// Add custom view sizing constraints here.
		keyboardView.frame.size = view.frame.size
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		proxy = textDocumentProxy as UITextDocumentProxy
		loadInterface()
		self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)

	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func viewWillLayoutSubviews() {
		self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
		super.viewWillLayoutSubviews()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let heightConstraint = NSLayoutConstraint(item: view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 220)
		view.addConstraint(heightConstraint)

	}


	func loadInterface(){
		let keyboardNib = UINib(nibName: "Keyboard", bundle: nil)
		keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as? UIView
		view.addSubview(keyboardView)
		loadKeys()
	}

	func addPadding(to stackView: UIStackView, width: CGFloat, key: String){
		let padding = UIButton(frame: CGRect(x: 0, y: 0, width: 3, height: 5))
		padding.setTitleColor(.clear, for: .normal)
		padding.alpha = 0.0
		padding.widthAnchor.constraint(equalToConstant: width).isActive = true

		// If we want to use this padding as a key.
		let keyToDisplay = shiftButtonState == .normal ? key : key.capitalized
		padding.layer.setValue(key, forKey: "original")
		padding.layer.setValue(keyToDisplay, forKey: "keyToDisplay")
		padding.layer.setValue(false, forKey: "isSpecial")
		padding.addTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
		padding.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
		padding.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)

		paddingViews.append(padding)
		stackView.addArrangedSubview(padding)
	}
    // Place before or after desiredStackView.addArrangedSubview(button) in loadKeys.
    // addPadding(to: desiredStackView, width: buttonWidth/2, key: "desiredKey")

	func loadKeys(){
		keys.forEach{$0.removeFromSuperview()}
		paddingViews.forEach{$0.removeFromSuperview()}
        
        // buttonWidth determined per keyboard by the top row.
        var buttonWidth = CGFloat(0)
		let letterButtonWidth = (UIScreen.main.bounds.width - 5) / CGFloat(Constants.letterKeys[0].count)
        let numSymButtonWidth = (UIScreen.main.bounds.width - 5) / CGFloat(Constants.numberKeys[0].count)

		var keyboard: [[String]]

		// Start padding.
		switch keyboardState {
		case .letters:
			keyboard = Constants.letterKeys
            buttonWidth = letterButtonWidth
            // Auto-capitalization.
            if proxy.documentContextBeforeInput?.count == 0 {
                shiftButtonState = .shift
            }
		case .numbers:
			keyboard = Constants.numberKeys
            buttonWidth = numSymButtonWidth
		case .symbols:
			keyboard = Constants.symbolKeys
            buttonWidth = numSymButtonWidth
		}

		let numRows = keyboard.count
		for row in 0...numRows - 1{
			for col in 0...keyboard[row].count - 1{
				let button = UIButton(type: .custom)
				button.backgroundColor = Constants.keyColor
				button.setTitleColor(.black, for: .normal)
				let key = keyboard[row][col]
				let capsKey = keyboard[row][col].capitalized
				let keyToDisplay = shiftButtonState == .normal ? key : capsKey
				button.layer.setValue(key, forKey: "original")
				button.layer.setValue(keyToDisplay, forKey: "keyToDisplay")
				button.layer.setValue(false, forKey: "isSpecial")
                
				button.setTitle(keyToDisplay, for: .normal) // set button character
                if key == "#+=" || key == "ABC" || key == "123" {
                    button.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.75)
                } else {
                    button.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.5)
                }
                
				button.layer.borderColor = keyboardView.backgroundColor?.cgColor
				button.layer.borderWidth = 3
                button.layer.cornerRadius = buttonWidth / 4
				button.addTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
				button.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
				button.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
				button.addTarget(self, action: #selector(keyMultiPress(_:event:)), for: .touchDownRepeat)
                
                // Pad before key is added.
                if key == "y"{
                    addPadding(to: stackView3, width: buttonWidth/3, key: "y")
                }

				if key == "⌫"{
					let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(keyLongPressed(_:)))
					button.addGestureRecognizer(longPressRecognizer)
				}

				keys.append(button)
				switch row{
				case 0: stackView1.addArrangedSubview(button)
				case 1: stackView2.addArrangedSubview(button)
				case 2: stackView3.addArrangedSubview(button)
				case 3: stackView4.addArrangedSubview(button)
				default:
					break
				}
                
				if key == "🌐"{
					nextKeyboardButton = button
				}
                
                // Pad after key is added.
                if key == "m"{
                    addPadding(to: stackView3, width: buttonWidth/3, key: "m")
                }

				// specialKey constraints.
				if key == "⌫" || key == "#+=" || key == "ABC" || key == "123" || key == "⇧" || key == "🌐"{
					button.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.5).isActive = true
					button.layer.setValue(true, forKey: "isSpecial")
					button.backgroundColor = Constants.specialKeyColor
					if key == "⇧" {
						if shiftButtonState != .normal{
							button.backgroundColor = Constants.keyPressedColor
						}
						if shiftButtonState == .caps{
							button.setTitle("⇪", for: .normal)
						}
					}
                }else if key == "↵" {
                    button.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 2).isActive = true
                    button.layer.setValue(true, forKey: "isSpecial")
                    button.backgroundColor = Constants.specialKeyColor
                }else if (keyboardState == .numbers || keyboardState == .symbols) && row == 2 {
					button.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.4).isActive = true
				}else if key != "Leerzeichen"{
					button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
				}else{
					button.layer.setValue(key, forKey: "original")
					button.setTitle(key, for: .normal)
				}
			}
		}

		// End padding.
		switch keyboardState {
		case .letters:
            break
		case .numbers:
			break
		case .symbols:
            break
		}
	}

	func changeKeyboardToNumberKeys(){
		keyboardState = .numbers
		shiftButtonState = .normal
		loadKeys()
	}
	func changeKeyboardToLetterKeys(){
		keyboardState = .letters
		loadKeys()
	}
	func changeKeyboardToSymbolKeys(){
		keyboardState = .symbols
		loadKeys()
	}
	func handlDeleteButtonPressed(){
		proxy.deleteBackward()
	}
    
    func nounGenderColoration(){
        if proxy.documentContextBeforeInput?.suffix("colorMe".count) == "colorMe"{
            proxy.insertText("!")
        }
//        if proxy.documentContextBeforeInput?.suffix("Bücher".count) == "Buch"{}
//        if proxy.documentContextBeforeInput?.suffix("Bücher".count) == "Bücher"{}
//        if proxy.documentContextBeforeInput?.suffix("Kind".count) == "Kind"{}
//        if proxy.documentContextBeforeInput?.suffix("Frau".count) == "Frau"{}
//        if proxy.documentContextBeforeInput?.suffix("Tisch".count) == "Tisch"{}
    }

    func pluralFuncCapitalization(){
        if proxy.documentContextBeforeInput?.suffix("pl(".count) == "pl("{
            changeKeyboardToLetterKeys()
            if shiftButtonState == .normal {
                shiftButtonState = .shift
                loadKeys()
            }
        }
    }
    
    func nounSingularToPlural(){
        if proxy.documentContextBeforeInput?.suffix("pl(Buch)".count) == "pl(Buch)"{
            proxy.deleteBackward()
            proxy.deleteBackward()
            proxy.deleteBackward()
            proxy.deleteBackward()
            proxy.deleteBackward()
            proxy.deleteBackward()
            proxy.deleteBackward()
            proxy.deleteBackward()
            proxy.insertText("Bücher")
        }
    }

	@IBAction func keyPressedTouchUp(_ sender: UIButton) {
		guard let originalKey = sender.layer.value(forKey: "original") as? String, let keyToDisplay = sender.layer.value(forKey: "keyToDisplay") as? String else {return}

		guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
		sender.backgroundColor = isSpecial ? Constants.specialKeyColor : Constants.keyColor

		switch originalKey {
		case "⌫":
			if shiftButtonState == .shift {
				shiftButtonState = .normal
				loadKeys()
			}
			handlDeleteButtonPressed()
            if proxy.documentContextBeforeInput == nil  {
                if keyboardState == .letters && shiftButtonState == .normal {
                    shiftButtonState = .shift
                    loadKeys()
                }
            }
		case "Leerzeichen":
			proxy.insertText(" ")
		case "🌐":
			break
		case "↵":
			proxy.insertText("\n")
		case "123":
			changeKeyboardToNumberKeys()
		case "ABC":
			changeKeyboardToLetterKeys()
        case "'":
            proxy.insertText("'")
            changeKeyboardToLetterKeys()
		case "#+=":
			changeKeyboardToSymbolKeys()
		case "⇧":
			shiftButtonState = shiftButtonState == .normal ? .shift : .normal
			loadKeys()
        case "(":
            proxy.insertText("(")
            pluralFuncCapitalization()
        case ")":
            proxy.insertText(")")
            nounSingularToPlural()
		default:
			if shiftButtonState == .shift {
				shiftButtonState = .normal
				loadKeys()
			}
			proxy.insertText(keyToDisplay)
            
        nounGenderColoration()
		}
	}

	@objc func keyMultiPress(_ sender: UIButton, event: UIEvent){
		guard let originalKey = sender.layer.value(forKey: "original") as? String else {return}

		let touch: UITouch = event.allTouches!.first!
		if (touch.tapCount == 2 && originalKey == "⇧") {
			shiftButtonState = .caps
			loadKeys()
		}
        // Double space period shortcut.
        if (touch.tapCount == 2 && originalKey == "Leerzeichen" && keyboardState == .letters && proxy.documentContextBeforeInput?.count != 1) {
            if proxy.documentContextBeforeInput?.suffix(2) != "  " {
                proxy.deleteBackward()
                proxy.insertText(". ")
                shiftButtonState = .shift
                loadKeys()
            }
        }
	}

	@objc func keyLongPressed(_ gesture: UIGestureRecognizer){
		if gesture.state == .began {
			backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
				self.handlDeleteButtonPressed()
			}
		} else if gesture.state == .ended || gesture.state == .cancelled {
			backspaceTimer?.invalidate()
			backspaceTimer = nil
			(gesture.view as! UIButton).backgroundColor = Constants.specialKeyColor
		}
	}

	@objc func keyUntouched(_ sender: UIButton){
		guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
		sender.backgroundColor = isSpecial ? Constants.specialKeyColor : Constants.keyColor
	}

	@objc func keyTouchDown(_ sender: UIButton){
		sender.backgroundColor = Constants.keyPressedColor
	}

	override func textWillChange(_ textInput: UITextInput?) {
		// The app is about to change the document's contents. Perform any preparation here.
	}

	override func textDidChange(_ textInput: UITextInput?) {
		// The app has just changed the document's contents, the document context has been updated.

		var textColor: UIColor
		let proxy = self.textDocumentProxy
		if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
			textColor = UIColor.white
		} else {
			textColor = UIColor.black
		}
		self.nextKeyboardButton.setTitleColor(textColor, for: [])
	}

}
