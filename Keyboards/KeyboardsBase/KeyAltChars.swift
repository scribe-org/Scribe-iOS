//
//  KeyAltChars.swift
//
//  Functions and variables to create alternate key views.
//

import UIKit

/// Sets the alternates for certain keys given the chosen keyboard.
func setKeyboardAlternateKeys() {
  if DeviceType.isPhone {
    keysWithAlternates += symbolKeysWithAlternatesLeft
    keysWithAlternates += symbolKeysWithAlternatesRight
    keysWithAlternates.append(currencySymbol)
    keysWithAlternatesLeft += symbolKeysWithAlternatesLeft
    keysWithAlternatesRight += symbolKeysWithAlternatesRight
    keysWithAlternatesRight.append(currencySymbol)
  }

  keyAlternatesDict = [
    "a": aAlternateKeys,
    "e": eAlternateKeys,
    "е": еAlternateKeys, // Russian е
    "i": iAlternateKeys,
    "o": oAlternateKeys,
    "u": uAlternateKeys,
    "ä": äAlternateKeys,
    "ö": öAlternateKeys,
    "y": yAlternateKeys,
    "s": sAlternateKeys,
    "l": lAlternateKeys,
    "z": zAlternateKeys,
    "d": dAlternateKeys,
    "c": cAlternateKeys,
    "n": nAlternateKeys,
    "ь": ьAlternateKeys,
    "/": backslashAlternateKeys,
    "?": questionMarkAlternateKeys,
    "!": exclamationAlternateKeys,
    "%": percentAlternateKeys,
    "&": ampersandAlternateKeys,
    "'": apostropheAlternateKeys,
    "\"": quotationAlternateKeys,
    "=": equalSignAlternateKeys,
    currencySymbol: currencySymbolAlternates
  ]
}

var alternatesKeyView: UIView!
var keyCancelled = false
var keysWithAlternates = [String]()
var alternateKeys = [String]()

// Variables for alternate key view appearance.
var alternateBtnStartX = CGFloat(0)
var alternatesViewWidth = CGFloat(0)
var alternateKeyWidth = CGFloat(0)
var alternatesViewX = CGFloat(0)
var alternatesViewY = CGFloat(0)
var alternatesBtnHeight = CGFloat(0)
var alternatesCharHeight = CGFloat(0)

// The main currency symbol that will receive the alternates view for iPhones.
var currencySymbol: String = ""
var currencySymbolAlternates = [String]()
let dollarAlternateKeys = ["¢", "₽", "₩", "¥", "£", "€"]
let euroAlternateKeys = ["¢", "₽", "₩", "¥", "£", "$"]
let roubleAlternateKeys = ["¢", "₩", "¥", "£", "$", "€"]
let kronaAlternateKeys = ["¢", "₽", "¥", "£", "$", "€"]

// Symbol keys that have consistent alternates for iPhones.
var symbolKeysWithAlternatesLeft = ["/", "?", "!", "%", "&"]
let backslashAlternateKeys = ["\\"]
let questionMarkAlternateKeys = ["¿"]
let exclamationAlternateKeys = ["¡"]
let percentAlternateKeys = ["‰"]
let ampersandAlternateKeys = ["§"]
var symbolKeysWithAlternatesRight = ["'", "\"", "="]
let apostropheAlternateKeys = ["`", "´", "'"]
let quotationAlternateKeys = ["«", "»", "„", "“", "\""]
let equalSignAlternateKeys = ["≈", "±", "≠"]
var keysWithAlternatesLeft = [String]()
var keysWithAlternatesRight = [String]()
var keyAlternatesDict = [String: [String]]()
var aAlternateKeys = [String]()
var eAlternateKeys = [String]()
var еAlternateKeys = [String]() // Russian е
var iAlternateKeys = [String]()
var oAlternateKeys = [String]()
var uAlternateKeys = [String]()
var yAlternateKeys = [String]()
var äAlternateKeys = [String]()
var öAlternateKeys = [String]()
var sAlternateKeys = [String]()
var lAlternateKeys = [String]()
var zAlternateKeys = [String]()
var dAlternateKeys = [String]()
var cAlternateKeys = [String]()
var nAlternateKeys = [String]()
var ьAlternateKeys = [String]()
