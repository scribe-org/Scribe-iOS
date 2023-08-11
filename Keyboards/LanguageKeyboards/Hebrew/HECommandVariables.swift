//
//  HECommandVariables.swift
//
//  Variables associated with commands for the Hebrew Scribe keyboard.
//

func heSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }
}

/// What the conjugation state is for the conjugate feature.
enum HEConjugationState {
  case present
}

var heConjugationState: HEConjugationState = .present

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func heGetConjugationTitle() {}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func heGetConjugationState() {}

/// Action associated with the left view switch button of the conjugation state.
func heConjugationStateLeft() {}

/// Action associated with the right view switch button of the conjugation state.
func heConjugationStateRight() {}
