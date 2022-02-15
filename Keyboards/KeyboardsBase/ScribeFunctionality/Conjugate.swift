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
func triggerConjugation(commandBar: UILabel) -> Bool {
  // Cancel via a return press.
  if commandBar.text! == conjugatePromptAndCursor {
    return false
  }
  verbToConjugate = (commandBar.text!.substring(with: conjugatePrompt.count..<(commandBar.text!.count) - 1))
  verbToConjugate = String(verbToConjugate.trailingSpacesTrimmed)

  // Check to see if the input was uppercase to return an uppercase conjugation.
  inputWordIsCapitalized = false
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
    if deConjugationState != .indicativePerfect {
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
  commandState = false
  conjugateView = false
}
