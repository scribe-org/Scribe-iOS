//
//  Translate.swift
//
//  Functions that control the translate command.
//

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

  guard !wordToReturn.isEmpty else {
    commandState = .invalid
    return
  }
  if inputWordIsCapitalized {
    proxy.insertText(wordToReturn.capitalized + " ")
  } else {
    proxy.insertText(wordToReturn + " ")
  }
}
