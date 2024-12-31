/**
 * Text displayed on the Third Party Licenses view.
 *
 * Copyright (C) 2023 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
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
