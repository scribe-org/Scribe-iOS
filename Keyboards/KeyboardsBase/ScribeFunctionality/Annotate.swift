/**
 * Functions and elements that control word annotations.
 *
 * Copyright (C) 2024 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import UIKit

// Dictionary for accessing keyboard conjugation state.
var nounFormToColorDict = [
  "F": annotateRed,
  "M": annotateBlue,
  "C": annotatePurple,
  "U": annotatePurple,
  "N": annotateGreen,
  "PL": annotateOrange,
  "Ж": annotateRed,
  "М": annotateBlue,
  "Н": annotateGreen,
  "МН": annotateOrange
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

/// The base function for annotation that's accessed by `typedWordAnnotation`.
///
/// - Parameters
///   - wordToAnnotate: the word that an annotation should be created for.
///   - KVC: the keyboard view controller.
func wordAnnotation(wordToAnnotate: String, KVC: KeyboardViewController) {
  let nounForm = LanguageDBManager.shared.queryNounForm(of: wordToAnnotate)[0]
  prepAnnotationForm = LanguageDBManager.shared.queryPrepForm(of: wordToAnnotate.lowercased())[0]

  hasNounForm = !nounForm.isEmpty
  hasPrepForm = !prepAnnotationForm.isEmpty

  annotationsToAssign = [String]()
  annotationBtns = [UIButton]()
  annotationColors = [UIColor]()
  annotationSeparators = [UIView]()

  let annotationFieldWidth = KVC.translateKey.frame.width * 0.85
  let annotationHeight = KVC.scribeKey.frame.height

  if wordToAnnotate == "Scribe" || wordToAnnotate == "scribe" {
    // Thank the user :)
    annotationState = true
    activateAnnotationBtn = true
    autoAction0Visible = false

    let annotationBtn = Annotation()
    annotationBtn.setAnnotationSize(
      width: annotationFieldWidth, height: annotationHeight, fontSize: annotationHeight * 0.55
    )
    annotationBtn.setAnnotationLoc(
      minX: KVC.translateKey.frame.origin.x
        + (KVC.translateKey.frame.width / 2)
        - (annotationFieldWidth / 2),
      maxY: KVC.scribeKey.frame.origin.y
    )
    annotationBtn.styleSingleAnnotation(fullAnnotation: true)

    let emojisToSelectFrom = "🥳🎉"
    let emojis = String((0 ..< 3).compactMap { _ in emojisToSelectFrom.randomElement() })
    annotationBtn.setTitle(emojis, for: .normal)
    KVC.view.addSubview(annotationBtn)
    annotationBtns.append(annotationBtn)
    annotationColors.append(commandKeyColor)

    KVC.activateBtn(btn: annotationBtn)
    setBtn(
      btn: annotationBtn, color: commandKeyColor, name: "ScribeAnnotation", canBeCapitalized: false, isSpecial: false
    )
  } else {
    if hasNounForm {
      if !nounForm.contains("/") {
        annotationsToAssign.append(nounForm)
      } else {
        for a in nounForm.components(separatedBy: "/") {
          annotationsToAssign.append(a)
        }
      }
    }

    if hasPrepForm {
      activateAnnotationBtn = true
      if !prepAnnotationForm.contains("/") {
        annotationsToAssign.append(prepAnnotationForm)
      } else {
        for a in prepAnnotationForm.components(separatedBy: "/") {
          annotationsToAssign.append(a)
        }
      }
    }

    let numAnnotations = annotationsToAssign.count
    if numAnnotations > 0 {
      annotationState = true
      autoAction0Visible = false

      let annotationWidth = annotationFieldWidth / CGFloat(annotationsToAssign.count)

      for i in 0 ..< numAnnotations {
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
            + (KVC.translateKey.frame.width / 2)
            - (annotationFieldWidth / 2)
            + (annotationWidth * CGFloat(i)),
          maxY: KVC.scribeKey.frame.origin.y
        )
        if numAnnotations == 1 {
          annotationBtn.styleSingleAnnotation(fullAnnotation: true)
        } else if i == 0 {
          annotationBtn.styleLeftAnnotation(fullAnnotation: true)
        } else if i == numAnnotations - 1 {
          annotationBtn.styleRightAnnotation(fullAnnotation: true)
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
          if let annotationColor = nounFormToColorDict[annotationsToAssign[i]] {
            annotationColors.append(annotationColor)
          }
        } else {
          annotationColors.append(UITraitCollection.current.userInterfaceStyle == .light ? .black : .white)
        }
        if activateAnnotationBtn {
          KVC.activateBtn(btn: annotationBtn)
        }
        setBtn(
          btn: annotationBtn,
          color: annotationColors[i],
          name: "GetAnnotationInfo",
          canBeCapitalized: false,
          isSpecial: false
        )

        if i != 0 {
          annotationSep = UIView(
            frame: CGRect(
              x: annotationBtn.frame.minX, y: annotationBtn.frame.minY, width: 1, height: annotationBtn.frame.height
            )
          )
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
///
/// - Parameters
///   - KVC: the keyboard view controller.
func typedWordAnnotation(KVC: KeyboardViewController) {
  guard let documentContextBeforeInput = proxy.documentContextBeforeInput, !documentContextBeforeInput.isEmpty else {
    return
  }

  wordsTyped = documentContextBeforeInput.components(separatedBy: " ")

  guard let lastWordTyped = wordsTyped.secondToLast() else {
    return
  }

  if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
    wordToCheck = lastWordTyped.lowercased()
  } else {
    wordToCheck = lastWordTyped
  }

  wordAnnotation(wordToAnnotate: wordToCheck, KVC: KVC)
}

/// Annotates nouns during autocomplete and autosuggest.
///
/// - Parameters
///   - autoActionWord: the word within an auto action that could be annotated.
///   - index: the auto action key index that the annotation should be set for.
///   - KVC: the keyboard view controller.
func autoActionAnnotation(autoActionWord: String, index: Int, KVC: KeyboardViewController) {
  let nounForm = LanguageDBManager.shared.queryNounForm(of: autoActionWord)[0]

  hasNounForm = !nounForm.isEmpty

  newAutoActionAnnotationsToAssign = [String]()
  newAutoActionAnnotationBtns = [UIButton]()
  newAutoActionAnnotationColors = [UIColor]()
  newAutoActionAnnotationSeparators = [UIView]()

  let annotationFieldWidth = KVC.translateKey.frame.width * 0.85
  let annotationHeight = KVC.scribeKey.frame.height * 0.1

  if hasNounForm {
    if !nounForm.contains("/") {
      newAutoActionAnnotationsToAssign.append(nounForm)
    } else {
      for a in nounForm.components(separatedBy: "/") {
        newAutoActionAnnotationsToAssign.append(a)
      }
    }
  }

  let numAnnotations = newAutoActionAnnotationsToAssign.count
  if numAnnotations > 0 {
    let annotationWidth = annotationFieldWidth / CGFloat(newAutoActionAnnotationsToAssign.count)

    for i in 0 ..< numAnnotations {
      let annotationBtn = Annotation()
      var annotationSep = UIView()

      if numAnnotations > 3 {
        annotationBtn.setAnnotationSize(
          width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.4
        )
      } else if numAnnotations > 2 {
        annotationBtn.setAnnotationSize(
          width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.55
        )
      } else {
        annotationBtn.setAnnotationSize(
          width: annotationWidth, height: annotationHeight, fontSize: annotationHeight * 0.6
        )
      }

      if index == 0 {
        annotationBtn.setAnnotationLoc(
          minX: KVC.translateKey.frame.origin.x
            + (KVC.translateKey.frame.width / 2)
            - (annotationFieldWidth / 2)
            + (annotationWidth * CGFloat(i)),
          maxY: KVC.translateKey.frame.origin.y + KVC.translateKey.frame.height - KVC.scribeKey.frame.height * 0.1
        )
      } else if index == 1 {
        annotationBtn.setAnnotationLoc(
          minX: KVC.conjugateKey.frame.origin.x
            + (KVC.conjugateKey.frame.width / 2)
            - (annotationFieldWidth / 2)
            + (annotationWidth * CGFloat(i)),
          maxY: KVC.conjugateKey.frame.origin.y + KVC.conjugateKey.frame.height - KVC.scribeKey.frame.height * 0.1
        )
      } else if index == 2 {
        annotationBtn.setAnnotationLoc(
          minX: KVC.pluralKey.frame.origin.x
            + (KVC.pluralKey.frame.width / 2)
            - (annotationFieldWidth / 2)
            + (annotationWidth * CGFloat(i)),
          maxY: KVC.pluralKey.frame.origin.y + KVC.pluralKey.frame.height - KVC.scribeKey.frame.height * 0.1
        )
      }

      if numAnnotations == 1 {
        annotationBtn.styleSingleAnnotation(fullAnnotation: false)
      } else if i == 0 {
        annotationBtn.styleLeftAnnotation(fullAnnotation: false)
      } else if i == numAnnotations - 1 {
        annotationBtn.styleRightAnnotation(fullAnnotation: false)
      } else {
        annotationBtn.styleMiddleAnnotation()
      }

      KVC.view.addSubview(annotationBtn)
      autoActionAnnotationBtns.append(annotationBtn)
      if let annotationColor = nounFormToColorDict[newAutoActionAnnotationsToAssign[i]] {
        let colorWithAlpha = annotationColor.withAlphaComponent(0.75)
        newAutoActionAnnotationColors.append(colorWithAlpha)
      }

      setBtn(
        btn: annotationBtn,
        color: newAutoActionAnnotationColors[i],
        name: "GetAnnotationInfo",
        canBeCapitalized: false,
        isSpecial: false
      )
      // Allow for interaction with the button beneath the annotation.
      annotationBtn.isUserInteractionEnabled = false

      if i != 0 {
        annotationSep = UIView(
          frame: CGRect(
            x: annotationBtn.frame.minX, y: annotationBtn.frame.minY, width: 1, height: annotationBtn.frame.height
          )
        )
        annotationSep.isUserInteractionEnabled = false
        annotationSep.backgroundColor = UITraitCollection.current.userInterfaceStyle == .light ? keyColor : specialKeyColor
        KVC.view.addSubview(annotationSep)
        autoActionAnnotationSeparators.append(annotationSep)
      }
    }
  } else {
    return
  }
}

/// UIButton class for annotation styling.
class Annotation: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  func style() {
    clipsToBounds = true
    layer.masksToBounds = false
    contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
    setTitleColor(UITraitCollection.current.userInterfaceStyle == .light ? keyColor : specialKeyColor, for: .normal)
    if activateAnnotationBtn {
      layer.shadowColor = keyShadowColor
      layer.shadowOffset = CGSize(width: 0, height: 1.25)
      layer.shadowOpacity = 1.0
      layer.shadowRadius = 0
    }
  }

  func styleSingleAnnotation(fullAnnotation: Bool) {
    style()
    if fullAnnotation {
      layer.cornerRadius = commandKeyCornerRadius / 2.5
    } else {
      layer.cornerRadius = commandKeyCornerRadius / 5
    }
  }

  func styleLeftAnnotation(fullAnnotation: Bool) {
    style()
    if fullAnnotation {
      layer.cornerRadius = commandKeyCornerRadius / 2.5
    } else {
      layer.cornerRadius = commandKeyCornerRadius / 5
    }
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
  }

  func styleRightAnnotation(fullAnnotation: Bool) {
    style()
    if fullAnnotation {
      layer.cornerRadius = commandKeyCornerRadius / 2.5
    } else {
      layer.cornerRadius = commandKeyCornerRadius / 5
    }
    layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
  }

  func styleMiddleAnnotation() {
    style()
  }

  // First set the size, and then the location which is based on width for proper positioning.
  func setAnnotationSize(width: CGFloat, height: CGFloat, fontSize: CGFloat) {
    frame = CGRect(x: 0, y: 0, width: width, height: height)
    titleLabel?.font = .systemFont(ofSize: fontSize)
  }

  func setAnnotationLoc(minX: CGFloat, maxY: CGFloat) {
    frame = CGRect(x: minX, y: maxY, width: frame.width, height: frame.height)
  }
}
