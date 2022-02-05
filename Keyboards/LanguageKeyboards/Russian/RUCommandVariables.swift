//
//  RUCommandVariables.swift
//
//  Variables associated with Scribe commands for the Russian keyboard.
//

func ruSetConjugationLabels() {
  switch ruConjugationState {
  case .present:
    labelFPS = "я"
    labelSPS = "ты"
    labelTPS = "он/она/оно"
    labelFPP = "мы"
    labelSPP = "вы"
    labelTPP = "они"
    labelTopLeft = ""
    labelTopRight = ""
    labelBottomLeft = ""
    labelBottomRight = ""
  case .past:
    labelFPS = ""
    labelSPS = ""
    labelTPS = ""
    labelFPP = ""
    labelSPP = ""
    labelTPP = ""
    labelTopLeft = "я/ты/он"
    labelTopRight = "я/ты/она"
    labelBottomLeft = "оно"
    labelBottomRight = "мы/вы/они"
  }
}

/// What the conjugation state is for the conjugate feature.
enum RUConjugationState {
  case present
  case past
}

var ruConjugationState: RUConjugationState = .present

/// Sets the title of the preview bar when the keyboard is in conjugate mode.
func ruGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch ruConjugationState {
  case .present:
    return previewPromptSpacing + "Настоящее: " + verbToDisplay
  case .past:
    return previewPromptSpacing + "Прошедшее: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func ruGetConjugationState() -> String {
  switch ruConjugationState {
  case .present:
    return "pres"
  case .past:
    return "past"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func ruConjugationStateLeft() {
  if ruConjugationState == .present {
    return
  } else if ruConjugationState == .past {
    ruConjugationState = .present
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func ruConjugationStateRight() {
  if ruConjugationState == .present {
    ruConjugationState = .past
    return
  } else if ruConjugationState == .past {
    return
  }
}
