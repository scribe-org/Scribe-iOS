//
//  Conjugation.swift
//
//  Functions and elements that control the conjugation command.
//

import UIKit

// Dictionary for accessing keyboard conjugation state.
let keyboardConjTitleDict: [String: Any] = [
  "French": frGetConjugationTitle,
  "German": deGetConjugationTitle,
  "Italian": itGetConjugationTitle,
  "Portuguese": ptGetConjugationTitle,
  "Russian": ruGetConjugationTitle,
  "Spanish": esGetConjugationTitle,
  "Swedish": svGetConjugationTitle
]

// Dictionary for accessing keyboard conjugation state.
let keyboardConjStateDict: [String: Any] = [
  "French": frGetConjugationState,
  "German": deGetConjugationState,
  "Italian": itGetConjugationState,
  "Portuguese": ptGetConjugationState,
  "Russian": ruGetConjugationState,
  "Spanish": esGetConjugationState,
  "Swedish": svGetConjugationState
]

// Dictionary for accessing keyboard conjugation state.
let keyboardConjLabelDict: [String: Any] = [
  "French": frSetConjugationLabels,
  "German": deSetConjugationLabels,
  "Italian": itSetConjugationLabels,
  "Portuguese": ptSetConjugationLabels,
  "Russian": ruSetConjugationLabels,
  "Spanish": esSetConjugationLabels,
  "Swedish": svSetConjugationLabels
]

/// Triggers the display of the conjugation view for a valid verb in the command bar.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
func triggerVerbConjugation(commandBar: UILabel) -> Bool {
  // Cancel via a return press.
  if commandBar.text! == conjugatePromptAndCursor || commandBar.text! == conjugatePromptAndPlaceholder {
    return false
  }
  verbToConjugate = (commandBar.text!.substring(with: conjugatePrompt.count..<(commandBar.text!.count) - 1))
  verbToConjugate = String(verbToConjugate.trailingSpacesTrimmed)

  // Check to see if the input was uppercase to return an uppercase conjugation.
  let firstLetter = verbToConjugate.substring(toIdx: 1)
  inputWordIsCapitalized = firstLetter.isUppercase
  verbToConjugate = verbToConjugate.lowercased()

  return verbs?[verbToConjugate] != nil
}

/// Returns a conjugation once a user presses a key in the conjugateView.
///
/// - Parameters
///   - keyPressed: the button pressed as sender.
///   - requestedTense: the tense that is triggered by the given key.
func returnConjugation(keyPressed: UIButton, requestedTense: String) {
  // Don't change proxy if they select a conjugation that's missing.
  if keyPressed.titleLabel?.text == invalidCommandMsg {
    proxy.insertText("")
  } else if conjugateAlternateView == false {
    if commandState == .selectCaseConjugation {
      wordToReturn = keyPressed.titleLabel?.text ?? ""
      proxy.insertText(wordToReturn + " ")
    } else if deConjugationState != .indicativePerfect {
      wordToReturn = verbs?[verbToConjugate]![requestedTense] as! String
      if inputWordIsCapitalized == true {
        proxy.insertText(wordToReturn.capitalized + " ")
      } else {
        proxy.insertText(wordToReturn + " ")
      }
    } else {
      proxy.insertText(verbs?[verbToConjugate]!["pastParticiple"] as! String + " ")
    }
  } else if conjugateAlternateView == true {
    wordToReturn = verbs?[verbToConjugate]![requestedTense] as! String
    if inputWordIsCapitalized == true {
      proxy.insertText(wordToReturn.capitalized + " ")
    } else {
      proxy.insertText(wordToReturn + " ")
    }
  }
  commandState = .idle
}

/// Returns the conjugation state to its initial conjugation based on the keyboard language.
func resetVerbConjugationState() {
  if controllerLanguage == "French" {
    frConjugationState = .indicativePresent
  } else if controllerLanguage == "German" {
    deConjugationState = .indicativePresent
  } else if controllerLanguage == "Italian" {
    itConjugationState = .present
  } else if controllerLanguage == "Portuguese" {
    ptConjugationState = .indicativePresent
  } else if controllerLanguage == "Russian" {
    ruConjugationState = .present
  } else if controllerLanguage == "Spanish" {
    esConjugationState = .indicativePresent
  } else if controllerLanguage == "Swedish" {
    svConjugationState = .active
  }
}

/// Returns the conjugation state to its initial conjugation based on the keyboard language.
func resetCaseConjugationState() {
  // The case conjugation display starts on the left most case.
  if controllerLanguage == "German" {
    if prepAnnotationForm.contains("Acc") {
      deCaseConjugationState = .accusative
    } else if prepAnnotationForm.contains("Dat") {
      deCaseConjugationState = .dative
    } else {
      deCaseConjugationState = .genitive
    }
  } else if controllerLanguage == "Russian" {
    if prepAnnotationForm.contains("Acc") {
      ruCaseConjugationState = .accusative
    } else if prepAnnotationForm.contains("Dat") {
      ruCaseConjugationState = .dative
    } else if prepAnnotationForm.contains("Gen") {
      ruCaseConjugationState = .genitive
    } else if prepAnnotationForm.contains("Pre") {
      ruCaseConjugationState = .prepositional
    } else {
      ruCaseConjugationState = .instrumental
    }
  }
}

/// Runs an action associated with the left view switch button of the conjugation state based on the keyboard language.
func conjugationStateLeft() {
  if controllerLanguage == "French" {
    frConjugationStateLeft()
  } else if controllerLanguage == "German" {
    deConjugationStateLeft()
  } else if controllerLanguage == "Italian" {
    itConjugationStateLeft()
  } else if controllerLanguage == "Portuguese" {
    ptConjugationStateLeft()
  } else if controllerLanguage == "Russian" {
    ruConjugationStateLeft()
  } else if controllerLanguage == "Spanish" {
    esConjugationStateLeft()
  } else if controllerLanguage == "Swedish" {
    svConjugationStateLeft()
  }
}

/// Runs an action associated with the right view switch button of the conjugation state based on the keyboard language.
func conjugationStateRight() {
  if controllerLanguage == "French" {
    frConjugationStateRight()
  } else if controllerLanguage == "German" {
    deConjugationStateRight()
  } else if controllerLanguage == "Italian" {
    itConjugationStateRight()
  } else if controllerLanguage == "Portuguese" {
    ptConjugationStateRight()
  } else if controllerLanguage == "Russian" {
    ruConjugationStateRight()
  } else if controllerLanguage == "Spanish" {
    esConjugationStateRight()
  } else if controllerLanguage == "Swedish" {
    svConjugationStateRight()
  }
}
