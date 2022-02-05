//
//  PTCommandVariables.swift
//
//  Variables associated with Scribe commands for the Portuguese keyboard.
//

func ptSetConjugationLabels() {
  labelFPS = "eu"
  labelSPS = "tu"
  labelTPS = "ele/ela/você"
  labelFPP = "nós"
  labelSPP = "vós"
  labelTPP = "eles/elas/vocês"
}

/// What the conjugation state is for the conjugate feature.
enum PTConjugationState {
  case indicativePresent
  case pastPerfect
  case pastImperfect
  case futureSimple
}

var ptConjugationState: PTConjugationState = .indicativePresent

/// Sets the title of the preview bar when the keyboard is in conjugate mode.
func ptGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch ptConjugationState {
  case .indicativePresent:
    return previewPromptSpacing + "Presente: " + verbToDisplay
  case .pastPerfect:
    return previewPromptSpacing + "Pretérito Perfeito: " + verbToDisplay
  case .pastImperfect:
    return previewPromptSpacing + "Pretérito Imperfeito: " + verbToDisplay
  case .futureSimple:
    return previewPromptSpacing + "Futuro Simples: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func ptGetConjugationState() -> String {
  switch ptConjugationState {
  case .indicativePresent:
    return "pres"
  case .pastPerfect:
    return "perf"
  case .pastImperfect:
    return "imp"
  case .futureSimple:
    return "fSimp"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func ptConjugationStateLeft() {
  if ptConjugationState == .indicativePresent {
    return
  } else if ptConjugationState == .pastPerfect {
    ptConjugationState = .indicativePresent
    return
  } else if ptConjugationState == .pastImperfect {
    ptConjugationState = .pastPerfect
    return
  } else if ptConjugationState == .futureSimple {
    ptConjugationState = .pastImperfect
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func ptConjugationStateRight() {
  if ptConjugationState == .indicativePresent {
    ptConjugationState = .pastPerfect
  } else if ptConjugationState == .pastPerfect {
    ptConjugationState = .pastImperfect
    return
  } else if ptConjugationState == .pastImperfect {
    ptConjugationState = .futureSimple
    return
  } else if ptConjugationState == .futureSimple {
    return
  }
}
