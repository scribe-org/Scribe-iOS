/**
 * Variables associated with Scribe commands.
 *
 * Copyright (C) 2024 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import GRDB
import UIKit

// Basic keyboard functionality variables.
var capsLockPossible = false
var doubleSpacePeriodPossible = false
var autoAction0Visible = true
var autoAction2Visible = true

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

var firstCompletionIsHighlighted = false
var spaceAutoInsertIsPossible = false
var allowUndo = false
var previousWord = ""
var currentPrefix = ""
var pastStringInTextProxy = ""
var backspaceTimer: Timer?

var baseAutosuggestions = [String]()
var completionWords = [String]()
var numericAutosuggestions = [String]()
var emojisToDisplayArray = [String]()
var pronounAutosuggestionTenses: [String: String] = [:]
var verbsAfterPronounsArray = [String]()

// Variables for basic keyboard appearance.
let commandCursor = "│"
var commandPromptSpacing = ""

// Command input and output variables.
var inputWordIsCapitalized = false
var wordToReturn = ""
var potentialWordsToReturn = [String]()
var invalidCommandMsg = ""

// Annotation variables.
var annotationState = false
var activateAnnotationBtn = false
var hasNounForm = false
var hasPrepForm = false
var prepAnnotationForm = ""
var annotationDisplayWord = ""
var wordToCheck = ""
var wordsTyped = [String]()

var annotationsToAssign = [String]()
var annotationBtns = [UIButton]()
var annotationColors = [UIColor]()
var annotationSeparators = [UIView]()

var autoActionAnnotationBtns = [UIButton]()
var autoActionAnnotationSeparators = [UIView]()

var newAutoActionAnnotationsToAssign = [String]()
var newAutoActionAnnotationBtns = [UIButton]()
var newAutoActionAnnotationColors = [UIColor]()
var newAutoActionAnnotationSeparators = [UIView]()

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

// MARK: Plural Variables

var pluralKeyLbl = ""
var pluralPrompt = ""
var pluralPlaceholder = ""
var pluralPromptAndCursor = ""
var pluralPromptAndPlaceholder = ""
var pluralPromptAndColorPlaceholder = NSMutableAttributedString()
var alreadyPluralMsg = ""
