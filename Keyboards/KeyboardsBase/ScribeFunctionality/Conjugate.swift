/**
 * Functions and elements that control the conjugation command.
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

// Dictionary for accessing keyboard conjugation state.
let keyboardConjTitleDict: [String: Any] = [
  "French": frGetConjugationTitle,
  "German": deGetConjugationTitle,
  "Italian": itGetConjugationTitle,
  "Portuguese": ptGetConjugationTitle,
  "Russian": ruGetConjugationTitle,
  "Spanish": esGetConjugationTitle,
  "Swedish": svGetConjugationTitle
]

// Dictionary for accessing keyboard conjugation state.
let keyboardConjStateDict: [String: Any] = [
  "French": frGetConjugationState,
  "German": deGetConjugationState,
  "Italian": itGetConjugationState,
  "Portuguese": ptGetConjugationState,
  "Russian": ruGetConjugationState,
  "Spanish": esGetConjugationState,
  "Swedish": svGetConjugationState
]

// Dictionary for accessing keyboard conjugation state.
let keyboardConjLabelDict: [String: Any] = [
  "French": frSetConjugationLabels,
  "German": deSetConjugationLabels,
  "Italian": itSetConjugationLabels,
  "Portuguese": ptSetConjugationLabels,
  "Russian": ruSetConjugationLabels,
  "Spanish": esSetConjugationLabels,
  "Swedish": svSetConjugationLabels
]

/// Returns a declension once a user presses a key in the conjugateView.
///
/// - Parameters
///   - keyPressed: the button pressed as sender.
///   - requestedForm: the form that is triggered by the given key.
func returnDeclension(keyPressed: UIButton) {
  let wordPressed = keyPressed.titleLabel?.text ?? ""

  var keyName = ""
  if let originalKeyValue = keyPressed.layer.value(forKey: "original") as? String {
    keyName = originalKeyValue
  }

  if !(wordPressed.contains("/") || wordPressed.contains("∗")) {
    proxy.insertText(wordPressed + " ")
    deCaseVariantDeclensionState = .disabled
    autoActionState = .suggest
    commandState = .idle
  } else if controllerLanguage == "Russian" { // pronoun selection paths not implemented for Russian
    proxy.insertText(wordPressed + " ")
    deCaseVariantDeclensionState = .disabled
    autoActionState = .suggest
    commandState = .idle
  } else {
    // Change to a new form selection display.
    if deCaseVariantDeclensionState == .disabled {
      if deCaseDeclensionState == .accusativePersonal {
        if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .accusativePersonalSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .accusativePersonalTPS
        }
      } else if deCaseDeclensionState == .dativePersonal {
        if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .dativePersonalSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .dativePersonalTPS
        }
      } else if deCaseDeclensionState == .genitivePersonal {
        if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .genitivePersonalSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .genitivePersonalTPS
        }
      } else if deCaseDeclensionState == .accusativePossessive {
        if keyName == "firstPersonSingular" {
          deCaseVariantDeclensionState = .accusativePossessiveFPS
        } else if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .accusativePossessiveSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .accusativePossessiveTPS
        } else if keyName == "firstPersonPlural" {
          deCaseVariantDeclensionState = .accusativePossessiveFPP
        } else if keyName == "secondPersonPlural" {
          deCaseVariantDeclensionState = .accusativePossessiveSPP
        } else if keyName == "thirdPersonPlural" {
          deCaseVariantDeclensionState = .accusativePossessiveTPP
        }
      } else if deCaseDeclensionState == .dativePossessive {
        if keyName == "firstPersonSingular" {
          deCaseVariantDeclensionState = .dativePossessiveFPS
        } else if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .dativePossessiveSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .dativePossessiveTPS
        } else if keyName == "firstPersonPlural" {
          deCaseVariantDeclensionState = .dativePossessiveFPP
        } else if keyName == "secondPersonPlural" {
          deCaseVariantDeclensionState = .dativePossessiveSPP
        } else if keyName == "thirdPersonPlural" {
          deCaseVariantDeclensionState = .dativePossessiveTPP
        }
      } else if deCaseDeclensionState == .genitivePossessive {
        if keyName == "firstPersonSingular" {
          deCaseVariantDeclensionState = .genitivePossessiveFPS
        } else if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .genitivePossessiveSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .genitivePossessiveTPS
        } else if keyName == "firstPersonPlural" {
          deCaseVariantDeclensionState = .genitivePossessiveFPP
        } else if keyName == "secondPersonPlural" {
          deCaseVariantDeclensionState = .genitivePossessiveSPP
        } else if keyName == "thirdPersonPlural" {
          deCaseVariantDeclensionState = .genitivePossessiveTPP
        }
      }
    } else {
      if deCaseVariantDeclensionState == .accusativePossessiveSPS {
        if keyName == "formLeft" {
          deCaseVariantDeclensionState = .accusativePossessiveSPSInformal
        } else if keyName == "formRight" {
          deCaseVariantDeclensionState = .accusativePossessiveSPSFormal
        }
      } else if deCaseVariantDeclensionState == .accusativePossessiveTPS {
        if keyName == "formTop" {
          deCaseVariantDeclensionState = .accusativePossessiveTPSMasculine
        } else if keyName == "formMiddle" {
          deCaseVariantDeclensionState = .accusativePossessiveTPSFeminine
        } else if keyName == "formBottom" {
          deCaseVariantDeclensionState = .accusativePossessiveTPSNeutral
        }
      } else if deCaseVariantDeclensionState == .dativePossessiveSPS {
        if keyName == "formLeft" {
          deCaseVariantDeclensionState = .dativePossessiveSPSInformal
        } else if keyName == "formRight" {
          deCaseVariantDeclensionState = .dativePossessiveSPSFormal
        }
      } else if deCaseVariantDeclensionState == .dativePossessiveTPS {
        if keyName == "formTop" {
          deCaseVariantDeclensionState = .dativePossessiveTPSMasculine
        } else if keyName == "formMiddle" {
          deCaseVariantDeclensionState = .dativePossessiveTPSFeminine
        } else if keyName == "formBottom" {
          deCaseVariantDeclensionState = .dativePossessiveTPSNeutral
        }
      } else if deCaseVariantDeclensionState == .genitivePossessiveSPS {
        if keyName == "formLeft" {
          deCaseVariantDeclensionState = .genitivePossessiveSPSInformal
        } else if keyName == "formRight" {
          deCaseVariantDeclensionState = .genitivePossessiveSPSFormal
        }
      } else if deCaseVariantDeclensionState == .genitivePossessiveTPS {
        if keyName == "formTop" {
          deCaseVariantDeclensionState = .genitivePossessiveTPSMasculine
        } else if keyName == "formMiddle" {
          deCaseVariantDeclensionState = .genitivePossessiveTPSFeminine
        } else if keyName == "formBottom" {
          deCaseVariantDeclensionState = .genitivePossessiveTPSNeutral
        }
      }
    }
    commandState = .selectCaseDeclension
  }
}

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
  verbToConjugate = String(verbToConjugate.trailingSpacesTrimmed)

  // Check to see if the input was uppercase to return an uppercase conjugation.
  let firstLetter = verbToConjugate.substring(toIdx: 1)
  inputWordIsCapitalized = firstLetter.isUppercase
  verbToConjugate = verbToConjugate.lowercased()

  let verbInTable = LanguageDBManager.shared.queryVerb(of: verbToConjugate)[0]

  return verbToConjugate == verbInTable
}

/// Returns a conjugation once a user presses a key in the conjugateView or triggers a declension.
///
/// - Parameters
///   - keyPressed: the button pressed as sender.
///   - requestedForm: the form that is triggered by the given key.
func returnConjugation(keyPressed: UIButton, requestedForm: String) {
  let outputCols = [requestedForm]

  if commandState == .selectCaseDeclension {
    returnDeclension(keyPressed: keyPressed)
    return
  }

  let wordPressed = keyPressed.titleLabel?.text ?? ""

  // Don't change proxy if they select a conjugation that's missing.
  if wordPressed == invalidCommandMsg {
    proxy.insertText("")
  } else if formsDisplayDimensions == .view3x2 {
    wordToReturn = LanguageDBManager.shared.queryVerb(of: verbToConjugate, with: outputCols)[0]
    potentialWordsToReturn = wordToReturn.components(separatedBy: " ")

    if inputWordIsCapitalized {
      if controllerLanguage == "German", potentialWordsToReturn.count == 2 {
        // Don't return a space as well as we have a perfect verb and the cursor will be between.
        proxy.insertText(wordToReturn.capitalize())
      } else {
        proxy.insertText(wordToReturn.capitalized + " ")
      }
    } else {
      proxy.insertText(wordToReturn + " ")
    }
  } else if formsDisplayDimensions == .view2x2 {
    wordToReturn = LanguageDBManager.shared.queryVerb(of: verbToConjugate, with: outputCols)[0]
    potentialWordsToReturn = wordToReturn.components(separatedBy: " ")

    if inputWordIsCapitalized {
      proxy.insertText(wordToReturn.capitalized + " ")
    } else {
      proxy.insertText(wordToReturn + " ")
    }
  }

  if controllerLanguage == "German" {
    if potentialWordsToReturn.count == 2 {
      proxy.adjustTextPosition(byCharacterOffset: (potentialWordsToReturn[1].count) * -1)
    }
  }

  autoActionState = .suggest
  commandState = .idle
  conjViewShiftButtonsState = .bothInactive
}

/// Returns the conjugation state to its initial conjugation based on the keyboard language.
func resetVerbConjugationState() {
  conjViewShiftButtonsState = .leftInactive
  if controllerLanguage.prefix("French".count) == "French" {
    frConjugationState = .indicativePresent
  } else if controllerLanguage == "German" {
    deConjugationState = .indicativePresent
  } else if controllerLanguage == "Italian" {
    itConjugationState = .present
  } else if controllerLanguage == "Portuguese" {
    ptConjugationState = .indicativePresent
  } else if controllerLanguage == "Russian" {
    ruConjugationState = .present
  } else if controllerLanguage == "Spanish" {
    esConjugationState = .indicativePresent
  } else if controllerLanguage == "Swedish" {
    svConjugationState = .active
  }
}

/// Returns the conjugation state to its initial conjugation based on the keyboard language.
func resetCaseDeclensionState() {
  // The case conjugation display starts on the left most case.
  if controllerLanguage == "German" {
    if prepAnnotationForm.contains("Acc") {
      conjViewShiftButtonsState = .leftInactive
      deCaseDeclensionState = .accusativeDefinite
    } else if prepAnnotationForm.contains("Dat") {
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dativeDefinite
    } else {
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitiveDefinite
    }
  } else if controllerLanguage == "Russian" {
    if prepAnnotationForm.contains("Acc") {
      conjViewShiftButtonsState = .leftInactive
      ruCaseDeclensionState = .accusative
    } else if prepAnnotationForm.contains("Dat") {
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .dative
    } else if prepAnnotationForm.contains("Gen") {
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .genitive
    } else if prepAnnotationForm.contains("Pre") {
      conjViewShiftButtonsState = .rightInactive
      ruCaseDeclensionState = .prepositional
    } else {
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .instrumental
    }
  }
}

/// Runs an action associated with the left view switch button of the conjugation state based on the keyboard language.
func conjugationStateLeft() {
  if controllerLanguage.prefix("French".count) == "French" {
    frConjugationStateLeft()
  } else if controllerLanguage == "German" {
    deConjugationStateLeft()
  } else if controllerLanguage == "Italian" {
    itConjugationStateLeft()
  } else if controllerLanguage == "Portuguese" {
    ptConjugationStateLeft()
  } else if controllerLanguage == "Russian" {
    ruConjugationStateLeft()
  } else if controllerLanguage == "Spanish" {
    esConjugationStateLeft()
  } else if controllerLanguage == "Swedish" {
    svConjugationStateLeft()
  }
}

/// Runs an action associated with the right view switch button of the conjugation state based on the keyboard language.
func conjugationStateRight() {
  if controllerLanguage.prefix("French".count) == "French" {
    frConjugationStateRight()
  } else if controllerLanguage == "German" {
    deConjugationStateRight()
  } else if controllerLanguage == "Italian" {
    itConjugationStateRight()
  } else if controllerLanguage == "Portuguese" {
    ptConjugationStateRight()
  } else if controllerLanguage == "Russian" {
    ruConjugationStateRight()
  } else if controllerLanguage == "Spanish" {
    esConjugationStateRight()
  } else if controllerLanguage == "Swedish" {
    svConjugationStateRight()
  }
}
