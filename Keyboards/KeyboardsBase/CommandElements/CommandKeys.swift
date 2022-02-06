//
//  CommandKeys.swift
//
//  Classes to define the separate command keys.
//

import UIKit

/// A base custom class that is inherited by other command keys.
class CommandKey: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  class func instanceFromNib() -> UIView {
      return UINib(nibName: "Keyboard", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
  }
}

/// A class to define elements for the translate key.
class TranslateKey: CommandKey {

}

/// A class to define elements for the conjugate key.
class ConjugateKey: CommandKey {

}

/// A class to define elements for the plural key.
class PluralKey: CommandKey {

}
