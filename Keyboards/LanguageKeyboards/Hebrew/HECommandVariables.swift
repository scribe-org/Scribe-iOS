/**
 * Variables associated with commands for the Hebrew Scribe keyboard.
 *
 * Copyright (C) 2024 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

func heSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for key in formLabelsDict.keys {
    formLabelsDict[key] = ""
  }

  switch heConjugationState {
  case .present, .past, .future, .conditional:
    formLabelsDict["TL"] = "פועל פשוט" // Poel Pashoot (Simple Verb)
    formLabelsDict["TR"] = "פועל מתמשך" // Poel מתמשך (Continuous Verb)
    formLabelsDict["BL"] = "פועל בתר" //  (Past Perfect Verb)
    formLabelsDict["BR"] = "פועל בתר מתמשך" // Poel Be'עבר מתמשך (Past Continuous Perfect Verb)
  case .presSimp, .presPerf, .presPerfCont:
    formLabelsDict["Left"] = "אני/אתה/את/אתם" // Ani/Ata/At/Atem (I/You/They)
    formLabelsDict["Right"] = "הוא/היא" // Hu/Hi (He/She)
  case .presCont:
    formLabelsDict["TL"] = "הווה משתתף" // Hove משתתף (Present Participle)
    formLabelsDict["TR"] = "אני" // Ani (I)
    formLabelsDict["BL"] = "אתה/את/אתם" // Ata/At/Atem (You/They)
    formLabelsDict["BR"] = "הוא/היא" // Hoo/Hi (He/She)
  case .pastCont:
    formLabelsDict["Top"] = "היה משתתף" // Haya משתתף (Past Participle)
    formLabelsDict["Middle"] = "אני/הוא/היא" // Ani/Hu/Hi (I/He/She)
    formLabelsDict["Bottom"] = "אתם/אתן" // Atem/Aten (You [plural, masculine/feminine])
  }
}

/// What the conjugation state is for the conjugate feature.
enum HEConjugationState {
  case present
  case presSimp
  case presCont
  case presPerf
  case presPerfCont
  case past
  case pastCont
  case future
  case conditional
}

var heConjugationState: HEConjugationState = .present

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func heGetConjugationTitle() -> String {
  if inputWordIsCapitalized {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch heConjugationState {
  case .present:
    return commandPromptSpacing + "הווה: " + verbToDisplay // Hove: (Present)
  case .presSimp:
    return commandPromptSpacing + "עבר פשוט: " + verbToDisplay // Avar Pashoot (Past Simple)
  case .presCont:
    return commandPromptSpacing + "הווה מתמשך: " + verbToDisplay // Hove מתמשך (Present Continuous)
  case .presPerf:
    return commandPromptSpacing + "הווה בתר: " + verbToDisplay // Hove Be'עבר (Present Perfect)
  case .presPerfCont:
    return commandPromptSpacing + "הווה בתר מתמשך: " + verbToDisplay // Hove Be'עבר מתמשך (Present Continuous Perfect)
  case .past:
    return commandPromptSpacing + "עבר: " + verbToDisplay // Avar (Past)
  case .pastCont:
    return commandPromptSpacing + "עבר מתמשך: " + verbToDisplay // Ovar מתמשך (Past Continuous)
  case .future:
    return commandPromptSpacing + "עתיד: " + verbToDisplay // Atid (Future)
  case .conditional:
    return commandPromptSpacing + "תנאי: " + verbToDisplay // Tnai (Conditional)
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func heGetConjugationState() -> [String] {
  switch heConjugationState {
  case .present:
    return ["presTPS", "presPart", "presPerfTPS", "presPerfTPSCont"] //
  case .presSimp:
    return ["presSimp", "presTPS"]
  case .presCont:
    return ["presPart", "presFPSCont", "prePluralCont", "presTPSCont"]
  case .presPerf:
    return ["presPerfSimp", "presPerfTPS"]
  case .presPerfCont:
    return ["presPerfSimpCont", "presPerfTPSCont"]
  case .past:
    return ["pastSimp", "presPart", "pastPerf", "pastPerfCont"]
  case .pastCont:
    return ["presPart", "pastSimpCont", "pastSimpPluralCont"]
  case .future:
    return ["futSimp", "futCont", "futPerf", "futPerfCont"]
  case .conditional:
    return ["condSimp", "condCont", "condPerf", "condPerfCont"]
  }
}

/// Action associated with the left view switch button of the conjugation state.
func heConjugationStateLeft() {
  switch heConjugationState {
  case .present, .presSimp, .presCont, .presPerf, .presPerfCont, .pastCont:
    break
  case .past:
    conjViewShiftButtonsState = .leftInactive
    heConjugationState = .present
  case .future:
    heConjugationState = .past
  case .conditional:
    conjViewShiftButtonsState = .bothActive
    heConjugationState = .future
  }
}

/// Action associated with the right view switch button of the conjugation state.
func heConjugationStateRight() {
  switch heConjugationState {
  case .presSimp, .presCont, .presPerf, .presPerfCont, .pastCont, .conditional:
    break
  case .present:
    conjViewShiftButtonsState = .bothActive
    heConjugationState = .past
  case .past:
    heConjugationState = .future
  case .future:
    conjViewShiftButtonsState = .rightInactive
    heConjugationState = .conditional
  }
}
