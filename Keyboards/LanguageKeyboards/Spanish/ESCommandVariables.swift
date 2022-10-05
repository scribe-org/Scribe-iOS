//
//  ESCommandVariables.swift
//
//  Variables associated with Scribe commands for the Spanish keyboard.
//

func esSetConjugationLabels() {
  labelFPS = "yo"
  labelSPS = "tú"
  labelTPS = "él/ella/Ud."
  labelFPP = "nosotros"
  labelSPP = "vosotros"
  labelTPP = "ellos/ellas/Uds."
}

/// What the conjugation state is for the conjugate feature.
enum ESConjugationState {
  case indicativePresent
  case preterite
  case imperfect
}

var esConjugationState: ESConjugationState = .indicativePresent

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func esGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch esConjugationState {
  case .indicativePresent:
    return commandPromptSpacing + "Presente: " + verbToDisplay
  case .preterite:
    return commandPromptSpacing + "Pretérito: " + verbToDisplay
  case .imperfect:
    return commandPromptSpacing + "Imperfecto: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func esGetConjugationState() -> String {
  switch esConjugationState {
  case .indicativePresent:
    return "pres"
  case .preterite:
    return "pret"
  case .imperfect:
    return "imp"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func esConjugationStateLeft() {
  switch esConjugationState {
  case .indicativePresent:
    break
  case .preterite:
    esConjugationState = .indicativePresent
  case .imperfect:
    esConjugationState = .preterite
  }
}

/// Action associated with the right view switch button of the conjugation state.
func esConjugationStateRight() {
  switch esConjugationState {
  case .indicativePresent:
    esConjugationState = .preterite
  case .preterite:
    esConjugationState = .imperfect
  case .imperfect:
    break
  }
}
