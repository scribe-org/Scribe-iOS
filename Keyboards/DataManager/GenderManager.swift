// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation

/// Manages gender query logic based on data contracts
class GenderManager {
  static let shared = GenderManager()

  private init() {}

  struct GenderQueryInfo {
    let query: String
    let outputCols: [String]
    let args: [String]
    let fallbackGender: String?
  }

  /**Builds the appropriate gender queries based on the contract structure
    - Parameters:
        - word: The word to query
        - contract: The data contract defining gender structure
    - Returns: Array of query info objects to execute
  */
  func buildGenderQueries(word: String, contract: DataContract) -> [GenderQueryInfo] {

    if hasCanonicalGender(contract) {
      if let queryInfo = buildCanonicalQuery(word: word, contract: contract) {
        return [queryInfo]
      }
    } else if hasMasculineFeminine(contract) {
      return buildMasculineFeminineQueries(word: word, contract: contract)
    } else {
      NSLog("GenderManager: No valid gender structure found in contract")
    }

    return []
  }

  // MARK: - Private Helper Methods

  /// Checks if the data contract defines a single, canonical gender column
  private func hasCanonicalGender(_ contract: DataContract) -> Bool {
    return contract.genders?.canonical?.first?.isEmpty == false
  }

  /// Checks if the data contract defines separate columns for masculine and feminine genders
  private func hasMasculineFeminine(_ contract: DataContract) -> Bool {
    let hasMasculine = !(contract.genders?.masculines?.isEmpty ?? true)
    let hasFeminine = !(contract.genders?.feminines?.isEmpty ?? true)
    return hasMasculine && hasFeminine
  }

  /// Builds query for canonical gender structure
  private func buildCanonicalQuery(word: String, contract: DataContract) -> GenderQueryInfo? {
    guard let nounCol = contract.numbers?.keys.first,
          let genderCol = contract.genders?.canonical?.first else {
      NSLog("GenderManager: Missing columns for canonical gender query")
      return nil
    }

    let query = """
            SELECT `\(genderCol)` FROM nouns
            WHERE `\(nounCol)` = ? OR `\(nounCol)` = ?
            """

    return GenderQueryInfo(
      query: query,
      outputCols: [genderCol],
      args: [word, word.lowercased()],
      fallbackGender: nil
    )
  }

  /// Builds queries for masculine/feminine gender structure
  private func buildMasculineFeminineQueries(word: String, contract: DataContract) -> [GenderQueryInfo] {
    var queries: [GenderQueryInfo] = []

    // Masculine column query
    if let masculineCol = contract.genders?.masculines?.first {
      let query = """
                SELECT `\(masculineCol)` FROM nouns
                WHERE `\(masculineCol)` = ? OR `\(masculineCol)` = ?
                """
      queries.append(GenderQueryInfo(
        query: query,
        outputCols: [masculineCol],
        args: [word, word.lowercased()],
        fallbackGender: "masculine"
      ))
    }

    // Feminine column query
    if let feminineCol = contract.genders?.feminines?.first {
      let query = """
                SELECT `\(feminineCol)` FROM nouns
                WHERE `\(feminineCol)` = ? OR `\(feminineCol)` = ?
                """
      queries.append(GenderQueryInfo(
        query: query,
        outputCols: [feminineCol],
        args: [word, word.lowercased()],
        fallbackGender: "feminine"
      ))
    }

    return queries
  }
}
