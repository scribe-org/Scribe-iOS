/**
 * Variables associated with commands for the German Scribe keyboard.
 *
 * Copyright (C) 2023 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

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
    if [
      .accusativeDefinite, .accusativeIndefinite, .accusativeDemonstrative,
      .dativeDefinite, .dativeIndefinite, .dativeDemonstrative,
      .genitiveDefinite, .genitiveIndefinite, .genitiveDemonstrative,
    ].contains(deCaseDeclensionState) {
      formLabelsDict["TL"] = "M"
      formLabelsDict["TR"] = "F"
      formLabelsDict["BL"] = "N"
      formLabelsDict["BR"] = "PL"
    } else {
      formLabelsDict["FPS"] = "ich"
      formLabelsDict["SPS"] = "du/Sie"
      formLabelsDict["TPS"] = "er/sie/es"
      formLabelsDict["FPP"] = "wir"
      formLabelsDict["SPP"] = "ihr"
      formLabelsDict["TPP"] = "sie"
    }
  } else {
    switch deCaseVariantDeclensionState {
    case .disabled:
      break // placeholder
    case .accusativePersonalSPS, .accusativePossessiveSPS,
         .dativePersonalSPS, .dativePossessiveSPS,
         .genitivePersonalSPS, .genitivePossessiveSPS:
      formLabelsDict["Left"] = "informell"
      formLabelsDict["Right"] = "formell"
    case .accusativePersonalTPS, .accusativePossessiveTPS,
         .dativePersonalTPS, .dativePossessiveTPS,
         .genitivePersonalTPS, .genitivePossessiveTPS:
      formLabelsDict["Top"] = "er"
      formLabelsDict["Middle"] = "sie"
      formLabelsDict["Bottom"] = "es"
    case .accusativePossessiveFPS, .accusativePossessiveSPSInformal, .accusativePossessiveSPSFormal,
         .accusativePossessiveTPSMasculine, .accusativePossessiveTPSFeminine, .accusativePossessiveTPSNeutral,
         .accusativePossessiveFPP, .accusativePossessiveSPP, .accusativePossessiveTPP,
         .dativePossessiveFPS, .dativePossessiveSPSInformal, .dativePossessiveSPSFormal,
         .dativePossessiveTPSMasculine, .dativePossessiveTPSFeminine, .dativePossessiveTPSNeutral,
         .dativePossessiveFPP, .dativePossessiveSPP, .dativePossessiveTPP,
         .genitivePossessiveFPS, .genitivePossessiveSPSInformal, .genitivePossessiveSPSFormal,
         .genitivePossessiveTPSMasculine, .genitivePossessiveTPSFeminine, .genitivePossessiveTPSNeutral,
         .genitivePossessiveFPP, .genitivePossessiveSPP, .genitivePossessiveTPP:
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
  case accusativeDefinite
  case accusativeIndefinite
  case accusativePersonal
  case accusativePossessive
  case accusativeDemonstrative
  case dativeDefinite
  case dativeIndefinite
  case dativePersonal
  case dativePossessive
  case dativeDemonstrative
  case genitiveDefinite
  case genitiveIndefinite
  case genitivePersonal
  case genitivePossessive
  case genitiveDemonstrative
}

/// Allows for switching the conjugation view to select from pronoun options based on noun genders.
enum DECaseVariantDeclensionState {
  case disabled
  case accusativePersonalSPS
  case accusativePersonalTPS
  case accusativePossessiveFPS
  case accusativePossessiveSPS
  case accusativePossessiveSPSInformal
  case accusativePossessiveSPSFormal
  case accusativePossessiveTPS
  case accusativePossessiveTPSMasculine
  case accusativePossessiveTPSFeminine
  case accusativePossessiveTPSNeutral
  case accusativePossessiveFPP
  case accusativePossessiveSPP
  case accusativePossessiveTPP
  case dativePersonalSPS
  case dativePersonalTPS
  case dativePossessiveFPS
  case dativePossessiveSPS
  case dativePossessiveSPSInformal
  case dativePossessiveSPSFormal
  case dativePossessiveTPS
  case dativePossessiveTPSMasculine
  case dativePossessiveTPSFeminine
  case dativePossessiveTPSNeutral
  case dativePossessiveFPP
  case dativePossessiveSPP
  case dativePossessiveTPP
  case genitivePersonalSPS
  case genitivePersonalTPS
  case genitivePossessiveFPS
  case genitivePossessiveSPS
  case genitivePossessiveSPSInformal
  case genitivePossessiveSPSFormal
  case genitivePossessiveTPS
  case genitivePossessiveTPSMasculine
  case genitivePossessiveTPSFeminine
  case genitivePossessiveTPSNeutral
  case genitivePossessiveFPP
  case genitivePossessiveSPP
  case genitivePossessiveTPP
}

var deConjugationState: DEConjugationState = .indicativePresent
var deCaseDeclensionState: DECaseDeclensionState = .accusativeDefinite
var deCaseVariantDeclensionState: DECaseVariantDeclensionState = .disabled

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func deGetConjugationTitle() -> String {
  if inputWordIsCapitalized {
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
    case .accusativeDefinite:
      return commandPromptSpacing + "Akkusativ Definitpronomen"
    case .accusativeIndefinite:
      return commandPromptSpacing + "Akkusativ Indefinitpronomen"
    case .accusativePersonal:
      return commandPromptSpacing + "Akkusativ Personalpronomen"
    case .accusativePossessive:
      return commandPromptSpacing + "Akkusativ Possessivpronomen"
    case .accusativeDemonstrative:
      return commandPromptSpacing + "Akkusativ Demonstrativpronomen"
    case .dativeDefinite:
      return commandPromptSpacing + "Dativ Definitpronomen"
    case .dativeIndefinite:
      return commandPromptSpacing + "Dativ Indefinitpronomen"
    case .dativePersonal:
      return commandPromptSpacing + "Dativ Personalpronomen"
    case .dativePossessive:
      return commandPromptSpacing + "Dativ Possessivpronomen"
    case .dativeDemonstrative:
      return commandPromptSpacing + "Dativ Demonstrativpronomen"
    case .genitiveDefinite:
      return commandPromptSpacing + "Genitiv Definitpronomen"
    case .genitiveIndefinite:
      return commandPromptSpacing + "Genitiv Indefinitpronomen"
    case .genitivePersonal:
      return commandPromptSpacing + "Genitiv Personalpronomen"
    case .genitivePossessive:
      return commandPromptSpacing + "Genitiv Possessivpronomen"
    case .genitiveDemonstrative:
      return commandPromptSpacing + "Genitiv Demonstrativpronomen"
    }
  } else {
    switch deCaseVariantDeclensionState {
    case .disabled:
      return "" // placeholder
    case .accusativePersonalSPS, .accusativePossessiveSPS,
         .dativePersonalSPS, .dativePossessiveSPS,
         .genitivePersonalSPS, .genitivePossessiveSPS:
      return commandPromptSpacing + "Formalität des Subjekts?"
    case .accusativePersonalTPS, .accusativePossessiveTPS,
         .dativePersonalTPS, .dativePossessiveTPS,
         .genitivePersonalTPS, .genitivePossessiveTPS:
      return commandPromptSpacing + "Geschlecht des Subjekts?"
    case .accusativePossessiveFPS, .accusativePossessiveSPSInformal, .accusativePossessiveSPSFormal,
         .accusativePossessiveTPSMasculine, .accusativePossessiveTPSFeminine, .accusativePossessiveTPSNeutral,
         .accusativePossessiveFPP, .accusativePossessiveSPP, .accusativePossessiveTPP,
         .dativePossessiveFPS, .dativePossessiveSPSInformal, .dativePossessiveSPSFormal,
         .dativePossessiveTPSMasculine, .dativePossessiveTPSFeminine, .dativePossessiveTPSNeutral,
         .dativePossessiveFPP, .dativePossessiveSPP, .dativePossessiveTPP,
         .genitivePossessiveFPS, .genitivePossessiveSPSInformal, .genitivePossessiveSPSFormal,
         .genitivePossessiveTPSMasculine, .genitivePossessiveTPSFeminine, .genitivePossessiveTPSNeutral,
         .genitivePossessiveFPP, .genitivePossessiveSPP, .genitivePossessiveTPP:
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
  case .accusativeDefinite:
    formTopLeft = "den"
    formTopRight = "die"
    formBottomLeft = "das"
    formBottomRight = "die"
  case .accusativeIndefinite:
    formTopLeft = "einen"
    formTopRight = "eine"
    formBottomLeft = "ein"
    formBottomRight = ""
  case .accusativePersonal:
    formFPS = "mich"
    formSPS = "dich/Sie"
    formTPS = "ihn/sie/es"
    formFPP = "uns"
    formSPP = "euch"
    formTPP = "sie"
  case .accusativeDemonstrative:
    formTopLeft = "diesen"
    formTopRight = "diese"
    formBottomLeft = "dieses"
    formBottomRight = "diese"
  case .dativeDefinite:
    formTopLeft = "dem"
    formTopRight = "der"
    formBottomLeft = "dem"
    formBottomRight = "den"
  case .dativeIndefinite:
    formTopLeft = "einem"
    formTopRight = "einer"
    formBottomLeft = "einem"
    formBottomRight = ""
  case .dativePersonal:
    formFPS = "mir"
    formSPS = "dir/Ihnen"
    formTPS = "ihm/ihr/ihm"
    formFPP = "uns"
    formSPP = "euch"
    formTPP = "ihnen"
  case .dativeDemonstrative:
    formTopLeft = "diesem"
    formTopRight = "dieser"
    formBottomLeft = "diesem"
    formBottomRight = "diesen"
  case .genitiveDefinite:
    formTopLeft = "des"
    formTopRight = "der"
    formBottomLeft = "des"
    formBottomRight = "der"
  case .genitiveIndefinite:
    formTopLeft = "eines"
    formTopRight = "einer"
    formBottomLeft = "eines"
    formBottomRight = ""
  case .genitivePersonal:
    formFPS = "meiner"
    formSPS = "deiner/Ihrer"
    formTPS = "seiner/ihrer/seiner"
    formFPP = "unser"
    formSPP = "euer"
    formTPP = "ihrer"
  case .genitiveDemonstrative:
    formTopLeft = "dieses"
    formTopRight = "dieser"
    formBottomLeft = "dieses"
    formBottomRight = "dieser"
  case .accusativePossessive, .dativePossessive, .genitivePossessive:
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
  case .accusativePossessiveSPS, .dativePossessiveSPS, .genitivePossessiveSPS:
    formLeft = "dein∗"
    formRight = "Ihr∗"
  case .accusativePossessiveTPS, .dativePossessiveTPS, .genitivePossessiveTPS:
    formTop = "sein∗"
    formMiddle = "ihr∗"
    formBottom = "sein∗"
  case .accusativePossessiveFPS:
    formTopLeft = "meinen"
    formTopRight = "meine"
    formBottomLeft = "mein"
    formBottomRight = "meine"
  case .accusativePossessiveSPSInformal:
    formTopLeft = "deinen"
    formTopRight = "deine"
    formBottomLeft = "dein"
    formBottomRight = "deine"
  case .accusativePossessiveSPSFormal:
    formTopLeft = "Ihren"
    formTopRight = "Ihre"
    formBottomLeft = "Ihr"
    formBottomRight = "Ihre"
  case .accusativePossessiveTPSMasculine:
    formTopLeft = "seinen"
    formTopRight = "seine"
    formBottomLeft = "sein"
    formBottomRight = "seine"
  case .accusativePossessiveTPSFeminine:
    formTopLeft = "ihren"
    formTopRight = "ihre"
    formBottomLeft = "ihr"
    formBottomRight = "ihre"
  case .accusativePossessiveTPSNeutral:
    formTopLeft = "seinen"
    formTopRight = "seine"
    formBottomLeft = "sein"
    formBottomRight = "seine"
  case .accusativePossessiveFPP:
    formTopLeft = "unsren"
    formTopRight = "unsre"
    formBottomLeft = "unser"
    formBottomRight = "unsre"
  case .accusativePossessiveSPP:
    formTopLeft = "euren"
    formTopRight = "eure"
    formBottomLeft = "euer"
    formBottomRight = "eure"
  case .accusativePossessiveTPP:
    formTopLeft = "ihren"
    formTopRight = "ihre"
    formBottomLeft = "ihr"
    formBottomRight = "ihre"
  case .dativePossessiveFPS:
    formTopLeft = "meinem"
    formTopRight = "meiner"
    formBottomLeft = "meinem"
    formBottomRight = "meinen"
  case .dativePossessiveSPSInformal:
    formTopLeft = "deinem"
    formTopRight = "deiner"
    formBottomLeft = "deinem"
    formBottomRight = "deinen"
  case .dativePossessiveSPSFormal:
    formTopLeft = "Ihrem"
    formTopRight = "Ihrer"
    formBottomLeft = "Ihrem"
    formBottomRight = "Ihren"
  case .dativePossessiveTPSMasculine:
    formTopLeft = "seinem"
    formTopRight = "seiner"
    formBottomLeft = "seinem"
    formBottomRight = "seinen"
  case .dativePossessiveTPSFeminine:
    formTopLeft = "ihrem"
    formTopRight = "ihrer"
    formBottomLeft = "ihrem"
    formBottomRight = "ihren"
  case .dativePossessiveTPSNeutral:
    formTopLeft = "seinem"
    formTopRight = "seiner"
    formBottomLeft = "seinem"
    formBottomRight = "seinen"
  case .dativePossessiveFPP:
    formTopLeft = "unsrem"
    formTopRight = "unsrer"
    formBottomLeft = "unsrem"
    formBottomRight = "unsren"
  case .dativePossessiveSPP:
    formTopLeft = "eurem"
    formTopRight = "eurer"
    formBottomLeft = "eurem"
    formBottomRight = "euren"
  case .dativePossessiveTPP:
    formTopLeft = "ihrem"
    formTopRight = "ihrer"
    formBottomLeft = "ihrem"
    formBottomRight = "ihren"
  case .genitivePossessiveFPS:
    formTopLeft = "meines"
    formTopRight = "meiner"
    formBottomLeft = "meines"
    formBottomRight = "meiner"
  case .genitivePossessiveSPSInformal:
    formTopLeft = "deines"
    formTopRight = "deiner"
    formBottomLeft = "deines"
    formBottomRight = "deiner"
  case .genitivePossessiveSPSFormal:
    formTopLeft = "Ihres"
    formTopRight = "Ihrer"
    formBottomLeft = "Ihres"
    formBottomRight = "Ihrer"
  case .genitivePossessiveTPSMasculine:
    formTopLeft = "seines"
    formTopRight = "seiner"
    formBottomLeft = "seines"
    formBottomRight = "seiner"
  case .genitivePossessiveTPSFeminine:
    formTopLeft = "ihres"
    formTopRight = "ihr"
    formBottomLeft = "ihres"
    formBottomRight = "ihr"
  case .genitivePossessiveTPSNeutral:
    formTopLeft = "seines"
    formTopRight = "seiner"
    formBottomLeft = "seines"
    formBottomRight = "seiner"
  case .genitivePossessiveFPP:
    formTopLeft = "unsres"
    formTopRight = "unsrer"
    formBottomLeft = "unsres"
    formBottomRight = "unsrer"
  case .genitivePossessiveSPP:
    formTopLeft = "eures"
    formTopRight = "eurer"
    formBottomLeft = "eures"
    formBottomRight = "eurer"
  case .genitivePossessiveTPP:
    formTopLeft = "ihres"
    formTopRight = "ihrer"
    formBottomLeft = "ihres"
    formBottomRight = "ihrer"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func deConjugationStateLeft() {
  if commandState == .selectCaseDeclension, deCaseVariantDeclensionState == .disabled {
    switch deCaseDeclensionState {
    case .accusativeDefinite:
      break
    case .accusativeIndefinite:
      conjViewShiftButtonsState = .leftInactive
      deCaseDeclensionState = .accusativeDefinite
    case .accusativePersonal:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativeIndefinite
    case .accusativePossessive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativePersonal
    case .accusativeDemonstrative:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativePossessive
    case .dativeDefinite:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativeDemonstrative
    case .dativeIndefinite:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativeDefinite
    case .dativePersonal:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativeIndefinite
    case .dativePossessive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativePersonal
    case .dativeDemonstrative:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativePossessive
    case .genitiveDefinite:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativeDemonstrative
    case .genitiveIndefinite:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitiveDefinite
    case .genitivePersonal:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitiveIndefinite
    case .genitivePossessive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitivePersonal
    case .genitiveDemonstrative:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitivePossessive
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
  if commandState == .selectCaseDeclension, deCaseVariantDeclensionState == .disabled {
    switch deCaseDeclensionState {
    case .accusativeDefinite:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativeIndefinite
    case .accusativeIndefinite:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativePersonal
    case .accusativePersonal:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativePossessive
    case .accusativePossessive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .accusativeDemonstrative
    case .accusativeDemonstrative:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativeDefinite
    case .dativeDefinite:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativeIndefinite
    case .dativeIndefinite:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativePersonal
    case .dativePersonal:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativePossessive
    case .dativePossessive:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativeDemonstrative
    case .dativeDemonstrative:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitiveDefinite
    case .genitiveDefinite:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitiveIndefinite
    case .genitiveIndefinite:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitivePersonal
    case .genitivePersonal:
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitivePossessive
    case .genitivePossessive:
      conjViewShiftButtonsState = .rightInactive
      deCaseDeclensionState = .genitiveDemonstrative
    case .genitiveDemonstrative:
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
