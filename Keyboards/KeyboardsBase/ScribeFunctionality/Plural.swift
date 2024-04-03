/**
 * Functions that control the plural command.
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

/// Inserts the plural of a valid noun in the command bar into the proxy.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
func queryPlural(commandBar: UILabel) {
  // Cancel via a return press.
  if let commandBarText = commandBar.text,
     commandBarText == pluralPromptAndCursor || commandBarText == pluralPromptAndCursor
  {
    return
  }

  var noun = ""
  if let commandBarText = commandBar.text {
    let startIndex = commandBarText.index(commandBarText.startIndex, offsetBy: pluralPrompt.count)
    let endIndex = commandBarText.index(before: commandBarText.endIndex)
    noun = String(commandBarText[startIndex ..< endIndex])
  }
  noun = String(noun.trailingSpacesTrimmed)

  // Check to see if the input was uppercase to return an uppercase plural.
  inputWordIsCapitalized = false
  if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
    inputWordIsCapitalized = noun.substring(toIdx: 1).isUppercase
    noun = noun.lowercased()
  }

  wordToReturn = LanguageDBManager.shared.queryNounPlural(of: noun)[0]

  guard !wordToReturn.isEmpty else {
    commandState = .invalid
    return
  }

  guard !wordToReturn.isEmpty else {
    commandState = .invalid
    return
  }

  if wordToReturn != "isPlural" {
    if inputWordIsCapitalized {
      proxy.insertText(wordToReturn.capitalized + " ")
    } else {
      proxy.insertText(wordToReturn + " ")
    }
  } else {
    proxy.insertText(noun + " ")
    commandState = .alreadyPlural
  }
}
