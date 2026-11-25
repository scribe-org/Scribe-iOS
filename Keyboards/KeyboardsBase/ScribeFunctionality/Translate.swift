// SPDX-License-Identifier: GPL-3.0-or-later

/*
 * Functions that control the translate command.
 */

import UIKit

/// Inserts the translation of a valid word in the command bar into the proxy.
///
/// - Parameters
///   - commandBar: the command bar into which an input was entered.
func queryTranslation(commandBar: UILabel) {
    // Cancel via a return press.
    if let commandBarText = commandBar.text,
       commandBarText == translatePromptAndCursor
       || commandBarText == translatePromptAndPlaceholder {
        return
    }

    if let commandBarText = commandBar.text {
        let startIndex = commandBarText.index(
            commandBarText.startIndex, offsetBy: translatePrompt.count
        )
        let endIndex = commandBarText.index(commandBarText.endIndex, offsetBy: -1)
        wordToTranslate = String(commandBarText[startIndex ..< endIndex])
    }

    queryWordToTranslate(queriedWordToTranslate: wordToTranslate)
}

func queryWordToTranslate(queriedWordToTranslate: String) {
    wordToTranslate = String(queriedWordToTranslate.trailingSpacesTrimmed)

    guard !wordToTranslate.isEmpty else {
        commandState = .invalid
        return
    }

    // Check to see if the input was uppercase to return an uppercase conjugation.
    inputWordIsCapitalized = wordToTranslate.substring(toIdx: 1).isUppercase

    let translations = LanguageDBManager.translations.queryTranslation(of: wordToTranslate.lowercased())
    if let firstTranslation = translations.first, !firstTranslation.isEmpty {
        wordToReturn = firstTranslation
    } else {
        let fallbackTranslations = LanguageDBManager.translations.queryTranslation(of: wordToTranslate)
        if let firstFallback = fallbackTranslations.first, !firstFallback.isEmpty {
            wordToReturn = firstFallback
        } else {
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
