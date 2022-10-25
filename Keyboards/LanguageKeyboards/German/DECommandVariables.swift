//
//  DECommandVariables.swift
//
//  Variables associated with Scribe commands for the German keyboard.
//

func deSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }
  
  formLabelsDict["FPS"] = "ich"
  formLabelsDict["SPS"] = "du"
  formLabelsDict["TPS"] = "er/sie/es"
  formLabelsDict["FPP"] = "wir"
  formLabelsDict["SPP"] = "ihr"
  formLabelsDict["TPP"] = "sie/Sie"
}

func deSetCaseDeclensionLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }
  if deCaseVariantDeclensionState == .disabled {
    if [.accusative, .dative, .genitive].contains(deCaseDeclensionState) {
      formLabelsDict["TL"] = "M"
      formLabelsDict["TR"] = "F"
      formLabelsDict["BL"] = "N"
      formLabelsDict["BR"] = "PL"
    } else {
      formLabelsDict["FPS"]  = "ich"
      formLabelsDict["SPS"]  = "du/Sie"
      formLabelsDict["TPS"]  = "er/sie/es"
      formLabelsDict["FPP"]  = "wir"
      formLabelsDict["SPP"]  = "ihr"
      formLabelsDict["TPP"]  = "sie"
    }
  } else {
    switch deCaseVariantDeclensionState {
    case .disabled:
      break // placeholder
    case .accusativePersonalSPS, .accusativePossesiveSPS,
        .dativePersonalSPS, .dativePossesiveSPS,
        .genitivePersonalSPS, .genitivePossesiveSPS:
      formLabelsDict["Left"] = "informell"
      formLabelsDict["Right"] = "formell"
    case .accusativePersonalTPS, .accusativePossesiveTPS,
        .dativePersonalTPS, .dativePossesiveTPS,
        .genitivePersonalTPS, .genitivePossesiveTPS:
      formLabelsDict["Top"] = "er"
      formLabelsDict["Middle"] = "sie"
      formLabelsDict["Bottom"] = "es"
    case .accusativePossesiveFPS, .accusativePossesiveSPSInformal, .accusativePossesiveSPSFormal,
        .accusativePossesiveTPSMasculine, .accusativePossesiveTPSFeminine, .accusativePossesiveTPSNeutral,
        .accusativePossesiveFPP, .accusativePossesiveSPP, .accusativePossesiveTPP,
        .dativePossesiveFPS, .dativePossesiveSPSInformal, .dativePossesiveSPSFormal,
        .dativePossesiveTPSMasculine, .dativePossesiveTPSFeminine, .dativePossesiveTPSNeutral,
        .dativePossesiveFPP, .dativePossesiveSPP, .dativePossesiveTPP,
        .genitivePossesiveFPS, .genitivePossesiveSPSInformal, .genitivePossesiveSPSFormal,
        .genitivePossesiveTPSMasculine, .genitivePossesiveTPSFeminine, .genitivePossesiveTPSNeutral,
        .genitivePossesiveFPP, .genitivePossesiveSPP, .genitivePossesiveTPP:
      formLabelsDict["TL"] = "M"
      formLabelsDict["TR"] = "F"
      formLabelsDict["BL"] = "N"
      formLabelsDict["BR"] = "PL"
    }
  }
}

/// What the conjugation state is for the conjugate feature.
enum DEConjugationState {
  case indicativePresent
  case indicativePreterite
  case indicativePerfect
}

/// What the conjugation state is for the case conjugate feature.
enum DECaseDeclensionState {
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
enum DECaseVariantDeclensionState {
  case disabled
  case accusativePersonalSPS
  case accusativePersonalTPS
  case accusativePossesiveFPS
  case accusativePossesiveSPS
  case accusativePossesiveSPSInformal
  case accusativePossesiveSPSFormal
  case accusativePossesiveTPS
  case accusativePossesiveTPSMasculine
  case accusativePossesiveTPSFeminine
  case accusativePossesiveTPSNeutral
  case accusativePossesiveFPP
  case accusativePossesiveSPP
  case accusativePossesiveTPP
  case dativePersonalSPS
  case dativePersonalTPS
  case dativePossesiveFPS
  case dativePossesiveSPS
  case dativePossesiveSPSInformal
  case dativePossesiveSPSFormal
  case dativePossesiveTPS
  case dativePossesiveTPSMasculine
  case dativePossesiveTPSFeminine
  case dativePossesiveTPSNeutral
  case dativePossesiveFPP
  case dativePossesiveSPP
  case dativePossesiveTPP
  case genitivePersonalSPS
  case genitivePersonalTPS
  case genitivePossesiveFPS
  case genitivePossesiveSPS
  case genitivePossesiveSPSInformal
  case genitivePossesiveSPSFormal
  case genitivePossesiveTPS
  case genitivePossesiveTPSMasculine
  case genitivePossesiveTPSFeminine
  case genitivePossesiveTPSNeutral
  case genitivePossesiveFPP
  case genitivePossesiveSPP
  case genitivePossesiveTPP
}

var deConjugationState: DEConjugationState = .indicativePresent
var deCaseDeclensionState: DECaseDeclensionState = .accusative
var deCaseVariantDeclensionState: DECaseVariantDeclensionState = .disabled

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
func deGetCaseDeclensionTitle() -> String {
  if deCaseVariantDeclensionState == .disabled {
    switch deCaseDeclensionState {
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
    switch deCaseVariantDeclensionState {
    case .disabled:
      return "" // placeholder
    case .accusativePersonalSPS, .accusativePossesiveSPS,
        .dativePersonalSPS, .dativePossesiveSPS,
        .genitivePersonalSPS, .genitivePossesiveSPS:
      return commandPromptSpacing + "Formalität des Subjekts?"
    case .accusativePersonalTPS, .accusativePossesiveTPS,
        .dativePersonalTPS, .dativePossesiveTPS,
        .genitivePersonalTPS, .genitivePossesiveTPS:
      return commandPromptSpacing + "Geschlecht des Subjekts?"
    case .accusativePossesiveFPS, .accusativePossesiveSPSInformal, .accusativePossesiveSPSFormal,
        .accusativePossesiveTPSMasculine, .accusativePossesiveTPSFeminine, .accusativePossesiveTPSNeutral,
        .accusativePossesiveFPP, .accusativePossesiveSPP, .accusativePossesiveTPP,
        .dativePossesiveFPS, .dativePossesiveSPSInformal, .dativePossesiveSPSFormal,
        .dativePossesiveTPSMasculine, .dativePossesiveTPSFeminine, .dativePossesiveTPSNeutral,
        .dativePossesiveFPP, .dativePossesiveSPP, .dativePossesiveTPP,
        .genitivePossesiveFPS, .genitivePossesiveSPSInformal, .genitivePossesiveSPSFormal,
        .genitivePossesiveTPSMasculine, .genitivePossesiveTPSFeminine, .genitivePossesiveTPSNeutral,
        .genitivePossesiveFPP, .genitivePossesiveSPP, .genitivePossesiveTPP:
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
func deSetCaseDeclensions() {
  switch deCaseDeclensionState {
  case .accusative:
    formTopLeft = "den"
    formTopRight = "die"
    formBottomLeft = "das"
    formBottomRight = "die"
  case .accusativePersonal:
    formFPS = "mich"
    formSPS = "dich/Sie"
    formTPS = "ihn/sie/es"
    formFPP = "uns"
    formSPP = "euch"
    formTPP = "sie"
  case .dative:
    formTopLeft = "dem"
    formTopRight = "der"
    formBottomLeft = "dem"
    formBottomRight = "den"
  case .dativePersonal:
    formFPS = "mir"
    formSPS = "dir/Ihnen"
    formTPS = "ihm/ihr/ihm"
    formFPP = "uns"
    formSPP = "euch"
    formTPP = "ihnen"
  case .genitive:
    formTopLeft = "des"
    formTopRight = "der"
    formBottomLeft = "des"
    formBottomRight = "der"
  case .genitivePersonal:
    formFPS = "meiner"
    formSPS = "deiner/Ihrer"
    formTPS = "seiner/ihrer/seiner"
    formFPP = "unser"
    formSPP = "euer"
    formTPP = "ihrer"
  case .accusativePossesive, .dativePossesive, .genitivePossesive:
    formFPS = "mein∗"
    formSPS = "dein∗/Ihr∗"
    formTPS = "sein∗/ihr∗/sein∗"
    formFPP = "unser∗"
    formSPP = "euer∗"
    formTPP = "ihr∗"
  }
}

/// Returns the appropriate options for a selection within the case conjugation table.
func deSetCaseVariantDeclensions() {
  switch deCaseVariantDeclensionState {
  case .disabled:
    break
  case .accusativePersonalSPS:
    formLeft = "dich"
    formRight = "Sie"
  case .accusativePersonalTPS:
    formTop = "ihn"
    formMiddle = "sie"
    formBottom = "es"
  case .dativePersonalSPS:
    formLeft = "dir"
    formRight = "Ihnen"
  case .dativePersonalTPS:
    formTop = "ihm"
    formMiddle = "ihr"
    formBottom = "ihm"
  case .genitivePersonalSPS:
    formLeft = "deiner"
    formRight = "Ihrer"
  case .genitivePersonalTPS:
    formTop = "seiner"
    formMiddle = "ihrer"
    formBottom = "seiner"
  case .accusativePossesiveSPS, .dativePossesiveSPS, .genitivePossesiveSPS:
    formLeft = "dein∗"
    formRight = "Ihr∗"
  case .accusativePossesiveTPS, .dativePossesiveTPS, .genitivePossesiveTPS:
    formTop = "sein∗"
    formMiddle = "ihr∗"
    formBottom = "sein∗"
  case .accusativePossesiveFPS:
    formTopLeft = "meinen"
    formTopRight = "meine"
    formBottomLeft = "mein"
    formBottomRight = "meine"
  case .accusativePossesiveSPSInformal:
    formTopLeft = "deinen"
    formTopRight = "deine"
    formBottomLeft = "dein"
    formBottomRight = "deine"
  case .accusativePossesiveSPSFormal:
    formTopLeft = "Ihren"
    formTopRight = "Ihre"
    formBottomLeft = "Ihr"
    formBottomRight = "Ihre"
  case .accusativePossesiveTPSMasculine:
    formTopLeft = "seinen"
    formTopRight = "seine"
    formBottomLeft = "sein"
    formBottomRight = "seine"
  case .accusativePossesiveTPSFeminine:
    formTopLeft = "ihren"
    formTopRight = "ihre"
    formBottomLeft = "ihr"
    formBottomRight = "ihre"
  case .accusativePossesiveTPSNeutral:
    formTopLeft = "seinen"
    formTopRight = "seine"
    formBottomLeft = "sein"
    formBottomRight = "seine"
  case .accusativePossesiveFPP:
    formTopLeft = "unsren"
    formTopRight = "unsre"
    formBottomLeft = "unser"
    formBottomRight = "unsre"
  case .accusativePossesiveSPP:
    formTopLeft = "euren"
    formTopRight = "eure"
    formBottomLeft = "euer"
    formBottomRight = "eure"
  case .accusativePossesiveTPP:
    formTopLeft = "ihren"
    formTopRight = "ihre"
    formBottomLeft = "ihr"
    formBottomRight = "ihre"
  case .dativePossesiveFPS:
    formTopLeft = "meinem"
    formTopRight = "meiner"
    formBottomLeft = "meinem"
    formBottomRight = "meinen"
  case .dativePossesiveSPSInformal:
    formTopLeft = "deinem"
    formTopRight = "deiner"
    formBottomLeft = "deinem"
    formBottomRight = "deinen"
  case .dativePossesiveSPSFormal:
    formTopLeft = "Ihrem"
    formTopRight = "Ihrer"
    formBottomLeft = "Ihrem"
    formBottomRight = "Ihren"
  case .dativePossesiveTPSMasculine:
    formTopLeft = "seinem"
    formTopRight = "seiner"
    formBottomLeft = "seinem"
    formBottomRight = "seinen"
  case .dativePossesiveTPSFeminine:
    formTopLeft = "ihrem"
    formTopRight = "ihrer"
    formBottomLeft = "ihrem"
    formBottomRight = "ihren"
  case .dativePossesiveTPSNeutral:
    formTopLeft = "seinem"
    formTopRight = "seiner"
    formBottomLeft = "seinem"
    formBottomRight = "seinen"
  case .dativePossesiveFPP:
    formTopLeft = "unsrem"
    formTopRight = "unsrer"
    formBottomLeft = "unsrem"
    formBottomRight = "unsren"
  case .dativePossesiveSPP:
    formTopLeft = "eurem"
    formTopRight = "eurer"
    formBottomLeft = "eurem"
    formBottomRight = "euren"
  case .dativePossesiveTPP:
    formTopLeft = "ihrem"
    formTopRight = "ihrer"
    formBottomLeft = "ihrem"
    formBottomRight = "ihren"
  case .genitivePossesiveFPS:
    formTopLeft = "meines"
    formTopRight = "meiner"
    formBottomLeft = "meines"
    formBottomRight = "meiner"
  case .genitivePossesiveSPSInformal:
    formTopLeft = "deines"
    formTopRight = "deiner"
    formBottomLeft = "deines"
    formBottomRight = "deiner"
  case .genitivePossesiveSPSFormal:
    formTopLeft = "Ihres"
    formTopRight = "Ihrer"
    formBottomLeft = "Ihres"
    formBottomRight = "Ihrer"
  case .genitivePossesiveTPSMasculine:
    formTopLeft = "seines"
    formTopRight = "seiner"
    formBottomLeft = "seines"
    formBottomRight = "seiner"
  case .genitivePossesiveTPSFeminine:
    formTopLeft = "ihres"
    formTopRight = "ihr"
    formBottomLeft = "ihres"
    formBottomRight = "ihr"
  case .genitivePossesiveTPSNeutral:
    formTopLeft = "seines"
    formTopRight = "seiner"
    formBottomLeft = "seines"
    formBottomRight = "seiner"
  case .genitivePossesiveFPP:
    formTopLeft = "unsres"
    formTopRight = "unsrer"
    formBottomLeft = "unsres"
    formBottomRight = "unsrer"
  case .genitivePossesiveSPP:
    formTopLeft = "eures"
    formTopRight = "eurer"
    formBottomLeft = "eures"
    formBottomRight = "eurer"
  case .genitivePossesiveTPP:
    formTopLeft = "ihres"
    formTopRight = "ihrer"
    formBottomLeft = "ihres"
    formBottomRight = "ihrer"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func deConjugationStateLeft() {
  if commandState == .selectCaseDeclension && deCaseVariantDeclensionState == .disabled {
    switch deCaseDeclensionState {
    case .accusative:
      break
    case .accusativePersonal:
      conjViewShiftButtonsState = .leftInactive
      deCaseDeclensionState = .accusative
    case .accusativePossesive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativePersonal
    case .dative:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativePossesive
    case .dativePersonal:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dative
    case .dativePossesive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativePersonal
    case .genitive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativePossesive
    case .genitivePersonal:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitive
    case .genitivePossesive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitivePersonal
    }
  } else {
    switch deConjugationState {
    case .indicativePresent:
      break
    case .indicativePreterite:
      conjViewShiftButtonsState = .leftInactive
      deConjugationState = .indicativePresent
    case .indicativePerfect:
      conjViewShiftButtonsState = .bothActive
      deConjugationState = .indicativePreterite
    }
  }
}

/// Action associated with the right view switch button of the conjugation state.
func deConjugationStateRight() {
  if commandState == .selectCaseDeclension && deCaseVariantDeclensionState == .disabled {
    switch deCaseDeclensionState {
    case .accusative:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativePersonal
    case .accusativePersonal:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativePossesive
    case .accusativePossesive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dative
    case .dative:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativePersonal
    case .dativePersonal:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativePossesive
    case .dativePossesive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitive
    case .genitive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitivePersonal
    case .genitivePersonal:
      conjViewShiftButtonsState = .rightInactive
      deCaseDeclensionState = .genitivePossesive
    case .genitivePossesive:
      break
    }
  } else {
    switch deConjugationState {
    case .indicativePresent:
      conjViewShiftButtonsState = .bothActive
      deConjugationState = .indicativePreterite
    case .indicativePreterite:
      conjViewShiftButtonsState = .rightInactive
      deConjugationState = .indicativePerfect
    case .indicativePerfect:
      break
    }
  }
}
