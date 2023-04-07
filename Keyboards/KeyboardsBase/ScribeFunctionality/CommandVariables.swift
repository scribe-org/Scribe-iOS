//
//  CommandVariables.swift
//
//  Variables associated with Scribe commands.
//

import UIKit

// Basic keyboard functionality variables.
var capsLockPossible = false
var doubleSpacePeriodPossible = false
var autoAction1Visible = true
var autoAction3Visible = true
var emojiSuggestVisible = false
var shouldHighlightFirstCompletion = false
var allowUndo = false
var previousWord = ""
var backspaceTimer: Timer?
var scribeKeyHeight = CGFloat(0)

// All data needed for Scribe commands for the given language keyboard.
var nouns = loadJSON(filename: "nouns")
let verbs = loadJSON(filename: "verbs")
let translations = loadJSON(filename: "translations")
let prepositions = loadJSON(filename: "prepositions")
let autosuggestions = loadJSON(filename: "autosuggestions")
let emojiKeywords = loadJSON(filename: "emoji_keywords")

// Words that should not be included in autocomplete should be added to the string below.
var autocompleteWords = [String]()
var baseAutosuggestions = [String]()
var emojisToSuggestArray = [String]()
var numericAutosuggestions = [String]()
var pronounAutosuggestionTenses: [String: String] = [:]
var verbsAfterPronounsArray = [String]()

var currentPrefix = ""
var pastStringInTextProxy = ""
var completionWords = [String]()

// A larger vertical bar than the normal | key for the cursor.
let commandCursor = "│"
var commandPromptSpacing = ""

// Command input and output variables.
var inputWordIsCapitalized = false
var wordToReturn = ""
var invalidCommandMsg = ""

// Annotation variables.
var annotationState = false
var activateAnnotationBtn = false
var prepAnnotationForm = ""
var annotationBtns = [UIButton]()
var annotationColors = [UIColor]()
var annotationSeparators = [UIView]()
var annotationDisplayWord = ""
var wordToCheck = ""
var wordsTyped = [String]()
var annotationsToAssign = [String]()
var isNoun = false
var isPrep = false

// Prompts and saving groups of languages.
var allPrompts = [""]
var allColoredPrompts: [NSAttributedString] = []

let languagesWithCapitalizedNouns = ["German"]
let languagesWithCaseDependantOnPrepositions = ["German", "Russian"]

// MARK: Translate Variables
var translateKeyLbl = ""
var translatePrompt = ""
var translatePlaceholder = ""
var translatePromptAndCursor = ""
var translatePromptAndPlaceholder = ""
var translatePromptAndColorPlaceholder = NSMutableAttributedString()
var wordToTranslate = ""

// MARK: Conjugate Variables
var conjugateKeyLbl = ""
var conjugatePrompt = ""
var conjugatePlaceholder = ""
var conjugatePromptAndCursor = ""
var conjugatePromptAndPlaceholder = ""
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

var formFPS = ""
var formSPS = ""
var formTPS = ""
var formFPP = ""
var formSPP = ""
var formTPP = ""

var formTop = ""
var formMiddle = ""
var formBottom = ""

var formTopLeft = ""
var formTopRight = ""
var formBottomLeft = ""
var formBottomRight = ""

var formLeft = ""
var formRight = ""

var formSingle = ""

var formLabelsDict = [
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

var verbToConjugate = ""
var verbToDisplay = ""
var wordToDisplay = ""
var conjugationToDisplay = ""
var verbConjugated = ""

// MARK: Plural Variables
var pluralKeyLbl = ""
var pluralPrompt = ""
var pluralPlaceholder = ""
var pluralPromptAndCursor = ""
var pluralPromptAndPlaceholder = ""
var pluralPromptAndColorPlaceholder = NSMutableAttributedString()
var alreadyPluralMsg = ""
