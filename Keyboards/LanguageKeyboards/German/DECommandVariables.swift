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

/// What the conjugation state is for the case conjugate feature.
enum DECaseConjugationState {
  case accusative
  case dative
  case genitive
}

var deConjugationState: DEConjugationState = .indicativePresent
var deCaseConjugationState: DECaseConjugationState = .accusative

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

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func deGetCaseConjugationTitle() -> String {
  switch deCaseConjugationState {
  case .accusative:
    return commandPromptSpacing + "Akkusativ Pronomen"
  case .dative:
    return commandPromptSpacing + "Dativ Pronomen"
  case .genitive:
    return commandPromptSpacing + "Genitiv Possessivpronomen"
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

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func deSetCaseCojugations() {
  switch deCaseConjugationState {
  case .accusative:
    conjFPS = "mich"
    conjSPS = "dich"
    conjTPS = "ihn/sie/es"
    conjFPP = "uns"
    conjSPP = "euch"
    conjTPP = "sie/Sie"
  case .dative:
    conjFPS = "mir"
    conjSPS = "dir"
    conjTPS = "ihm/ihr/ihm"
    conjFPP = "uns"
    conjSPP = "euch"
    conjTPP = "ihnen/Ihnen"
  case .genitive:
    conjFPS = "meine(s/r)"
    conjSPS = "deine(s/r)"
    conjTPS = "seine(s/r)/ihre(s/r)"
    conjFPP = "unsere(s/r)"
    conjSPP = "eure(s/r)"
    conjTPP = "ihre(s/r)"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func deConjugationStateLeft() {
  if commandState == .selectCaseConjugation {
    if deCaseConjugationState == .accusative {
      return
    } else if deCaseConjugationState == .dative {
      deCaseConjugationState = .accusative
    } else if deCaseConjugationState == .genitive {
      deCaseConjugationState = .dative
    }
  } else {
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
}

/// Action associated with the right view switch button of the conjugation state.
func deConjugationStateRight() {
  if commandState == .selectCaseConjugation {
    if deCaseConjugationState == .accusative {
      deCaseConjugationState = .dative
    } else if deCaseConjugationState == .dative {
      deCaseConjugationState = .genitive
    } else if deCaseConjugationState == .genitive {
      return
    }
  } else {
    if deConjugationState == .indicativePresent {
      deConjugationState = .indicativePreterite
    } else if deConjugationState == .indicativePreterite {
      deConjugationState = .indicativePerfect
      return
    } else if deConjugationState == .indicativePerfect {
      return
    }
  }
}
