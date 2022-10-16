//
//  CommandVariables.swift
//
//  Variables associated with Scribe commands.
//

import UIKit

// Basic keyboard functionality variables.
var capsLockPossible = false
var doubleSpacePeriodPossible = false
var autoAction1Visible: Bool = true
var backspaceTimer: Timer?
var scribeKeyHeight = CGFloat(0)

// All data needed for Scribe commands for the given language keyboard.
var nouns = loadJSON(filename: "nouns")
let verbs = loadJSON(filename: "verbs")
let translations = loadJSON(filename: "translations")
let prepositions = loadJSON(filename: "prepositions")
let autosuggestions = loadJSON(filename: "autosuggestions")

// Words that should not be included in autocomplete should be added to the string below.
var autocompleteWords = [String]()
var baseAutosuggestions = [String]()
var numericAutosuggestions = [String]()
var pronounAutosuggestionTenses: [String: String] = [:]
var verbsAfterPronounsArray = [String]()

var currentPrefix: String = ""
var pastStringInTextProxy: String = ""
var completionWords = [String]()

// A larger vertical bar than the normal | key for the cursor.
let commandCursor: String = "│"
var commandPromptSpacing: String = ""

// Command input and output variables.
var inputWordIsCapitalized: Bool = false
var wordToReturn: String = ""
var invalidCommandMsg: String = ""

// Annotation variables.
var annotationState: Bool = false
var activateAnnotationBtn: Bool = false
var prepAnnotationForm: String = ""
var annotationBtns: [UIButton] = [UIButton]()
var annotationColors: [UIColor] = [UIColor]()
var annotationSeparators: [UIView] = [UIView]()
var annotationDisplayWord: String = ""
var wordToCheck: String = ""
var wordsTyped: [String] = [String]()
var annotationsToAssign: [String] = [String]()
var isNoun: Bool = false
var isPrep: Bool = false

// Prompts and saving groups of languages.
var allPrompts: [String] = [""]
var allColoredPrompts: [NSAttributedString] = []

let languagesWithCapitalizedNouns = ["German"]
let languagesWithCaseDependantOnPrepositions = ["German", "Russian"]

// MARK: Translate Variables
var translateKeyLbl: String = ""
var translatePrompt: String = ""
var translatePlaceholder: String = ""
var translatePromptAndCursor: String = ""
var translatePromptAndPlaceholder: String = ""
var translatePromptAndColorPlaceholder = NSMutableAttributedString()
var wordToTranslate: String = ""

// MARK: Conjugate Variables
var conjugateKeyLbl: String = ""
var conjugatePrompt: String = ""
var conjugatePlaceholder: String = ""
var conjugatePromptAndCursor: String = ""
var conjugatePromptAndPlaceholder: String = ""
var conjugatePromptAndColorPlaceholder = NSMutableAttributedString()

/// What the view of the conjugation display to display to the user.
enum FormsDisplayDimensions {
  case view3x2
  case view3x1
  case view2x2
  case view1x2
  case view1x1
}

var formsDisplayDimensions: FormsDisplayDimensions = .view3x2

var allConjugations = [String]()
var allConjugationBtns = [UIButton]()

var formFPS: String = ""
var formSPS: String = ""
var formTPS: String = ""
var formFPP: String = ""
var formSPP: String = ""
var formTPP: String = ""

var formTop: String = ""
var formMiddle: String = ""
var formBottom: String = ""

var formTopLeft: String = ""
var formTopRight: String = ""
var formBottomLeft: String = ""
var formBottomRight: String = ""

var formLeft: String = ""
var formRight: String = ""

var formSingle: String = ""

var formLabelsDict: [String: String] = [
  "FPS": "",
  "SPS": "",
  "TPS": "",
  "FPP": "",
  "SPP": "",
  "TPP": "",
  "Top": "",
  "Bottom": "",
  "Middle": "",
  "TL": "",
  "TR": "",
  "BL": "",
  "BR": "",
  "Left": "",
  "Right": "",
  "Single": ""
]

var verbToConjugate: String = ""
var verbToDisplay: String = ""
var wordToDisplay: String = ""
var conjugationToDisplay: String = ""
var verbConjugated: String = ""

// MARK: Plural Variables
var pluralKeyLbl: String = ""
var pluralPrompt: String = ""
var pluralPlaceholder: String = ""
var pluralPromptAndCursor: String = ""
var pluralPromptAndPlaceholder: String = ""
var pluralPromptAndColorPlaceholder = NSMutableAttributedString()
var alreadyPluralMsg: String = ""
