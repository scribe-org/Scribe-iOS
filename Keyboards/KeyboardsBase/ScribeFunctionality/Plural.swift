// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Functions that control the plural command.
 */

import UIKit

/// Inserts the plural of a valid noun in the command bar into the proxy.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
func queryPlural(commandBar: UILabel) {
  // Cancel via a return press.
  if let commandBarText = commandBar.text,
    commandBarText == pluralPromptAndCursor {
    return
  }

  var noun = ""
  if let commandBarText = commandBar.text {
    let startIndex = commandBarText.index(commandBarText.startIndex, offsetBy: pluralPrompt.count)
    let endIndex = commandBarText.index(before: commandBarText.endIndex)
    noun = String(commandBarText[startIndex ..< endIndex])
  }

  queryPluralNoun(queriedNoun: noun)
}

func queryPluralNoun(queriedNoun: String) {
  var noun = String(queriedNoun.trailingSpacesTrimmed)

  // Check to see if the input was uppercase to return an uppercase plural.
  inputWordIsCapitalized = false
  if !languagesWithCapitalizedNouns.contains(controllerLanguage) {
    inputWordIsCapitalized = noun.substring(toIdx: 1).isUppercase
    noun = noun.lowercased()
  }

  // Check if the word is already plural (always use lowercase for Set lookup).
  let lowercaseNoun = noun.lowercased()
  let isAlreadyPlural = pluralWords?.contains(lowercaseNoun) == true

  if isAlreadyPlural {
    wordToReturn = noun  // Use original capitalization.
    commandState = .alreadyPlural
  } else {
    let result = LanguageDBManager.shared.queryNounPlural(of: noun)
    guard !result.isEmpty, !result[0].isEmpty else {
      commandState = .invalid
      return
    }
    wordToReturn = result[0]
  }

  if inputWordIsCapitalized {
    proxy.insertText(wordToReturn.capitalized + getOptionalSpace())
  } else {
    proxy.insertText(wordToReturn + getOptionalSpace())
  }
}
