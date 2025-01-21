// SPDX-License-Identifier: AGPL-3.0-or-later

/**
 * Text displayed on the Third Party Licenses view.
 */

import SwiftUI

let thirdPartyLicensesTitle = NSLocalizedString("app.about.legal.third_party", value: "Third-party licenses", comment: "")
let thirdPartyLicensesCaption = NSLocalizedString("app.about.legal.third_party.caption", value: "Whose code we used", comment: "")

let thirdPartyLicensesText = NSLocalizedString("app.about.legal.third_party.text", value: """
The Scribe developers (SCRIBE) built the iOS application "Scribe - Language Keyboards" (SERVICE) using third party code. All source code used in the creation of this SERVICE comes from sources that allow its full use in the manner done so by the SERVICE. This section lists the source code on which the SERVICE was based as well as the coinciding licenses of each.

The following is a list of all used source code, the main author or authors of the code, the license under which it was released at time of usage, and a link to the license.
""", comment: "") + "\n\n1. " + NSLocalizedString("app.about.legal.third_party.entry_custom_keyboard", value: """
Custom Keyboard
• Author: EthanSK
• License: MIT
• Link: https://github.com/EthanSK/CustomKeyboard/blob/master/LICENSE
""", comment: "") + "\n\n2. " + NSLocalizedString("app.about.legal.third_legal.entry_simple_keyboard", value: """
Simple Keyboard
• Author: Simple Mobile Tools
• License: GPL-3.0
• Link: https://github.com/SimpleMobileTools/Simple-Keyboard/blob/main/LICENSE
""", comment: "")
