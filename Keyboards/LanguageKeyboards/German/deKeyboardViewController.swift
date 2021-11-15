//
//  deKeyboardViewController.swift
//

class deKeyboardViewController: KeyboardViewController {
  convenience init() {
    self.init(nibName: "KeyboardViewController", bundle: nil)
  }

  /// Sets the keyboard layouts given the device type.
  func deKeyboardSetLayouts() {
    if DeviceType.isPhone {
      letterKeys = deKeyboardConstants.letterKeysPhone
      numberKeys = deKeyboardConstants.numberKeysPhone
      symbolKeys = deKeyboardConstants.symbolKeysPhone
    } else if DeviceType.isPad {
      letterKeys = deKeyboardConstants.letterKeysPad
      numberKeys = deKeyboardConstants.numberKeysPad
      symbolKeys = deKeyboardConstants.symbolKeysPad
    }

    aAlternateKeys = deKeyboardConstants.aAlternateKeys
    eAlternateKeys = deKeyboardConstants.eAlternateKeys
    iAlternateKeys = deKeyboardConstants.iAlternateKeys
    oAlternateKeys = deKeyboardConstants.oAlternateKeys
    uAlternateKeys = deKeyboardConstants.uAlternateKeys
    yAlternateKeys = deKeyboardConstants.yAlternateKeys
    sAlternateKeys = deKeyboardConstants.sAlternateKeys
    cAlternateKeys = deKeyboardConstants.cAlternateKeys
    nAlternateKeys = deKeyboardConstants.nAlternateKeys
  }

  override func viewDidLoad() {
    deKeyboardSetLayouts()
    super.viewDidLoad()
  }
}
