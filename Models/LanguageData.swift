// SPDX-License-Identifier: GPL-3.0-or-later

import Foundation

/// LanguageData represents the structure of the data received from the API,
/// including the language, contract information, and the data tables.
typealias RowData = [String: String?]
typealias Table = [RowData]

struct DataResponse: Decodable {
    let language: String
    let contract: Contract
    let data: [String: Table]
}

struct Contract: Decodable {
    let version: String
    let updatedAt: String
    let fields: [String: [String: String]]

    enum CodingKeys: String, CodingKey {
        case version
        case updatedAt = "updated_at"
        case fields
    }
}

/// Represents the structure of the data version information received from the API.
struct DataVersionResponse: Decodable {
    let language: String
    let versions: [String: String]
}
