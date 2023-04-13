//
//  CommandVariables.swift
//
//  Variables associated with Scribe commands.
//

import UIKit
import GRDB

// Basic keyboard functionality variables.
var capsLockPossible = false
var doubleSpacePeriodPossible = false
var autoAction1Visible = true
var autoAction3Visible = true

/// States of the emoji display corresponding to the number to show.
enum EmojisToShow {
  case zero
  case one
  case two
  case three
}

var emojisToShow: EmojisToShow = .zero
var currentEmojiTriggerWord = ""
var emojiAutoActionRepeatPossible = false

var shouldHighlightFirstCompletion = false
var allowUndo = false
var previousWord = ""
var backspaceTimer: Timer?
var scribeKeyHeight = CGFloat(0)

/// Makes a connection to the language database given the value for controllerLanguage.
func openDBQueue() -> DatabaseQueue {
  let dbName = "\(String(describing: get_iso_code(keyboardLanguage: controllerLanguage).uppercased()))LanguageData"
  let dbPath = Bundle.main.path(forResource: dbName, ofType: "sqlite")!
  let db = try! DatabaseQueue(
    path: dbPath
  )

  return db
}

/// Returns a value from the language database given a query and arguemtns.
///
/// - Parameters
///   - query: the query to run against the language database.
///   - args: arguments to pass to the query.
///   - outputCols: the columns from which the value should come.
func queryDB(query: String, args: [String], outputCols: [String]) -> [String] {
  var outputValues = [String]()
  do {
    try languageDB.read { db in
      if let row = try Row.fetchOne(db, sql: query, arguments: StatementArguments(args)) {
        for col in outputCols {
          outputValues.append(row[col])
        }
      }
    }
  } catch {}

  return outputValues
}

var languageDB = try! DatabaseQueue()

// All data needed for Scribe commands for the given language keyboard.
var nouns = loadJSON(filename: "nouns")
let verbs = loadJSON(filename: "verbs")
let translations = loadJSON(filename: "translations")
var prepositions = loadJSON(filename: "prepositions")
let emojiKeywords = loadJSON(filename: "emoji_keywords")
let autosuggestions = loadJSON(filename: "autosuggestions")

/// Performs a few minor edits to language data to make sure that certain values are included.
func expandLanguageDatasets() {
  // Make sure that Scribe shows up in auto actions.
  nouns["Scribe"] = [
    "plural": "Scribes",
    "form": ""
  ]

  // Make sure preposition annotations show for German compound prepositions.
  if controllerLanguage == "German" {
    for (p, g) in contractedGermanPrepositions {
      prepositions[p].stringValue = g
    }
  }
}

/// Creates the word lexicon from with autocompletions will be referenced.
/// Note: this function also calls expandLanguageDatasets prior to creating the lexicon.
func createAutocompleteLexicon() -> [String] {
  expandLanguageDatasets()

  // Derive a list of unique keys from the autosuggest and emoji keys to serve as a basis for autocompletions.
  let baseLexicon = Array(autosuggestions.dictionaryValue.keys) + Array(emojiKeywords.dictionaryValue.keys)

  // Remove words that appear in nouns to make sure that capitalized versions are used for autocomplete.
  // Note: this is especially important for German where all nouns are capitalized.
  var uniqueBaseLexicon = [String]()
  for elem in baseLexicon {
    if elem.count > 2 && !(
      nouns[elem].exists() || nouns[elem.capitalized].exists() || nouns[elem.uppercased()].exists()
    ) {
      if autosuggestions[elem.lowercased()].exists() || emojiKeywords[elem].exists()
          && !uniqueBaseLexicon.contains(elem.lowercased()) {
        uniqueBaseLexicon.append(elem.lowercased())
      } else if
          elem.isCapitalized
          && !uniqueBaseLexicon.contains(elem)
          && !uniqueBaseLexicon.contains(elem.lowercased()) {
        uniqueBaseLexicon.append(elem)
      }
    }
  }

  var lexicon = Array(nouns.dictionaryValue.keys) + Array(prepositions.dictionaryValue.keys) + uniqueBaseLexicon

  // Filter our numbers and hyphenated words.
  lexicon = lexicon.filter(
    { $0.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890-")) == nil }
  ).sorted{$0.caseInsensitiveCompare($1) == .orderedAscending}

  return lexicon
}

var autocompleteLexicon = createAutocompleteLexicon()

// Words that should not be included in autocomplete should be added to the string below.
var baseAutosuggestions = [String]()
var emojisToDisplayArray = [String]()
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
