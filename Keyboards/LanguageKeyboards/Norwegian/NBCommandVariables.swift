/**
 * Variables associated with commands for the Norwegian Bokmål Scribe keyboard.
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

func nbSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }
}

/// What the conjugation state is for the conjugate feature.
enum NBConjugationState {
  case present
}

var nbConjugationState: NBConjugationState = .present

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func nbGetConjugationTitle() {}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func nbGetConjugationState() {}

/// Action associated with the left view switch button of the conjugation state.
func nbConjugationStateLeft() {}

/// Action associated with the right view switch button of the conjugation state.
func nbConjugationStateRight() {}
