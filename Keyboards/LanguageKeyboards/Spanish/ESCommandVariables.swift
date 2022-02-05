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

/// Sets the title of the preview bar when the keyboard is in conjugate mode.
func esGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch esConjugationState {
  case .indicativePresent:
    return previewPromptSpacing + "Presente: " + verbToDisplay
  case .preterite:
    return previewPromptSpacing + "Pretérito: " + verbToDisplay
  case .imperfect:
    return previewPromptSpacing + "Imperfecto: " + verbToDisplay
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
  if esConjugationState == .indicativePresent {
    return
  } else if esConjugationState == .preterite {
    esConjugationState = .indicativePresent
    return
  } else if esConjugationState == .imperfect {
    esConjugationState = .preterite
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func esConjugationStateRight() {
  if esConjugationState == .indicativePresent {
    esConjugationState = .preterite
  } else if esConjugationState == .preterite {
    esConjugationState = .imperfect
    return
  } else if esConjugationState == .imperfect {
    return
  }
}
