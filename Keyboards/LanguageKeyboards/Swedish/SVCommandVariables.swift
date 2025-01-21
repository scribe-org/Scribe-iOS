// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Variables associated with commands for the Swedish Scribe keyboard.
 */

func svSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }

  switch svConjugationState {
  case .active:
    formLabelsDict["TL"] = "imperativ"
    formLabelsDict["TR"] = "liggande"
    formLabelsDict["BL"] = "presens"
    formLabelsDict["BR"] = "dåtid"
  case .passive:
    formLabelsDict["TL"] = "infinitiv"
    formLabelsDict["TR"] = "liggande"
    formLabelsDict["BL"] = "presens"
    formLabelsDict["BR"] = "dåtid"
  }
}

/// What the conjugation state is for the conjugate feature.
enum SVConjugationState {
  case active
  case passive
}

var svConjugationState: SVConjugationState = .active

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func svGetConjugationTitle() -> String {
  if inputWordIsCapitalized {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch svConjugationState {
  case .active:
    return commandPromptSpacing + "Aktiv: " + verbToDisplay
  case .passive:
    return commandPromptSpacing + "Passiv: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func svGetConjugationState() -> [String] {
  switch svConjugationState {
  case .active:
    return ["imperative", "activeSupine", "activePresent", "activePreterite"]
  case .passive:
    return ["passiveInfinitive", "passiveSupine", "passivePresent", "passivePreterite"]
  }
}

/// Action associated with the left view switch button of the conjugation state.
func svConjugationStateLeft() {
  switch svConjugationState {
  case .active:
    break
  case .passive:
    conjViewShiftButtonsState = .leftInactive
    svConjugationState = .active
  }
}

/// Action associated with the right view switch button of the conjugation state.
func svConjugationStateRight() {
  switch svConjugationState {
  case .active:
    conjViewShiftButtonsState = .rightInactive
    svConjugationState = .passive
  case .passive:
    break
  }
}
