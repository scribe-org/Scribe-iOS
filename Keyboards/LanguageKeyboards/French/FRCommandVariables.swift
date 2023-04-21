//
//  FRCommandVariables.swift
//
//  Variables associated with Scribe commands for the French keyboard.
//

func frSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }

  formLabelsDict["FPS"] = "je"
  formLabelsDict["SPS"] = "tu"
  formLabelsDict["TPS"] = "il/elle"
  formLabelsDict["FPP"] = "nous"
  formLabelsDict["SPP"] = "vous"
  formLabelsDict["TPP"] = "ils/elles"
}

/// What the conjugation state is for the conjugate feature.
enum FRConjugationState {
  case indicativePresent
  case preterite
  case imperfect
  case future
}

var frConjugationState: FRConjugationState = .indicativePresent

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func frGetConjugationTitle() -> String {
  if inputWordIsCapitalized {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch frConjugationState {
  case .indicativePresent:
    return commandPromptSpacing + "Présent: " + verbToDisplay
  case .preterite:
    return commandPromptSpacing + "Passé simple: " + verbToDisplay
  case .imperfect:
    return commandPromptSpacing + "Imparfait: " + verbToDisplay
  case .future:
    return commandPromptSpacing + "Futur: " + verbToDisplay
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
  case .future:
    return "fut"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func frConjugationStateLeft() {
  switch frConjugationState {
  case .indicativePresent:
    break
  case .preterite:
    conjViewShiftButtonsState = .leftInactive
    frConjugationState = .indicativePresent
  case .imperfect:
    conjViewShiftButtonsState = .bothActive
    frConjugationState = .preterite
  case .future:
    conjViewShiftButtonsState = .bothActive
    frConjugationState = .imperfect
  }
}

/// Action associated with the right view switch button of the conjugation state.
func frConjugationStateRight() {
  switch frConjugationState {
  case .indicativePresent:
    conjViewShiftButtonsState = .bothActive
    frConjugationState = .preterite
  case .preterite:
    conjViewShiftButtonsState = .bothActive
    frConjugationState = .imperfect
  case .imperfect:
    conjViewShiftButtonsState = .rightInactive
    frConjugationState = .future
  case .future:
    break
  }
}
