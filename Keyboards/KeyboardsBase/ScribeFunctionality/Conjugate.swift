//
//  Conjugation.swift
//
//  Functions and elements that control the conjugation command.
//

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
  let wordPressed: String = keyPressed.titleLabel?.text ?? ""

  let keyName = keyPressed.layer.value(
    forKey: "original"
  ) as! String

  if !(wordPressed.contains("/") || wordPressed.contains("∗")) {
    proxy.insertText(wordPressed + " ")
    deCaseVariantDeclensionState = .disabled
    autoActionState = .suggest
    commandState = .idle
  } else if controllerLanguage == "Russian" { // prounoun selection paths not implemented for Russian
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
      } else if deCaseDeclensionState == .accusativePossesive {
        if keyName == "firstPersonSingular" {
          deCaseVariantDeclensionState = .accusativePossesiveFPS
        } else if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .accusativePossesiveSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .accusativePossesiveTPS
        } else if keyName == "firstPersonPlural" {
          deCaseVariantDeclensionState = .accusativePossesiveFPP
        } else if keyName == "secondPersonPlural" {
          deCaseVariantDeclensionState = .accusativePossesiveSPP
        } else if keyName == "thirdPersonPlural" {
          deCaseVariantDeclensionState = .accusativePossesiveTPP
        }
      } else if deCaseDeclensionState == .dativePossesive {
        if keyName == "firstPersonSingular" {
          deCaseVariantDeclensionState = .dativePossesiveFPS
        } else if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .dativePossesiveSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .dativePossesiveTPS
        } else if keyName == "firstPersonPlural" {
          deCaseVariantDeclensionState = .dativePossesiveFPP
        } else if keyName == "secondPersonPlural" {
          deCaseVariantDeclensionState = .dativePossesiveSPP
        } else if keyName == "thirdPersonPlural" {
          deCaseVariantDeclensionState = .dativePossesiveTPP
        }
      } else if deCaseDeclensionState == .genitivePossesive {
        if keyName == "firstPersonSingular" {
          deCaseVariantDeclensionState = .genitivePossesiveFPS
        } else if keyName == "secondPersonSingular" {
          deCaseVariantDeclensionState = .genitivePossesiveSPS
        } else if keyName == "thirdPersonSingular" {
          deCaseVariantDeclensionState = .genitivePossesiveTPS
        } else if keyName == "firstPersonPlural" {
          deCaseVariantDeclensionState = .genitivePossesiveFPP
        } else if keyName == "secondPersonPlural" {
          deCaseVariantDeclensionState = .genitivePossesiveSPP
        } else if keyName == "thirdPersonPlural" {
          deCaseVariantDeclensionState = .genitivePossesiveTPP
        }
      }
    } else {
      if deCaseVariantDeclensionState == .accusativePossesiveSPS {
        if keyName == "formLeft" {
          deCaseVariantDeclensionState = .accusativePossesiveSPSInformal
        } else if keyName == "formRight" {
          deCaseVariantDeclensionState = .accusativePossesiveSPSFormal
        }
      } else if deCaseVariantDeclensionState == .accusativePossesiveTPS {
        if keyName == "formTop" {
          deCaseVariantDeclensionState = .accusativePossesiveTPSMasculine
        } else if keyName == "formMiddle" {
          deCaseVariantDeclensionState = .accusativePossesiveTPSFeminine
        } else if keyName == "formBottom" {
          deCaseVariantDeclensionState = .accusativePossesiveTPSNeutral
        }
      } else if deCaseVariantDeclensionState == .dativePossesiveSPS {
        if keyName == "formLeft" {
          deCaseVariantDeclensionState = .dativePossesiveSPSInformal
        } else if keyName == "formRight" {
          deCaseVariantDeclensionState = .dativePossesiveSPSFormal
        }
      } else if deCaseVariantDeclensionState == .dativePossesiveTPS {
        if keyName == "formTop" {
          deCaseVariantDeclensionState = .dativePossesiveTPSMasculine
        } else if keyName == "formMiddle" {
          deCaseVariantDeclensionState = .dativePossesiveTPSFeminine
        } else if keyName == "formBottom" {
          deCaseVariantDeclensionState = .dativePossesiveTPSNeutral
        }
      } else if deCaseVariantDeclensionState == .genitivePossesiveSPS {
        if keyName == "formLeft" {
          deCaseVariantDeclensionState = .genitivePossesiveSPSInformal
        } else if keyName == "formRight" {
          deCaseVariantDeclensionState = .genitivePossesiveSPSFormal
        }
      } else if deCaseVariantDeclensionState == .genitivePossesiveTPS {
        if keyName == "formTop" {
          deCaseVariantDeclensionState = .genitivePossesiveTPSMasculine
        } else if keyName == "formMiddle" {
          deCaseVariantDeclensionState = .genitivePossesiveTPSFeminine
        } else if keyName == "formBottom" {
          deCaseVariantDeclensionState = .genitivePossesiveTPSNeutral
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
  if commandBar.text! == conjugatePromptAndCursor || commandBar.text! == conjugatePromptAndPlaceholder {
    return false
  }
  verbToConjugate = (commandBar.text!.substring(with: conjugatePrompt.count..<(commandBar.text!.count) - 1))
  verbToConjugate = String(verbToConjugate.trailingSpacesTrimmed)

  // Check to see if the input was uppercase to return an uppercase conjugation.
  let firstLetter = verbToConjugate.substring(toIdx: 1)
  inputWordIsCapitalized = firstLetter.isUppercase
  verbToConjugate = verbToConjugate.lowercased()

  return verbs[verbToConjugate].exists()
}

/// Returns a conjugation once a user presses a key in the conjugateView or triggers a declension.
///
/// - Parameters
///   - keyPressed: the button pressed as sender.
///   - requestedForm: the form that is triggered by the given key.
func returnConjugation(keyPressed: UIButton, requestedForm: String) {
  if commandState == .selectCaseDeclension {
    returnDeclension(keyPressed: keyPressed)
    return
  }
  let wordPressed: String = keyPressed.titleLabel?.text ?? ""

  // Don't change proxy if they select a conjugation that's missing.
  if wordPressed == invalidCommandMsg {
    proxy.insertText("")
  } else if formsDisplayDimensions == .view3x2 {
    if deConjugationState != .indicativePerfect {
      wordToReturn = verbs[verbToConjugate][requestedForm].string ?? ""
      if inputWordIsCapitalized == true {
        proxy.insertText(wordToReturn.capitalized + " ")
      } else {
        proxy.insertText(wordToReturn + " ")
      }
    } else {
      proxy.insertText(verbs[verbToConjugate]["pastParticiple"].string ?? "" + " ")
    }
  } else if formsDisplayDimensions == .view2x2 {
    wordToReturn = verbs[verbToConjugate][requestedForm].string ?? ""
    if inputWordIsCapitalized == true {
      proxy.insertText(wordToReturn.capitalized + " ")
    } else {
      proxy.insertText(wordToReturn + " ")
    }
  }
  autoActionState = .suggest
  commandState = .idle
  conjViewShiftButtonsState = .bothInactive
}

/// Returns the conjugation state to its initial conjugation based on the keyboard language.
func resetVerbConjugationState() {
  conjViewShiftButtonsState = .leftInactive
  if controllerLanguage == "French" {
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
      deCaseDeclensionState = .accusative
    } else if prepAnnotationForm.contains("Dat") {
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .dative
    } else {
      conjViewShiftButtonsState = .bothActive
      deCaseDeclensionState = .genitive
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
  if controllerLanguage == "French" {
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
  if controllerLanguage == "French" {
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
