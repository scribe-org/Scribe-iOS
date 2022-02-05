//
//  CommandVariables.swift
//
//  Variables associated with Scribe commands.
//

import UIKit

// A larger vertical bar than the normal | key for the cursor.
let previewCursor: String = "│"
var previewPromptSpacing: String = ""
var previewState: Bool = false

var inputWordIsCapitalized: Bool = false
var wordToReturn: String = ""

var invalidState: Bool = false
var invalidCommandMsg: String = ""

// Annotation variables.
var annotationState: Bool = false
var nounAnnotationsToDisplay: Int = 0
var prepAnnotationState: Bool = false

var annotationHeight = CGFloat(0)

// Indicates that the keyboard has switched to another.
// For example another input method is needed to translate.
var switchInput: Bool = false

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

// Prompts and saving groups of languages.
var allPrompts: [String] = [""]

let languagesWithCapitalizedNouns = ["German"]
let languagesWithCaseDependantOnPrepositions = ["German", "Russian"]
