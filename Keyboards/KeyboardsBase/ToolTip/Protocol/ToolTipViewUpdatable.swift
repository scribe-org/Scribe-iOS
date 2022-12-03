//
//  ToolTipViewUpdatable.swift
//  Scribe
//
//  Created by Gabriel Moraes on 03/12/22.
//

import Foundation

protocol ToolTipViewUpdatable {
  var didUpdatePage: ( (ConjViewShiftButtonsState) -> Void)? { get set}

  func updateNext()
  func updatePrevious()
  func updateText(index: Int)
}
