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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import SwiftUI

let thirdPartyLicensesTitle = NSLocalizedString("about.thirdParty", comment: "Title for the third party licenses")
let thirdPartyLicensesCaption = NSLocalizedString("about.thirdParty.caption", comment: "Caption for the third party license")

let thirdPartyLicensesText = NSLocalizedString("about.thirdParty.body", comment: "Main text body for the third party license")

let localizedAuthor = NSLocalizedString("about.thirdParty.author", comment: "Author of third party code")
let localizedLicense = NSLocalizedString("about.thirdParty.license", comment: "License of third party code")
let localizedLink = NSLocalizedString("about.thirdParty.link", comment: "Link to license of third party code")

let thirdPartyLicensesListItems = [
  "• \(localizedAuthor): EthanSK",
  "• \(localizedLicense): MIT",
  "• \(localizedLink): https://github.com/EthanSK/CustomKeyboard/blob/master/LICENSE"
]
