// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Variables associated with commands for the Norwegian Bokmål Scribe keyboard.
 */

// Command Variables for Norwegian Conjugation
func nbSetConjugationLabels() {
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }
  
  formLabelsDict["FPS"] = "jeg"    // I
  formLabelsDict["SPS"] = "du"     // you (informal)
  formLabelsDict["TPS"] = "han/henne/det" // he/she/it
  formLabelsDict["FPP"] = "vi"     // we
  formLabelsDict["SPP"] = "dere"   // you (plural)
  formLabelsDict["TPP"] = "de"     // they
}

// Conjugation State
enum NBConjugationState {
  case present
}

var nbConjugationState: NBConjugationState = .present

// Get Conjugation Title for Norwegian
func nbGetConjugationTitle() -> String {
  let verbToDisplay = verbToConjugate
  switch nbConjugationState {
  case .present:
    return commandPromptSpacing + "Presens: " + verbToDisplay
  }
}

// Get Conjugation State
func nbGetConjugationState() -> String {
  switch nbConjugationState {
  case .present:
    return "pres"
  }
}

// Handle Left Action for Conjugation State
func nbConjugationStateLeft() {
  switch nbConjugationState {
  case .present:
    // Transition to other states if applicable
    break
  }
}

// Handle Right Action for Conjugation State
func nbConjugationStateRight() {
  switch nbConjugationState {
  case .present:
    // Transition to other states if applicable
    break
  }
}
