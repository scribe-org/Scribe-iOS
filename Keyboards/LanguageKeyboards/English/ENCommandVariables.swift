// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Variables associated with commands for the English Scribe keyboard.
 */

func enSetConjugationLabels() {
  // Reset all form labels prior to assignment.
  for k in formLabelsDict.keys {
    formLabelsDict[k] = ""
  }

  switch enConjugationState {
  case .present, .past, .future, .conditional:
    formLabelsDict["TL"] = "Simple"
    formLabelsDict["TR"] = "Continuous"
    formLabelsDict["BL"] = "Perfect"
    formLabelsDict["BR"] = "Perfect Continuous"
  case .presSimp, .presPerf, .presPerfCont:
    formLabelsDict["Left"] = "I/you/plural"
    formLabelsDict["Right"] = "he/she/it"
  case .presCont:
    formLabelsDict["TL"] = "Participle"
    formLabelsDict["TR"] = "I"
    formLabelsDict["BL"] = "you/plural"
    formLabelsDict["BR"] = "he/she/it"
  case .pastCont:
    formLabelsDict["Top"] = "Participle"
    formLabelsDict["Middle"] = "I/he/she/it"
    formLabelsDict["Bottom"] = "you/plural"
  }
}

/// What the conjugation state is for the conjugate feature.
enum ENConjugationState {
  case present
  case presSimp
  case presCont
  case presPerf
  case presPerfCont
  case past
  case pastCont
  case future
  case conditional
}

var enConjugationState: ENConjugationState = .present

/// Sets the title of the command bar when the keyboard is in conjugate mode.
func enGetConjugationTitle() -> String {
  if inputWordIsCapitalized {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch enConjugationState {
  case .present:
    return commandPromptSpacing + "Present: " + verbToDisplay
  case .presSimp:
    return commandPromptSpacing + "Pr. Simple: " + verbToDisplay
  case .presCont:
    return commandPromptSpacing + "Pr. Continuous: " + verbToDisplay
  case .presPerf:
    return commandPromptSpacing + "Pr. Perfect: " + verbToDisplay
  case .presPerfCont:
    return commandPromptSpacing + "Pr. Perf. Continuous: " + verbToDisplay
  case .past:
    return commandPromptSpacing + "Past: " + verbToDisplay
  case .pastCont:
    return commandPromptSpacing + "Past Continuous: " + verbToDisplay
  case .future:
    return commandPromptSpacing + "Future: " + verbToDisplay
  case .conditional:
    return commandPromptSpacing + "Conditional: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func enGetConjugationState() -> [String] {
  switch enConjugationState {
  case .present:
    return ["presTPS", "presPart", "presPerfTPS", "presPerfTPSCont"]
  case .presSimp:
    return ["presSimp", "presTPS"]
  case .presCont:
    return ["presPart", "presFPSCont", "prePluralCont", "presTPSCont"]
  case .presPerf:
    return ["presPerfSimp", "presPerfTPS"]
  case .presPerfCont:
    return ["presPerfSimpCont", "presPerfTPSCont"]
  case .past:
    return ["pastSimp", "presPart", "pastPerf", "pastPerfCont"]
  case .pastCont:
    return ["presPart", "pastSimpCont", "pastSimpPluralCont"]
  case .future:
    return ["futSimp", "futCont", "futPerf", "futPerfCont"]
  case .conditional:
    return ["condSimp", "condCont", "condPerf", "condPerfCont"]
  }
}

/// Action associated with the left view switch button of the conjugation state.
func enConjugationStateLeft() {
  switch enConjugationState {
  case .present, .presSimp, .presCont, .presPerf, .presPerfCont, .pastCont:
    break
  case .past:
    conjViewShiftButtonsState = .leftInactive
    enConjugationState = .present
  case .future:
    enConjugationState = .past
  case .conditional:
    conjViewShiftButtonsState = .bothActive
    enConjugationState = .future
  }
}

/// Action associated with the right view switch button of the conjugation state.
func enConjugationStateRight() {
  switch enConjugationState {
  case .presSimp, .presCont, .presPerf, .presPerfCont, .pastCont, .conditional:
    break
  case .present:
    conjViewShiftButtonsState = .bothActive
    enConjugationState = .past
  case .past:
    enConjugationState = .future
  case .future:
    conjViewShiftButtonsState = .rightInactive
    enConjugationState = .conditional
  }
}
