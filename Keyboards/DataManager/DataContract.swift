// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation

/** DataContract represents the structure of the data used in the application.
*/
struct DataContract: Codable {
    let numbers: [String: String]?
    let genders: GenderContract?
    let conjugations: [String: ConjugationTense]?
}

struct GenderContract: Codable {
    let canonical: [String]?
    let feminines: [String]?
    let masculines: [String]?
    let commons: [String]?
    let neuters: [String]?
}

struct ConjugationTense: Codable {
    let title: String
    let conjugationTypes: [String: ConjugationType]
}

struct ConjugationType: Codable {
    let title: String
    let conjugationForms: [String: String]
}
