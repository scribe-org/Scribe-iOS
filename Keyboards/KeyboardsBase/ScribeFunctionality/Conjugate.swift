// SPDX-License-Identifier: GPL-3.0-or-later

/// Functions and elements that control the conjugation command.

import UIKit

/// Triggers the display of the conjugation view for a valid verb in the command bar.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
func triggerVerbConjugation(commandBar: UILabel) -> Bool {
  // Cancel via a return press.
  if let commandBarText = commandBar.text,
     commandBarText == conjugatePromptAndCursor || commandBarText == conjugatePromptAndCursor {
    return false
  }

  if let commandBarText = commandBar.text {
    let startIndex = commandBarText.index(commandBarText.startIndex, offsetBy: conjugatePrompt.count)
    let endIndex = commandBarText.index(commandBarText.endIndex, offsetBy: -1)
    verbToConjugate = String(commandBarText[startIndex ..< endIndex])
  }

  return isVerbInConjugationTable(queriedVerbToConjugate: verbToConjugate)
}

/// Checks if the verb to conjugate exists in the conjugation table.
/// - Parameters:
///   - queriedVerbToConjugate: The verb to check for existence.
/// - Returns: True if the verb exists in the conjugation table, false otherwise.
func isVerbInConjugationTable(queriedVerbToConjugate: String) -> Bool {
  verbToConjugate = String(queriedVerbToConjugate.trailingSpacesTrimmed)

  let firstLetter = verbToConjugate.substring(toIdx: 1)
  inputWordIsCapitalized = firstLetter.isUppercase
  verbToConjugate = verbToConjugate.lowercased()

  // Try to query any conjugation form to verify verb exists.
  let columnName = (controllerLanguage == "Swedish") ? "verb" : "infinitive"
  let results = LanguageDBManager.shared.queryVerb(of: verbToConjugate, with: [columnName])

  return !results.isEmpty && !results[0].isEmpty
}
