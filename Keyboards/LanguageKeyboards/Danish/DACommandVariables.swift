// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Variables associated with commands for the Danish Scribe keyboard.
 */

func daSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }
}

/// What the conjugation state is for the conjugate feature.
enum DAConjugationState {
  case present
}

var daConjugationState: DAConjugationState = .present

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func daGetConjugationTitle() {}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func daGetConjugationState() {}

/// Action associated with the left view switch button of the conjugation state.
func daConjugationStateLeft() {}

/// Action associated with the right view switch button of the conjugation state.
func daConjugationStateRight() {}
