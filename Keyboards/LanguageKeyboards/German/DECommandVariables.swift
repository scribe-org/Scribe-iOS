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

func deSetCaseConjugationLabels() {
  if [.accusative, .dative, .genitive].contains(deCaseConjugationState) {
    labelFPS = ""
    labelSPS = ""
    labelTPS = ""
    labelFPP = ""
    labelSPP = ""
    labelTPP = ""
    labelTopLeft = "M"
    labelTopRight = "F"
    labelBottomLeft = "N"
    labelBottomRight = "PL"
  } else {
    labelFPS = "ich"
    labelSPS = "du/Sie"
    labelTPS = "er/sie/es"
    labelFPP = "wir"
    labelSPP = "ihr"
    labelTPP = "sie"
    labelTopLeft = ""
    labelTopRight = ""
    labelBottomLeft = ""
    labelBottomRight = ""
  }
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
  case accusativePersonal
  case accusativePossesive
  case dative
  case dativePersonal
  case dativePossesive
  case genitive
  case genitivePersonal
  case genitivePossesive
}

/// Allows for switching the conjugation view to select from pronoun options based on noun genders.
enum DECaseGenderConjugationState {
  case none
  case accusativePersonal2PS
  case accusativePersonal3PS
  case accusativePossesive1PS
  case accusativePossesive2PS
  case accusativePossesive2PSInformal
  case accusativePossesive2PSFormal
  case accusativePossesive3PS
  case accusativePossesive3PSMasculine
  case accusativePossesive3PSFeminine
  case accusativePossesive3PSNeutral
  case accusativePossesive1PP
  case accusativePossesive2PP
  case accusativePossesive3PP
  case dativePersonal2PS
  case dativePersonal3PS
  case dativePossesive1PS
  case dativePossesive2PS
  case dativePossesive2PSInformal
  case dativePossesive2PSFormal
  case dativePossesive3PS
  case dativePossesive3PSMasculine
  case dativePossesive3PSFeminine
  case dativePossesive3PSNeutral
  case dativePossesive1PP
  case dativePossesive2PP
  case dativePossesive3PP
  case genitivePersonal2PS
  case genitivePersonal3PS
  case genitivePossesive1PS
  case genitivePossesive2PS
  case genitivePossesive2PSInformal
  case genitivePossesive2PSFormal
  case genitivePossesive3PS
  case genitivePossesive3PSMasculine
  case genitivePossesive3PSFeminine
  case genitivePossesive3PSNeutral
  case genitivePossesive1PP
  case genitivePossesive2PP
  case genitivePossesive3PP
}

var deConjugationState: DEConjugationState = .indicativePresent
var deCaseConjugationState: DECaseConjugationState = .accusative
var deCaseGenderConjugationState: DECaseGenderConjugationState = .none

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
  if deCaseGenderConjugationState == .none {
    switch deCaseConjugationState {
    case .accusative:
      return commandPromptSpacing + "Akkusativ Pronomen"
    case .accusativePersonal:
      return commandPromptSpacing + "Akkusativ Personalpronomen"
    case .accusativePossesive:
      return commandPromptSpacing + "Akkusativ Possessivpronomen"
    case .dative:
      return commandPromptSpacing + "Dativ Pronomen"
    case .dativePersonal:
      return commandPromptSpacing + "Dativ Personalpronomen"
    case .dativePossesive:
      return commandPromptSpacing + "Dativ Possessivpronomen"
    case .genitive:
      return commandPromptSpacing + "Genitiv Pronomen"
    case .genitivePersonal:
      return commandPromptSpacing + "Genitiv Personalpronomen"
    case .genitivePossesive:
      return commandPromptSpacing + "Genitiv Possessivpronomen"
    }
  } else {
    switch deCaseGenderConjugationState {
    case .none:
      return "" // placeholder
    case .accusativePersonal2PS, .accusativePersonal3PS, .accusativePossesive2PS, .accusativePossesive3PS,
        .dativePersonal2PS, .dativePersonal3PS, .dativePossesive2PS, .dativePossesive3PS,
        .genitivePersonal2PS, .genitivePersonal3PS, .genitivePossesive2PS, .genitivePossesive3PS:
      return commandPromptSpacing + "Geschlecht des Subjekts?"
    case .accusativePossesive1PS, .accusativePossesive2PSInformal, .accusativePossesive2PSFormal,
        .accusativePossesive3PSMasculine, .accusativePossesive3PSFeminine, .accusativePossesive3PSNeutral,
        .accusativePossesive1PP, .accusativePossesive2PP, .accusativePossesive3PP,
        .dativePossesive1PS, .dativePossesive2PSInformal, .dativePossesive2PSFormal,
        .dativePossesive3PSMasculine, .dativePossesive3PSFeminine, .dativePossesive3PSNeutral,
        .dativePossesive1PP, .dativePossesive2PP, .dativePossesive3PP,
        .genitivePossesive1PS, .genitivePossesive2PSInformal, .genitivePossesive2PSFormal,
        .genitivePossesive3PSMasculine, .genitivePossesive3PSFeminine, .genitivePossesive3PSNeutral,
        .genitivePossesive1PP, .genitivePossesive2PP, .genitivePossesive3PP:
      return commandPromptSpacing + "Geschlecht des Objekts?"
    }
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

/// Returns the appropriate pronoun options given the case.
func deSetCaseConjugations() {
  switch deCaseConjugationState {
  case .accusative:
    conjTopLeft = "den"
    conjTopRight = "die"
    conjBottomLeft = "das"
    conjBottomRight = "die"
  case .accusativePersonal:
    conjFPS = "mich"
    conjSPS = "dich/Sie"
    conjTPS = "ihn/sie/es"
    conjFPP = "uns"
    conjSPP = "euch"
    conjTPP = "sie"
  case .dative:
    conjTopLeft = "dem"
    conjTopRight = "der"
    conjBottomLeft = "dem"
    conjBottomRight = "den"
  case .dativePersonal:
    conjFPS = "mir"
    conjSPS = "dir/Ihnen"
    conjTPS = "ihm/ihr/ihm"
    conjFPP = "uns"
    conjSPP = "euch"
    conjTPP = "ihnen"
  case .genitive:
    conjTopLeft = "des"
    conjTopRight = "der"
    conjBottomLeft = "des"
    conjBottomRight = "der"
  case .genitivePersonal:
    conjFPS = "meiner"
    conjSPS = "deiner/Ihrer"
    conjTPS = "seiner/ihrer/seiner"
    conjFPP = "unser"
    conjSPP = "euer"
    conjTPP = "ihrer"
  case .accusativePossesive, .dativePossesive, .genitivePossesive:
    conjFPS = "mein+"
    conjSPS = "dein+/Ihr+"
    conjTPS = "sein+/ihr+/sein+"
    conjFPP = "unser+"
    conjSPP = "euer+"
    conjTPP = "ihr+"
  }
}

/// Returns the appropriate options for a selection within the case conjugation table.
func deSetCaseGenderConjugations() {
  switch deCaseGenderConjugationState {
  case .none:
    break
  case .accusativePersonal2PS:
    conjLeft = "dich"
    conjRight = "Sie"
  case .accusativePersonal3PS:
    conjTop = "ihn"
    conjMiddle = "sie"
    conjBottom = "es"
  case .dativePersonal2PS:
    conjLeft = "dir"
    conjRight = "Ihnen"
  case .dativePersonal3PS:
    conjTop = "ihm"
    conjMiddle = "ihr"
    conjBottom = "ihm"
  case .genitivePersonal2PS:
    conjLeft = "deiner"
    conjRight = "Ihrer"
  case .genitivePersonal3PS:
    conjTop = "seiner"
    conjMiddle = "ihrer"
    conjBottom = "seiner"
  case .accusativePossesive2PS, .dativePossesive2PS, .genitivePossesive2PS:
    conjLeft = "dein+"
    conjRight = "Ihr+"
  case .accusativePossesive3PS, .dativePossesive3PS, .genitivePossesive3PS:
    conjTop = "sein+"
    conjMiddle = "ihr+"
    conjBottom = "sein+"
  case .accusativePossesive1PS:
    conjTopLeft = "meinen"
    conjTopRight = "meine"
    conjBottomLeft = "mein"
    conjBottomRight = "meine"
  case .accusativePossesive2PSInformal:
    conjTopLeft = "deinen"
    conjTopRight = "deine"
    conjBottomLeft = "dein"
    conjBottomRight = "deine"
  case .accusativePossesive2PSFormal:
    conjTopLeft = "Ihren"
    conjTopRight = "Ihre"
    conjBottomLeft = "Ihr"
    conjBottomRight = "Ihre"
  case .accusativePossesive3PSMasculine:
    conjTopLeft = "seinen"
    conjTopRight = "seine"
    conjBottomLeft = "sein"
    conjBottomRight = "seine"
  case .accusativePossesive3PSFeminine:
    conjTopLeft = "ihren"
    conjTopRight = "ihre"
    conjBottomLeft = "ihr"
    conjBottomRight = "ihre"
  case .accusativePossesive3PSNeutral:
    conjTopLeft = "seinen"
    conjTopRight = "seine"
    conjBottomLeft = "sein"
    conjBottomRight = "seine"
  case .accusativePossesive1PP:
    conjTopLeft = "unsren"
    conjTopRight = "unsre"
    conjBottomLeft = "unser"
    conjBottomRight = "unsre"
  case .accusativePossesive2PP:
    conjTopLeft = "euren"
    conjTopRight = "eure"
    conjBottomLeft = "euer"
    conjBottomRight = "eure"
  case .accusativePossesive3PP:
    conjTopLeft = "ihren"
    conjTopRight = "ihre"
    conjBottomLeft = "ihr"
    conjBottomRight = "ihre"
  case .dativePossesive1PS:
    conjTopLeft = "meinem"
    conjTopRight = "meiner"
    conjBottomLeft = "meinem"
    conjBottomRight = "meinen"
  case .dativePossesive2PSInformal:
    conjTopLeft = "deinem"
    conjTopRight = "deiner"
    conjBottomLeft = "deinem"
    conjBottomRight = "deinen"
  case .dativePossesive2PSFormal:
    conjTopLeft = "Ihrem"
    conjTopRight = "Ihrer"
    conjBottomLeft = "Ihrem"
    conjBottomRight = "Ihren"
  case .dativePossesive3PSMasculine:
    conjTopLeft = "seinem"
    conjTopRight = "seiner"
    conjBottomLeft = "seinem"
    conjBottomRight = "seinen"
  case .dativePossesive3PSFeminine:
    conjTopLeft = "ihrem"
    conjTopRight = "ihrer"
    conjBottomLeft = "ihrem"
    conjBottomRight = "ihren"
  case .dativePossesive3PSNeutral:
    conjTopLeft = "seinem"
    conjTopRight = "seiner"
    conjBottomLeft = "seinem"
    conjBottomRight = "seinen"
  case .dativePossesive1PP:
    conjTopLeft = "unsrem"
    conjTopRight = "unsrer"
    conjBottomLeft = "unsrem"
    conjBottomRight = "unsren"
  case .dativePossesive2PP:
    conjTopLeft = "eurem"
    conjTopRight = "eurer"
    conjBottomLeft = "eurem"
    conjBottomRight = "euren"
  case .dativePossesive3PP:
    conjTopLeft = "ihrem"
    conjTopRight = "ihrer"
    conjBottomLeft = "ihrem"
    conjBottomRight = "ihren"
  case .genitivePossesive1PS:
    conjTopLeft = "meines"
    conjTopRight = "meiner"
    conjBottomLeft = "meines"
    conjBottomRight = "meiner"
  case .genitivePossesive2PSInformal:
    conjTopLeft = "deines"
    conjTopRight = "deiner"
    conjBottomLeft = "deines"
    conjBottomRight = "deiner"
  case .genitivePossesive2PSFormal:
    conjTopLeft = "Ihres"
    conjTopRight = "Ihrer"
    conjBottomLeft = "Ihres"
    conjBottomRight = "Ihrer"
  case .genitivePossesive3PSMasculine:
    conjTopLeft = "seines"
    conjTopRight = "seiner"
    conjBottomLeft = "seines"
    conjBottomRight = "seiner"
  case .genitivePossesive3PSFeminine:
    conjTopLeft = "ihres"
    conjTopRight = "ihr"
    conjBottomLeft = "ihres"
    conjBottomRight = "ihr"
  case .genitivePossesive3PSNeutral:
    conjTopLeft = "seines"
    conjTopRight = "seiner"
    conjBottomLeft = "seines"
    conjBottomRight = "seiner"
  case .genitivePossesive1PP:
    conjTopLeft = "unsres"
    conjTopRight = "unsrer"
    conjBottomLeft = "unsres"
    conjBottomRight = "unsrer"
  case .genitivePossesive2PP:
    conjTopLeft = "eures"
    conjTopRight = "eurer"
    conjBottomLeft = "eures"
    conjBottomRight = "eurer"
  case .genitivePossesive3PP:
    conjTopLeft = "ihres"
    conjTopRight = "ihrer"
    conjBottomLeft = "ihres"
    conjBottomRight = "ihrer"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func deConjugationStateLeft() {
  if commandState == .selectCaseConjugation {
    switch deCaseConjugationState {
    case .accusative:
      break
    case .accusativePersonal:
      deCaseConjugationState = .accusative
    case .accusativePossesive:
      deCaseConjugationState = .accusativePersonal
    case .dative:
      deCaseConjugationState = .accusativePossesive
    case .dativePersonal:
      deCaseConjugationState = .dative
    case .dativePossesive:
      deCaseConjugationState = .dativePersonal
    case .genitive:
      deCaseConjugationState = .dativePossesive
    case .genitivePersonal:
      deCaseConjugationState = .genitive
    case .genitivePossesive:
      deCaseConjugationState = .genitivePersonal
    }
  } else {
    switch deConjugationState {
    case .indicativePresent:
      break
    case .indicativePreterite:
      deConjugationState = .indicativePresent
    case .indicativePerfect:
      deConjugationState = .indicativePreterite
    }
  }
}

/// Action associated with the right view switch button of the conjugation state.
func deConjugationStateRight() {
  if commandState == .selectCaseConjugation {
    switch deCaseConjugationState {
    case .accusative:
      deCaseConjugationState = .accusativePersonal
    case .accusativePersonal:
      deCaseConjugationState = .accusativePossesive
    case .accusativePossesive:
      deCaseConjugationState = .dative
    case .dative:
      deCaseConjugationState = .dativePersonal
    case .dativePersonal:
      deCaseConjugationState = .dativePossesive
    case .dativePossesive:
      deCaseConjugationState = .genitive
    case .genitive:
      deCaseConjugationState = .genitivePersonal
    case .genitivePersonal:
      deCaseConjugationState = .genitivePossesive
    case .genitivePossesive:
      break
    }
  } else {
    switch deConjugationState {
    case .indicativePresent:
      deConjugationState = .indicativePreterite
    case .indicativePreterite:
      deConjugationState = .indicativePerfect
    case .indicativePerfect:
      break
    }
  }
}
