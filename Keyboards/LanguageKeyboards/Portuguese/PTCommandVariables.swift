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

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func ptGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch ptConjugationState {
  case .indicativePresent:
    return commandPromptSpacing + "Presente: " + verbToDisplay
  case .pastPerfect:
    return commandPromptSpacing + "Pretérito Perfeito: " + verbToDisplay
  case .pastImperfect:
    return commandPromptSpacing + "Pretérito Imperfeito: " + verbToDisplay
  case .futureSimple:
    return commandPromptSpacing + "Futuro Simples: " + verbToDisplay
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
  switch ptConjugationState {
  case .indicativePresent:
    break
  case .pastPerfect:
    ptConjugationState = .indicativePresent
  case .pastImperfect:
    ptConjugationState = .pastPerfect
  case .futureSimple:
    ptConjugationState = .pastImperfect
  }
}

/// Action associated with the right view switch button of the conjugation state.
func ptConjugationStateRight() {
  switch ptConjugationState {
  case .indicativePresent:
    ptConjugationState = .pastPerfect
  case .pastPerfect:
    ptConjugationState = .pastImperfect
  case .pastImperfect:
    ptConjugationState = .futureSimple
  case .futureSimple:
    break
  }
}
