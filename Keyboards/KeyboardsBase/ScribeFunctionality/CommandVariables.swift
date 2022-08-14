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
var autoAction2Visible: Bool = true
var removeLeftAutoActionPartition = false
var backspaceTimer: Timer?

// All data needed for Scribe commands for the given language keyboard.
let nouns = loadJSONToDict(filename: "nouns")
let verbs = loadJSONToDict(filename: "verbs")
let translations = loadJSONToDict(filename: "translations")
let prepositions = loadJSONToDict(filename: "prepositions")

// Words that should not be included in autocomplete should be added to the string below.
let autocompleteWords = nouns!.keys.filter(
  { $0.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890-")) == nil }
).sorted()

var currentPrefix: String = ""
var pastStringInTextProxy: String = ""
var secondaryPastStringOnDelete: String = ""
var completionWords = [String]()

// A larger vertical bar than the normal | key for the cursor.
let commandCursor: String = "│"
var commandPromptSpacing: String = ""
var commandState: Bool = false

// Command input and output variables.
var inputWordIsCapitalized: Bool = false
var wordToReturn: String = ""
var invalidState: Bool = false
var invalidCommandMsg: String = ""

// Annotation variables.
var annotationState: Bool = false
var nounAnnotationsToDisplay: Int = 0
var prepAnnotationState: Bool = false
var annotationHeight = CGFloat(0)

// Indicates that the keyboard has switched to another input language.
// For example another input method is needed to translate.
var switchInput: Bool = false

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
var getTranslation: Bool = false
var wordToTranslate: String = ""

// MARK: Conjugate Variables
var conjugateKeyLbl: String = ""
var conjugatePrompt: String = ""
var conjugatePlaceholder: String = ""
var conjugatePromptAndCursor: String = ""
var conjugatePromptAndPlaceholder: String = ""
var conjugatePromptAndColorPlaceholder = NSMutableAttributedString()
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

// MARK: Plural Variables
var pluralKeyLbl: String = ""
var pluralPrompt: String = ""
var pluralPlaceholder: String = ""
var pluralPromptAndCursor: String = ""
var pluralPromptAndPlaceholder: String = ""
var pluralPromptAndColorPlaceholder = NSMutableAttributedString()
var getPlural: Bool = false
var isAlreadyPluralState: Bool = false
var isAlreadyPluralMessage: String = ""
