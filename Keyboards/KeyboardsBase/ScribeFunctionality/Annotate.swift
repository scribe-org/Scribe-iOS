//
//  Annotate.swift
//
//  Functions and elements that control word annotations.
//

import UIKit

// Dictionary for accessing keyboard conjugation state.
let formToColorDict: [String: UIColor] = [
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
let caseAnnotationConversionDict = [
  "German": ["Acc": "Akk"],
  "Russian": ["Acc": "Вин", "Dat": "Дат", "Gen": "Род", "Loc": "Мес", "Pre": "Пре", "Ins": "Инс"]
]

/// Hides the annotation display so that it can be selectively shown to the user as needed.
///
/// - Parameters
///   - annotationDisplay: the full annotation display elements.
func hideAnnotations(annotationDisplay: [UILabel]) {
  for idx in 0..<annotationDisplay.count {
    annotationDisplay[idx].backgroundColor = .clear
    annotationDisplay[idx].text = ""
  }
}

/// Sets the annotation of an noun annotation element given parameters.
///
/// - Parameters
///  - label: the label to change the appearance of to show annotations.
///  - annotation: the annotation to set to the element.
func setNounAnnotation(label: UILabel, annotation: String) {
  var annotationToDisplay: String = annotation

  if ![.translate, .conjugate, .plural].contains(commandState) { // Cancel if typing while commands are displayed.
    // Convert annotation into the keyboard language if necessary.
    if nounAnnotationConversionDict[controllerLanguage] != nil {
      if nounAnnotationConversionDict[controllerLanguage]?[annotation] != nil {
        annotationToDisplay = nounAnnotationConversionDict[controllerLanguage]?[annotation] ?? ""
      }
    }

    if annotation == "PL" {
      // Make text smaller to fit the annotation.
      if DeviceType.isPhone {
        label.font = .systemFont(ofSize: annotationHeight * 0.6)
      } else if DeviceType.isPad {
        label.font = .systemFont(ofSize: annotationHeight * 0.8)
      }
    } else {
      if DeviceType.isPhone {
        label.font = .systemFont(ofSize: annotationHeight * 0.70)
      } else if DeviceType.isPad {
        label.font = .systemFont(ofSize: annotationHeight * 0.95)
      }
    }

    // Assign color and text to the label.
    label.backgroundColor = formToColorDict[annotation]
    label.text = annotationToDisplay
  }
}

/// Checks if a word is a noun and annotates the command bar if so.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
///   - nounAnnotationDisplay: the part of the annotation display that's for nouns.
///   - annotationDisplay: the full annotation display elements.
///   - givenWord: a word that is potentially a noun.
func nounAnnotation(
  commandBar: UILabel,
  nounAnnotationDisplay: [UILabel],
  annotationDisplay: [UILabel],
  givenWord: String
) {
  // Convert the given word to lower case unless nouns are capitalized in the language.
  var wordToCheck: String = ""
  if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
    wordToCheck = givenWord.lowercased()
  } else {
    wordToCheck = givenWord
  }

  let isNoun = nouns?[wordToCheck] != nil || nouns?[givenWord.lowercased()] != nil
  if isNoun {
    autoAction1Visible = false

    // Clear the prior annotations to assure that preposition annotations don't persist.
    hideAnnotations(annotationDisplay: annotationDisplay)
    nounAnnotationsToDisplay = 0

    // Make command bar font larger for annotation.
    if DeviceType.isPhone {
      commandBar.font = .systemFont(ofSize: annotationHeight * 0.8)
    } else if DeviceType.isPad {
      commandBar.font = .systemFont(ofSize: annotationHeight)
    }

    let nounForm: String = nouns?[wordToCheck]?["form"] as! String
    if nounForm == "" {
      return
    } else {
      // Count how many annotations will be changed.
      var numberOfAnnotations: Int = 0
      var annotationsToAssign: [String] = [String]()
      if nounForm.count >= 3 { // Would have a slash as the largest is PL
        annotationsToAssign = (nounForm.components(separatedBy: "/"))
        numberOfAnnotations = annotationsToAssign.count
      } else {
        numberOfAnnotations = 1
        annotationsToAssign.append(nounForm)
      }

      for idx in 0..<numberOfAnnotations {
        setNounAnnotation(label: nounAnnotationDisplay[idx], annotation: annotationsToAssign[idx])
      }

      if formToColorDict[nounForm] != nil {
        commandBar.textColor = formToColorDict[nounForm]
      } else {
        commandBar.textColor = keyCharColor
      }

      let wordSpacing = String(
        repeating: " ",
        count: ( numberOfAnnotations * 7 ) - ( numberOfAnnotations - 1 )
      )

      if ![.alreadyPlural, .invalid].contains(commandState) {
        if DeviceType.isPhone {
          if commandPromptSpacing.count + wordSpacing.count > 9 {
            annotationDisplayWord = givenWord.prefix(2) + "..."
            if commandPromptSpacing.count + wordSpacing.count > 15 {
              annotationDisplayWord = givenWord.prefix(1) + ""
            }
          } else {
            annotationDisplayWord = givenWord
          }
        } else if DeviceType.isPad {
          annotationDisplayWord = givenWord
        }

        commandBar.text = commandPromptSpacing + wordSpacing + annotationDisplayWord
      }

      // Check if it's a preposition and pass information to prepositionAnnotation if so.
      let isPrep = prepositions?[wordToCheck.lowercased()] != nil
      nounAnnotationsToDisplay = numberOfAnnotations
      if isPrep { prepAnnotationState = true }
    }
  }
}

/// Annotates the command bar with the form of a valid selected noun.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
///   - nounAnnotationDisplay: the part of the annotation display that's for nouns.
///   - annotationDisplay: the full annotation display elements.
func selectedNounAnnotation(
  commandBar: UILabel,
  nounAnnotationDisplay: [UILabel],
  annotationDisplay: [UILabel]
) {
  let selectedWord = proxy.selectedText ?? ""

  nounAnnotation(
    commandBar: commandBar,
    nounAnnotationDisplay: nounAnnotationDisplay,
    annotationDisplay: annotationDisplay,
    givenWord: selectedWord
  )
}

/// Annotates the command bar with the form of a valid typed noun.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
///   - nounAnnotationDisplay: the part of the annotation display that's for nouns.
///   - annotationDisplay: the full annotation display elements.
func typedNounAnnotation(
  commandBar: UILabel,
  nounAnnotationDisplay: [UILabel],
  annotationDisplay: [UILabel]
) {
  if proxy.documentContextBeforeInput != nil {
    let wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
    let lastWordTyped = wordsTyped.secondToLast()

    if lastWordTyped != "" {
      nounAnnotation(
        commandBar: commandBar,
        nounAnnotationDisplay: nounAnnotationDisplay,
        annotationDisplay: annotationDisplay,
        givenWord: lastWordTyped ?? ""
      )
    }
  }
}

/// Sets the annotation of an preposition annotation element given parameters.
///
/// - Parameters
///  - label: the label to change the appearance of to show annotations.
///  - annotation: the annotation to set to the element.
func setPrepAnnotation(label: UILabel, annotation: String) {
  var annotationToDisplay: String = annotation

  if commandState == .idle {
    // Convert annotation into the keyboard language if necessary.
    if caseAnnotationConversionDict[controllerLanguage] != nil {
      if caseAnnotationConversionDict[controllerLanguage]?[annotation] != nil {
        annotationToDisplay = caseAnnotationConversionDict[controllerLanguage]?[annotation] ?? ""
      }
    }

    if DeviceType.isPhone {
      label.font = .systemFont(ofSize: annotationHeight * 0.65)
    } else if DeviceType.isPad {
      label.font = .systemFont(ofSize: annotationHeight * 0.85)
    }

    // Assign color and text to the label.
    label.backgroundColor = keyCharColor
    label.text = annotationToDisplay
  }
}

/// Checks if a word is a preposition and annotates the command bar if so.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
///   - prepAnnotationDisplay: the part of the annotation display that's for prepositions.
///   - givenWord: a word that is potentially a preposition.
func prepositionAnnotation(
  commandBar: UILabel,
  prepAnnotationDisplay: [UILabel],
  givenWord: String
) {
  // Check to see if the input was uppercase to return an uppercase annotation.
  let wordToCheck = givenWord.lowercased()

  // Check if prepAnnotationState has been passed and reset nounAnnotationsToDisplay if not.
  if prepAnnotationState == false {
    nounAnnotationsToDisplay = 0
  }

  let isPreposition = prepositions?[wordToCheck] != nil
  if isPreposition {
    prepAnnotationState = true
    autoAction1Visible = false

    // Make command bar font larger for annotation.
    if DeviceType.isPhone {
      commandBar.font = .systemFont(ofSize: annotationHeight * 0.8)
    } else if DeviceType.isPad {
      commandBar.font = .systemFont(ofSize: annotationHeight)
    }
    commandBar.textColor = keyCharColor

    guard let prepositionCase: String = prepositions?[wordToCheck] as? String else { return }

    var numberOfAnnotations: Int = 0
    var annotationsToAssign: [String] = [String]()
    if prepositionCase.count >= 4 { // Would have a slash as they all are three characters long
      annotationsToAssign = (prepositionCase.components(separatedBy: "/"))
      numberOfAnnotations = annotationsToAssign.count
    } else {
      numberOfAnnotations = 1
      annotationsToAssign.append(prepositionCase)
    }

    for idx in 0..<numberOfAnnotations {
      setPrepAnnotation(
        label: prepAnnotationDisplay[idx],
        annotation: annotationsToAssign[idx]
      )
    }
    // Cancel the state to allow for symbol coloration in selection annotation without calling loadKeys.
    prepAnnotationState = false

    let wordSpacing = String(
      repeating: " ",
      count:
      ( nounAnnotationsToDisplay * 7 )
      - ( nounAnnotationsToDisplay - 1 )
      + ( numberOfAnnotations * 9 )
      - ( numberOfAnnotations - 1 )
    )

    if DeviceType.isPhone {
      if commandPromptSpacing.count + wordSpacing.count > 9 && givenWord.count > 3 {
        annotationDisplayWord = givenWord.prefix(3) + "..."
        if commandPromptSpacing.count + wordSpacing.count > 14 && givenWord.count > 2 {
          annotationDisplayWord = givenWord.prefix(1) + "..."
        }
        if commandPromptSpacing.count + wordSpacing.count > 18 {
          annotationDisplayWord = givenWord.prefix(1) + ""
        }
        if commandPromptSpacing.count + wordSpacing.count > 22 {
          annotationDisplayWord = ""
        }
      } else {
        annotationDisplayWord = givenWord
      }
    } else if DeviceType.isPad {
      annotationDisplayWord = givenWord
    }

    commandBar.text = commandPromptSpacing + wordSpacing + annotationDisplayWord
  }
}

/// Annotates the command bar with the form of a valid selected preposition.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
///   - prepAnnotationDisplay: the part of the annotation display that's for prepositions.
func selectedPrepAnnotation(
  commandBar: UILabel,
  prepAnnotationDisplay: [UILabel]
) {
  if languagesWithCaseDependantOnPrepositions.contains(controllerLanguage) {
    let selectedWord = proxy.selectedText ?? ""

    prepositionAnnotation(
      commandBar: commandBar,
      prepAnnotationDisplay: prepAnnotationDisplay,
      givenWord: selectedWord
    )
  }
}

/// Annotates the command bar with the form of a valid typed preposition.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
///   - prepAnnotationDisplay: the part of the annotation display that's for prepositions.
func typedPrepAnnotation(
  commandBar: UILabel,
  prepAnnotationDisplay: [UILabel]
) {
  if languagesWithCaseDependantOnPrepositions.contains(controllerLanguage) {
    if proxy.documentContextBeforeInput != nil {
      let wordsTyped = proxy.documentContextBeforeInput!.components(separatedBy: " ")
      let lastWordTyped = wordsTyped.secondToLast()

      if lastWordTyped != "" {
        prepositionAnnotation(
          commandBar: commandBar,
          prepAnnotationDisplay: prepAnnotationDisplay,
          givenWord: lastWordTyped ?? ""
        )
      }
    }
  }
}
