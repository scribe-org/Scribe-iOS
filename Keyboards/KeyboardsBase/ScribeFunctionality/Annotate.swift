//
//  Annotate.swift
//
//  Functions and elements that control word annotations.
//

import UIKit

// Dictionary for accessing keyboard conjugation state.
var nounFormToColorDict: [String: UIColor] = [:]

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
func selectedWordAnnotation() {
//  let selectedWord = proxy.selectedText ?? ""
}

/// Annotates a typed word after a space or auto action.
func typedWordAnnotation() {
  if proxy.documentContextBeforeInput != nil {
//    let wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
//    let lastWordTyped = wordsTyped.secondToLast()
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
    self.layer.shadowColor = keyShadowColor
    self.layer.shadowOffset = CGSize(width: 0, height: 1.2)
    self.layer.shadowOpacity = 1.0
    self.layer.shadowRadius = 0
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
