//
//  FRInterfaceVariables.swift
//
//  Constants and functions to load the French Scribe keyboard.
//

import UIKit

/// Provides a French keyboard layout after checking for AZERTY or QWERTY.
func setFRKeyboardLayout() {
  if controllerLanguage == "French_AZERTY" {
    getFRAZERTYKeys()
    currencySymbol = "€"
  } else if controllerLanguage == "French_QWERTY" {
    getFRQWERTYKeys()
    currencySymbol = "$"
  }

  currencySymbolAlternates = euroAlternateKeys
  spaceBar = "espace"
  invalidCommandMsg = "Pas dans Wikidata"
  baseAutosuggestions = ["je", "il", "le"]
  numericAutosuggestions = ["je", "que", "c’est"]

  translateKeyLbl = "Traduire"
  translatePlaceholder = "Entrez un mot"
  translatePrompt = commandPromptSpacing + "fr -› \(getControllerLanguageAbbr()): "
  translatePromptAndCursor = translatePrompt + commandCursor
  translatePromptAndPlaceholder = translatePromptAndCursor + " " + translatePlaceholder
  translatePromptAndColorPlaceholder = NSMutableAttributedString(string: translatePromptAndPlaceholder)
  translatePromptAndColorPlaceholder.setColorForText(textForAttribute: translatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  conjugateKeyLbl = "Conjuguer"
  conjugatePlaceholder = "Entrez un verbe"
  conjugatePrompt = commandPromptSpacing + "Conjuguer: "
  conjugatePromptAndCursor = conjugatePrompt + commandCursor
  conjugatePromptAndPlaceholder = conjugatePromptAndCursor + " " + conjugatePlaceholder
  conjugatePromptAndColorPlaceholder = NSMutableAttributedString(string: conjugatePromptAndPlaceholder)
  conjugatePromptAndColorPlaceholder.setColorForText(textForAttribute: conjugatePlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))

  pluralKeyLbl = "Pluriel"
  pluralPlaceholder = "Entrez un nom"
  pluralPrompt = commandPromptSpacing + "Pluriel: "
  pluralPromptAndCursor = pluralPrompt + commandCursor
  pluralPromptAndPlaceholder = pluralPromptAndCursor + " " + pluralPlaceholder
  pluralPromptAndColorPlaceholder = NSMutableAttributedString(string: pluralPromptAndPlaceholder)
  pluralPromptAndColorPlaceholder.setColorForText(textForAttribute: pluralPlaceholder, withColor: UIColor(cgColor: commandBarBorderColor))
  alreadyPluralMsg = "Déjà pluriel"
}
