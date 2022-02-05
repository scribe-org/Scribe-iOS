//
//  AppTextIcons.swift
//
//  Functions returning styled text elements for the app screen.
//

import UIKit

var fontSize = CGFloat(0)
/// Sets the font size for the text in the app screen and corresponding UIImage icons.
func setFontSize() {
  if DeviceType.isPhone {
    fontSize = UIScreen.main.bounds.height / 65
  } else if DeviceType.isPad {
    fontSize = UIScreen.main.bounds.height / 60
  }
}

/// Concatenates attributed strings.
///
/// - Parameters
///  - left: the left attributed string to concatenate.
///  - right: the right attributed string to concatenate.
func concatAttributedStrings (left: NSAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
  let result = NSMutableAttributedString()
  result.append(left)
  result.append(right)
  return result
}

/// Returns an attributed text that hyperlinked.
///
/// - Parameters
///  - originalText: the original text that hyperlinks will be added to.
///  - hyperLinks: a dictionary of strings and the link to which they should link.
func addHyperLinks(originalText: String, links: [String: String], fontSize: CGFloat) -> NSMutableAttributedString {
  let style = NSMutableParagraphStyle()
  style.alignment = .left
  let attributedOriginalText = NSMutableAttributedString(
    string: originalText,
    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
  )
  for (hyperLink, urlString) in links {
    let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
    let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
    attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
    attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
  }

  return attributedOriginalText
}

/// Formats and returns an arrow icon for the app texts.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func getArrowIcon(fontSize: CGFloat) -> NSAttributedString {
  // The down right arrow character as a text attachment.
  let arrowAttachment = NSTextAttachment()
  let selectArrowIconConfig = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium, scale: .medium)
  arrowAttachment.image = UIImage(
    systemName: "arrow.turn.down.right",
    withConfiguration: selectArrowIconConfig
  )?.withTintColor(.scribeGrey)

  return NSAttributedString(attachment: arrowAttachment)
}

/// Formats and returns an arrow icon for the app texts.
///
/// - Parameters
///  - fontSize: the size of the font derived for the app text given screen dimensions.
func getGlobeIcon(fontSize: CGFloat) -> NSAttributedString {
  // The globe character as a text attachment.
  let globeAttachment = NSTextAttachment()
  let selectGlobeIconConfig = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium, scale: .medium)
  globeAttachment.image = UIImage(
    systemName: "globe",
    withConfiguration: selectGlobeIconConfig
  )?.withTintColor(.scribeGrey)

  return NSAttributedString(attachment: globeAttachment)
}
