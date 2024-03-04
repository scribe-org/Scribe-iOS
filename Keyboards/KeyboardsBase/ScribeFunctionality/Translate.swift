/**
 * Functions that control the translate command.
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

import UIKit

/// Inserts the translation of a valid word in the command bar into the proxy.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
func queryTranslation(commandBar: UILabel) {
  // Cancel via a return press.
  if commandBar.text! == translatePromptAndCursor || commandBar.text! == translatePromptAndPlaceholder {
    return
  }
  wordToTranslate = (commandBar.text!.substring(
    with: translatePrompt.count ..< ((commandBar.text!.count) - 1))
  )
  wordToTranslate = String(wordToTranslate.trailingSpacesTrimmed)

  // Check to see if the input was uppercase to return an uppercase conjugation.
  inputWordIsCapitalized = wordToTranslate.substring(toIdx: 1).isUppercase
  wordToTranslate = wordToTranslate.lowercased()

  let query = "SELECT * FROM translations WHERE word = ?"
  let args = [wordToTranslate]
  let outputCols = ["translation"]
  wordToReturn = queryDBRow(query: query, outputCols: outputCols, args: args)[0]

  if wordToReturn != "" {
    if inputWordIsCapitalized {
      proxy.insertText(wordToReturn.capitalized + " ")
    } else {
      proxy.insertText(wordToReturn + " ")
    }
  } else {
    commandState = .invalid
  }
}
