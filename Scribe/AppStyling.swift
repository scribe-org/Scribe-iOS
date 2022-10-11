//
//  AppStyling.swift
//
//  Functions to style app elements.
//

import UIKit

/// Applies a shadow to a given UI element.
///
/// - Parameters
///  - elem: the element to have shadows added to.
func applyShadowEffects(elem: AnyObject) {
  elem.layer.shadowColor = UIColor(.keyShadow).light.cgColor
  elem.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
  elem.layer.shadowOpacity = 1.0
  elem.layer.shadowRadius = 3.0
}

/// Applies a corner radius to a given UI element.
///
/// - Parameters
///  - elem: the element to have shadows added to.
func applyCornerRadius(elem: AnyObject, radius: CGFloat) {
  elem.layer.masksToBounds = false
  elem.layer.cornerRadius = radius
}
