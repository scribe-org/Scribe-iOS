/**
 * Text displayed on the English Wikimedia and Scribe view.
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

let wikimediaAndScribeTitle = NSLocalizedString("about.wikimedia", value: "Wikimedia and Scribe", comment: "")
let wikimediaAndScribeCaption = NSLocalizedString("about.wikimedia.caption", value: "How we work together", comment: "")

let wikimediaAndScribeText1 = "\n" + NSLocalizedString("about.wikimedia.text1", value: "Scribe would not be possible without countless contributions by Wikimedia contributors to the many projects that they support. Specifically Scribe makes use of data from the Wikidata Lexicographical data community, as well as data from Wikipedia for each language that Scribe supports.", comment: "") + "\n\n"
let wikimediaAndScribeText2 = "\n\n" + NSLocalizedString("about.wikimedia.text2", value: "Wikidata is a collaboratively edited multilingual knowledge graph hosted by the Wikimedia Foundation. It provides freely available data that anyone can use under a Creative Commons Public Domain license (CC0).  Scribe uses language data from Wikidata to provide users with verb conjugations, noun-form annotations, noun plurals, and many other features.", comment: "") + "\n\n"
let wikimediaAndScribeText3 = "\n\n" + NSLocalizedString("about.wikimedia.text3", value: "Wikipedia is a multilingual free online encyclopedia written and maintained by a community of volunteers through open collaboration and a wiki-based editing system. Scribe uses data from Wikipedia to produce autosuggestions by deriving the most common words in a language as well as the most common words that follow them.", comment: "") + "\n"

let wikimediaAndScribeText = [wikimediaAndScribeText1, wikimediaAndScribeText2, wikimediaAndScribeText3]
