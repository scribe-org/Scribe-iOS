//
//  PrivacyPolicy.swift
//
//  The English privacy policy for the Scribe app.
//
//  PRIVACY.txt is formatted for GitHub, and this is formatted for modular sizing.
//

import UIKit

/// Formats and returns the text of the Scribe privacy policy.
func setENPrivacyPolicy(fontSize: CGFloat) -> NSMutableAttributedString {
  let privacyTextTitle = NSMutableAttributedString(string: """
  Privacy Policy
  """, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize * 1.5)])

  let wikidataDataLicensing: String = "https://www.wikidata.org/wiki/Wikidata:Licensing"
  let huggingFaceLicensing: String = "https://github.com/huggingface/transformers/blob/master/LICENSE"
  let scribeGitHub: String = "https://github.com/scribe-org"
  let scribeEmail: String = "scribe.langauge@gmail.com"
  let gitHubLogoLicensing: String = "https://github.com/logos"
  let wikidataLogoLicensing: String = "https://foundation.wikimedia.org/wiki/Policy:Trademark_policy"

  let privacyPolicyTextWithLinks = addHyperLinks(
    originalText: privacyPolicyText,
    links: [
      wikidataDataLicensing: wikidataDataLicensing,
      huggingFaceLicensing: huggingFaceLicensing,
      scribeGitHub: scribeGitHub,
      scribeEmail: "mailto:" + scribeEmail,
      gitHubLogoLicensing: gitHubLogoLicensing,
      wikidataLogoLicensing: wikidataLogoLicensing],
    fontSize: fontSize
  )

  return concatAttributedStrings(
    left: privacyTextTitle,
    right: privacyPolicyTextWithLinks
  )
}

// swiftlint:disable all

// Includes a new line so that there is space between it and the page title.
let privacyPolicyText = """
\n
The Scribe developers (SCRIBE) built the iOS application "Scribe - Language Keyboards" (SERVICE) as an open-source application. This SERVICE is provided by SCRIBE at no cost and is intended for use as is.

This privacy policy (POLICY) is used to inform the reader of the policies for the access, tracking, collection, retention, use, and disclosure of personal information (USER INFORMATION) and usage data (USER DATA) for all individuals who make use of this SERVICE (USERS).

USER INFORMATION is specifically defined as any information related to the USERS themselves or the devices they use to access the SERVICE.

USER DATA is specifically defined as any text that is typed or actions that are done by the USERS while using the SERVICE.

1. Policy Statement

This SERVICE does not access, track, collect, retain, use, or disclose any USER INFORMATION or USER DATA.

2. Do Not Track

USERS contacting SCRIBE to ask that their USER INFORMATION and USER DATA not be tracked will be provided with a copy of this POLICY as well as a link to all source codes as proof that they are not being tracked.

3. Third-Party Data

This SERVICE makes use of third-party data. All data used in the creation of this SERVICE comes from sources that allow its full use in the manner done so by the SERVICE. Specifically, the data for this SERVICE comes from Wikidata, which states that, "All structured data in the main, property and lexeme namespaces is made available under the Creative Commons CC0 License; text in other namespaces is made available under the Creative Commons Attribution-ShareAlike License." The policy in regards to the third-party data used can be found at https://www.wikidata.org/wiki/Wikidata:Licensing.

4. Third-Party Services

This SERVICE makes use of third-party services to manipulate some of the third-party data. Specifically, data has been translated using models from Hugging Face transformers. This service is covered by a Apache License 2.0, which states that it is available for commercial use, modification, distribution, patent use, and private use. The license for the aforementioned service can be found at https://github.com/huggingface/transformers/blob/master/LICENSE.

5. Third-Party Links

This SERVICE contains links to external websites. If USERS click on a third-party link, they will be directed to a website. Note that these external websites are not operated by this SERVICE. Therefore, USERS are strongly advised to review the privacy policy of these websites. This SERVICE has no control over and assumes no responsibility for the content, privacy policies, or practices of any third-party sites or services.

6. Third-Party Images

This SERVICE contains images that are copyrighted by third-parties. Specifically this app includes a copy of the logos of GitHub, Inc and Wikidata, trademarked by Wikimedia Foundation, Inc. The terms by which the GitHub logo can be used are found on https://github.com/logos, and the terms for the Wikidata logo are found on the following Wikimedia page: https://foundation.wikimedia.org/wiki/Policy:Trademark_policy. This SERVICE uses the copyrighted images in a way that matches these criteria, with the only deviation being a rotation of the GitHub logo that is common in the open-source community to indicate that there is a link to the GitHub website.

7. Content Notice

This SERVICE allows USERS to access linguistic content (CONTENT). Some of this CONTENT could be deemed inappropriate for children and legal minors. Accessing CONTENT using the SERVICE is done in a way that the information is unavailable unless explicitly known. Specifically, USERS "can" translate words, conjugate verbs, and access other grammatical features of CONTENT that may be sexual, violent, or otherwise inappropriate in nature. USERS "cannot" translate words, conjugate verbs, and access other grammatical features of CONTENT that may be sexual, violent, or otherwise inappropriate in nature if they do not already know about the nature of this CONTENT. SCRIBE takes no responsibility for the access of such CONTENT.

8. Changes

This POLICY is subject to change. Updates to this POLICY will replace all prior instances, and if deemed material will further be clearly stated in the next applicable update to the SERVICE. SCRIBE encourages the USERS to familiarize themselves with any changes to this POLICY.

9. Contact

If you have any questions, concerns, or suggestions about this POLICY, do not hesitate to visit https://github.com/scribe-org or contact SCRIBE at scribe.langauge@gmail.com. The person responsible for such inquiries is Andrew Tavis McAllister.

10. Effective Date

This POLICY is effective as of the 27th of January, 2022.
"""
