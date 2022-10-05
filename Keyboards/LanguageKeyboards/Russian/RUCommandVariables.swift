//
//  RUCommandVariables.swift
//
//  Variables associated with Scribe commands for the Russian keyboard.
//

func ruSetConjugationLabels() {
  labelFPS = "я"
  labelSPS = "ты"
  labelTPS = "он/она/оно"
  labelFPP = "мы"
  labelSPP = "вы"
  labelTPP = "они"
  labelTopLeft = ""
  labelTopRight = ""
  labelBottomLeft = ""
  labelBottomRight = ""

  if ruConjugationState == .past {
    labelFPS = ""
    labelSPS = ""
    labelTPS = ""
    labelFPP = ""
    labelSPP = ""
    labelTPP = ""
    labelTopLeft = "я/ты/он"
    labelTopRight = "я/ты/она"
    labelBottomLeft = "оно"
    labelBottomRight = "мы/вы/они"
  }
}

/// What the conjugation state is for the conjugate feature.
enum RUConjugationState {
  case present
  case past
}

/// What the conjugation state is for the case conjugate feature.
enum RUCaseConjugationState {
  case accusative
  case dative
  case genitive
  case instrumental
  case prepositional
}

var ruConjugationState: RUConjugationState = .present
var ruCaseConjugationState: RUCaseConjugationState = .accusative

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func ruGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
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
func ruGetCaseConjugationTitle() -> String {
  switch ruCaseConjugationState {
  case .accusative:
    return commandPromptSpacing + "Винительный местоимения"
  case .dative:
    return commandPromptSpacing + "Дательный местоимения"
  case .genitive:
    return commandPromptSpacing + "Родительный местоимения"
  case .instrumental:
    return commandPromptSpacing + "Твори́тельный местоимения"
  case .prepositional:
    return commandPromptSpacing + "Предло́жный местоимения"
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
func ruSetCaseConjugations() {
  switch ruCaseConjugationState {
  case .accusative:
    conjFPS = "меня"
    conjSPS = "тебя"
    conjTPS = "его/её/его"
    conjFPP = "нас"
    conjSPP = "вас"
    conjTPP = "их"
  case .dative:
    conjFPS = "мне"
    conjSPS = "тебе"
    conjTPS = "ему/ей/ему"
    conjFPP = "нам"
    conjSPP = "вам"
    conjTPP = "им"
  case .genitive:
    conjFPS = "меня"
    conjSPS = "тебя"
    conjTPS = "его/её/его"
    conjFPP = "нас"
    conjSPP = "вас"
    conjTPP = "их"
  case .instrumental:
    conjFPS = "мной"
    conjSPS = "тобой"
    conjTPS = "им/ей/им"
    conjFPP = "нами"
    conjSPP = "вами"
    conjTPP = "ими"
  case .prepositional:
    conjFPS = "мне"
    conjSPS = "тебе"
    conjTPS = "нём/ней/нём"
    conjFPP = "нас"
    conjSPP = "вас"
    conjTPP = "них"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func ruConjugationStateLeft() {
  if commandState == .selectCaseConjugation {
    switch ruCaseConjugationState {
    case .accusative:
      break
    case .dative:
      ruCaseConjugationState = .accusative
    case .genitive:
      ruCaseConjugationState = .dative
    case .instrumental:
      ruCaseConjugationState = .genitive
    case .prepositional:
      ruCaseConjugationState = .instrumental
    }
  } else {
    switch ruConjugationState {
    case .present:
      break
    case .past:
      ruConjugationState = .present
    }
  }
}

/// Action associated with the right view switch button of the conjugation state.
func ruConjugationStateRight() {
  if commandState == .selectCaseConjugation {
    switch ruCaseConjugationState {
    case .accusative:
      ruCaseConjugationState = .dative
    case .dative:
      ruCaseConjugationState = .genitive
    case .genitive:
      ruCaseConjugationState = .instrumental
    case .instrumental:
      ruCaseConjugationState = .prepositional
    case .prepositional:
      break
    }
  } else {
    switch ruConjugationState {
    case .present:
      ruConjugationState = .past
    case .past:
      break
    }
  }
}
