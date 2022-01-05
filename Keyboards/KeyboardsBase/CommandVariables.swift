//
//  CommandVariables.swift
//
//  Variables associated with Scribe commands.
//

// A larger vertical bar than the normal | key for the cursor.
let previewCursor: String = "│"
var previewPromptSpacing: String = ""

var previewState: Bool! = false
var invalidState: Bool! = false

// Translate, conjugate, and plural variables.
let translatePrompt: String = previewPromptSpacing + "Translate: "
let translatePromptAndCursor: String = translatePrompt + previewCursor
var getTranslation: Bool = false

let conjugatePrompt: String = previewPromptSpacing + "Conjugate: "
let conjugatePromptAndCursor: String = conjugatePrompt + previewCursor
var getConjugation: Bool = false
var conjugateView: Bool = false
var conjugateAlternateView: Bool = false
var tenseFPS: String = ""
var tenseSPS: String = ""
var tenseTPS: String = ""
var tenseFPP: String = ""
var tenseSPP: String = ""
var tenseTPP: String = ""

var labelFPS: String = ""
var labelSPS: String = ""
var labelTPS: String = ""
var labelFPP: String = ""
var labelSPP: String = ""
var labelTPP: String = ""

var tenseTopLeft: String = ""
var tenseBottomLeft: String = ""
var tenseTopRight: String = ""
var tenseBottomRight: String = ""

var labelTopLeft: String = ""
var labelBottomLeft: String = ""
var labelTopRight: String = ""
var labelBottomRight: String = ""

let languagesWithCapitalizedNouns = ["German"]

var verbToConjugate: String = ""
var verbConjugated: String = ""

let pluralPrompt: String = previewPromptSpacing + "Plural: "
let pluralPromptAndCursor: String = pluralPrompt + previewCursor
var getPlural: Bool = false
var isAlreadyPluralState: Bool = false

let allPrompts: [String] = [translatePromptAndCursor, conjugatePromptAndCursor, pluralPromptAndCursor]

// MARK: German conjugation command variables

func deGetConjugationLabels() {
  labelFPS = "ich"
  labelSPS = "du"
  labelTPS = "er/sie/es"
  labelFPP = "wir"
  labelSPP = "ihr"
  labelTPP = "sie/Sie"
}

/// What the conjugation state is for the conjugate feature.
enum DEConjugationState {
  case indicativePresent
  case indicativePreterite
  case indicativePerfect
}

var deConjugationState: DEConjugationState = .indicativePresent

/// Sets the title of the preview bar when the keyboard is in conjugate mode.
func deGetConjugationTitle() -> String {
  switch deConjugationState {
  case .indicativePresent:
    return previewPromptSpacing + "Präsens: " + verbToConjugate
  case .indicativePreterite:
    return previewPromptSpacing + "Präteritum: " + verbToConjugate
  case .indicativePerfect:
    return previewPromptSpacing + "Perfekt: " + verbToConjugate
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func deGetConjugationState() -> String {
  switch deConjugationState {
  case .indicativePresent:
    return "indicativePresent"
  case .indicativePreterite:
    return "indicativePreterite"
  case .indicativePerfect:
    return "indicativePerfect"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func deConjugationStateLeft() {
  if deConjugationState == .indicativePresent {
    return
  } else if deConjugationState == .indicativePreterite {
    deConjugationState = .indicativePresent
    return
  } else if deConjugationState == .indicativePerfect {
    deConjugationState = .indicativePreterite
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func deConjugationStateRight() {
  if deConjugationState == .indicativePresent {
    deConjugationState = .indicativePreterite
  } else if deConjugationState == .indicativePreterite {
    deConjugationState = .indicativePerfect
    return
  } else if deConjugationState == .indicativePerfect {
    return
  }
}

// MARK: Spanish conjugation command variables

func esGetConjugationLabels() {
  labelFPS = "yo"
  labelSPS = "tú"
  labelTPS = "él/ella/Ud."
  labelFPP = "nosotros"
  labelSPP = "vosotros"
  labelTPP = "ellos/ellas/Uds."
}

/// What the conjugation state is for the conjugate feature.
enum ESConjugationState {
  case indicativePresent
  case preterite
  case imperfect
}

var esConjugationState: ESConjugationState = .indicativePresent

/// Sets the title of the preview bar when the keyboard is in conjugate mode.
func esGetConjugationTitle() -> String {
  switch esConjugationState {
  case .indicativePresent:
    return previewPromptSpacing + "Presente: " + verbToConjugate
  case .preterite:
    return previewPromptSpacing + "Pretérito: " + verbToConjugate
  case .imperfect:
    return previewPromptSpacing + "Imperfecto: " + verbToConjugate
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func esGetConjugationState() -> String {
  switch esConjugationState {
  case .indicativePresent:
    return "indicativePresent"
  case .preterite:
    return "preterite"
  case .imperfect:
    return "imperfect"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func esConjugationStateLeft() {
  if esConjugationState == .indicativePresent {
    return
  } else if esConjugationState == .preterite {
    esConjugationState = .indicativePresent
    return
  } else if esConjugationState == .imperfect {
    esConjugationState = .preterite
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func esConjugationStateRight() {
  if esConjugationState == .indicativePresent {
    esConjugationState = .preterite
  } else if esConjugationState == .preterite {
    esConjugationState = .imperfect
    return
  } else if esConjugationState == .imperfect {
    return
  }
}
