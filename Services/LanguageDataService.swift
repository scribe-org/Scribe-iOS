// SPDX-License-Identifier: GPL-3.0-or-later

import Foundation
import GRDB

final class LanguageDataService {
    static let shared = LanguageDataService()

    private let apiClient = LanguageDataAPIClient.shared
    private let userDefaults = UserDefaults.standard
    private let lastUpdateKey = "last_update_"

    private init() {}

    // MARK: Download Data

    func downloadData(language: String, forceDownload: Bool = false) async throws {
        let localLastUpdate = getLastUpdate(for: language) ?? "1970-01-01"

        // Fetch data from API.
        let response = try await apiClient.fetchLanguageData(language: language)
        let serverLastUpdate = response.contract.updatedAt

        // Check if update is needed.
        if forceDownload || isUpdateAvailable(local: localLastUpdate, server: serverLastUpdate) {
            try syncDatabaseForLanguage(language: language, response: response)
            saveLastUpdate(serverLastUpdate, for: language)
        }
    }

    // MARK: Check for Updates

    func checkForUpdates(language: String) async throws -> Bool {
        let localLastUpdate = getLastUpdate(for: language) ?? "1970-01-01"
        let versionResponse = try await apiClient.fetchDataVersion(language: language)

        return versionResponse.versions.values.contains { serverDate in
            isUpdateAvailable(local: localLastUpdate, server: serverDate)
        }
    }

    // MARK: Has Data

    func hasData(for language: String) -> Bool {
        return getLastUpdate(for: language) != nil
    }

    // MARK: Sync Database

    private func syncDatabaseForLanguage(
        language: String,
        response: DataResponse
    ) throws {
        guard
            let containerURL = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: "group.be.scri.userDefaultsContainer"
            )
        else {
            throw NSError(
                domain: "AppGroup", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "App group container not found"]
            )
        }

        let dbURL = containerURL.appendingPathComponent(
            "\(language.uppercased())LanguageData.sqlite"
        )
        let dbQueue = try DatabaseQueue(path: dbURL.path)

        try dbQueue.write { db in
            // Create tables.
            for (tableName, columns) in response.contract.fields {
                let columnDefs = columns.map { columnName, _ in
                    columnName == "lexemeID"
                        ? "lexemeID TEXT PRIMARY KEY"
                        : "\"\(columnName)\" TEXT"
                }.joined(separator: ", ")

                try db.execute(
                    sql: """
                        CREATE TABLE IF NOT EXISTS "\(tableName)" (
                            \(columnDefs)
                        )
                    """
                )

                try db.execute(sql: #"DELETE FROM "\#(tableName)""#)
            }

            // Insert data.
            for (tableName, rows) in response.data {
                for row in rows {
                    let nonNilRow = row.compactMapValues { $0 }
                    guard !nonNilRow.isEmpty else { continue }

                    let columns = nonNilRow.keys.map { "\"\($0)\"" }.joined(separator: ", ")
                    let placeholders = Array(repeating: "?", count: nonNilRow.count).joined(
                        separator: ", "
                    )
                    let values = nonNilRow.values.map { $0 }

                    try db.execute(
                        sql: """
                        INSERT OR REPLACE INTO "\(tableName)" (\(columns))
                        VALUES (\(placeholders))
                        """,
                        arguments: StatementArguments(values)
                    )
                }
            }
        }
    }

    // MARK: Private Helpers

    private func isUpdateAvailable(local: String, server: String) -> Bool {
        let localDate = String(local.prefix(10))
        let serverDate = String(server.prefix(10))
        return serverDate > localDate
    }

    private func getLastUpdate(for language: String) -> String? {
        return userDefaults.string(forKey: "\(lastUpdateKey)\(language)")
    }

    private func saveLastUpdate(_ date: String, for language: String) {
        userDefaults.set(date, forKey: "\(lastUpdateKey)\(language)")
    }
}
