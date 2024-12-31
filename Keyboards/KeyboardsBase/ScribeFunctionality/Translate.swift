/**
 * Functions that control the translate command.
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

import UIKit

/// Inserts the translation of a valid word in the command bar into the proxy.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
func queryTranslation(commandBar: UILabel) {
  // Cancel via a return press.
  if let commandBarText = commandBar.text,
      commandBarText == translatePromptAndCursor || commandBarText == translatePromptAndPlaceholder {
    return
  }

  if let commandBarText = commandBar.text {
    let startIndex = commandBarText.index(commandBarText.startIndex, offsetBy: translatePrompt.count)
    let endIndex = commandBarText.index(commandBarText.endIndex, offsetBy: -1)
    wordToTranslate = String(commandBarText[startIndex ..< endIndex])
  }

  queryWordToTranslate(queriedWordToTranslate: wordToTranslate)
}

func queryWordToTranslate(queriedWordToTranslate: String) {
  wordToTranslate = String(queriedWordToTranslate.trailingSpacesTrimmed)

  // Check to see if the input was uppercase to return an uppercase conjugation.
  inputWordIsCapitalized = wordToTranslate.substring(toIdx: 1).isUppercase

  wordToReturn = LanguageDBManager.translations.queryTranslation(of: wordToTranslate.lowercased())[0]

  if wordToReturn.isEmpty {
    wordToReturn = LanguageDBManager.translations.queryTranslation(of: wordToTranslate)[0]
    guard !wordToReturn.isEmpty else {
      commandState = .invalid
      return
    }
  }

  if inputWordIsCapitalized {
    proxy.insertText(wordToReturn.capitalized + getOptionalSpace())
  } else {
    proxy.insertText(wordToReturn + getOptionalSpace())
  }
}
