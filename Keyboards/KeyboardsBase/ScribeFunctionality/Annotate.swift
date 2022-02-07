//
//  Annotate.swift
//
//  Functions and elements that control word annotations.
//

import UIKit

/// Hides the annotation display so that it can be selectively shown to the user as needed.
func hideAnnotations(annotationDisplay: [UILabel]) {
  for idx in 0..<annotationDisplay.count {
    annotationDisplay[idx].backgroundColor = UIColor.clear
    annotationDisplay[idx].text = ""
  }
}

/// Sets the annotation of an annotation element given parameters.
///
/// - Parameters
///  - elem: the element to change the appearance of to show annotations.
///  - annotation: the annotation to set to the element.
func setAnnotation(elem: UILabel, annotation: String) {
  var annotationToDisplay = annotation

  if scribeKeyState != true { // Cancel if typing while commands are displayed.
    if prepAnnotationState == false {
      if controllerLanguage == "Swedish" {
        if annotation == "C" {
          annotationToDisplay = "U"
        }
      } else if controllerLanguage == "Russian" {
        if annotation == "F" {
          annotationToDisplay = "Ж"
        } else if annotation == "M" {
          annotationToDisplay = "М"
        } else if annotation == "N" {
          annotationToDisplay = "Н"
        } else if annotation == "PL" {
          annotationToDisplay = "МН"
        }
      }

      if annotation == "PL" {
        // Make text smaller to fit the annotation.
        if DeviceType.isPhone {
          elem.font = .systemFont(ofSize: annotationHeight * 0.6)
        } else if DeviceType.isPad {
          elem.font = .systemFont(ofSize: annotationHeight * 0.8)
        }
      } else {
        if DeviceType.isPhone {
          elem.font = .systemFont(ofSize: annotationHeight * 0.70)
        } else if DeviceType.isPad {
          elem.font = .systemFont(ofSize: annotationHeight * 0.95)
        }
      }

      if annotation == "F" {
        elem.backgroundColor = annotateRed
      } else if annotation == "M" {
        elem.backgroundColor = annotateBlue
      } else if annotation == "C" {
        elem.backgroundColor = annotatePurple
      } else if annotation == "N" {
        elem.backgroundColor = annotateGreen
      } else if annotation == "PL" {
        elem.backgroundColor = annotateOrange
      }
    } else {
      if controllerLanguage == "German" {
        if annotation == "Acc" {
          annotationToDisplay = "Akk"
        }
      } else if controllerLanguage == "Russian" {
        if annotation == "Acc" {
          annotationToDisplay = "Вин"
        } else if annotation == "Dat" {
          annotationToDisplay = "Дат"
        } else if annotation == "Gen" {
          annotationToDisplay = "Род"
        } else if annotation == "Loc" {
          annotationToDisplay = "Мес"
        } else if annotation == "Pre" {
          annotationToDisplay = "Пре"
        } else if annotation == "Ins" {
          annotationToDisplay = "Инс"
        }
      }
      if DeviceType.isPhone {
        elem.font = .systemFont(ofSize: annotationHeight * 0.65)
      } else if DeviceType.isPad {
        elem.font = .systemFont(ofSize: annotationHeight * 0.85)
      }
      elem.backgroundColor = keyCharColor
    }
    elem.text = annotationToDisplay
  }
}

/// Checks if a word is a noun and annotates the command bar if so.
///
/// - Parameters
///   - givenWord: a word that is potentially a noun.
func nounAnnotation(
  commandBar: UILabel,
  nounAnnotationDisplay: [UILabel],
  annotationDisplay: [UILabel],
  givenWord: String) {
  // Check to see if the input was uppercase to return an uppercase annotation.
  inputWordIsCapitalized = false
  var wordToCheck: String = ""
  if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
    let firstLetter = givenWord.substring(toIdx: 1)
    inputWordIsCapitalized = firstLetter.isUppercase
    wordToCheck = givenWord.lowercased()
  } else {
    wordToCheck = givenWord
  }

  let isNoun = nouns?[wordToCheck] != nil || nouns?[givenWord.lowercased()] != nil
  if isNoun {
    // Clear the prior annotations to assure that preposition annotations don't persist.
    hideAnnotations(annotationDisplay: annotationDisplay)
    nounAnnotationsToDisplay = 0

    // Make command bar font larger for annotation.
    if DeviceType.isPhone {
      commandBar.font = .systemFont(ofSize: annotationHeight * 0.8)
    } else if DeviceType.isPad {
      commandBar.font = .systemFont(ofSize: annotationHeight)
    }

    let nounForm = nouns?[wordToCheck]?["form"] as? String
    if nounForm == "" {
      return
    } else {
      // Count how many annotations will be changed.
      var numberOfAnnotations: Int = 0
      var annotationsToAssign: [String] = [String]()
      if nounForm?.count ?? 0 >= 3 { // Would have a slash as the largest is PL
        annotationsToAssign = (nounForm?.components(separatedBy: "/"))!
        numberOfAnnotations = annotationsToAssign.count
      } else {
        numberOfAnnotations = 1
        annotationsToAssign.append(nounForm ?? "")
      }

      // To be passed to preposition annotations.
      nounAnnotationsToDisplay = numberOfAnnotations

      for idx in 0..<numberOfAnnotations {
        setAnnotation(elem: nounAnnotationDisplay[idx], annotation: annotationsToAssign[idx])
      }

      if nounForm == "F" {
        commandBar.textColor = annotateRed
      } else if nounForm == "M" {
        commandBar.textColor = annotateBlue
      } else if nounForm == "C" {
        commandBar.textColor = annotatePurple
      } else if nounForm ==  "N" {
        commandBar.textColor = annotateGreen
      } else if nounForm ==  "PL" {
        commandBar.textColor = annotateOrange
      } else {
        commandBar.textColor = keyCharColor
      }

      let wordSpacing = String(
        repeating: " ",
        count: ( numberOfAnnotations * 7 ) - ( numberOfAnnotations - 1 )
      )
      if invalidState != true {
        if inputWordIsCapitalized == false {
          commandBar.text = commandPromptSpacing + wordSpacing + wordToCheck
        } else {
          commandBar.text = commandPromptSpacing + wordSpacing + wordToCheck.capitalized
        }
      }
    }
    wordToCheck = wordToCheck.lowercased() // in case it was capitalized for German
    let isPrep = prepositions?[wordToCheck] != nil
    // Pass the preposition state so that if it's false nounAnnotationsToDisplay can be made 0.
    if isPrep {
      prepAnnotationState = true
    }
  }
}

/// Annotates the command bar with the form of a valid selected noun.
func selectedNounAnnotation(
  commandBar: UILabel,
  nounAnnotationDisplay: [UILabel],
  annotationDisplay: [UILabel]) {
  let selectedWord = proxy.selectedText ?? ""

  nounAnnotation(
    commandBar: commandBar,
    nounAnnotationDisplay: nounAnnotationDisplay,
    annotationDisplay: annotationDisplay,
    givenWord: selectedWord
  )
}

/// Annotates the command bar with the form of a valid typed noun.
func typedNounAnnotation(
  commandBar: UILabel,
  nounAnnotationDisplay: [UILabel],
  annotationDisplay: [UILabel]) {
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

/// Checks if a word is a preposition and annotates the command bar if so.
///
/// - Parameters
///   - givenWord: a word that is potentially a preposition.
func prepositionAnnotation(
  commandBar: UILabel,
  prepAnnotationDisplay: [UILabel],
  givenWord: String) {
  // Check to see if the input was uppercase to return an uppercase annotation.
  inputWordIsCapitalized = false
  let firstLetter = givenWord.substring(toIdx: 1)
  inputWordIsCapitalized = firstLetter.isUppercase
  let wordToCheck = givenWord.lowercased()

  // Check if prepAnnotationState has been passed and reset nounAnnotationsToDisplay if not.
  if prepAnnotationState == false {
    nounAnnotationsToDisplay = 0
  }

  let isPreposition = prepositions?[wordToCheck] != nil
  if isPreposition {
    prepAnnotationState = true
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
      setAnnotation(elem: prepAnnotationDisplay[idx], annotation: annotationsToAssign[idx])
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
    if inputWordIsCapitalized == false {
      commandBar.text = commandPromptSpacing + wordSpacing + wordToCheck
    } else {
      commandBar.text = commandPromptSpacing + wordSpacing + wordToCheck.capitalized
    }
  }
}

/// Annotates the command bar with the form of a valid selected preposition.
func selectedPrepAnnotation(
  commandBar: UILabel,
  prepAnnotationDisplay: [UILabel]) {
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
func typedPrepAnnotation(
  commandBar: UILabel,
  prepAnnotationDisplay: [UILabel]) {
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
