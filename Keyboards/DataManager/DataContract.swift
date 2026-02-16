// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation

/**
 * DataContract represents the structure of the data used in the application.
 */
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
    let tenseForms: [String: String]
}

struct DeclensionSection: Codable {
    let title: String?
    let sectionTitle: String?
    let declensionForms: [String: DeclensionForm]?
}

enum DeclensionForm: Codable {
    case value(String)
    case nested([String: DeclensionForm])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .value(string)
        } else {
            self = .nested(try container.decode([String: DeclensionForm].self))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .value(let string): try container.encode(string)
        case .nested(let dict):  try container.encode(dict)
        }
    }
}
