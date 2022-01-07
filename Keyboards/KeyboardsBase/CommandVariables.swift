//
//  CommandVariables.swift
//
//  Variables associated with Scribe commands.
//

import UIKit

// A larger vertical bar than the normal | key for the cursor.
let previewCursor: String = "│"
var previewPromptSpacing: String = ""
var previewState: Bool! = false

var inputWordIsCapitalized: Bool = false
var wordToReturn: String = ""

var invalidState: Bool! = false
var invalidCommandMsg: String = ""

var nounFormToDisplay: String = ""

// Indicates that the keyboard has switched to another.
// For example another input method is needed to translate.
var swtichInput: Bool = false

// Translate, conjugate, and plural variables.
var translateBtnLbl: String = ""
var translatePrompt: String = ""
var translatePromptAndCursor: String = ""
var getTranslation: Bool = false
var wordToTranslate: String = ""

var conjugateBtnLbl: String = ""
var conjugatePrompt: String = ""
var conjugatePromptAndCursor: String = ""
var getConjugation: Bool = false
var conjugateView: Bool = false
var conjugateAlternateView: Bool = false

var allTenses = [String]()
var allConjugationBtns = [UIButton]()

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
var tenseTopRight: String = ""
var tenseBottomLeft: String = ""
var tenseBottomRight: String = ""

var labelTopLeft: String = ""
var labelTopRight: String = ""
var labelBottomLeft: String = ""
var labelBottomRight: String = ""

var verbToConjugate: String = ""
var verbToDisplay: String = ""
var conjugationToDisplay: String = ""
var verbConjugated: String = ""

var pluralBtnLbl: String = ""
var pluralPrompt: String = ""
var pluralPromptAndCursor: String = ""
var getPlural: Bool = false
var isAlreadyPluralState: Bool = false

var allPrompts: [String] = [""]

let languagesWithCapitalizedNouns = ["German"]
let languagesWithCaseDependantOnPrepositions = ["German", "Russian"]

// MARK: French conjugation command variables

func frSetConjugationLabels() {
  labelFPS = "je"
  labelSPS = "tu"
  labelTPS = "il/elle"
  labelFPP = "nous"
  labelSPP = "vous"
  labelTPP = "ils/elles"
}

/// What the conjugation state is for the conjugate feature.
enum FRConjugationState {
  case indicativePresent
  case preterite
  case imperfect
}

var frConjugationState: FRConjugationState = .indicativePresent

/// Sets the title of the preview bar when the keyboard is in conjugate mode.
func frGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch frConjugationState {
  case .indicativePresent:
    return previewPromptSpacing + "Présent: " + verbToDisplay
  case .preterite:
    return previewPromptSpacing + "Passé simple: " + verbToDisplay
  case .imperfect:
    return previewPromptSpacing + "Imparfait: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func frGetConjugationState() -> String {
  switch frConjugationState {
  case .indicativePresent:
    return "indicativePresent"
  case .preterite:
    return "preterite"
  case .imperfect:
    return "imperfect"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func frConjugationStateLeft() {
  if frConjugationState == .indicativePresent {
    return
  } else if frConjugationState == .preterite {
    frConjugationState = .indicativePresent
    return
  } else if frConjugationState == .imperfect {
    frConjugationState = .preterite
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func frConjugationStateRight() {
  if frConjugationState == .indicativePresent {
    frConjugationState = .preterite
  } else if frConjugationState == .preterite {
    frConjugationState = .imperfect
    return
  } else if frConjugationState == .imperfect {
    return
  }
}


// MARK: German conjugation command variables

func deSetConjugationLabels() {
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
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch deConjugationState {
  case .indicativePresent:
    return previewPromptSpacing + "Präsens: " + verbToDisplay
  case .indicativePreterite:
    return previewPromptSpacing + "Präteritum: " + verbToDisplay
  case .indicativePerfect:
    return previewPromptSpacing + "Perfekt: " + verbToDisplay
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

// MARK: Portuguese conjugation command variables

func ptSetConjugationLabels() {
  labelFPS = "eu"
  labelSPS = "tu"
  labelTPS = "ele/ela/você"
  labelFPP = "nós"
  labelSPP = "vós"
  labelTPP = "eles/elas/vocês"
}

/// What the conjugation state is for the conjugate feature.
enum PTConjugationState {
  case indicativePresent
  case pastPerfect
  case pastImperfect
  case futureSimple
}

var ptConjugationState: PTConjugationState = .indicativePresent

/// Sets the title of the preview bar when the keyboard is in conjugate mode.
func ptGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch ptConjugationState {
  case .indicativePresent:
    return previewPromptSpacing + "Presente: " + verbToDisplay
  case .pastPerfect:
    return previewPromptSpacing + "Pretérito Perfeito: " + verbToDisplay
  case .pastImperfect:
    return previewPromptSpacing + "Pretérito Imperfeito: " + verbToDisplay
  case .futureSimple:
    return previewPromptSpacing + "Futuro Simples" + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func ptGetConjugationState() -> String {
  switch ptConjugationState {
  case .indicativePresent:
    return "indicativePresent"
  case .pastPerfect:
    return "pastPerfect"
  case .pastImperfect:
    return "pastImperfect"
  case .futureSimple:
    return "futureSimple"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func ptConjugationStateLeft() {
  if ptConjugationState == .indicativePresent {
    return
  } else if ptConjugationState == .pastPerfect {
    ptConjugationState = .indicativePresent
    return
  } else if ptConjugationState == .pastImperfect {
    ptConjugationState = .pastPerfect
    return
  } else if ptConjugationState == .futureSimple {
    ptConjugationState = .pastImperfect
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func ptConjugationStateRight() {
  if ptConjugationState == .indicativePresent {
    ptConjugationState = .pastPerfect
  } else if ptConjugationState == .pastPerfect {
    ptConjugationState = .pastImperfect
    return
  } else if ptConjugationState == .pastImperfect {
    ptConjugationState = .futureSimple
    return
  } else if ptConjugationState == .futureSimple {
    return
  }
}

// MARK: Russian conjugation command variables

func ruSetConjugationLabels() {
  switch ruConjugationState {
  case .present:
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
  case .past:
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

var ruConjugationState: RUConjugationState = .present

/// Sets the title of the preview bar when the keyboard is in conjugate mode.
func ruGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch ruConjugationState {
  case .present:
    return previewPromptSpacing + "Настоящее: " + verbToDisplay
  case .past:
    return previewPromptSpacing + "Прошедшее: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func ruGetConjugationState() -> String {
  switch ruConjugationState {
  case .present:
    return "present"
  case .past:
    return "past"
  }
}

/// Action associated with the left view switch button of the conjugation state.
func ruConjugationStateLeft() {
  if ruConjugationState == .present {
    return
  } else if ruConjugationState == .past {
    ruConjugationState = .present
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func ruConjugationStateRight() {
  if ruConjugationState == .present {
    ruConjugationState = .past
    return
  } else if ruConjugationState == .past {
    return
  }
}

// MARK: Spanish conjugation command variables

func esSetConjugationLabels() {
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
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch esConjugationState {
  case .indicativePresent:
    return previewPromptSpacing + "Presente: " + verbToDisplay
  case .preterite:
    return previewPromptSpacing + "Pretérito: " + verbToDisplay
  case .imperfect:
    return previewPromptSpacing + "Imperfecto: " + verbToDisplay
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

// MARK: Swedish conjugation command variables

func svSetConjugationLabels() {
  switch svConjugationState {
  case .active:
    labelTopLeft = "imperativ"
    labelTopRight = "liggande"
    labelBottomLeft = "presens"
    labelBottomRight = "dåtid"
  case .passive:
    labelTopLeft = "infinitiv"
    labelTopRight = "liggande"
    labelBottomLeft = "presens"
    labelBottomRight = "dåtid"
  }
}

/// What the conjugation state is for the conjugate feature.
enum SVConjugationState {
  case active
  case passive
}

var svConjugationState: SVConjugationState = .active

/// Sets the title of the preview bar when the keyboard is in conjugate mode.
func svGetConjugationTitle() -> String {
  if inputWordIsCapitalized == true {
    verbToDisplay = verbToConjugate.capitalized
  } else {
    verbToDisplay = verbToConjugate
  }
  switch svConjugationState {
  case .active:
    return previewPromptSpacing + "Aktiv: " + verbToDisplay
  case .passive:
    return previewPromptSpacing + "Passiv: " + verbToDisplay
  }
}

/// Returns the appropriate key in the verbs dictionary to access conjugations.
func svGetConjugationState() -> [String] {
  switch svConjugationState {
  case .active:
    return ["imperative", "activeSupine", "activePresent", "activePreterite"]
  case .passive:
    return ["passiveInfinitive", "passiveSupine", "passivePresent", "passivePreterite"]
  }
}

/// Action associated with the left view switch button of the conjugation state.
func svConjugationStateLeft() {
  if svConjugationState == .active {
    return
  } else if svConjugationState == .passive {
    svConjugationState = .active
    return
  }
}

/// Action associated with the right view switch button of the conjugation state.
func svConjugationStateRight() {
  if svConjugationState == .active {
    svConjugationState = .passive
  } else if svConjugationState == .passive {
    return
  }
}
