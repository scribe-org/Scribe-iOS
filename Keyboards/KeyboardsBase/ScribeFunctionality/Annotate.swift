//
//  Annotate.swift
//
//  Functions and elements that control word annotations.
//

import UIKit

// Dictionary for accessing keyboard conjugation state.
var nounFormToColorDict: [String: UIColor] = [
  "F": annotateRed,
  "M": annotateBlue,
  "C": annotatePurple,
  "N": annotateGreen,
  "PL": annotateOrange
]

// Dictionary to convert noun annotations into the keyboard language.
let nounAnnotationConversionDict = [
  "Swedish": ["C": "U"],
  "Russian": ["F": "Ж", "M": "М", "N": "Н", "PL": "МН"]
]

// Dictionary to convert case annotations into the keyboard language.
let prepAnnotationConversionDict = [
  "German": ["Acc": "Akk"],
  "Russian": ["Acc": "Вин", "Dat": "Дат", "Gen": "Род", "Loc": "Мес", "Pre": "Пре", "Ins": "Инс"]
]

/// Annotates a word after it's selected and the Scribe key is pressed.
func selectedWordAnnotation(_ KVC: KeyboardViewController) {
  wordToCheck = proxy.selectedText ?? ""
  if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
    wordToCheck = wordToCheck.lowercased()
  }

  isNoun = nouns?[wordToCheck] != nil
  isPrep = prepositions?[wordToCheck.lowercased()] != nil

  annotationsToAssign = [String]()
  annotationBtns = [UIButton]()
  annotationColors = [UIColor]()
  annotationSeparators = [UIView]()

  let annotationFieldWidth = KVC.translateKey.frame.width * 0.85
  var annotationHeight: CGFloat = 0.0
  annotationHeight = scribeKeyHeight

  if wordToCheck == "Scribe" || wordToCheck == "scribe" {
    // Thank the user :)
    annotationState = true
    activateAnnotationBtn = true
    autoAction1Visible = false

    let annotationBtn = Annotation()
    annotationBtn.setAnnotationSize(width: annotationFieldWidth, height: annotationHeight, fontSize: annotationHeight * 0.55)
    annotationBtn.setAnnotationLoc(
      minX: KVC.translateKey.frame.origin.x
      + ( KVC.translateKey.frame.width / 2 )
        - ( annotationFieldWidth / 2 ),
      maxY: KVC.scribeKey.frame.origin.y
    )
    annotationBtn.styleSingleAnnotation()

    let emojisToSelectFrom: String = "🥳🎉"
    let emojis: String = String((0..<3).map{ _ in emojisToSelectFrom.randomElement()! })
    annotationBtn.setTitle(emojis, for: .normal)
    KVC.view.addSubview(annotationBtn)
    annotationBtns.append(annotationBtn)
    annotationColors.append(commandKeyColor)

    KVC.activateBtn(btn: annotationBtn)
    setBtn(btn: annotationBtn, color: commandKeyColor, name: "ScribeAnnotation", canCap: false, isSpecial: false)
  } else {
    if isNoun {
      let nounAnnotationForm: String = nouns?[wordToCheck]?["form"] as! String
      if nounAnnotationForm != "" {
        if !nounAnnotationForm.contains("/") {
          annotationsToAssign.append(nounAnnotationForm)
        } else {
          for a in nounAnnotationForm.components(separatedBy: "/") {
            annotationsToAssign.append(a)
          }
        }
      }
    }
    
    if isPrep {
      prepAnnotationForm = prepositions?[wordToCheck.lowercased()] as! String
      if prepAnnotationForm != "" {
        if !prepAnnotationForm.contains("/") {
          annotationsToAssign.append(prepAnnotationForm)
        } else {
          for a in prepAnnotationForm.components(separatedBy: "/") {
            annotationsToAssign.append(a)
          }
        }
      }
    }
    
    if annotationsToAssign.count > 0 {
      annotationState = true
      autoAction1Visible = false

      let annotationWidth = annotationFieldWidth / CGFloat(annotationsToAssign.count)
      let numAnnotations = annotationsToAssign.count

      for i in 0..<numAnnotations {
        let annotationBtn = Annotation()
        var annotationSep = UIView()
        var annotationToDisplay: String = annotationsToAssign[i]

        if nounFormToColorDict.keys.contains(annotationToDisplay) {
          if numAnnotations > 3 {
            annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.4)
          } else if numAnnotations > 2 {
            annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.55)
          } else {
            annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.6)
          }
        } else {
          if numAnnotations > 3 {
            annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.4)
          } else if numAnnotations == 1 {
            annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.55)
          } else {
            annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.5)
          }
        }

        annotationBtn.setAnnotationLoc(
          minX: KVC.translateKey.frame.origin.x
          + ( KVC.translateKey.frame.width / 2 )
            - ( annotationFieldWidth / 2 )
            + ( annotationWidth * CGFloat(i) ),
          maxY: KVC.scribeKey.frame.origin.y
        )
        if numAnnotations == 1 {
          annotationBtn.styleSingleAnnotation()
        } else if i == 0 {
          annotationBtn.styleLeftAnnotation()
        } else if i == numAnnotations - 1 {
          annotationBtn.styleRightAnnotation()
        } else {
          annotationBtn.styleMiddleAnnotation()
        }

        // Convert the annotation into the keyboard language.
        if nounFormToColorDict.keys.contains(annotationToDisplay) {
          if nounAnnotationConversionDict[controllerLanguage] != nil {
            if nounAnnotationConversionDict[controllerLanguage]?[annotationsToAssign[i]] != nil {
              annotationToDisplay = nounAnnotationConversionDict[controllerLanguage]?[annotationsToAssign[i]] ?? ""
            }
          }
        } else {
          if prepAnnotationConversionDict[controllerLanguage] != nil {
            if prepAnnotationConversionDict[controllerLanguage]?[annotationsToAssign[i]] != nil {
              annotationToDisplay = prepAnnotationConversionDict[controllerLanguage]?[annotationsToAssign[i]] ?? ""
            }
          }
        }

        annotationBtn.setTitle(annotationToDisplay, for: .normal)
        KVC.view.addSubview(annotationBtn)
        annotationBtns.append(annotationBtn)
        if nounFormToColorDict.keys.contains(annotationToDisplay) {
          annotationColors.append(nounFormToColorDict[annotationsToAssign[i]]!)
        } else {
          annotationColors.append(UITraitCollection.current.userInterfaceStyle == .light ? .black : .white)
        }
        KVC.activateBtn(btn: annotationBtn)
        setBtn(btn: annotationBtn, color: annotationColors[i], name: "GetAnnotationInfo", canCap: false, isSpecial: false)

        if i != 0 {
          annotationSep = UIView(frame: CGRect(x: annotationBtn.frame.minX, y: annotationBtn.frame.minY, width: 1, height: annotationBtn.frame.height))
          annotationSep.isUserInteractionEnabled = false
          annotationSep.backgroundColor = UITraitCollection.current.userInterfaceStyle == .light ? keyColor : specialKeyColor
          KVC.view.addSubview(annotationSep)
          annotationSeparators.append(annotationSep)
        }
      }
    } else {
      return
    }
  }
}

/// Annotates a typed word after a space or auto action.
func typedWordAnnotation(_ KVC: KeyboardViewController) {
  if proxy.documentContextBeforeInput?.count != 0 {
    wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
    let lastWordTyped = wordsTyped.secondToLast()
    if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
      wordToCheck = lastWordTyped!.lowercased()
    } else {
      wordToCheck = lastWordTyped!
    }

    isNoun = nouns?[wordToCheck] != nil
    isPrep = prepositions?[wordToCheck.lowercased()] != nil

    annotationsToAssign = [String]()
    annotationBtns = [UIButton]()
    annotationColors = [UIColor]()
    annotationSeparators = [UIView]()

    let annotationFieldWidth = KVC.translateKey.frame.width * 0.85
    var annotationHeight: CGFloat = 0.0
    annotationHeight = scribeKeyHeight
    
    if lastWordTyped == "Scribe" || lastWordTyped == "scribe" {
      // Thank the user :)
      annotationState = true
      activateAnnotationBtn = true
      autoAction1Visible = false

      let annotationBtn = Annotation()
      annotationBtn.setAnnotationSize(width: annotationFieldWidth, height: annotationHeight, fontSize: annotationHeight * 0.55)
      annotationBtn.setAnnotationLoc(
        minX: KVC.translateKey.frame.origin.x
        + ( KVC.translateKey.frame.width / 2 )
          - ( annotationFieldWidth / 2 ),
        maxY: KVC.scribeKey.frame.origin.y
      )
      annotationBtn.styleSingleAnnotation()

      let emojisToSelectFrom: String = "🥳🎉"
      let emojis: String = String((0..<3).map{ _ in emojisToSelectFrom.randomElement()! })
      annotationBtn.setTitle(emojis, for: .normal)
      KVC.view.addSubview(annotationBtn)
      annotationBtns.append(annotationBtn)
      annotationColors.append(commandKeyColor)

      KVC.activateBtn(btn: annotationBtn)
      setBtn(btn: annotationBtn, color: commandKeyColor, name: "ScribeAnnotation", canCap: false, isSpecial: false)
    } else {
      if isNoun {
        let nounAnnotationForm: String = nouns?[wordToCheck]?["form"] as! String
        if nounAnnotationForm != "" {
          if !nounAnnotationForm.contains("/") {
            annotationsToAssign.append(nounAnnotationForm)
          } else {
            for a in nounAnnotationForm.components(separatedBy: "/") {
              annotationsToAssign.append(a)
            }
          }
        }
      }
      
      if isPrep {
        prepAnnotationForm = prepositions?[wordToCheck.lowercased()] as! String
        if prepAnnotationForm != "" {
          if !prepAnnotationForm.contains("/") {
            annotationsToAssign.append(prepAnnotationForm)
          } else {
            for a in prepAnnotationForm.components(separatedBy: "/") {
              annotationsToAssign.append(a)
            }
          }
        }
      }
      
      if annotationsToAssign.count > 0 {
        annotationState = true
        autoAction1Visible = false

        let annotationWidth = annotationFieldWidth / CGFloat(annotationsToAssign.count)
        let numAnnotations = annotationsToAssign.count

        for i in 0..<numAnnotations {
          let annotationBtn = Annotation()
          var annotationSep = UIView()
          var annotationToDisplay: String = annotationsToAssign[i]

          if nounFormToColorDict.keys.contains(annotationToDisplay) {
            if numAnnotations > 3 {
              annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.4)
            } else if numAnnotations > 2 {
              annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.55)
            } else {
              annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.6)
            }
          } else {
            if numAnnotations > 3 {
              annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.4)
            } else if numAnnotations == 1 {
              annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.55)
            } else {
              annotationBtn.setAnnotationSize(width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.5)
            }
          }

          annotationBtn.setAnnotationLoc(
            minX: KVC.translateKey.frame.origin.x
            + ( KVC.translateKey.frame.width / 2 )
              - ( annotationFieldWidth / 2 )
              + ( annotationWidth * CGFloat(i) ),
            maxY: KVC.scribeKey.frame.origin.y
          )
          if numAnnotations == 1 {
            annotationBtn.styleSingleAnnotation()
          } else if i == 0 {
            annotationBtn.styleLeftAnnotation()
          } else if i == numAnnotations - 1 {
            annotationBtn.styleRightAnnotation()
          } else {
            annotationBtn.styleMiddleAnnotation()
          }

          // Convert the annotation into the keyboard language.
          if nounFormToColorDict.keys.contains(annotationToDisplay) {
            if nounAnnotationConversionDict[controllerLanguage] != nil {
              if nounAnnotationConversionDict[controllerLanguage]?[annotationsToAssign[i]] != nil {
                annotationToDisplay = nounAnnotationConversionDict[controllerLanguage]?[annotationsToAssign[i]] ?? ""
              }
            }
          } else {
            if prepAnnotationConversionDict[controllerLanguage] != nil {
              if prepAnnotationConversionDict[controllerLanguage]?[annotationsToAssign[i]] != nil {
                annotationToDisplay = prepAnnotationConversionDict[controllerLanguage]?[annotationsToAssign[i]] ?? ""
              }
            }
          }

          annotationBtn.setTitle(annotationToDisplay, for: .normal)
          KVC.view.addSubview(annotationBtn)
          annotationBtns.append(annotationBtn)
          if nounFormToColorDict.keys.contains(annotationToDisplay) {
            annotationColors.append(nounFormToColorDict[annotationsToAssign[i]]!)
          } else {
            annotationColors.append(UITraitCollection.current.userInterfaceStyle == .light ? .black : .white)
          }
          KVC.activateBtn(btn: annotationBtn)
          setBtn(btn: annotationBtn, color: annotationColors[i], name: "GetAnnotationInfo", canCap: false, isSpecial: false)

          if i != 0 {
            annotationSep = UIView(frame: CGRect(x: annotationBtn.frame.minX, y: annotationBtn.frame.minY, width: 1, height: annotationBtn.frame.height))
            annotationSep.isUserInteractionEnabled = false
            annotationSep.backgroundColor = UITraitCollection.current.userInterfaceStyle == .light ? keyColor : specialKeyColor
            KVC.view.addSubview(annotationSep)
            annotationSeparators.append(annotationSep)
          }
        }
      } else {
        return
      }
    }
  } else {
    return
  }
}

class Annotation: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  func style() {
    self.clipsToBounds = true
    self.layer.masksToBounds = false
    self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    self.setTitleColor(UITraitCollection.current.userInterfaceStyle == .light ? keyColor : specialKeyColor, for: .normal)
    if activateAnnotationBtn {
      self.layer.shadowColor = keyShadowColor
      self.layer.shadowOffset = CGSize(width: 0, height: 2)
      self.layer.shadowOpacity = 1.0
      self.layer.shadowRadius = 0
    }
  }

  func styleSingleAnnotation() {
    self.style()
    self.layer.cornerRadius = commandKeyCornerRadius / 2.5
  }

  func styleLeftAnnotation() {
    self.style()
    self.layer.cornerRadius = commandKeyCornerRadius / 2.5
    self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
  }

  func styleRightAnnotation() {
    self.style()
    self.layer.cornerRadius = commandKeyCornerRadius / 2.5
    self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]

  }

  func styleMiddleAnnotation() {
    self.style()
  }

  // First set the size, and then the location which is based on width for proper positioning.
  func setAnnotationSize(width: CGFloat, height: CGFloat, fontSize: CGFloat) {
    self.frame = CGRect(x: 0, y: 0, width: width, height: height)
    self.titleLabel?.font = .systemFont(ofSize: fontSize)
  }

  func setAnnotationLoc(minX: CGFloat, maxY: CGFloat) {
    self.frame = CGRect(x: minX, y: maxY, width: self.frame.width, height: self.frame.height)
  }
}
