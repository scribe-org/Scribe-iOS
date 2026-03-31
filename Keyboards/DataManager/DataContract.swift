// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation

/// DataContract represents the structure of the data used in the application.
struct DataContract: Codable {
    let numbers: [String: String]?
    let genders: GenderContract?
    let conjugations: [Int: ConjugationSection]?
    let declensions: [Int: DeclensionSection]?
}

struct GenderContract: Codable {
    let canonical: [String]?
    let feminines: [String]?
    let masculines: [String]?
    let commons: [String]?
    let neuters: [String]?
}

struct ConjugationSection: Codable {
    let sectionTitle: String
    let tenses: [Int: ConjugationTense]
}

struct ConjugationTense: Codable {
    let tenseTitle: String
    let tenseForms: [Int: TenseForm]
}

struct TenseForm: Codable {
    let label: String
    let value: String
}

struct DeclensionSection: Codable {
    let title: String?
    let sectionTitle: String?
    let declensionForms: [Int: DeclensionNode]?
}

class DeclensionNode: Codable {
    let label: String?
    let value: String?
    let displayValue: String?
    let title: String?
    let declensionForms: [Int: DeclensionNode]?
}
