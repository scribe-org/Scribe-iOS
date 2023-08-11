//
//  NBCommandVariables.swift
//
//  Variables associated with commands for the Norwegian Bokmål Scribe keyboard.
//

func nbSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }
}

/// What the conjugation state is for the conjugate feature.
enum NBConjugationState {
  case present
}

var nbConjugationState: NBConjugationState = .present

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func nbGetConjugationTitle() {}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func nbGetConjugationState() {}

/// Action associated with the left view switch button of the conjugation state.
func nbConjugationStateLeft() {}

/// Action associated with the right view switch button of the conjugation state.
func nbConjugationStateRight() {}
