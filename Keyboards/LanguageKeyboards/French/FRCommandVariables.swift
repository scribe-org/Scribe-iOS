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
}

var frConjugationState: FRConjugationState = .indicativePresent

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func frGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
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
  switch frConjugationState {
  case .indicativePresent:
    break
  case .preterite:
    conjViewShiftButtonsState = .leftInactive
    frConjugationState = .indicativePresent
  case .imperfect:
    conjViewShiftButtonsState = .bothActive
    frConjugationState = .preterite
  }
}

/// Action associated with the right view switch button of the conjugation state.
func frConjugationStateRight() {
  switch frConjugationState {
  case .indicativePresent:
    conjViewShiftButtonsState = .bothActive
    frConjugationState = .preterite
  case .preterite:
    conjViewShiftButtonsState = .rightInactive
    frConjugationState = .imperfect
  case .imperfect:
    break
  }
}
