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
  case accusativePossesive
  case dative
  case dativePossesive
  case genitivePossesive
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
  case .accusativePossesive:
    return commandPromptSpacing + "Akkusativ Possessiv + (en/e/(e)s/e)"
  case .dative:
    return commandPromptSpacing + "Dativ Pronomen"
  case .dativePossesive:
    return commandPromptSpacing + "Dativ Possessiv + (em/er/em/en)"
  case .genitivePossesive:
    return commandPromptSpacing + "Genitiv Possessiv + (s/r/s/r)"
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
func deSetCaseConjugations() {
  switch deCaseConjugationState {
  case .accusative:
    conjFPS = "mich"
    conjSPS = "dich"
    conjTPS = "ihn/sie/es"
    conjFPP = "uns"
    conjSPP = "euch"
    conjTPP = "sie/Sie"
  case .accusativePossesive:
    conjFPS = "mein"
    conjSPS = "dein"
    conjTPS = "sein/ihr/sein"
    conjFPP = "unser"
    conjSPP = "eur"
    conjTPP = "ihr/Ihr"
  case .dative:
    conjFPS = "mir"
    conjSPS = "dir"
    conjTPS = "ihm/ihr/ihm"
    conjFPP = "uns"
    conjSPP = "euch"
    conjTPP = "ihnen/Ihnen"
  case .dativePossesive:
    conjFPS = "mein"
    conjSPS = "dein"
    conjTPS = "sein/ihr/sein"
    conjFPP = "unser"
    conjSPP = "eur"
    conjTPP = "ihr/Ihr"
  case .genitivePossesive:
    conjFPS = "meine"
    conjSPS = "deine"
    conjTPS = "seine/ihre"
    conjFPP = "unsere"
    conjSPP = "eure"
    conjTPP = "ihre"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func deConjugationStateLeft() {
  if commandState == .selectCaseConjugation {
    switch deCaseConjugationState {
    case .accusative:
      return
    case .accusativePossesive:
      deCaseConjugationState = .accusative
    case .dative:
      deCaseConjugationState = .accusativePossesive
    case .dativePossesive:
      deCaseConjugationState = .dative
    case .genitivePossesive:
      deCaseConjugationState = .dativePossesive
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
    switch deCaseConjugationState {
    case .accusative:
      deCaseConjugationState = .accusativePossesive
    case .accusativePossesive:
      deCaseConjugationState = .dative
    case .dative:
      deCaseConjugationState = .dativePossesive
    case .dativePossesive:
      deCaseConjugationState = .genitivePossesive
    case .genitivePossesive:
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
