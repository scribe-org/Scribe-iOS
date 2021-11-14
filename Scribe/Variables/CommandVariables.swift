//
//  CommandVariables.swift
//
// Variables assosciated with Scribe commands.
//

// A larger vertical bar than the normal | key for the cursor.
let previewCursor: String = "│"
let previewPromptSpacing = String(repeating: " ", count: 2)

var previewState: Bool! = false
var invalidState: Bool! = false

// Variables assosciated with Scribe commands.
let translatePrompt: String = previewPromptSpacing + "Translate: "
let translatePromptAndCursor: String = translatePrompt + previewCursor
var getTranslation: Bool = false

let conjugatePrompt: String = previewPromptSpacing + "Conjugate: "
let conjugatePromptAndCursor: String = conjugatePrompt + previewCursor
var getConjugation: Bool = false
var conjugateView: Bool = false
var tenseFPS: String = ""
var tenseSPS: String = ""
var tenseTPS: String = ""
var tenseFPP: String = ""
var tenseSPP: String = ""
var tenseTPP: String = ""
var verbToConjugate: String = ""
var verbConjugated: String = ""

let pluralPrompt: String = previewPromptSpacing + "Plural: "
let pluralPromptAndCursor: String = pluralPrompt + previewCursor
var getPlural: Bool = false
var isAlreadyPluralState: Bool = false

let allPrompts: [String] = [translatePromptAndCursor, conjugatePromptAndCursor, pluralPromptAndCursor]

/// What the conjugation state is for the conjugate feature.
enum ConjugationState {
  case indicativePresent
  case indicativePreterite
  case indicativePerfect
}

var conjugationState: ConjugationState = .indicativePresent

func getConjugationTitle() -> String {
  switch conjugationState {
  case .indicativePresent:
    return previewPromptSpacing + "Indikativ Präsens: " + verbToConjugate
  case .indicativePreterite:
    return previewPromptSpacing + "Indikativ Präteritum: " + verbToConjugate
  case .indicativePerfect:
    return previewPromptSpacing + "Indikativ Perfect: " + verbToConjugate
  }
}

func getConjugationState() -> String {
  switch conjugationState {
  case .indicativePresent:
    return "indicativePresent"
  case .indicativePreterite:
    return "indicativePreterite"
  case .indicativePerfect:
    return "indicativePerfect"
  }
}

func conjugationStateLeft() {
  if conjugationState == .indicativePresent {
    return
  } else if conjugationState == .indicativePreterite {
    conjugationState = .indicativePresent
    return
  } else if conjugationState == .indicativePerfect {
    conjugationState = .indicativePreterite
    return
  }
}

func conjugationStateRight() {
  if conjugationState == .indicativePresent {
    conjugationState = .indicativePreterite
  } else if conjugationState == .indicativePreterite {
    conjugationState = .indicativePerfect
    return
  } else if conjugationState == .indicativePerfect {
    return
  }
}

