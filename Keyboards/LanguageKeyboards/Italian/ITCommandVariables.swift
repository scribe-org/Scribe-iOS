//
//  ITCommandVariables.swift
//
//  Variables associated with Scribe commands for the Italian keyboard.
//

func itSetConjugationLabels() {
  labelFPS = "io"
  labelSPS = "tu"
  labelTPS = "lei/lui"
  labelFPP = "noi"
  labelSPP = "voi"
  labelTPP = "loro"
}

/// What the conjugation state is for the conjugate feature.
enum ITConjugationState {
  case present
  case preterite
  case imperfect
}

var itConjugationState: ITConjugationState = .present

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func itGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch itConjugationState {
  case .present:
    return commandPromptSpacing + "Presente: " + verbToDisplay
  case .preterite:
    return commandPromptSpacing + "Preterito: " + verbToDisplay
  case .imperfect:
    return commandPromptSpacing + "Imperfetto: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func itGetConjugationState() -> String {
  switch itConjugationState {
  case .present:
    return "pres"
  case .preterite:
    return "pret"
  case .imperfect:
    return "perf"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func itConjugationStateLeft() {
  if itConjugationState == .present {
    return
  } else if itConjugationState == .preterite {
    itConjugationState = .present
    return
  } else if itConjugationState == .imperfect {
    itConjugationState = .preterite
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func itConjugationStateRight() {
  if itConjugationState == .present {
    itConjugationState = .preterite
  } else if itConjugationState == .preterite {
    itConjugationState = .imperfect
    return
  } else if itConjugationState == .imperfect {
    return
  }
}
