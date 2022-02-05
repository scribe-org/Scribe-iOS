//
//  FRCommandVaribles.swift
//
//  Variables associated with Scribe commands for the French keyboard.
//

func frSetConjugationLabels() {
  labelFPS = "je"
  labelSPS = "tu"
  labelTPS = "il/elle"
  labelFPP = "nous"
  labelSPP = "vous"
  labelTPP = "ils/elles"
}

/// What the conjugation state is for the conjugate feature.
enum FRConjugationState {
  case indicativePresent
  case preterite
  case imperfect
}

var frConjugationState: FRConjugationState = .indicativePresent

/// Sets the title of the preview bar when the keyboard is in conjugate mode.
func frGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch frConjugationState {
  case .indicativePresent:
    return previewPromptSpacing + "Présent: " + verbToDisplay
  case .preterite:
    return previewPromptSpacing + "Passé simple: " + verbToDisplay
  case .imperfect:
    return previewPromptSpacing + "Imparfait: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func frGetConjugationState() -> String {
  switch frConjugationState {
  case .indicativePresent:
    return "pres"
  case .preterite:
    return "pret"
  case .imperfect:
    return "imp"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func frConjugationStateLeft() {
  if frConjugationState == .indicativePresent {
    return
  } else if frConjugationState == .preterite {
    frConjugationState = .indicativePresent
    return
  } else if frConjugationState == .imperfect {
    frConjugationState = .preterite
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func frConjugationStateRight() {
  if frConjugationState == .indicativePresent {
    frConjugationState = .preterite
  } else if frConjugationState == .preterite {
    frConjugationState = .imperfect
    return
  } else if frConjugationState == .imperfect {
    return
  }
}
