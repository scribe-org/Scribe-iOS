//
//  KeyboardViewController.swift
//

import Foundation
import UIKit

var proxy: UITextDocumentProxy!
var keyColor = UIColor.systemGray6
var specialKeyColor = UIColor.systemGray2
var keyPressedColor = UIColor.systemGray5

var keyboardHeight: CGFloat!
var btnKeyCornerRadius: CGFloat!
var isLandscapeView:Bool = false

var letterKeys = [[String]]()
var numberKeys = [[String]]()
var symbolKeys = [[String]]()

// Variables for alternate key views.
let keysWithAlternates = ["a", "e", "s", "y", "c", "u", "i", "o", "n"]
let keysWithAlternatesLeft = ["a", "e", "s", "y", "c"]
let KeysWithAlternatesRight = ["u", "i", "o", "n"]
var alternatesKeyView: UIView!

var buttonWidth = CGFloat(5) // place holder.

struct DeviceType
{
    static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
}

// A larger vertical bar than the normal key for the cursor.
let previewCursor: String = "│"
let previewPromptSpacing = String(repeating: " ", count: 2)

let translatePrompt: String = previewPromptSpacing + "Translate: "
let translatePromptAndCursor: String = translatePrompt + previewCursor
var getTranslation: Bool = false

let conjugatePrompt: String = previewPromptSpacing + "Conjugate: "
let conjugatePromptAndCursor: String = conjugatePrompt + previewCursor
var getConjugation: Bool = false
var conjugateView: Bool = false
var tenseFPS: String = ""
var tenseSPS: String = ""
var tenseTPS: String = ""
var tenseFPP: String = ""
var tenseSPP: String = ""
var tenseTPP: String = ""
var verbToConjugate: String = ""
var verbConjugated: String = ""

let pluralPrompt: String = previewPromptSpacing + "Plural: "
let pluralPromptAndCursor: String = pluralPrompt + previewCursor
var getPlural: Bool = false
var isAlreadyPluralState: Bool = false

let allPrompts: [String] = [translatePromptAndCursor, conjugatePromptAndCursor, pluralPromptAndCursor]

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

extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
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
let germanTranslations = loadJsonToDict(filename: "translations")

class KeyboardViewController: UIInputViewController, UITextFieldDelegate {

	@IBOutlet var selectKeyboardButton: UIButton!

	var keyboardView: UIView!
	var keys: [UIButton] = []
	var paddingViews: [UIButton] = []
	var backspaceTimer: Timer?

	enum KeyboardState{
		case letters
		case numbers
		case symbols
	}
    
    func setKeyboardStyles() {
        if DeviceType.isPhone {
            letterKeys = Constants.letterKeysPhone
            numberKeys = Constants.numberKeysPhone
            symbolKeys = Constants.symbolKeysPhone
        } else if DeviceType.isPad {
            letterKeys = Constants.letterKeysPad
            numberKeys = Constants.numberKeysPad
            symbolKeys = Constants.symbolKeysPad
        }
    }

	enum ShiftButtonState {
		case normal
		case shift
		case caps
	}

    enum ConjugationState{
        case indicativePresent
        case indicativePreterite
        case indicativePerfect
    }

    // Baseline state variables.
	var keyboardState: KeyboardState = .letters
	var shiftButtonState: ShiftButtonState = .normal
    var conjugationState: ConjugationState = .indicativePresent
    var previewState: Bool! = false
    var invalidState: Bool! = false
    var scribeBtnState: Bool! = false

    func activateBtn(btn: UIButton) {
        btn.addTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
        btn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
        btn.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
    }

    func deactivateBtn(btn: UIButton) {
        btn.setTitle("", for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.removeTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
        btn.removeTarget(self, action: #selector(keyTouchDown), for: .touchDown)
        btn.removeTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
    }

    func setBtn(btn: UIButton, color: UIColor, name: String, canCapitalize: Bool, isSpecial: Bool) {
        btn.backgroundColor = color
        btn.layer.setValue(name, forKey: "original")
        var capsKey = ""
        if canCapitalize == true {
            if name != "ß" {
                capsKey = name.capitalized
            } else {
                capsKey = name
            }
            let shiftChar = shiftButtonState == .normal ? name : capsKey
            btn.layer.setValue(shiftChar, forKey: "keyToDisplay")
        } else {
            btn.layer.setValue(name, forKey: "keyToDisplay")
        }
        btn.layer.setValue(isSpecial, forKey: "isSpecial")
        activateBtn(btn: btn)
    }

    func styleBtn(btn: UIButton, title: String, radius: CGFloat) {
        btn.clipsToBounds = true
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = radius
//        btn.frame.size = CGSize(width: X * 2, height: Y)  // would need a size arg
        btn.setTitle(title, for: .normal)
//        btn.titleLabel?.font.withSize(letterButtonWidth / 2) // would need a fontSize arg
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        btn.setTitleColor(UIColor.label, for: .normal)
    }

    @IBOutlet var scribeBtn: UIButton!
    func setScribeBtn() {
        scribeBtn.setImage(UIImage(named: "ScribeBtn.png"), for: .normal)
        setBtn(btn: scribeBtn, color: UIColor.scribeBlue, name: "Scribe", canCapitalize: false, isSpecial: false)
    }
    @IBOutlet var deGrammarPreviewLabel: UILabel!
    func setPreviewLabel() {
        deGrammarPreviewLabel?.backgroundColor = specialKeyColor
        deGrammarPreviewLabel?.textAlignment = NSTextAlignment.left
    }

    @IBOutlet var translateBtn: UIButton!
    @IBOutlet var conjugateBtn: UIButton!
    @IBOutlet var pluralBtn: UIButton!
    func setGrammarBtns() {
        setBtn(btn: translateBtn, color: UIColor.scribeBlue, name: "Translate", canCapitalize: false, isSpecial: false)
        setBtn(btn: conjugateBtn, color: UIColor.scribeBlue, name: "Conjugate", canCapitalize: false, isSpecial: false)
        setBtn(btn: pluralBtn, color: UIColor.scribeBlue, name: "Plural", canCapitalize: false, isSpecial: false)
    }

    @IBOutlet var conjugateBtnFPS: UIButton!
    @IBOutlet var conjugateBtnSPS: UIButton!
    @IBOutlet var conjugateBtnTPS: UIButton!
    @IBOutlet var conjugateBtnFPP: UIButton!
    @IBOutlet var conjugateBtnSPP: UIButton!
    @IBOutlet var conjugateBtnTPP: UIButton!

    @IBOutlet var conjugateShiftLeftBtn: UIButton!
    @IBOutlet var conjugateShiftRightBtn: UIButton!

    func setConjugationBtns() {
        setBtn(btn: conjugateBtnFPS, color: keyColor, name: "firstPersonSingular", canCapitalize: false, isSpecial: false)
        setBtn(btn: conjugateBtnSPS, color: keyColor, name: "secondPersonSingular", canCapitalize: false, isSpecial: false)
        setBtn(btn: conjugateBtnTPS, color: keyColor, name: "thirdPersonSingular", canCapitalize: false, isSpecial: false)
        setBtn(btn: conjugateBtnFPP, color: keyColor, name: "firstPersonPlural", canCapitalize: false, isSpecial: false)
        setBtn(btn: conjugateBtnSPP, color: keyColor, name: "secondPersonPlural", canCapitalize: false, isSpecial: false)
        setBtn(btn: conjugateBtnTPP, color: keyColor, name: "thirdPersonPlural", canCapitalize: false, isSpecial: false)

        setBtn(btn: conjugateShiftLeftBtn, color: keyColor, name: "shiftConjugateLeft", canCapitalize: false, isSpecial: false)
        setBtn(btn: conjugateShiftRightBtn, color: keyColor, name: "shiftConjugateRight", canCapitalize: false, isSpecial: false)
    }

    func daectivateConjugationDisplay() {
        deactivateBtn(btn: conjugateBtnFPS)
        deactivateBtn(btn: conjugateBtnSPS)
        deactivateBtn(btn: conjugateBtnTPS)
        deactivateBtn(btn: conjugateBtnFPP)
        deactivateBtn(btn: conjugateBtnSPP)
        deactivateBtn(btn: conjugateBtnTPP)

        deactivateBtn(btn: conjugateShiftLeftBtn)
        deactivateBtn(btn: conjugateShiftRightBtn)
    }

    func getConjugationTitle() -> String {
        switch conjugationState {
        case .indicativePresent:
            return previewPromptSpacing + "Indikativ Präsens: " + verbToConjugate
        case .indicativePreterite:
            return previewPromptSpacing + "Indikativ Präteritum: " + verbToConjugate
        case .indicativePerfect:
            return previewPromptSpacing + "Indikativ Perfect: " + verbToConjugate
        }
    }

    func getConjugationState() -> String{
        switch conjugationState {
        case .indicativePresent:
            return "indicativePresent"
        case .indicativePreterite:
            return "indicativePreterite"
        case .indicativePerfect:
            return "indicativePerfect"
        }
    }

    func setConjugationState() {
        deGrammarPreviewLabel?.text = getConjugationTitle()

        tenseFPS = getConjugationState() + "FPS"
        tenseSPS = getConjugationState() + "SPS"
        tenseTPS = getConjugationState() + "TPS"
        tenseFPP = getConjugationState() + "FPP"
        tenseSPP = getConjugationState() + "SPP"
        tenseTPP = getConjugationState() + "TPP"
        
        // Assign the invalid message if the conjugation isn't present in the directory.
        if germanVerbs?[verbToConjugate]![tenseFPS] as! String == "" {
            styleBtn(btn: conjugateBtnFPS, title: "Not in directory", radius: btnKeyCornerRadius)
        } else {
            styleBtn(btn: conjugateBtnFPS, title: germanVerbs?[verbToConjugate]![tenseFPS] as! String, radius: btnKeyCornerRadius)
        }
        
        if germanVerbs?[verbToConjugate]![tenseSPS] as! String == "" {
            styleBtn(btn: conjugateBtnSPS, title: "Not in directory", radius: btnKeyCornerRadius)
        } else {
            styleBtn(btn: conjugateBtnSPS, title: germanVerbs?[verbToConjugate]![tenseSPS] as! String, radius: btnKeyCornerRadius)
        }
        
        if germanVerbs?[verbToConjugate]![tenseTPS] as! String == "" {
            styleBtn(btn: conjugateBtnTPS, title: "Not in directory", radius: btnKeyCornerRadius)
        } else {
            styleBtn(btn: conjugateBtnTPS, title: germanVerbs?[verbToConjugate]![tenseTPS] as! String, radius: btnKeyCornerRadius)
        }
        
        if germanVerbs?[verbToConjugate]![tenseFPP] as! String == "" {
            styleBtn(btn: conjugateBtnFPP, title: "Not in directory", radius: btnKeyCornerRadius)
        } else {
            styleBtn(btn: conjugateBtnFPP, title: germanVerbs?[verbToConjugate]![tenseFPP] as! String, radius: btnKeyCornerRadius)
        }
        
        if germanVerbs?[verbToConjugate]![tenseSPP] as! String == "" {
            styleBtn(btn: conjugateBtnSPP, title: "Not in directory", radius: btnKeyCornerRadius)
        } else {
            styleBtn(btn: conjugateBtnSPP, title: germanVerbs?[verbToConjugate]![tenseSPP] as! String, radius: btnKeyCornerRadius)
        }
        
        if germanVerbs?[verbToConjugate]![tenseTPP] as! String == "" {
            styleBtn(btn: conjugateBtnTPP, title: "Not in directory", radius: btnKeyCornerRadius)
        } else {
            styleBtn(btn: conjugateBtnTPP, title: germanVerbs?[verbToConjugate]![tenseTPP] as! String, radius: btnKeyCornerRadius)
        }
    }

    func conjugationStateLeft() {
        if conjugationState == .indicativePresent {
            return
        } else if conjugationState == .indicativePreterite {
            conjugationState = .indicativePresent
            return
        } else if conjugationState == .indicativePerfect {
            conjugationState = .indicativePreterite
            return
        }
    }

    func conjugationStateRight() {
        if conjugationState == .indicativePresent {
            conjugationState = .indicativePreterite
        } else if conjugationState == .indicativePreterite {
            conjugationState = .indicativePerfect
            return
        } else if conjugationState == .indicativePerfect {
            return
        }
    }
    
    func checkLandscrapeMode() {
        if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
            isLandscapeView = true
        } else if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
            isLandscapeView = false
        }
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
		self.selectKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
    
    override func viewWillLayoutSubviews() {
        self.selectKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }

	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DeviceType.isPhone {
            if isLandscapeView == true {
                keyboardHeight = 180
            } else {
                keyboardHeight = 230
            }
        } else if DeviceType.isPad {
            if isLandscapeView == true {
                keyboardHeight = 320
            } else {
                keyboardHeight = 340
            }
        }
        
		let heightConstraint = NSLayoutConstraint(item: view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: keyboardHeight)
		view.addConstraint(heightConstraint)
	}
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        loadKeys()
    }

	func loadInterface() {
		let keyboardNib = UINib(nibName: "Keyboard", bundle: nil)
		keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as? UIView
        keyboardView.translatesAutoresizingMaskIntoConstraints = true
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
        checkLandscrapeMode()
        setKeyboardStyles()
        setScribeBtn()
        setPreviewLabel()
        setGrammarBtns()
        setConjugationBtns()
        invalidState = false

		keys.forEach{$0.removeFromSuperview()}
		paddingViews.forEach{$0.removeFromSuperview()}

        // buttonWidth determined per keyboard by the top row.
        var letterButtonWidth = CGFloat(0)
        var numSymButtonWidth = CGFloat(0)
        
        if isLandscapeView == true {
            if DeviceType.isPhone {
                letterButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(letterKeys[0].count) * 1.8
                numSymButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(numberKeys[0].count) * 1.8
            } else if DeviceType.isPad {
                letterButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(letterKeys[0].count) * 1.3
                numSymButtonWidth = (UIScreen.main.bounds.height - 5) / CGFloat(numberKeys[0].count) * 1.3
            }
        } else {
            letterButtonWidth = (UIScreen.main.bounds.width - 5) / CGFloat(letterKeys[0].count)
            numSymButtonWidth = (UIScreen.main.bounds.width - 5) / CGFloat(numberKeys[0].count)
        }

		var keyboard: [[String]]

		// Start padding.
		switch keyboardState {
		case .letters:
			keyboard = letterKeys
            buttonWidth = letterButtonWidth
            // Auto-capitalization.
            if proxy.documentContextBeforeInput?.count == 0 {
                shiftButtonState = .shift
            }
		case .numbers:
			keyboard = numberKeys
            buttonWidth = numSymButtonWidth
		case .symbols:
			keyboard = symbolKeys
            buttonWidth = numSymButtonWidth
		}
        
        if DeviceType.isPhone {
            if isLandscapeView == true {
                btnKeyCornerRadius = buttonWidth / 8
            } else {
                btnKeyCornerRadius = buttonWidth / 4
            }
        } else if DeviceType.isPad {
            if isLandscapeView == true {
                btnKeyCornerRadius = buttonWidth / 12
            } else {
                btnKeyCornerRadius = buttonWidth / 8
            }
        }

        if !conjugateView {
            deStackView1.isUserInteractionEnabled = true
            deStackView2.isUserInteractionEnabled = true
            deStackView3.isUserInteractionEnabled = true
            deStackView4.isUserInteractionEnabled = true

            daectivateConjugationDisplay()

            let numRows = keyboard.count
            for row in 0...numRows - 1{
                for col in 0...keyboard[row].count - 1{
                    let btn = UIButton(type: .custom)
                    btn.backgroundColor = keyColor
                    btn.setTitleColor(UIColor.label, for: .normal)

                    let key = keyboard[row][col]
                    var capsKey = ""
                    if key != "ß" {
                        capsKey = keyboard[row][col].capitalized
                    } else {
                        capsKey = key
                    }
                    let keyToDisplay = shiftButtonState == .normal ? key : capsKey
                    btn.layer.setValue(key, forKey: "original")
                    btn.layer.setValue(keyToDisplay, forKey: "keyToDisplay")
                    btn.layer.setValue(false, forKey: "isSpecial")
                    btn.setTitle(keyToDisplay, for: .normal) // set button character
                    
                    btn.layer.borderColor = keyboardView.backgroundColor?.cgColor
                    btn.layer.borderWidth = 3
                    if DeviceType.isPhone {
                        if isLandscapeView == true {
                            btn.layer.cornerRadius = btnKeyCornerRadius
                            if key == "#+=" || key == "ABC" || key == "123" {
                                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.5)
                            } else if key == "Leerzeichen" {
                                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 4)
                            } else {
                                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3)
                            }
                        } else {
                            btn.layer.cornerRadius = btnKeyCornerRadius
                            if key == "#+=" || key == "ABC" || key == "123" {
                                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.75)
                            } else if key == "Leerzeichen" {
                                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 2)
                            } else {
                                btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 1.5)
                            }
                        }
                    } else if DeviceType.isPad {
                        btn.layer.cornerRadius = btnKeyCornerRadius
                        if key == "#+=" || key == "ABC" || key == "hideKeyboard" {
                            btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.25)
                        } else if key == "Leerzeichen" {
                            btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3.5)
                        } else if key == ".?123" {
                            btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 4)
                        } else {
                            btn.titleLabel?.font = .systemFont(ofSize: letterButtonWidth / 3)
                        }
                    }

                    activateBtn(btn: btn)
                    btn.addTarget(self, action: #selector(keyMultiPress(_:event:)), for: .touchDownRepeat)

                    styleBtn(btn: scribeBtn, title: "Scribe", radius: btnKeyCornerRadius)
                    scribeBtn?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

                    if scribeBtnState {
                        scribeBtn.setImage(UIImage(named: "escBtn.png"), for: .normal)
                        scribeBtn?.setTitle("", for: .normal) // esc
                        scribeBtn?.backgroundColor = specialKeyColor
                        scribeBtn?.layer.cornerRadius = btnKeyCornerRadius
                        scribeBtn?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]

                        deGrammarPreviewLabel?.backgroundColor = UIColor.clear
                        deGrammarPreviewLabel?.text = ""

                        styleBtn(btn: translateBtn, title: "Translate", radius: btnKeyCornerRadius)
                        styleBtn(btn: conjugateBtn, title: "Conjugate", radius: btnKeyCornerRadius)
                        styleBtn(btn: pluralBtn, title: "Plural", radius: btnKeyCornerRadius)
                    } else {
                        scribeBtn?.setTitle("", for: .normal)
                        deactivateBtn(btn: conjugateBtn)
                        deactivateBtn(btn: translateBtn)
                        deactivateBtn(btn: pluralBtn)

                        deGrammarPreviewLabel?.clipsToBounds = true
                        deGrammarPreviewLabel?.layer.cornerRadius = btnKeyCornerRadius
                        deGrammarPreviewLabel?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                        if DeviceType.isPhone {
                            deGrammarPreviewLabel?.font = .systemFont(ofSize: letterButtonWidth / 2)
                        } else if DeviceType.isPad {
                            deGrammarPreviewLabel?.font = .systemFont(ofSize: letterButtonWidth / 4)
                        }
                        deGrammarPreviewLabel?.textColor = UIColor.label
                        deGrammarPreviewLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                        if previewState == false {
                            deGrammarPreviewLabel?.text = ""
                        }
                        deGrammarPreviewLabel?.sizeToFit()
                    }

                    // Pad before key is added.
                    if DeviceType.isPhone && key == "y" {
                        addPadding(to: deStackView3, width: buttonWidth / 3, key: "y")
                    }

                    if key == "delete" {
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

                    if key == "selectKeyboard" {
                        selectKeyboardButton = btn
                        btn.setTitle("", for: .normal)
                        var selectKeyboardIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .light, scale: .medium)
                        if DeviceType.isPad {
                            selectKeyboardIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .light, scale: .medium)
                        }
                        btn.setImage(UIImage(systemName: "globe", withConfiguration: selectKeyboardIconConfig), for: .normal)
                        if UITraitCollection.current.userInterfaceStyle == .dark {
                            btn.tintColor = .white
                        }
                        else {
                            btn.tintColor = .black
                        }
                    }
                    
                    if key == "hideKeyboard" {
                        btn.setTitle("", for: .normal)
                        let hideKeyboardIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .light, scale: .medium)
                        btn.setImage(UIImage(systemName: "keyboard.chevron.compact.down", withConfiguration: hideKeyboardIconConfig), for: .normal)
                        if UITraitCollection.current.userInterfaceStyle == .dark {
                            btn.tintColor = .white
                        }
                        else {
                            btn.tintColor = .black
                        }
                    }
                    
                    if key == "shift" {
                        btn.setTitle("", for: .normal)
                        var shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .regular, scale: .medium)
                        if DeviceType.isPad {
                            shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .regular, scale: .medium)
                        }
                        btn.setImage(UIImage(systemName: "shift", withConfiguration: shiftIconConfig), for: .normal)
                        if UITraitCollection.current.userInterfaceStyle == .dark {
                            btn.tintColor = .white
                        }
                        else {
                            btn.tintColor = .black
                        }
                    }
                    
                    if key == "return" {
                        btn.setTitle("", for: .normal)
                        var returnIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .regular, scale: .medium)
                        if DeviceType.isPad {
                            returnIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .regular, scale: .medium)
                        }
                        btn.setImage(UIImage(systemName: "return", withConfiguration: returnIconConfig), for: .normal)
                        if UITraitCollection.current.userInterfaceStyle == .dark {
                            btn.tintColor = .white
                        }
                        else {
                            btn.tintColor = .black
                        }
                    }
                    
                    if key == "delete" {
                        btn.setTitle("", for: .normal)
                        var deleteIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .regular, scale: .medium)
                        if DeviceType.isPad {
                            deleteIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .regular, scale: .medium)
                        }
                        btn.setImage(UIImage(systemName: "delete.left", withConfiguration: deleteIconConfig), for: .normal)
                        if UITraitCollection.current.userInterfaceStyle == .dark {
                            btn.tintColor = .white
                        }
                        else {
                            btn.tintColor = .black
                        }
                    }
                    
                    if key == "a" {
                        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(aLongPressedSelectAlternates(sender:)))
                        longGesture.minimumPressDuration = 1.2
                        btn.addGestureRecognizer(longGesture)
                    }
                    
                    if key == "e" {
                        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(eLongPressedSelectAlternates(sender:)))
                        longGesture.minimumPressDuration = 1.2
                        btn.addGestureRecognizer(longGesture)
                    }
                    
                    if key == "i" {
                        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(iLongPressedSelectAlternates(sender:)))
                        longGesture.minimumPressDuration = 1.2
                        btn.addGestureRecognizer(longGesture)
                    }
                    
                    if key == "o" {
                        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(oLongPressedSelectAlternates(sender:)))
                        longGesture.minimumPressDuration = 1.2
                        btn.addGestureRecognizer(longGesture)
                    }
                    
                    if key == "u" {
                        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(uLongPressedSelectAlternates(sender:)))
                        longGesture.minimumPressDuration = 1.2
                        btn.addGestureRecognizer(longGesture)
                    }
                    
                    if key == "y" {
                        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(yLongPressedSelectAlternates(sender:)))
                        longGesture.minimumPressDuration = 1.2
                        btn.addGestureRecognizer(longGesture)
                    }
                    
                    if key == "s" {
                        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(sLongPressedSelectAlternates(sender:)))
                        longGesture.minimumPressDuration = 1.2
                        btn.addGestureRecognizer(longGesture)
                    }
                    
                    if key == "c" {
                        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(cLongPressedSelectAlternates(sender:)))
                        longGesture.minimumPressDuration = 1.2
                        btn.addGestureRecognizer(longGesture)
                    }
                    
                    if key == "n" {
                        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(nLongPressedSelectAlternates(sender:)))
                        longGesture.minimumPressDuration = 1.2
                        btn.addGestureRecognizer(longGesture)
                    }

                    // Pad after key is added.
                    if DeviceType.isPhone && key == "m" {
                        addPadding(to: deStackView3, width: buttonWidth / 3, key: "m")
                    }

                    // specialKey constraints.
                    if key == "ABC" {
                        if DeviceType.isPhone {
                            btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 2).isActive = true
                        } else {
                            btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1).isActive = true
                        }
                        btn.layer.setValue(true, forKey: "isSpecial")
                        btn.backgroundColor = specialKeyColor
                    } else if key == "delete" || key == "#+=" || key == "shift" || key == "undoArrow" || key == "selectKeyboard" {
                        if DeviceType.isPhone {
                            btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.5).isActive = true
                        } else {
                            btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1).isActive = true
                        }
                        btn.layer.setValue(true, forKey: "isSpecial")
                        btn.backgroundColor = specialKeyColor
                        if key == "shift" {
                            if shiftButtonState != .normal {
                                btn.backgroundColor = keyPressedColor
                                var shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .regular, scale: .medium)
                                if DeviceType.isPad {
                                    shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .regular, scale: .medium)
                                }
                                btn.setImage(UIImage(systemName: "shift.fill", withConfiguration: shiftIconConfig), for: .normal)
                                if UITraitCollection.current.userInterfaceStyle == .dark {
                                    btn.tintColor = .white
                                }
                                else {
                                    btn.tintColor = .black
                                }
                            }
                            if shiftButtonState == .caps {
                                var shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 1.75, weight: .regular, scale: .medium)
                                if DeviceType.isPad {
                                    shiftIconConfig = UIImage.SymbolConfiguration(pointSize: letterButtonWidth / 3, weight: .regular, scale: .medium)
                                }
                                btn.setImage(UIImage(systemName: "capslock.fill", withConfiguration: shiftIconConfig), for: .normal)
                                if UITraitCollection.current.userInterfaceStyle == .dark {
                                    btn.tintColor = .white
                                }
                                else {
                                    btn.tintColor = .black
                                }
                            }
                        }
                    } else if key == "123" || key == ".?123" || key == "return" || key == "hideKeyboard" {
                        if DeviceType.isPhone {
                            btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 2).isActive = true
                        } else {
                            btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1).isActive = true
                        }
                        btn.layer.setValue(true, forKey: "isSpecial")
                        btn.backgroundColor = specialKeyColor
                    // Only change widths for number and symbol keys for iPhones.
                    } else if (keyboardState == .numbers || keyboardState == .symbols) && row == 2 && DeviceType.isPhone {
                        btn.widthAnchor.constraint(equalToConstant: numSymButtonWidth * 1.4).isActive = true
                    } else if key != "Leerzeichen" {
                        btn.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                    } else {
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
        } else {
            deStackView1.isUserInteractionEnabled = false
            deStackView2.isUserInteractionEnabled = false
            deStackView3.isUserInteractionEnabled = false
            deStackView4.isUserInteractionEnabled = false

            scribeBtn?.setTitle("esc", for: .normal)
            scribeBtn?.backgroundColor = specialKeyColor
            scribeBtn?.layer.cornerRadius = buttonWidth / 4
            scribeBtn?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

            deGrammarPreviewLabel?.backgroundColor = UIColor.scribeBlue

            deactivateBtn(btn: conjugateBtn)
            deactivateBtn(btn: translateBtn)
            deactivateBtn(btn: pluralBtn)

            activateBtn(btn: conjugateBtnFPS)
            activateBtn(btn: conjugateBtnSPS)
            activateBtn(btn: conjugateBtnTPS)
            activateBtn(btn: conjugateBtnFPP)
            activateBtn(btn: conjugateBtnSPP)
            activateBtn(btn: conjugateBtnTPP)

            activateBtn(btn: conjugateShiftLeftBtn)
            activateBtn(btn: conjugateShiftRightBtn)

            setConjugationState()

            styleBtn(btn: conjugateShiftLeftBtn, title: "⟨", radius: btnKeyCornerRadius)
//            conjugateShiftLeftBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            styleBtn(btn: conjugateShiftRightBtn, title: "⟩", radius: btnKeyCornerRadius)
//            conjugateShiftRightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
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

    func queryTranslation() {
        let word = deGrammarPreviewLabel?.text!.substring(with: conjugatePrompt.count..<((deGrammarPreviewLabel?.text!.count)!-1))
        let lowerCaseWord = word!.lowercased()
        let wordInDirectory = germanTranslations?[lowerCaseWord] != nil
        if wordInDirectory {
            proxy.insertText(germanTranslations?[lowerCaseWord] as! String + " ")
        // Cancel via a return press.
        } else if deGrammarPreviewLabel?.text! == translatePromptAndCursor {
            return
        } else {
            invalidState = true
        }
    }

    func queryConjugation() {
        verbToConjugate = (deGrammarPreviewLabel?.text!.substring(with: conjugatePrompt.count..<((deGrammarPreviewLabel?.text!.count)!-1)))!
        let verbInDirectory = germanVerbs?[verbToConjugate] != nil
        if verbInDirectory {
            conjugateView = true
            loadKeys()
        // Cancel via a return press.
        } else if deGrammarPreviewLabel?.text! == conjugatePromptAndCursor {
            return
        } else {
            invalidState = true
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

    func selectedNounAnnotation() {
        let selectedWord = proxy.selectedText
        let isNoun = germanNouns?[selectedWord!] != nil
        if isNoun {
            let nounForm = germanNouns?[selectedWord!]?["form"] as! String
            if nounForm == "F" {
                deGrammarPreviewLabel?.textColor = UIColor.previewRedLightTheme
            } else if nounForm == "M" {
                deGrammarPreviewLabel?.textColor = UIColor.previewBlueLightTheme
            } else if nounForm ==  "N" {
                deGrammarPreviewLabel?.textColor = UIColor.previewGreenLightTheme
            } else if nounForm ==  "PL" {
                deGrammarPreviewLabel?.textColor = UIColor.previewOrangeLightTheme
            } else {
                deGrammarPreviewLabel?.textColor = .black
            }

            deGrammarPreviewLabel?.text = previewPromptSpacing + "(\(nounForm)) " + selectedWord!
            deGrammarPreviewLabel?.sizeToFit()
        }
    }

    func typedNounAnnotation() {
        if proxy.documentContextBeforeInput != nil {
            let wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
            let lastWordTyped = wordsTyped.penultimate()
            let isNoun = germanNouns?[lastWordTyped!] != nil
            if isNoun {
                let nounForm = germanNouns?[lastWordTyped!]?["form"] as! String
                if nounForm == "F" {
                    deGrammarPreviewLabel?.textColor = UIColor.previewRedLightTheme
                } else if nounForm == "M" {
                    deGrammarPreviewLabel?.textColor = UIColor.previewBlueLightTheme
                } else if nounForm ==  "N" {
                    deGrammarPreviewLabel?.textColor = UIColor.previewGreenLightTheme
                } else if nounForm ==  "PL" {
                    deGrammarPreviewLabel?.textColor = UIColor.previewOrangeLightTheme
                } else {
                    deGrammarPreviewLabel?.textColor = .black
                }

                deGrammarPreviewLabel?.text = previewPromptSpacing + "(\(nounForm)) " + lastWordTyped!
                deGrammarPreviewLabel?.sizeToFit()
            }
        }
    }

    func clearPreviewLabel() {
        if previewState != true {
            deGrammarPreviewLabel?.textColor = UIColor.label
            deGrammarPreviewLabel?.text = " "
        }
    }

	@IBAction func keyPressedTouchUp(_ sender: UIButton) {
		guard let originalKey = sender.layer.value(forKey: "original") as? String, let keyToDisplay = sender.layer.value(forKey: "keyToDisplay") as? String else {return}

		guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
		sender.backgroundColor = isSpecial ? specialKeyColor : keyColor

		switch originalKey {
        case "Scribe":
            if (proxy.selectedText != nil) {
                loadKeys()
                selectedNounAnnotation()
            } else {
                if scribeBtnState == false && conjugateView != true{
                    scribeBtnState = true
                    activateBtn(btn: translateBtn)
                    activateBtn(btn: conjugateBtn)
                    activateBtn(btn: pluralBtn)
                } else if conjugateView == true {
                    conjugateView = false
                    scribeBtnState = false
                } else {
                    scribeBtnState = false
                }
                loadKeys()
            }

        case "Translate":
            scribeBtnState = false
            loadKeys()
            deGrammarPreviewLabel?.text = translatePromptAndCursor
            previewState = true
            getTranslation = true

        case "Conjugate":
            scribeBtnState = false
            if shiftButtonState == .shift {
                            shiftButtonState = .normal
                        }
            loadKeys()
            deGrammarPreviewLabel?.text = conjugatePromptAndCursor
            previewState = true
            getConjugation = true

        case "firstPersonSingular":
            // Don't change proxy if they select a conjugation that's missing.
            if sender.titleLabel?.text == "Not in directory" {
                proxy.insertText("")
            }
            else if conjugationState != .indicativePerfect {
                proxy.insertText(germanVerbs?[verbToConjugate]![tenseFPS] as! String + " ")
            } else {
                proxy.insertText(germanVerbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
            }
            previewState = false
            conjugateView = false
            loadKeys()

        case "secondPersonSingular":
            // Don't change proxy if they select a conjugation that's missing.
            if sender.titleLabel?.text == "Not in directory" {
                proxy.insertText("")
            }
            else if conjugationState != .indicativePerfect {
                proxy.insertText(germanVerbs?[verbToConjugate]![tenseSPS] as! String + " ")
            } else {
                proxy.insertText(germanVerbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
            }
            previewState = false
            conjugateView = false
            loadKeys()

        case "thirdPersonSingular":
            // Don't change proxy if they select a conjugation that's missing.
            if sender.titleLabel?.text == "Not in directory" {
                proxy.insertText("")
            }
            else if conjugationState != .indicativePerfect {
                proxy.insertText(germanVerbs?[verbToConjugate]![tenseTPS] as! String + " ")
            } else {
                proxy.insertText(germanVerbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
            }
            previewState = false
            conjugateView = false
            loadKeys()

        case "firstPersonPlural":
            // Don't change proxy if they select a conjugation that's missing.
            if sender.titleLabel?.text == "Not in directory" {
                proxy.insertText("")
            }
            else if conjugationState != .indicativePerfect {
                proxy.insertText(germanVerbs?[verbToConjugate]![tenseFPP] as! String + " ")
            } else {
                proxy.insertText(germanVerbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
            }
            previewState = false
            conjugateView = false
            loadKeys()

        case "secondPersonPlural":
            // Don't change proxy if they select a conjugation that's missing.
            if sender.titleLabel?.text == "Not in directory" {
                proxy.insertText("")
            }
            else if conjugationState != .indicativePerfect {
                proxy.insertText(germanVerbs?[verbToConjugate]![tenseSPP] as! String + " ")
            } else {
                proxy.insertText(germanVerbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
            }
            previewState = false
            conjugateView = false
            loadKeys()

        case "thirdPersonPlural":
            // Don't change proxy if they select a conjugation that's missing.
            if sender.titleLabel?.text == "Not in directory" {
                proxy.insertText("")
            }
            else if conjugationState != .indicativePerfect {
                proxy.insertText(germanVerbs?[verbToConjugate]![tenseTPP] as! String + " ")
            } else {
                proxy.insertText(germanVerbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
            }
            previewState = false
            conjugateView = false
            loadKeys()

        case "shiftConjugateLeft":
            conjugationStateLeft()
            loadKeys()

        case "shiftConjugateRight":
            conjugationStateRight()
            loadKeys()

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

		case "delete":
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
            typedNounAnnotation()
            if proxy.documentContextBeforeInput?.suffix("  ".count) == "  " {
                clearPreviewLabel()
            }
            
		case "selectKeyboard":
            self.advanceToNextInputMode()
			break
            
        case "hideKeyboard":
            self.dismissKeyboard()
            
		case "return":
            if getTranslation {
                queryTranslation()
                getTranslation = false
            }
            if getConjugation {
                // Reset to the most basic conjugations.
                conjugationState = .indicativePresent
                queryConjugation()
                getConjugation = false
            }
            if getPlural {
                queryPlural()
                getPlural = false
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
                deGrammarPreviewLabel?.textColor = UIColor.label

                invalidState = false
                isAlreadyPluralState = false
            }
            else {
                previewState = false
                clearPreviewLabel()
                typedNounAnnotation()
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
            
        case ".?123":
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
            
		case "shift":
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
        if self.view.viewWithTag(1001) != nil {
            let viewWithTag = self.view.viewWithTag(1001)
            viewWithTag?.removeFromSuperview()
        }
	}

	@objc func keyMultiPress(_ sender: UIButton, event: UIEvent) {
		guard let originalKey = sender.layer.value(forKey: "original") as? String else {return}

		let touch: UITouch = event.allTouches!.first!
		if (touch.tapCount == 2 && originalKey == "shift") {
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
    
    @objc func aLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        // 7 options for a.
        let viewX = tapLocation.x - 10.0
        let viewWidth = CGFloat(buttonWidth * 7.0 + (5.0 * 7.0) + 5.0)
        
        var alternateBtnStartX = 5.0
        var viewY = 0.0
        var alternatesBtnHeight = 0.0
        var alternatesCharHeight = 0.0
        if DeviceType.isPhone {
            viewY = tapLocation.y - 50.0
            alternatesBtnHeight = buttonWidth * 1.4
            alternatesCharHeight = buttonWidth / 2
        } else if DeviceType.isPad {
            viewY = tapLocation.y - 100.0
            alternatesBtnHeight = buttonWidth
            alternatesCharHeight = buttonWidth / 3
        }
        
        alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

        //Only run this code when the state begins.
        if sender.state != UIGestureRecognizer.State.began {
                return
             }
        // If alternateKeysView is Already in added than remove and then add.
        if self.view.viewWithTag(1001) != nil {
            alternatesKeyView.removeFromSuperview()
           }
        
        alternatesKeyView.backgroundColor = keyboardView.backgroundColor
        alternatesKeyView.layer.cornerRadius = 5
        alternatesKeyView.layer.borderWidth = 1
        alternatesKeyView.tag = 1001
        alternatesKeyView.layer.borderColor = specialKeyColor.cgColor
        
        for char in Constants.aAlternateKeys {
            let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: buttonWidth, height: alternatesBtnHeight))
            if shiftButtonState == .normal {
                btn.setTitle(char, for: .normal)
            } else {
                btn.setTitle(char.capitalized, for: .normal)
            }
            btn.titleLabel?.font = .systemFont(ofSize: alternatesCharHeight)
            btn.setTitleColor(UIColor.black, for: .normal);
            
            alternatesKeyView.addSubview(btn)
            setBtn(btn: btn, color: keyboardView.backgroundColor!, name: char, canCapitalize: true, isSpecial: false)
            
            alternateBtnStartX += (buttonWidth + 5.0)
        }
         self.view.addSubview(alternatesKeyView)
    }

    @objc func eLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        // 5 options for e.
        let viewX = tapLocation.x - 10.0
        let viewWidth = CGFloat(buttonWidth * 5.0 + (5.0 * 5.0) + 5.0)
        
        var alternateBtnStartX = 5.0
        var viewY = 0.0
        var alternatesBtnHeight = 0.0
        var alternatesCharHeight = 0.0
        if DeviceType.isPhone {
            viewY = tapLocation.y - 50.0
            alternatesBtnHeight = buttonWidth * 1.4
            alternatesCharHeight = buttonWidth / 2
        } else if DeviceType.isPad {
            viewY = tapLocation.y - 100.0
            alternatesBtnHeight = buttonWidth
            alternatesCharHeight = buttonWidth / 3
        }
        
        alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

        //Only run this code when the state begins.
        if sender.state != UIGestureRecognizer.State.began {
                return
             }
        // If alternateKeysView is Already in added than remove and then add.
        if self.view.viewWithTag(1001) != nil {
            alternatesKeyView.removeFromSuperview()
           }
        
        alternatesKeyView.backgroundColor = keyboardView.backgroundColor
        alternatesKeyView.layer.cornerRadius = 5
        alternatesKeyView.layer.borderWidth = 1
        alternatesKeyView.tag = 1001
        alternatesKeyView.layer.borderColor = specialKeyColor.cgColor
        
        for char in Constants.eAlternateKeys {
            let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: buttonWidth, height: alternatesBtnHeight))
            if shiftButtonState == .normal {
                btn.setTitle(char, for: .normal)
            } else {
                btn.setTitle(char.capitalized, for: .normal)
            }
            btn.titleLabel?.font = .systemFont(ofSize: alternatesCharHeight)
            btn.setTitleColor(UIColor.black, for: .normal);
            
            alternatesKeyView.addSubview(btn)
            setBtn(btn: btn, color: keyboardView.backgroundColor!, name: char, canCapitalize: true, isSpecial: false)
            
            alternateBtnStartX += (buttonWidth + 5.0)
        }
         self.view.addSubview(alternatesKeyView)
    }
    
    @objc func iLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        // 5 options for i.
        let viewX = tapLocation.x - CGFloat(buttonWidth * 5.0 + (5.0 * 5.0) - 5.0)
        let viewWidth = CGFloat(buttonWidth * 5.0 + (5.0 * 5.0) + 5.0)
        
        var alternateBtnStartX = 5.0
        var viewY = 0.0
        var alternatesBtnHeight = 0.0
        var alternatesCharHeight = 0.0
        if DeviceType.isPhone {
            viewY = tapLocation.y - 50.0
            alternatesBtnHeight = buttonWidth * 1.4
            alternatesCharHeight = buttonWidth / 2
        } else if DeviceType.isPad {
            viewY = tapLocation.y - 100.0
            alternatesBtnHeight = buttonWidth
            alternatesCharHeight = buttonWidth / 3
        }
        
        alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

        //Only run this code when the state begins.
        if sender.state != UIGestureRecognizer.State.began {
                return
             }
        // If alternateKeysView is Already in added than remove and then add.
        if self.view.viewWithTag(1001) != nil {
            alternatesKeyView.removeFromSuperview()
           }
        
        alternatesKeyView.backgroundColor = keyboardView.backgroundColor
        alternatesKeyView.layer.cornerRadius = 5
        alternatesKeyView.layer.borderWidth = 1
        alternatesKeyView.tag = 1001
        alternatesKeyView.layer.borderColor = specialKeyColor.cgColor
        
        for char in Constants.iAlternateKeys {
            let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: buttonWidth, height: alternatesBtnHeight))
            if shiftButtonState == .normal {
                btn.setTitle(char, for: .normal)
            } else {
                btn.setTitle(char.capitalized, for: .normal)
            }
            btn.titleLabel?.font = .systemFont(ofSize: alternatesCharHeight)
            btn.setTitleColor(UIColor.black, for: .normal);
            
            alternatesKeyView.addSubview(btn)
            setBtn(btn: btn, color: keyboardView.backgroundColor!, name: char, canCapitalize: true, isSpecial: false)
            
            alternateBtnStartX += (buttonWidth + 5.0)
        }
         self.view.addSubview(alternatesKeyView)
    }
    
    @objc func oLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        // 7 options for o.
        let viewX = tapLocation.x - CGFloat(buttonWidth * 7.0 + (5.0 * 7.0) - 5.0)
        let viewWidth = CGFloat(buttonWidth * 7.0 + (5.0 * 7.0) + 5.0)
        
        var alternateBtnStartX = 5.0
        var viewY = 0.0
        var alternatesBtnHeight = 0.0
        var alternatesCharHeight = 0.0
        if DeviceType.isPhone {
            viewY = tapLocation.y - 50.0
            alternatesBtnHeight = buttonWidth * 1.4
            alternatesCharHeight = buttonWidth / 2
        } else if DeviceType.isPad {
            viewY = tapLocation.y - 100.0
            alternatesBtnHeight = buttonWidth
            alternatesCharHeight = buttonWidth / 3
        }
        
        alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

        //Only run this code when the state begins.
        if sender.state != UIGestureRecognizer.State.began {
                return
             }
        // If alternateKeysView is Already in added than remove and then add.
        if self.view.viewWithTag(1001) != nil {
            alternatesKeyView.removeFromSuperview()
           }
        
        alternatesKeyView.backgroundColor = keyboardView.backgroundColor
        alternatesKeyView.layer.cornerRadius = 5
        alternatesKeyView.layer.borderWidth = 1
        alternatesKeyView.tag = 1001
        alternatesKeyView.layer.borderColor = specialKeyColor.cgColor
        
        for char in Constants.oAlternateKeys {
            let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: buttonWidth, height: alternatesBtnHeight))
            if shiftButtonState == .normal {
                btn.setTitle(char, for: .normal)
            } else {
                btn.setTitle(char.capitalized, for: .normal)
            }
            btn.titleLabel?.font = .systemFont(ofSize: alternatesCharHeight)
            btn.setTitleColor(UIColor.black, for: .normal);
            
            alternatesKeyView.addSubview(btn)
            setBtn(btn: btn, color: keyboardView.backgroundColor!, name: char, canCapitalize: true, isSpecial: false)
            
            alternateBtnStartX += (buttonWidth + 5.0)
        }
         self.view.addSubview(alternatesKeyView)
    }
    
    @objc func uLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        // 4 options for u.
        let viewX = tapLocation.x - CGFloat(buttonWidth * 4.0 + (5.0 * 4.0) - 5.0)
        let viewWidth = CGFloat(buttonWidth * 4.0 + (5.0 * 4.0) + 5.0)
        
        var alternateBtnStartX = 5.0
        var viewY = 0.0
        var alternatesBtnHeight = 0.0
        var alternatesCharHeight = 0.0
        if DeviceType.isPhone {
            viewY = tapLocation.y - 50.0
            alternatesBtnHeight = buttonWidth * 1.4
            alternatesCharHeight = buttonWidth / 2
        } else if DeviceType.isPad {
            viewY = tapLocation.y - 100.0
            alternatesBtnHeight = buttonWidth
            alternatesCharHeight = buttonWidth / 3
        }
        
        alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

        //Only run this code when the state begins.
        if sender.state != UIGestureRecognizer.State.began {
                return
             }
        // If alternateKeysView is Already in added than remove and then add.
        if self.view.viewWithTag(1001) != nil {
            alternatesKeyView.removeFromSuperview()
           }
        
        alternatesKeyView.backgroundColor = keyboardView.backgroundColor
        alternatesKeyView.layer.cornerRadius = 5
        alternatesKeyView.layer.borderWidth = 1
        alternatesKeyView.tag = 1001
        alternatesKeyView.layer.borderColor = specialKeyColor.cgColor
        
        for char in Constants.uAlternateKeys {
            let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: buttonWidth, height: alternatesBtnHeight))
            if shiftButtonState == .normal {
                btn.setTitle(char, for: .normal)
            } else {
                btn.setTitle(char.capitalized, for: .normal)
            }
            btn.titleLabel?.font = .systemFont(ofSize: alternatesCharHeight)
            btn.setTitleColor(UIColor.black, for: .normal);
            
            alternatesKeyView.addSubview(btn)
            setBtn(btn: btn, color: keyboardView.backgroundColor!, name: char, canCapitalize: true, isSpecial: false)
            
            alternateBtnStartX += (buttonWidth + 5.0)
        }
         self.view.addSubview(alternatesKeyView)
    }
    
    @objc func yLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        // 5 options for y.
        let viewX = tapLocation.x - 10.0
        let viewWidth = CGFloat(buttonWidth * 1.0 + (5.0 * 1.0) + 5.0)
        
        var alternateBtnStartX = 5.0
        var viewY = 0.0
        var alternatesBtnHeight = 0.0
        var alternatesCharHeight = 0.0
        if DeviceType.isPhone {
            viewY = tapLocation.y - 50.0
            alternatesBtnHeight = buttonWidth * 1.4
            alternatesCharHeight = buttonWidth / 2
        } else if DeviceType.isPad {
            viewY = tapLocation.y - 100.0
            alternatesBtnHeight = buttonWidth
            alternatesCharHeight = buttonWidth / 3
        }
        
        alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

        //Only run this code when the state begins.
        if sender.state != UIGestureRecognizer.State.began {
                return
             }
        // If alternateKeysView is Already in added than remove and then add.
        if self.view.viewWithTag(1001) != nil {
            alternatesKeyView.removeFromSuperview()
           }
        
        alternatesKeyView.backgroundColor = keyboardView.backgroundColor
        alternatesKeyView.layer.cornerRadius = 5
        alternatesKeyView.layer.borderWidth = 1
        alternatesKeyView.tag = 1001
        alternatesKeyView.layer.borderColor = specialKeyColor.cgColor
        
        for char in Constants.yAlternateKeys {
            let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: buttonWidth, height: alternatesBtnHeight))
            if shiftButtonState == .normal {
                btn.setTitle(char, for: .normal)
            } else {
                btn.setTitle(char.capitalized, for: .normal)
            }
            btn.titleLabel?.font = .systemFont(ofSize: alternatesCharHeight)
            btn.setTitleColor(UIColor.black, for: .normal);
            
            alternatesKeyView.addSubview(btn)
            setBtn(btn: btn, color: keyboardView.backgroundColor!, name: char, canCapitalize: true, isSpecial: false)
            
            alternateBtnStartX += (buttonWidth + 5.0)
        }
         self.view.addSubview(alternatesKeyView)
    }
    
    @objc func sLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        // 5 options for s.
        let viewX = tapLocation.x - 10.0
        let viewWidth = CGFloat(buttonWidth * 3.0 + (5.0 * 3.0) + 5.0)

        var alternateBtnStartX = 5.0
        var viewY = 0.0
        var alternatesBtnHeight = 0.0
        var alternatesCharHeight = 0.0
        if DeviceType.isPhone {
            viewY = tapLocation.y - 50.0
            alternatesBtnHeight = buttonWidth * 1.4
            alternatesCharHeight = buttonWidth / 2
        } else if DeviceType.isPad {
            viewY = tapLocation.y - 100.0
            alternatesBtnHeight = buttonWidth
            alternatesCharHeight = buttonWidth / 3
        }
        
        alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

        //Only run this code when the state begins.
        if sender.state != UIGestureRecognizer.State.began {
                return
             }
        // If alternateKeysView is Already in added than remove and then add.
        if self.view.viewWithTag(1001) != nil {
            alternatesKeyView.removeFromSuperview()
           }
        
        alternatesKeyView.backgroundColor = keyboardView.backgroundColor
        alternatesKeyView.layer.cornerRadius = 5
        alternatesKeyView.layer.borderWidth = 1
        alternatesKeyView.tag = 1001
        alternatesKeyView.layer.borderColor = specialKeyColor.cgColor
        
        for char in Constants.sAlternateKeys {
            let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: buttonWidth, height: alternatesBtnHeight))
            if shiftButtonState == .normal || char == "ß" {
                btn.setTitle(char, for: .normal)
            } else {
                btn.setTitle(char.capitalized, for: .normal)
            }
            btn.titleLabel?.font = .systemFont(ofSize: alternatesCharHeight)
            btn.setTitleColor(UIColor.black, for: .normal);
            
            alternatesKeyView.addSubview(btn)
            setBtn(btn: btn, color: keyboardView.backgroundColor!, name: char, canCapitalize: true, isSpecial: false)
            
            alternateBtnStartX += (buttonWidth + 5.0)
        }
         self.view.addSubview(alternatesKeyView)
    }
    
    @objc func cLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        // 5 options for c.
        let viewX = tapLocation.x - 10.0
        let viewWidth = CGFloat(buttonWidth * 3.0 + (5.0 * 3.0) + 5.0)
        
        var alternateBtnStartX = 5.0
        var viewY = 0.0
        var alternatesBtnHeight = 0.0
        var alternatesCharHeight = 0.0
        if DeviceType.isPhone {
            viewY = tapLocation.y - 50.0
            alternatesBtnHeight = buttonWidth * 1.4
            alternatesCharHeight = buttonWidth / 2
        } else if DeviceType.isPad {
            viewY = tapLocation.y - 100.0
            alternatesBtnHeight = buttonWidth
            alternatesCharHeight = buttonWidth / 3
        }
        
        alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

        //Only run this code when the state begins.
        if sender.state != UIGestureRecognizer.State.began {
                return
             }
        // If alternateKeysView is Already in added than remove and then add.
        if self.view.viewWithTag(1001) != nil {
            alternatesKeyView.removeFromSuperview()
           }
        
        alternatesKeyView.backgroundColor = keyboardView.backgroundColor
        alternatesKeyView.layer.cornerRadius = 5
        alternatesKeyView.layer.borderWidth = 1
        alternatesKeyView.tag = 1001
        alternatesKeyView.layer.borderColor = specialKeyColor.cgColor
        
        for char in Constants.cAlternateKeys {
            let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: buttonWidth, height: alternatesBtnHeight))
            if shiftButtonState == .normal {
                btn.setTitle(char, for: .normal)
            } else {
                btn.setTitle(char.capitalized, for: .normal)
            }
            btn.titleLabel?.font = .systemFont(ofSize: alternatesCharHeight)
            btn.setTitleColor(UIColor.black, for: .normal);
            
            alternatesKeyView.addSubview(btn)
            setBtn(btn: btn, color: keyboardView.backgroundColor!, name: char, canCapitalize: true, isSpecial: false)
            
            alternateBtnStartX += (buttonWidth + 5.0)
        }
         self.view.addSubview(alternatesKeyView)
    }
    
    @objc func nLongPressedSelectAlternates(sender: UILongPressGestureRecognizer) {
        let tapLocation = sender.location(in: self.view)
        
        // 5 options for n.
        let viewX = tapLocation.x - CGFloat(buttonWidth * 2.0 + (5.0 * 2.0) - 5.0)
        let viewWidth = CGFloat(buttonWidth * 2.0 + (5.0 * 2.0) + 5.0)

        var alternateBtnStartX = 5.0
        var viewY = 0.0
        var alternatesBtnHeight = 0.0
        var alternatesCharHeight = 0.0
        if DeviceType.isPhone {
            viewY = tapLocation.y - 50.0
            alternatesBtnHeight = buttonWidth * 1.4
            alternatesCharHeight = buttonWidth / 2
        } else if DeviceType.isPad {
            viewY = tapLocation.y - 100.0
            alternatesBtnHeight = buttonWidth
            alternatesCharHeight = buttonWidth / 3
        }
        
        alternatesKeyView = UIView(frame: CGRect(x: viewX, y: viewY, width: viewWidth, height: alternatesBtnHeight))

        //Only run this code when the state begins.
        if sender.state != UIGestureRecognizer.State.began {
                return
             }
        // If alternateKeysView is Already in added than remove and then add.
        if self.view.viewWithTag(1001) != nil {
            alternatesKeyView.removeFromSuperview()
           }
        
        alternatesKeyView.backgroundColor = keyboardView.backgroundColor
        alternatesKeyView.layer.cornerRadius = 5
        alternatesKeyView.layer.borderWidth = 1
        alternatesKeyView.tag = 1001
        alternatesKeyView.layer.borderColor = specialKeyColor.cgColor
        
        for char in Constants.nAlternateKeys {
            let btn: UIButton = UIButton(frame: CGRect(x: alternateBtnStartX, y: 0, width: buttonWidth, height: alternatesBtnHeight))
            if shiftButtonState == .normal {
                btn.setTitle(char, for: .normal)
            } else {
                btn.setTitle(char.capitalized, for: .normal)
            }
            btn.titleLabel?.font = .systemFont(ofSize: alternatesCharHeight)
            btn.setTitleColor(UIColor.black, for: .normal);
            
            alternatesKeyView.addSubview(btn)
            setBtn(btn: btn, color: keyboardView.backgroundColor!, name: char, canCapitalize: true, isSpecial: false)
            
            alternateBtnStartX += (buttonWidth + 5.0)
        }
         self.view.addSubview(alternatesKeyView)
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
            (gesture.view as! UIButton).backgroundColor = specialKeyColor
        }
	}

	@objc func keyUntouched(_ sender: UIButton) {
		guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
		sender.backgroundColor = isSpecial ? specialKeyColor : keyColor
	}

	@objc func keyTouchDown(_ sender: UIButton) {
		sender.backgroundColor = keyPressedColor
	}

	override func textWillChange(_ textInput: UITextInput?) {
		// The app is about to change the document's contents. Perform any preparation here.
	}

	override func textDidChange(_ textInput: UITextInput?) {
		// The app has just changed the document's contents, the document context has been updated.
	}

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Trait collection has already changed
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
    }
}
