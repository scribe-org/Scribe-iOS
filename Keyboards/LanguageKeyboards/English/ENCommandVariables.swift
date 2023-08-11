//
//  ENCommandVariables.swift
//
//  Variables associated with commands for the English Scribe keyboard.
//

func enSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }
}

/// What the conjugation state is for the conjugate feature.
enum ENConjugationState {
  case present
}

var enConjugationState: ENConjugationState = .present

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func enGetConjugationTitle() {}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func enGetConjugationState() {}

/// Action associated with the left view switch button of the conjugation state.
func enConjugationStateLeft() {}

/// Action associated with the right view switch button of the conjugation state.
func enConjugationStateRight() {}
