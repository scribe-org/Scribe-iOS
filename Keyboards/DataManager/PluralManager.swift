// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation

/// Manages plural query logic based on data contracts
class PluralManager {
  static let shared = PluralManager()

  private init() {}

  struct PluralQueryInfo {
    let query: String
    let outputCols: [String]
    let args: [String]
  }

  /**Builds a query to find the plural form of a word based on the contract structure
   - Parameters:
   - word: The singular word to find the plural for
   - contract: The data contract defining the database structure
   - Returns: Query info to execute, or nil if contract is invalid
   */
  func buildPluralQuery(word: String, contract: DataContract?) -> [PluralQueryInfo] {  // ← Return array!
    guard let contract = contract,
          let numbers = contract.numbers,
          !numbers.isEmpty else {
      NSLog("PluralManager: No valid plural columns in contract")
      return []
    }

    var queries: [PluralQueryInfo] = []

    // Build a query for EACH singular/plural pair
    for (singularCol, pluralCol) in numbers {
      let query = """
            SELECT `\(singularCol)`, `\(pluralCol)`
            FROM nouns
            WHERE `\(singularCol)` = ? COLLATE NOCASE
            """

      queries.append(PluralQueryInfo(
        query: query,
        outputCols: [singularCol, pluralCol],
        args: [word.lowercased()]
      ))
    }

    return queries
  }

  /**Builds a query to get all plural forms for a language
   - Parameter contract: The data contract defining plural columns
   - Returns: Query info to execute, or nil if contract is invalid
   */
  func buildAllPluralsQuery(contract: DataContract?) -> PluralQueryInfo? {
    guard let contract = contract,
          let numbers = contract.numbers,
          !numbers.isEmpty else {
      NSLog("PluralManager: No valid plural columns in contract")
      return nil
    }

    let pluralColumns = Array(numbers.values)
    let columns = pluralColumns.map { "`\($0)`" }.joined(separator: ", ")
    let query = "SELECT \(columns) FROM nouns"

    return PluralQueryInfo(
      query: query,
      outputCols: pluralColumns,
      args: []
    )
  }
}
