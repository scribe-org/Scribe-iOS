// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Variables associated with commands for the Russian Scribe keyboard.
 */

func ruSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }

  switch ruConjugationState {
  case .present:
    formLabelsDict["FPS"] = "я"
    formLabelsDict["SPS"] = "ты"
    formLabelsDict["TPS"] = "он/она/оно"
    formLabelsDict["FPP"] = "мы"
    formLabelsDict["SPP"] = "вы"
    formLabelsDict["TPP"] = "они"
  case .past:
    formLabelsDict["TL"] = "я/ты/он"
    formLabelsDict["TR"] = "я/ты/она"
    formLabelsDict["BL"] = "оно"
    formLabelsDict["BR"] = "мы/вы/они"
  }
}

func ruSetCaseDeclensionLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }

  formLabelsDict["FPS"] = "я"
  formLabelsDict["SPS"] = "ты"
  formLabelsDict["TPS"] = "он/она/оно"
  formLabelsDict["FPP"] = "мы"
  formLabelsDict["SPP"] = "вы"
  formLabelsDict["TPP"] = "они"
}

/// What the conjugation state is for the conjugate feature.
enum RUConjugationState {
  case present
  case past
}

/// What the conjugation state is for the case conjugate feature.
enum RUCaseDeclensionState {
  case accusative
  case dative
  case genitive
  case instrumental
  case prepositional
}

var ruConjugationState: RUConjugationState = .present
var ruCaseDeclensionState: RUCaseDeclensionState = .accusative

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func ruGetConjugationTitle() -> String {
  if inputWordIsCapitalized {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch ruConjugationState {
  case .present:
    return commandPromptSpacing + "Настоящее: " + verbToDisplay
  case .past:
    return commandPromptSpacing + "Прошедшее: " + verbToDisplay
  }
}

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func ruGetCaseDeclensionTitle() -> String {
  switch ruCaseDeclensionState {
  case .accusative:
    return commandPromptSpacing + "Винительные местоимения"
  case .dative:
    return commandPromptSpacing + "Дательные местоимения"
  case .genitive:
    return commandPromptSpacing + "Родительные местоимения"
  case .instrumental:
    return commandPromptSpacing + "Творительные местоимения"
  case .prepositional:
    return commandPromptSpacing + "Предложные местоимения"
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func ruGetConjugationState() -> String {
  switch ruConjugationState {
  case .present:
    return "pres"
  case .past:
    return "past"
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func ruSetCaseDeclensions() {
  switch ruCaseDeclensionState {
  case .accusative:
    formFPS = "меня"
    formSPS = "тебя"
    formTPS = "его/её/его"
    formFPP = "нас"
    formSPP = "вас"
    formTPP = "их"
  case .dative:
    formFPS = "мне"
    formSPS = "тебе"
    formTPS = "ему/ей/ему"
    formFPP = "нам"
    formSPP = "вам"
    formTPP = "им"
  case .genitive:
    formFPS = "меня"
    formSPS = "тебя"
    formTPS = "его/её/его"
    formFPP = "нас"
    formSPP = "вас"
    formTPP = "их"
  case .instrumental:
    formFPS = "мной"
    formSPS = "тобой"
    formTPS = "им/ей/им"
    formFPP = "нами"
    formSPP = "вами"
    formTPP = "ими"
  case .prepositional:
    formFPS = "мне"
    formSPS = "тебе"
    formTPS = "нём/ней/нём"
    formFPP = "нас"
    formSPP = "вас"
    formTPP = "них"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func ruConjugationStateLeft() {
  if commandState == .selectCaseDeclension {
    switch ruCaseDeclensionState {
    case .accusative:
      break
    case .dative:
      conjViewShiftButtonsState = .leftInactive
      ruCaseDeclensionState = .accusative
    case .genitive:
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .dative
    case .instrumental:
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .genitive
    case .prepositional:
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .instrumental
    }
  } else {
    switch ruConjugationState {
    case .present:
      break
    case .past:
      conjViewShiftButtonsState = .leftInactive
      ruConjugationState = .present
    }
  }
}

/// Action associated with the right view switch button of the conjugation state.
func ruConjugationStateRight() {
  if commandState == .selectCaseDeclension {
    switch ruCaseDeclensionState {
    case .accusative:
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .dative
    case .dative:
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .genitive
    case .genitive:
      conjViewShiftButtonsState = .bothActive
      ruCaseDeclensionState = .instrumental
    case .instrumental:
      conjViewShiftButtonsState = .rightInactive
      ruCaseDeclensionState = .prepositional
    case .prepositional:
      break
    }
  } else {
    switch ruConjugationState {
    case .present:
      conjViewShiftButtonsState = .rightInactive
      ruConjugationState = .past
    case .past:
      break
    }
  }
}
