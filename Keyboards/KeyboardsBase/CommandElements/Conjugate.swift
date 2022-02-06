//
//  Conjugation.swift
//
//  Functions and elements that control the conjugation command.
//

import UIKit

/// Triggers the display of the conjugation view for a valid verb in the preview bar.
func queryConjugation(commandBar: UILabel) -> Bool {
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
