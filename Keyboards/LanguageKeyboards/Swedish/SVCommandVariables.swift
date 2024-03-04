/**
 * Variables associated with commands for the Swedish Scribe keyboard.
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

func svSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }

  switch svConjugationState {
  case .active:
    formLabelsDict["TL"] = "imperativ"
    formLabelsDict["TR"] = "liggande"
    formLabelsDict["BL"] = "presens"
    formLabelsDict["BR"] = "dåtid"
  case .passive:
    formLabelsDict["TL"] = "infinitiv"
    formLabelsDict["TR"] = "liggande"
    formLabelsDict["BL"] = "presens"
    formLabelsDict["BR"] = "dåtid"
  }
}

/// What the conjugation state is for the conjugate feature.
enum SVConjugationState {
  case active
  case passive
}

var svConjugationState: SVConjugationState = .active

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func svGetConjugationTitle() -> String {
  if inputWordIsCapitalized {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch svConjugationState {
  case .active:
    return commandPromptSpacing + "Aktiv: " + verbToDisplay
  case .passive:
    return commandPromptSpacing + "Passiv: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func svGetConjugationState() -> [String] {
  switch svConjugationState {
  case .active:
    return ["imperative", "activeSupine", "activePresent", "activePreterite"]
  case .passive:
    return ["passiveInfinitive", "passiveSupine", "passivePresent", "passivePreterite"]
  }
}

/// Action associated with the left view switch button of the conjugation state.
func svConjugationStateLeft() {
  switch svConjugationState {
  case .active:
    break
  case .passive:
    conjViewShiftButtonsState = .leftInactive
    svConjugationState = .active
  }
}

/// Action associated with the right view switch button of the conjugation state.
func svConjugationStateRight() {
  switch svConjugationState {
  case .active:
    conjViewShiftButtonsState = .rightInactive
    svConjugationState = .passive
  case .passive:
    break
  }
}
