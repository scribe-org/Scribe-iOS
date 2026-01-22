// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation

class ContractManager {
    static let shared = ContractManager()
    private var contractCache: [String: DataContract] = [:]

    private init() {}

    func loadContract(language: String) -> DataContract {
        let languageCode = language.lowercased()

        // Check cache
        if let cached = contractCache[languageCode] {
            return cached
        }

        // Load JSON file (e.g., "de.json", "en.json", "es.json")
        guard let url = Bundle.main.url(
            forResource: languageCode,
            withExtension: "json",
            subdirectory: "DataContracts"
        ) else {
            print("Contract not found: \(languageCode).json")
            return createDefaultContract()
        }

        do {
            let data = try Data(contentsOf: url)
            let contract = try JSONDecoder().decode(DataContract.self, from: data)
            contractCache[languageCode] = contract
            print("Loaded contract: \(languageCode).json")
            return contract
        } catch {
            print("Error loading contract \(languageCode).json: \(error)")
            return createDefaultContract()
        }
    }

    private func createDefaultContract() -> DataContract {
        return DataContract(
            numbers: nil,
            genders: nil,
            conjugations: nil
        )
    }
}
