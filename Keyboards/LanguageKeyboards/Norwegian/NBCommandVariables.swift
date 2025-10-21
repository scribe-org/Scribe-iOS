// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Variables associated with commands for the Norwegian Bokmål Scribe keyboard.
 */
func nbSetConjugationLabels() {
  // Reset all form labels prior to assignment.
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

/// What the conjugation state is for the conjugate feature.
enum NBConjugationState {
  case present
}

var nbConjugationState: NBConjugationState = .present

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func nbGetConjugationTitle() -> String {
  let verbToDisplay = verbToConjugate
  switch nbConjugationState {
  case .present:
    return commandPromptSpacing + "Presens: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func nbGetConjugationState() -> String {
  switch nbConjugationState {
  case .present:
    return "pres"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func nbConjugationStateLeft() {
  switch nbConjugationState {
  case .present:
    // Transition to other states if applicable
    break
  }
}

/// Action associated with the right view switch button of the conjugation state.
func nbConjugationStateRight() {
  switch nbConjugationState {
  case .present:
    // Transition to other states if applicable
    break
  }
}
