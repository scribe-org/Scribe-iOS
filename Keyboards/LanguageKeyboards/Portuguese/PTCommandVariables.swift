/**
 * Variables associated with commands for the Portuguese Scribe keyboard
 *
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

func ptSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }

  formLabelsDict["FPS"] = "eu"
  formLabelsDict["SPS"] = "tu"
  formLabelsDict["TPS"] = "ele/ela/você"
  formLabelsDict["FPP"] = "nós"
  formLabelsDict["SPP"] = "vós"
  formLabelsDict["TPP"] = "eles/elas/vocês"
}

/// What the conjugation state is for the conjugate feature.
enum PTConjugationState {
  case indicativePresent
  case pastPerfect
  case pastImperfect
  case futureSimple
}

var ptConjugationState: PTConjugationState = .indicativePresent

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func ptGetConjugationTitle() -> String {
  if inputWordIsCapitalized {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch ptConjugationState {
  case .indicativePresent:
    return commandPromptSpacing + "Presente: " + verbToDisplay
  case .pastPerfect:
    return commandPromptSpacing + "Pretérito Perfeito: " + verbToDisplay
  case .pastImperfect:
    return commandPromptSpacing + "Pretérito Imperfeito: " + verbToDisplay
  case .futureSimple:
    return commandPromptSpacing + "Futuro Simples: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func ptGetConjugationState() -> String {
  switch ptConjugationState {
  case .indicativePresent:
    return "pres"
  case .pastPerfect:
    return "perf"
  case .pastImperfect:
    return "imp"
  case .futureSimple:
    return "fSimp"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func ptConjugationStateLeft() {
  switch ptConjugationState {
  case .indicativePresent:
    break
  case .pastPerfect:
    conjViewShiftButtonsState = .leftInactive
    ptConjugationState = .indicativePresent
  case .pastImperfect:
    conjViewShiftButtonsState = .bothActive
    ptConjugationState = .pastPerfect
  case .futureSimple:
    conjViewShiftButtonsState = .bothActive
    ptConjugationState = .pastImperfect
  }
}

/// Action associated with the right view switch button of the conjugation state.
func ptConjugationStateRight() {
  switch ptConjugationState {
  case .indicativePresent:
    conjViewShiftButtonsState = .bothActive
    ptConjugationState = .pastPerfect
  case .pastPerfect:
    conjViewShiftButtonsState = .bothActive
    ptConjugationState = .pastImperfect
  case .pastImperfect:
    conjViewShiftButtonsState = .rightInactive
    ptConjugationState = .futureSimple
  case .futureSimple:
    break
  }
}
