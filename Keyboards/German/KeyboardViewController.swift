//
//  KeyboardViewController.swift
//

import UIKit

var proxy : UITextDocumentProxy!
// A larger vertical bar than the normal key for the cursor.
let previewCursor = "│"

extension String {
    func index(from: Int) -> Index {
            return self.index(startIndex, offsetBy: from)
    }
    
    func substring(to: Int) -> String {
            let toIndex = index(from: to)
            return String(self[..<toIndex])
    }
    
    func insertPriorToCursor(char: String) -> String {
        return substring(to: self.count - 1) + char + previewCursor
    }
    
    func deletePriorToCursor() -> String {
        return substring(to: self.count - 2) + previewCursor
    }
}

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
    
    @IBOutlet var deGrammarPreviewLabel: UILabel!
    func setPreviewLabel() {
        deGrammarPreviewLabel?.backgroundColor = Constants.previewLabelColor
    }
    var previewState: Bool! = false
    var invalidState: Bool! = false
    let pluralPrompt: String = "     /pl: " + previewCursor
    let firstPersonSingularPrompt: String = "     /fps: " + previewCursor
    let secondPersonSingularPrompt: String = "     /sps: " + previewCursor
    let thirdPersonSingularPrompt: String = "     /tps: " + previewCursor
    let firstPersonPluralPrompt: String = "     /fpp: " + previewCursor
    let secondPersonPluralPrompt: String = "     /spp: " + previewCursor
    let thirdPersonPluralPrompt: String = "     /tpp: " + previewCursor
    let pastParticiplePrompt: String = "     /pp: " + previewCursor
    lazy var allPrompts : [String] = [pluralPrompt, firstPersonSingularPrompt]
    
    @IBOutlet weak var deStackView1: UIStackView!
	@IBOutlet weak var deStackView2: UIStackView!
	@IBOutlet weak var deStackView3: UIStackView!
	@IBOutlet weak var deStackView4: UIStackView!

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


	func loadInterface() {
		let keyboardNib = UINib(nibName: "Keyboard", bundle: nil)
		keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as? UIView
		view.addSubview(keyboardView)
		loadKeys()
	}

	func addPadding(to stackView: UIStackView, width: CGFloat, key: String) {
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

	func loadKeys() {
        setPreviewLabel()
        invalidState = false
        
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
                
                deGrammarPreviewLabel?.layer.cornerRadius = buttonWidth / 4
                deGrammarPreviewLabel?.layer.masksToBounds = true
                deGrammarPreviewLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.75)
                deGrammarPreviewLabel?.textColor = .black
                deGrammarPreviewLabel?.numberOfLines = 0
                deGrammarPreviewLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                if previewState == false {
                    deGrammarPreviewLabel?.text = ""
                    deGrammarPreviewLabel?.textAlignment = NSTextAlignment.center
                }
                deGrammarPreviewLabel?.sizeToFit()
                
                // Pad before key is added.
                if key == "y"{
                    addPadding(to: deStackView3, width: buttonWidth/3, key: "y")
                }

				if key == "⌫"{
					let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(keyLongPressed(_:)))
					button.addGestureRecognizer(longPressRecognizer)
				}

				keys.append(button)
				switch row{
				case 0: deStackView1.addArrangedSubview(button)
				case 1: deStackView2.addArrangedSubview(button)
				case 2: deStackView3.addArrangedSubview(button)
				case 3: deStackView4.addArrangedSubview(button)
				default:
					break
				}
                
				if key == "🌐"{
					nextKeyboardButton = button
				}
                
                // Pad after key is added.
                if key == "m"{
                    addPadding(to: deStackView3, width: buttonWidth/3, key: "m")
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

	func changeKeyboardToNumberKeys() {
		keyboardState = .numbers
		shiftButtonState = .normal
		loadKeys()
	}
	func changeKeyboardToLetterKeys() {
		keyboardState = .letters
		loadKeys()
	}
	func changeKeyboardToSymbolKeys() {
		keyboardState = .symbols
		loadKeys()
	}
	func handlDeleteButtonPressed() {
        if previewState != true {
            proxy.deleteBackward()
        } else if !(previewState == true && allPrompts.contains((deGrammarPreviewLabel?.text!)!)) {
        guard
            let text = deGrammarPreviewLabel?.text,
            !text.isEmpty
        else {
            return
        }
            deGrammarPreviewLabel?.text = deGrammarPreviewLabel.text!.deletePriorToCursor()
        }
        else {
            backspaceTimer?.invalidate()
            backspaceTimer = nil
        }
	}
    
    @IBAction func grammarQueryPreview(commandLength: Int) {
        for _ in 0...commandLength - 1{
            proxy.deleteBackward()
        }
        previewState = true
    }
    
    func pluralPreview() {
        if proxy.documentContextBeforeInput?.suffix("/pl".count) == "/pl"{
            if shiftButtonState == .normal {
                            shiftButtonState = .shift
                            loadKeys()
                        }
            deGrammarPreviewLabel?.text = pluralPrompt
            deGrammarPreviewLabel?.textAlignment = NSTextAlignment.left
            let commandLength = 3
            grammarQueryPreview(commandLength: commandLength)
        }
    }
    
    func firstPersonSingularPreview() {
        if proxy.documentContextBeforeInput?.suffix("/fps".count) == "/fps"{
            deGrammarPreviewLabel?.text = firstPersonSingularPrompt
            deGrammarPreviewLabel?.textAlignment = NSTextAlignment.left
            let commandLength = 4
            grammarQueryPreview(commandLength: commandLength)
        }
    }
    
    func queryPlural() {
        if deGrammarPreviewLabel?.text == "     /pl: Buch" + previewCursor{
            proxy.insertText("Bücher ")
        } else if ((deGrammarPreviewLabel?.text?.prefix(pluralPrompt.count))! == pluralPrompt) && (deGrammarPreviewLabel?.text!.count ?? pluralPrompt.count > pluralPrompt.count) {
            invalidState = true
        }
    }
    func queryFirstPersonSingular() {
        if deGrammarPreviewLabel?.text == "     /fps: gehen" + previewCursor{
            proxy.insertText("gehe ")
        } else if ((deGrammarPreviewLabel?.text?.prefix(firstPersonSingularPrompt.count))! == firstPersonSingularPrompt) && (deGrammarPreviewLabel?.text!.count ?? firstPersonSingularPrompt.count > firstPersonSingularPrompt.count) {
            invalidState = true
        }
    }
    
    func selectedNounGenderColoration() {
        if proxy.selectedText == "Buch" {
            deGrammarPreviewLabel?.textColor = Constants.previewGreenLightTheme
            deGrammarPreviewLabel?.text = "Buch"
            deGrammarPreviewLabel?.textAlignment = NSTextAlignment.center
            deGrammarPreviewLabel?.sizeToFit()
        }
    }
    
    func typedNounGenderColoration() {
        if proxy.documentContextBeforeInput?.suffix("Buch ".count) == "Buch "{
            deGrammarPreviewLabel?.textColor = Constants.previewGreenLightTheme
            deGrammarPreviewLabel?.text = "(N) Buch"
            deGrammarPreviewLabel?.textAlignment = NSTextAlignment.center
            deGrammarPreviewLabel?.sizeToFit()
        }
        if proxy.documentContextBeforeInput?.suffix("Bücher ".count) == "Bücher "{
            deGrammarPreviewLabel?.textColor = Constants.previewOrangeLightTheme
            deGrammarPreviewLabel?.text = "(PL) Bücher"
            deGrammarPreviewLabel?.textAlignment = NSTextAlignment.center
            deGrammarPreviewLabel?.sizeToFit()
        }
        if proxy.documentContextBeforeInput?.suffix("Frau ".count) == "Frau "{
            deGrammarPreviewLabel?.textColor = Constants.previewRedLightTheme
            deGrammarPreviewLabel?.text = "(F) Frau"
            deGrammarPreviewLabel?.textAlignment = NSTextAlignment.center
            deGrammarPreviewLabel?.sizeToFit()
        }
        if proxy.documentContextBeforeInput?.suffix("Tisch ".count) == "Tisch "{
            deGrammarPreviewLabel?.textColor = Constants.previewBlueLightTheme
            deGrammarPreviewLabel?.text = "(M) Tisch"
            deGrammarPreviewLabel?.textAlignment = NSTextAlignment.center
            deGrammarPreviewLabel?.sizeToFit()
        }
    }
    func clearPreviewLabel() {
        if previewState != true {
            deGrammarPreviewLabel?.textColor = UIColor.black
            deGrammarPreviewLabel?.text = " "
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
            // Prevent the preview state prompt from being deleted.
            if previewState == true && allPrompts.contains((deGrammarPreviewLabel?.text!)!) {
                return
            }
			handlDeleteButtonPressed()
            if proxy.documentContextBeforeInput == nil && previewState != true{
                if keyboardState == .letters && shiftButtonState == .normal {
                    shiftButtonState = .shift
                    loadKeys()
                }
            }
            clearPreviewLabel()
		case "Leerzeichen":
            if previewState != true {
                proxy.insertText(" ")
            } else {
                deGrammarPreviewLabel?.text! = (deGrammarPreviewLabel?.text!.insertPriorToCursor(char: " "))!
            }
            typedNounGenderColoration()
            if proxy.documentContextBeforeInput?.suffix("  ".count) == "  " {
                clearPreviewLabel()
            }
		case "🌐":
			break
		case "↵":
            queryPlural()
            queryFirstPersonSingular()
            if previewState == false {
                proxy.insertText("\n")
                clearPreviewLabel()
            } else if invalidState == true {
                previewState = false
                deGrammarPreviewLabel?.text = "Not in directory"
                deGrammarPreviewLabel?.textColor = .black
                deGrammarPreviewLabel?.textAlignment = NSTextAlignment.center
            }
            else {
                previewState = false
                clearPreviewLabel()
                typedNounGenderColoration()
                // Auto-capitalization if at the start of the proxy.
                proxy.insertText(" ")
                if proxy.documentContextBeforeInput == " " {
                    if shiftButtonState == .normal {
                                    shiftButtonState = .shift
                                    loadKeys()
                                }
                }
                proxy.deleteBackward()
            }
		case "123":
			changeKeyboardToNumberKeys()
            clearPreviewLabel()
		case "ABC":
			changeKeyboardToLetterKeys()
            clearPreviewLabel()
        case "'":
            if previewState != true {
                proxy.insertText("'")
            } else {
                deGrammarPreviewLabel?.text! = (deGrammarPreviewLabel?.text!.insertPriorToCursor(char: "'"))!
            }
            changeKeyboardToLetterKeys()
            clearPreviewLabel()
        case "/":
            if previewState != true {
                proxy.insertText("/")
            } else {
                deGrammarPreviewLabel?.text! = (deGrammarPreviewLabel?.text!.insertPriorToCursor(char: "/"))!
            }
            changeKeyboardToLetterKeys()
            clearPreviewLabel()
		case "#+=":
			changeKeyboardToSymbolKeys()
            clearPreviewLabel()
		case "⇧":
			shiftButtonState = shiftButtonState == .normal ? .shift : .normal
			loadKeys()
            clearPreviewLabel()
		default:
			if shiftButtonState == .shift {
				shiftButtonState = .normal
				loadKeys()
			}
            if previewState == false {
                proxy.insertText(keyToDisplay)
                pluralPreview()
                firstPersonSingularPreview()
                clearPreviewLabel()
            } else {
                deGrammarPreviewLabel?.text = deGrammarPreviewLabel?.text!.insertPriorToCursor(char: keyToDisplay)
            }
		}
	}

	@objc func keyMultiPress(_ sender: UIButton, event: UIEvent) {
		guard let originalKey = sender.layer.value(forKey: "original") as? String else {return}

		let touch: UITouch = event.allTouches!.first!
		if (touch.tapCount == 2 && originalKey == "⇧") {
			shiftButtonState = .caps
			loadKeys()
            clearPreviewLabel()
		}
        // Double space period shortcut.
        if (touch.tapCount == 2 && originalKey == "Leerzeichen" && keyboardState == .letters && proxy.documentContextBeforeInput?.count != 1) {
            if proxy.documentContextBeforeInput?.suffix(2) != "  " && previewState != true {
                proxy.deleteBackward()
                proxy.insertText(". ")
                shiftButtonState = .shift
                loadKeys()
            } else if proxy.documentContextBeforeInput?.suffix(2) != "  " && previewState == true {
                deGrammarPreviewLabel?.text! = (deGrammarPreviewLabel?.text!.deletePriorToCursor())!
                deGrammarPreviewLabel?.text! = (deGrammarPreviewLabel?.text!.insertPriorToCursor(char: ". "))!
                shiftButtonState = .shift
                loadKeys()
            }
            clearPreviewLabel()
        }
	}

	@objc func keyLongPressed(_ gesture: UIGestureRecognizer) {
        // Prevent the preview state prompt from being deleted.
        if previewState == true && allPrompts.contains((deGrammarPreviewLabel?.text!)!) {
            gesture.state = .cancelled
        }
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

	@objc func keyUntouched(_ sender: UIButton) {
		guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
		sender.backgroundColor = isSpecial ? Constants.specialKeyColor : Constants.keyColor
	}

	@objc func keyTouchDown(_ sender: UIButton) {
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
