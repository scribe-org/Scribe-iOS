//
//  AppTextIcons.swift
//
//  Functions returning styled text elements for the app screen.
//

import UIKit

var fontSize = CGFloat(0)

/// Concatenates attributed strings.
///
/// - Parameters
///  - left: the left attributed string to concatenate.
///  - right: the right attributed string to concatenate.
func concatAttributedStrings(left: NSAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
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
    textToAddIndentation.addAttribute(NSAttributedString.Key.paragraphStyle, value: listParagraphStyle, range: linkRange)
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
  )?.withTintColor(.init(.keyChar))

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
  )?.withTintColor(.init(.keyChar))

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
    imageAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: imageParagraphStyle, range: imageAttributedString.mutableString.range(of: imageAttributedString.string))
    
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
  
  mutableString.enumerateAttribute(.attachment, in: NSRange(location: 0, length: mutableString.length), options: []) { attachment, range, stop in
    guard let attachment = attachment as? NSTextAttachment,
          let asset = attachment.image?.imageAsset else { return }
    
    attachment.image = asset.image(with: .current)
    
    let imageParagraphStyle = NSMutableParagraphStyle()
    imageParagraphStyle.alignment = .center
    let imageAttributedString = NSMutableAttributedString(attachment: attachment)
    imageAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: imageParagraphStyle, range: imageAttributedString.mutableString.range(of: imageAttributedString.string))
    
    mutableString.replaceCharacters(in: range, with: imageAttributedString)
  }
  
  return mutableString
}


/// Formats and returns the text of the Scribe privacy policy with links activated.
func setPrivacyPolicy(fontSize: CGFloat, text: String) -> NSMutableAttributedString {
  let wikidataDataLicensing = "https://www.wikidata.org/wiki/Wikidata:Licensing"
  let wikipediaDataLicensing = "https://en.wikipedia.org/wiki/Wikipedia:Reusing_Wikipedia_content"
  let unicodeDataLicense = "https://www.unicode.org/license.txt"
  let huggingFaceLicensing = "https://github.com/huggingface/transformers/blob/master/LICENSE"
  let scribeGitHub = "https://github.com/scribe-org"
  let scribeEmail = "scribe.langauge@gmail.com"
  let gitHubLogoLicensing = "https://github.com/logos"
  let wikidataLogoLicensing = "https://foundation.wikimedia.org/wiki/Policy:Trademark_policy"
  let customKeyboardLicense = "https://github.com/EthanSK/CustomKeyboard/blob/master/LICENSE"

  let privacyPolicyTextWithLinks = addHyperLinks(
    originalText: text,
    links: [
      wikidataDataLicensing: wikidataDataLicensing,
      wikipediaDataLicensing: wikipediaDataLicensing,
      unicodeDataLicense: unicodeDataLicense,
      huggingFaceLicensing: huggingFaceLicensing,
      scribeGitHub: scribeGitHub,
      scribeEmail: "mailto:" + scribeEmail,
      gitHubLogoLicensing: gitHubLogoLicensing,
      wikidataLogoLicensing: wikidataLogoLicensing,
      customKeyboardLicense: customKeyboardLicense,
    ],
    fontSize: fontSize
  )

  return privacyPolicyTextWithLinks
}

/// Formats and returns the text of the Scribe third-party licenses with links activated and list indents.
func setThirdPartyLicenses(fontSize: CGFloat, text: String, listElements: [String]) -> NSMutableAttributedString {
  let licensesLink = "https://github.com/EthanSK/CustomKeyboard/blob/master/LICENSE"
  let thirdPartyLicensesTextWithLink = addHyperLinks(
    originalText: text,
    links: [
      licensesLink : licensesLink
    ],
    fontSize: fontSize
  )
  
  let thirdPartyLicensesTextWithLinkAndIndents = addTabStops(attributedOriginalText: thirdPartyLicensesTextWithLink, links: listElements)
  
  return thirdPartyLicensesTextWithLinkAndIndents
}

/// Formats and returns the text of the Wikimedia and Scribe screen with images.
func setWikimediaAndScribe(text: [String], fontSize: CGFloat, imageWidth: CGFloat) -> NSMutableAttributedString {
  var attributedTextBySections = [NSMutableAttributedString]()
  
  for section in text {
    let attributedSection = NSMutableAttributedString(string: section, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)])
    attributedTextBySections.append(attributedSection)
  }
  
  let wikidataLogoString = getCenteredImagesForWikimediaAndScribe(imageString: "wikidata.logo", imageWidth: imageWidth)
  
  let wikipediaLogoString = getCenteredImagesForWikimediaAndScribe(imageString: "wikipedia.logo", imageWidth: imageWidth)

  let wikimediaAndScribeTextWithImages = attributedTextBySections[0]
  wikimediaAndScribeTextWithImages.append(wikidataLogoString)
  wikimediaAndScribeTextWithImages.append(attributedTextBySections[1])
  wikimediaAndScribeTextWithImages.append(wikipediaLogoString)
  wikimediaAndScribeTextWithImages.append(attributedTextBySections[2])

  return wikimediaAndScribeTextWithImages
}
