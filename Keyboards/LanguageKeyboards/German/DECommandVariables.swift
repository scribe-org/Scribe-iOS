//
//  DECommandVariables.swift
//
//  Variables associated with Scribe commands for the German keyboard.
//

func deSetConjugationLabels() {
  labelFPS = "ich"
  labelSPS = "du"
  labelTPS = "er/sie/es"
  labelFPP = "wir"
  labelSPP = "ihr"
  labelTPP = "sie/Sie"
}

/// What the conjugation state is for the conjugate feature.
enum DEConjugationState {
  case indicativePresent
  case indicativePreterite
  case indicativePerfect
}

var deConjugationState: DEConjugationState = .indicativePresent

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func deGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch deConjugationState {
  case .indicativePresent:
    return commandPromptSpacing + "Präsens: " + verbToDisplay
  case .indicativePreterite:
    return commandPromptSpacing + "Präteritum: " + verbToDisplay
  case .indicativePerfect:
    return commandPromptSpacing + "Perfekt: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func deGetConjugationState() -> String {
  switch deConjugationState {
  case .indicativePresent:
    return "pres"
  case .indicativePreterite:
    return "pret"
  case .indicativePerfect:
    return "perf"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func deConjugationStateLeft() {
  if deConjugationState == .indicativePresent {
    return
  } else if deConjugationState == .indicativePreterite {
    deConjugationState = .indicativePresent
    return
  } else if deConjugationState == .indicativePerfect {
    deConjugationState = .indicativePreterite
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func deConjugationStateRight() {
  if deConjugationState == .indicativePresent {
    deConjugationState = .indicativePreterite
  } else if deConjugationState == .indicativePreterite {
    deConjugationState = .indicativePerfect
    return
  } else if deConjugationState == .indicativePerfect {
    return
  }
}
