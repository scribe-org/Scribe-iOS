//
//  KeyboardViewController.swift
//

import Foundation
import UIKit

var proxy : UITextDocumentProxy!
// A larger vertical bar than the normal key for the cursor.
let previewCursor = "│"
let previewPromptSpacing = String(repeating: " ", count: 2)

let conjugatePrompt: String = previewPromptSpacing + "Conjugate: "
let conjugatePromptAndCursor: String = conjugatePrompt + previewCursor
var getConjugation = false

let translatePrompt: String = previewPromptSpacing + "Translate: "
let translatePromptAndCursor: String = translatePrompt + previewCursor
var getTranslation = false

let pluralPrompt: String = previewPromptSpacing + "Plural: "
let pluralPromptAndCursor: String = pluralPrompt + previewCursor
var getPlural = false
var isAlreadyPluralState = false

let allPrompts : [String] = [pluralPromptAndCursor, conjugatePromptAndCursor]

extension String {
    func index(from: Int) -> Index {
            return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
            let fromIndex = index(from: from)
            return String(self[fromIndex...])
        }

    func substring(to: Int) -> String {
            let toIndex = index(from: to)
            return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
            let startIndex = index(from: r.lowerBound)
            let endIndex = index(from: r.upperBound)
            return String(self[startIndex..<endIndex])
        }

    func insertPriorToCursor(char: String) -> String {
        return substring(to: self.count - 1) + char + previewCursor
    }

    func deletePriorToCursor() -> String {
        return substring(to: self.count - 2) + previewCursor
    }
}

extension Array {
  func penultimate() -> Element? {
      if self.count < 2 {
          return nil
      }
      let index = self.count - 2
      return self[index]
  }
}

func loadJsonToDict(filename fileName: String) -> Dictionary<String, AnyObject>? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let jsonData = try JSONSerialization.jsonObject(with: data)
            return jsonData as? Dictionary<String, AnyObject>
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}

let germanNouns = loadJsonToDict(filename: "nouns")
let germanVerbs = loadJsonToDict(filename: "verbs")

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
	var shiftButtonState: ShiftButtonState = .normal
    var previewState: Bool! = false
    var invalidState: Bool! = false
    var scribeBtnState: Bool! = false
    var conjugationState: Bool! = false
    
    func activateBtn (btn: UIButton) {
        btn.addTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
        btn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
        btn.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
    }
    
    func deactivateBtn (btn: UIButton) {
        btn.removeTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
        btn.removeTarget(self, action: #selector(keyTouchDown), for: .touchDown)
        btn.removeTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
    }

    @IBOutlet var scribeBtn: UIButton!
    func setScribeBtn() {
        scribeBtn?.backgroundColor = UIColor.scribeBlue
        scribeBtn.layer.setValue("Scribe", forKey: "original")
        scribeBtn.layer.setValue("Scribe", forKey: "keyToDisplay")
        scribeBtn.layer.setValue(false, forKey: "isSpecial")
        activateBtn(btn: scribeBtn)
    }
    @IBOutlet var deGrammarPreviewLabel: UILabel!
    func setPreviewLabel() {
        deGrammarPreviewLabel?.backgroundColor = UIColor.defaultSpecialKeyGrey
        deGrammarPreviewLabel?.textAlignment = NSTextAlignment.left
    }
    @IBOutlet var conjugateBtn: UIButton!
    @IBOutlet var pluralBtn: UIButton!
    func setGrammarBtns() {
        conjugateBtn?.backgroundColor = UIColor.scribeBlue
        conjugateBtn.layer.setValue("Conjugate", forKey: "original")
        conjugateBtn.layer.setValue("Conjugate", forKey: "keyToDisplay")
        conjugateBtn.layer.setValue(false, forKey: "isSpecial")
        activateBtn(btn: conjugateBtn)
        
        pluralBtn?.backgroundColor = UIColor.scribeBlue
        pluralBtn.layer.setValue("Plural", forKey: "original")
        pluralBtn.layer.setValue("Plural", forKey: "keyToDisplay")
        pluralBtn.layer.setValue(false, forKey: "isSpecial")
        activateBtn(btn: pluralBtn)
    }
    
    @IBOutlet var conjugateLabel: UILabel!
    
    @IBOutlet var conjugateBtnFPS: UIButton!
    @IBOutlet var conjugateBtnSPS: UIButton!
    @IBOutlet var conjugateBtnTPS: UIButton!
    @IBOutlet var conjugateBtnFPP: UIButton!
    @IBOutlet var conjugateBtnSPP: UIButton!
    @IBOutlet var conjugateBtnTPP: UIButton!
    
    @IBOutlet var conjugateShiftLeftBtn: UIButton!
    @IBOutlet var conjugateShiftRightBtn: UIButton!
    
    func setConjugationDisplay() {
        conjugateLabel?.backgroundColor = UIColor.clear
        conjugateBtnFPS?.backgroundColor = UIColor.clear
        conjugateBtnSPS?.backgroundColor = UIColor.clear
        conjugateBtnTPS?.backgroundColor = UIColor.clear
        conjugateBtnFPP?.backgroundColor = UIColor.clear
        conjugateBtnSPP?.backgroundColor = UIColor.clear
        conjugateBtnTPP?.backgroundColor = UIColor.clear
        conjugateShiftLeftBtn?.backgroundColor = UIColor.clear
        conjugateShiftRightBtn?.backgroundColor = UIColor.clear
        
        deactivateBtn(btn: conjugateBtnFPS)
        deactivateBtn(btn: conjugateBtnSPS)
        deactivateBtn(btn: conjugateBtnTPS)
        deactivateBtn(btn: conjugateBtnFPP)
        deactivateBtn(btn: conjugateBtnSPP)
        deactivateBtn(btn: conjugateBtnTPP)
        deactivateBtn(btn: conjugateShiftLeftBtn)
        deactivateBtn(btn: conjugateShiftRightBtn)
    }
    
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
        setScribeBtn()
        setPreviewLabel()
        setGrammarBtns()
        setConjugationDisplay()
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
				let btn = UIButton(type: .custom)
                btn.backgroundColor = Constants.keyColor
                btn.setTitleColor(.black, for: .normal)
                
				let key = keyboard[row][col]
				let capsKey = keyboard[row][col].capitalized
				let keyToDisplay = shiftButtonState == .normal ? key : capsKey
                btn.layer.setValue(key, forKey: "original")
                btn.layer.setValue(keyToDisplay, forKey: "keyToDisplay")
                btn.layer.setValue(false, forKey: "isSpecial")

                btn.setTitle(keyToDisplay, for: .normal) // set button character
                if key == "#+=" || key == "ABC" || key == "123" {
                    btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.75)
                } else if key == "Leerzeichen" {
                    btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 2)
                } else {
                    btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.5)
                }

                btn.layer.borderColor = keyboardView.backgroundColor?.cgColor
                btn.layer.borderWidth = 3
                btn.layer.cornerRadius = buttonWidth / 4
                btn.addTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
                btn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
                btn.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
                btn.addTarget(self, action: #selector(keyMultiPress(_:event:)), for: .touchDownRepeat)

                scribeBtn?.clipsToBounds = true
                scribeBtn?.layer.cornerRadius = buttonWidth / 4
                scribeBtn?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
//                scribeBtn?.frame.size = CGSize(width: numSymButtonWidth * 2, height: numSymButtonWidth)
                scribeBtn?.setTitle("Scribe", for: .normal)
                scribeBtn?.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
                scribeBtn?.setTitleColor(.black, for: .normal)
                
                if scribeBtnState {
                    scribeBtn?.setTitle("Esc", for: .normal)
                    scribeBtn?.backgroundColor = UIColor.defaultSpecialKeyGrey
                    scribeBtn?.layer.cornerRadius = buttonWidth / 4
                    scribeBtn?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                    
                    deGrammarPreviewLabel?.backgroundColor = UIColor.clear
                    deGrammarPreviewLabel?.text = ""
                    
                    conjugateBtn?.layer.cornerRadius = buttonWidth / 4
                    conjugateBtn?.layer.masksToBounds = true
//                    conjugateBtn?.frame.size = CGSize(width: numSymButtonWidth * 2, height: numSymButtonWidth)
                    conjugateBtn?.setTitle("Conjugate", for: .normal)
                    conjugateBtn?.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
                    conjugateBtn?.setTitleColor(.black, for: .normal)
                    
                    pluralBtn?.layer.cornerRadius = buttonWidth / 4
                    pluralBtn?.layer.masksToBounds = true
//                    pluralBtn?.frame.size = CGSize(width: numSymButtonWidth * 2, height: numSymButtonWidth)
                    pluralBtn?.setTitle("Plural", for: .normal)
                    pluralBtn?.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
                    pluralBtn?.setTitleColor(.black, for: .normal)
                } else {
                    conjugateBtn?.setTitle("", for: .normal)
                    conjugateBtn?.backgroundColor = UIColor.clear
                    deactivateBtn(btn: conjugateBtn)
                    
                    pluralBtn?.setTitle("", for: .normal)
                    pluralBtn?.backgroundColor = UIColor.clear
                    deactivateBtn(btn: pluralBtn)
                    
                    deGrammarPreviewLabel?.clipsToBounds = true
                    deGrammarPreviewLabel?.layer.cornerRadius = buttonWidth / 4
                    deGrammarPreviewLabel?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                    deGrammarPreviewLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.75)
                    deGrammarPreviewLabel?.textColor = .black
                    deGrammarPreviewLabel?.numberOfLines = 0
                    deGrammarPreviewLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                    if previewState == false {
                        deGrammarPreviewLabel?.text = ""
                    }
                    deGrammarPreviewLabel?.sizeToFit()
                }

                // Pad before key is added.
                if key == "y" {
                    addPadding(to: deStackView3, width: buttonWidth/3, key: "y")
                }

				if key == "⌫" {
					let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(keyLongPressed(_:)))
                    btn.addGestureRecognizer(longPressRecognizer)
				}

				keys.append(btn)
				switch row{
				case 0: deStackView1.addArrangedSubview(btn)
				case 1: deStackView2.addArrangedSubview(btn)
				case 2: deStackView3.addArrangedSubview(btn)
				case 3: deStackView4.addArrangedSubview(btn)
				default:
					break
				}

				if key == "🌐" {
					nextKeyboardButton = btn
				}

                // Pad after key is added.
                if key == "m" {
                    addPadding(to: deStackView3, width: buttonWidth/3, key: "m")
                }

				// specialKey constraints.
				if key == "⌫" || key == "#+=" || key == "⇧" || key == "🌐" {
                    btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.5).isActive = true
                    btn.layer.setValue(true, forKey: "isSpecial")
                    btn.backgroundColor = UIColor.defaultSpecialKeyGrey
					if key == "⇧" {
						if shiftButtonState != .normal{
                            btn.backgroundColor = Constants.keyPressedColor
						}
						if shiftButtonState == .caps{
                            btn.setTitle("⇪", for: .normal)
						}
					}
                }else if key == "123" || key == "ABC" || key == "↵" {
                    btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 2).isActive = true
                    btn.layer.setValue(true, forKey: "isSpecial")
                    btn.backgroundColor = UIColor.defaultSpecialKeyGrey
                }else if (keyboardState == .numbers || keyboardState == .symbols) && row == 2 {
                    btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.4).isActive = true
				}else if key != "Leerzeichen" {
                    btn.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
				}else{
                    btn.layer.setValue(key, forKey: "original")
                    btn.setTitle(key, for: .normal)
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

    func queryPlural() {
        let noun = deGrammarPreviewLabel?.text!.substring(with: pluralPrompt.count..<((deGrammarPreviewLabel?.text!.count)!-1))
        let nounInDirectory = germanNouns?[noun!] != nil
        if nounInDirectory {
            if germanNouns?[noun!]?["plural"] as! String != "isPlural" {
                proxy.insertText(germanNouns?[noun!]?["plural"] as! String + " ")
            } else {
                proxy.insertText(noun! + " ")
                deGrammarPreviewLabel?.text = previewPromptSpacing + "Already plural"
                invalidState = true
                isAlreadyPluralState = true
            }
        // Cancel via a return press.
        } else if deGrammarPreviewLabel?.text! == pluralPromptAndCursor {
            return
        } else {
            invalidState = true
        }
    }
    
    func queryConjugation() {
        let verb = deGrammarPreviewLabel?.text!.substring(with: conjugatePrompt.count..<((deGrammarPreviewLabel?.text!.count)!-1))
        let verbInDirectory = germanVerbs?[verb!] != nil
        if verbInDirectory {
            proxy.insertText(germanVerbs?[verb!]?["indicativePresentFPS"] as! String + " ")
        // Cancel via a return press.
        } else if deGrammarPreviewLabel?.text! == conjugatePromptAndCursor {
            return
        }else {
            invalidState = true
        }
    }

    func selectedNounGenderAnnotation() {
        let selectedWord = proxy.selectedText
        let isNoun = germanNouns?[selectedWord!] != nil
        if isNoun {
            let nounGender = germanNouns?[selectedWord!]?["gender"] as! String
            if nounGender == "F" {
                deGrammarPreviewLabel?.textColor = UIColor.previewRedLightTheme
            } else if nounGender == "M" {
                deGrammarPreviewLabel?.textColor = UIColor.previewBlueLightTheme
            } else if nounGender ==  "N" {
                deGrammarPreviewLabel?.textColor = UIColor.previewGreenLightTheme
            } else if nounGender ==  "PL"{
                deGrammarPreviewLabel?.textColor = UIColor.previewOrangeLightTheme
            }

            deGrammarPreviewLabel?.text = previewPromptSpacing + "(\(nounGender)) " + selectedWord!
            deGrammarPreviewLabel?.sizeToFit()
        }
    }

    func typedNounGenderAnnotation() {
        if proxy.documentContextBeforeInput != nil {
            let wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
            let lastWordTyped = wordsTyped.penultimate()
            let isNoun = germanNouns?[lastWordTyped!] != nil
            if isNoun {
                let nounGender = germanNouns?[lastWordTyped!]?["gender"] as! String
                if nounGender == "F" {
                    deGrammarPreviewLabel?.textColor = UIColor.previewRedLightTheme
                } else if nounGender == "M" {
                    deGrammarPreviewLabel?.textColor = UIColor.previewBlueLightTheme
                } else if nounGender ==  "N" {
                    deGrammarPreviewLabel?.textColor = UIColor.previewGreenLightTheme
                } else if nounGender ==  "PL"{
                    deGrammarPreviewLabel?.textColor = UIColor.previewOrangeLightTheme
                }

                deGrammarPreviewLabel?.text = previewPromptSpacing + "(\(nounGender)) " + lastWordTyped!
                deGrammarPreviewLabel?.sizeToFit()
            }
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
		sender.backgroundColor = isSpecial ? UIColor.defaultSpecialKeyGrey : Constants.keyColor

		switch originalKey {
        case "Scribe":
            if (proxy.selectedText != nil) {
                loadKeys()
                selectedNounGenderAnnotation()
            } else {
                if scribeBtnState == false {
                    scribeBtnState = true
                    activateBtn(btn: conjugateBtn)
                    activateBtn(btn: pluralBtn)
                } else {
                    scribeBtnState = false
                }
                loadKeys()
            }
            
        case "Conjugate":
            scribeBtnState = false
            if shiftButtonState == .shift {
                            shiftButtonState = .normal
                        }
            loadKeys()
            deGrammarPreviewLabel?.text = conjugatePromptAndCursor
            previewState = true
            getConjugation = true
            
        case "Plural":
            scribeBtnState = false
            if shiftButtonState == .normal {
                            shiftButtonState = .shift
                            loadKeys()
                        }
            loadKeys()
            deGrammarPreviewLabel?.text = pluralPromptAndCursor
            previewState = true
            getPlural = true
            
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
            typedNounGenderAnnotation()
            if proxy.documentContextBeforeInput?.suffix("  ".count) == "  " {
                clearPreviewLabel()
            }
		case "🌐":
			break
		case "↵":
            if getPlural {
                queryPlural()
                getPlural = false
            }
            if getConjugation {
                queryConjugation()
                getConjugation = false
            }
            if previewState == false {
                proxy.insertText("\n")
                clearPreviewLabel()
            } else if invalidState == true {
                previewState = false
                // Auto-capitalization if at the start of the proxy.
                proxy.insertText(" ")
                if proxy.documentContextBeforeInput == " " {
                    if shiftButtonState == .normal {
                                    shiftButtonState = .shift
                                    loadKeys()
                                }
                }
                proxy.deleteBackward()
                if isAlreadyPluralState != true {
                    deGrammarPreviewLabel?.text = previewPromptSpacing + "Not in directory"
                }
                deGrammarPreviewLabel?.textColor = .black
                
                invalidState = false
                isAlreadyPluralState = false
            }
            else {
                previewState = false
                clearPreviewLabel()
                typedNounGenderAnnotation()
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
            proxy.insertText(" ")
            if proxy.documentContextBeforeInput == " " {
                if shiftButtonState == .normal {
                                shiftButtonState = .shift
                                loadKeys()
                            }
            }
            proxy.deleteBackward()
        case "'":
            if previewState != true {
                proxy.insertText("'")
            } else {
                deGrammarPreviewLabel?.text! = (deGrammarPreviewLabel?.text!.insertPriorToCursor(char: "'"))!
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
            (gesture.view as! UIButton).backgroundColor = UIColor.defaultSpecialKeyGrey
        }
	}

	@objc func keyUntouched(_ sender: UIButton) {
		guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
		sender.backgroundColor = isSpecial ? UIColor.defaultSpecialKeyGrey : Constants.keyColor
	}

	@objc func keyTouchDown(_ sender: UIButton) {
		sender.backgroundColor = Constants.keyPressedColor
	}
    
//    @objc func screenTouch(_ sender: UIView) {}

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
