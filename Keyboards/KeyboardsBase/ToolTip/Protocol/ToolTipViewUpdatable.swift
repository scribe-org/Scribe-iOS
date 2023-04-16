//
//  ToolTipViewUpdatable.swift
//

import Foundation

protocol ToolTipViewUpdatable {
  var didUpdatePage: ((ConjViewShiftButtonsState) -> Void)? { get set }

  func updateNext()
  func updatePrevious()
  func updateText(index: Int)
}
