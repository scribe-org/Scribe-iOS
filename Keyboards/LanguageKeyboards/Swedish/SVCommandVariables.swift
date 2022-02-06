//
//  SVCommandVariables.swift
//
//  Variables associated with Scribe commands for the Swedish keyboard.
//

func svSetConjugationLabels() {
  switch svConjugationState {
  case .active:
    labelTopLeft = "imperativ"
    labelTopRight = "liggande"
    labelBottomLeft = "presens"
    labelBottomRight = "dåtid"
  case .passive:
    labelTopLeft = "infinitiv"
    labelTopRight = "liggande"
    labelBottomLeft = "presens"
    labelBottomRight = "dåtid"
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
  if inputWordIsCapitalized == true {
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
  if svConjugationState == .active {
    return
  } else if svConjugationState == .passive {
    svConjugationState = .active
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func svConjugationStateRight() {
  if svConjugationState == .active {
    svConjugationState = .passive
  } else if svConjugationState == .passive {
    return
  }
}
