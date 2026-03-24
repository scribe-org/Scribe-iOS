// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation
import Yams

/// ContractManager is responsible for loading and caching DataContract instances based on language codes.
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

        // Load YAML file (e.g., "de.yaml", "en.yaml", "es.yaml").
        guard
            let yamlResourcePath = Bundle.main.path(
                forResource: languageCode,
                ofType: "yaml"
            )
        else {
            NSLog("Contract not found: \(languageCode).yaml")
            return createDefaultContract()
        }
        do {
            let yamlString = try String(contentsOfFile: yamlResourcePath)
            let decoder = YAMLDecoder()
            let contract = try decoder.decode(DataContract.self, from: yamlString)
            contractCache[languageCode] = contract
            print("Loaded contract: \(languageCode).yaml")
            return contract
        } catch {
            NSLog("Error loading contract \(languageCode).yaml: \(error)")
            return createDefaultContract()
        }
    }

    private func createDefaultContract() -> DataContract {
        return DataContract(
            numbers: nil,
            genders: nil,
            conjugations: nil,
            declensions: nil
        )
    }
}
