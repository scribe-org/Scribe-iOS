/**
 * Functions returning styled text elements for the app screen.
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

import UIKit

var fontSize = CGFloat(0)

/// Concatenates attributed strings.
///
/// - Parameters
///  - left: the left attributed string to concatenate.
///  - right: the right attributed string to concatenate.
func concatAttributedStrings(
  left: NSAttributedString, right: NSAttributedString
) -> NSMutableAttributedString {
  let result = NSMutableAttributedString()
  result.append(left)
  result.append(right)
  return result
}

/// Returns an attributed text that is hyperlinked.
///
/// - Parameters
///  - originalText: the original text that hyperlinks will be added to.
///  - links: a dictionary of strings and the link to which they should link.
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

/// Returns an attributed text that has indentation for list items.
///
/// - Parameters
///  - attributedOriginalText: the original text that hyperlinks will be added to passed as a NSMutableAttributedString.
///  - links: a array of strings with the list items text.
func addTabStops(attributedOriginalText: NSMutableAttributedString, links: [String]) -> NSMutableAttributedString {
  let textToAddIndentation = attributedOriginalText

  let listParagraphStyle = NSMutableParagraphStyle()
  listParagraphStyle.headIndent = 46
  listParagraphStyle.firstLineHeadIndent = 36
  listParagraphStyle.lineBreakMode = .byCharWrapping

  for element in links {
    let linkRange = textToAddIndentation.mutableString.range(of: element)
    textToAddIndentation.addAttribute(
      NSAttributedString.Key.paragraphStyle, value: listParagraphStyle, range: linkRange
    )
  }

  return textToAddIndentation
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
  )?.withTintColor(.init(ScribeColor.keyChar))

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
  )?.withTintColor(.init(ScribeColor.keyChar))

  return NSAttributedString(attachment: globeAttachment)
}

/// Returns image as an attachment to a NSMutableAttributedString which can be appended with the rest of the text.
///
/// - Parameters
///  - imageString: name of the image asset to add as attachment.
///  - imageWidth: width to scale the image appropriately to fit in text view.
func getCenteredImagesForWikimediaAndScribe(imageString: String, imageWidth: CGFloat) -> NSMutableAttributedString {
  if let image = UIImage(named: imageString) {
    let imageParagraphStyle = NSMutableParagraphStyle()
    imageParagraphStyle.alignment = .center

    let imageAttachment = NSTextAttachment()
    let aspectRatio = image.size.width / image.size.height
    let imageHeight = imageWidth / aspectRatio
    imageAttachment.image = image
    imageAttachment.bounds = CGRect(origin: .zero, size: CGSize(width: imageWidth, height: imageHeight))

    let imageAttributedString = NSMutableAttributedString(attachment: imageAttachment)
    imageAttributedString.addAttribute(
      NSAttributedString.Key.paragraphStyle,
      value: imageParagraphStyle,
      range: imageAttributedString.mutableString.range(of: imageAttributedString.string)
    )

    return imageAttributedString
  }

  return NSMutableAttributedString(string: "")
}

/// Function that deals with switching image when the device theme changes.
/// This happens as images as an attachment aren't dynamic like a UIImageView.
///
/// - Parameters
///  - attributedString: attributed string with the image in it as an attachment.
func switchAttachmentOnThemeChange(for attributedString: NSAttributedString) -> NSMutableAttributedString {
  let mutableString = NSMutableAttributedString(attributedString: attributedString)

  mutableString.enumerateAttribute(.attachment, in: NSRange(location: 0, length: mutableString.length), options: []) { attachment, range, _ in
    guard let attachment = attachment as? NSTextAttachment,
          let asset = attachment.image?.imageAsset else { return }

    attachment.image = asset.image(with: .current)

    let imageParagraphStyle = NSMutableParagraphStyle()
    imageParagraphStyle.alignment = .center
    let imageAttributedString = NSMutableAttributedString(attachment: attachment)
    imageAttributedString.addAttribute(
      NSAttributedString.Key.paragraphStyle,
      value: imageParagraphStyle,
      range: imageAttributedString.mutableString.range(of: imageAttributedString.string)
    )

    mutableString.replaceCharacters(in: range, with: imageAttributedString)
  }

  return mutableString
}

/// Formats and returns the text of the Scribe privacy policy with links activated.
func setPrivacyPolicy(fontSize: CGFloat, text: String) -> NSMutableAttributedString {
  let links = [
    "https://www.wikidata.org/wiki/Wikidata:Licensing",
    "https://en.wikipedia.org/wiki/Wikipedia:Reusing_Wikipedia_content",
    "https://www.unicode.org/license.txt",
    "https://github.com/huggingface/transformers/blob/master/LICENSE",
    "https://github.com/scribe-org",
    "scribe.langauge@gmail.com",
    "https://github.com/logos",
    "https://foundation.wikimedia.org/wiki/Policy:Trademark_policy",
    "https://github.com/EthanSK/CustomKeyboard/blob/master/LICENSE"
  ]

  let privacyPolicyTextWithLinks = addHyperLinks(
    originalText: text,
    links: pairLinks(links),
    fontSize: fontSize
  )

  return privacyPolicyTextWithLinks
}

/// Formats and returns the text of the Scribe third-party licenses with links activated and list indents.
func setThirdPartyLicenses(fontSize: CGFloat, text: String) -> NSMutableAttributedString {
  let links = [
    "https://github.com/EthanSK/CustomKeyboard/blob/master/LICENSE",
    "https://github.com/SimpleMobileTools/Simple-Keyboard/blob/main/LICENSE"
  ]
  let thirdPartyLicensesTextWithLink = addHyperLinks(
    originalText: text,
    links: pairLinks(links),
    fontSize: fontSize
  )

  return thirdPartyLicensesTextWithLink
}

/// Formats and returns the text of the Wikimedia and Scribe screen with images.
func setWikimediaAndScribe(text: [String], fontSize: CGFloat, imageWidth: CGFloat) -> NSMutableAttributedString {
  var attributedTextBySections = [NSMutableAttributedString]()

  for section in text {
    let attributedSection = NSMutableAttributedString(
      string: section, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
    )
    attributedTextBySections.append(attributedSection)
  }

  let wikidataLogoString = getCenteredImagesForWikimediaAndScribe(
    imageString: "wikidata.logo", imageWidth: imageWidth
  )

  let wikipediaLogoString = getCenteredImagesForWikimediaAndScribe(
    imageString: "wikipedia.logo", imageWidth: imageWidth
  )

  let wikimediaAndScribeTextWithImages = attributedTextBySections[0]
  wikimediaAndScribeTextWithImages.append(wikidataLogoString)
  wikimediaAndScribeTextWithImages.append(attributedTextBySections[1])
  wikimediaAndScribeTextWithImages.append(wikipediaLogoString)
  wikimediaAndScribeTextWithImages.append(attributedTextBySections[2])

  return wikimediaAndScribeTextWithImages
}

func pairLinks(_ linkList: [String]) -> [String: String] {
  var pairedLinks: [String: String] = [:]
  for hyperlink in linkList {
    if hyperlink.contains("@") && hyperlink.range(of: #"https?://"#, options: .regularExpression) == nil {
      pairedLinks[hyperlink] = "mailto:\(hyperlink)"
    } else {
      pairedLinks[hyperlink] = hyperlink
    }
  }
  return pairedLinks
}
