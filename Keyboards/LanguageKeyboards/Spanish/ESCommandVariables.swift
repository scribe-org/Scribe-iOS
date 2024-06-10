/**
 * Variables associated with commands for the Spanish Scribe keyboard.
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

func esSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }

  formLabelsDict["FPS"] = "yo"
  formLabelsDict["SPS"] = "tú"
  formLabelsDict["TPS"] = "él/ella/Ud."
  formLabelsDict["FPP"] = "nosotros"
  formLabelsDict["SPP"] = "vosotros"
  formLabelsDict["TPP"] = "ellos/ellas/Uds."
}

/// Returns the reflexive pronoun for a given pronoun.
func getESReflexivePronoun(pronoun: String) -> String {
  if pronoun == "yo" {
    return "me"
  } else if pronoun == "tú" {
    return "te"
  } else if ["él", "ella", "usted", "ellos", "ellas", "ustedes"].contains(pronoun) {
    return "se"
  } else if ["nosotros", "nosotras"].contains(pronoun) {
    return "nos"
  } else if ["vosotros", "vosotras"].contains(pronoun) {
    return "os"
  } else {
    return ""
  }
}

/// What the conjugation state is for the conjugate feature.
enum ESConjugationState {
  case indicativePresent
  case preterite
  case imperfect
}

var esConjugationState: ESConjugationState = .indicativePresent

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func esGetConjugationTitle() -> String {
  if inputWordIsCapitalized {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch esConjugationState {
  case .indicativePresent:
    return commandPromptSpacing + "Presente: " + verbToDisplay
  case .preterite:
    return commandPromptSpacing + "Pretérito: " + verbToDisplay
  case .imperfect:
    return commandPromptSpacing + "Imperfecto: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func esGetConjugationState() -> String {
  switch esConjugationState {
  case .indicativePresent:
    return "pres"
  case .preterite:
    return "pret"
  case .imperfect:
    return "imp"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func esConjugationStateLeft() {
  switch esConjugationState {
  case .indicativePresent:
    break
  case .preterite:
    conjViewShiftButtonsState = .leftInactive
    esConjugationState = .indicativePresent
  case .imperfect:
    conjViewShiftButtonsState = .bothActive
    esConjugationState = .preterite
  }
}

/// Action associated with the right view switch button of the conjugation state.
func esConjugationStateRight() {
  switch esConjugationState {
  case .indicativePresent:
    conjViewShiftButtonsState = .bothActive
    esConjugationState = .preterite
  case .preterite:
    conjViewShiftButtonsState = .rightInactive
    esConjugationState = .imperfect
  case .imperfect:
    break
  }
}
