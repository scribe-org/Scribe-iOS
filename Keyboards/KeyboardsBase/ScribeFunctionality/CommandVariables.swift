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
var nouns = loadJSONToDict(filename: "nouns")
let verbs = loadJSONToDict(filename: "verbs")
let translations = loadJSONToDict(filename: "translations")
let prepositions = loadJSONToDict(filename: "prepositions")
let autosuggestions = loadJSONToDict(filename: "autosuggestions")

// Words that should not be included in autocomplete should be added to the string below.
var autocompleteWords = [String]()
var baseAutosuggestions = [String]()
var numericAutosuggestions = [String]()

var currentPrefix: String = ""
var pastStringInTextProxy: String = ""
var secondaryPastStringOnDelete: String = ""
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
var conjugateAlternateView: Bool = false

var allConjugations = [String]()
var allConjugationBtns = [UIButton]()

var conjFPS: String = ""
var conjSPS: String = ""
var conjTPS: String = ""
var conjFPP: String = ""
var conjSPP: String = ""
var conjTPP: String = ""

var labelFPS: String = ""
var labelSPS: String = ""
var labelTPS: String = ""
var labelFPP: String = ""
var labelSPP: String = ""
var labelTPP: String = ""

var conjTopLeft: String = ""
var conjTopRight: String = ""
var conjBottomLeft: String = ""
var conjBottomRight: String = ""

var labelTopLeft: String = ""
var labelTopRight: String = ""
var labelBottomLeft: String = ""
var labelBottomRight: String = ""

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
