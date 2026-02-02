// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation

/// Manages retrieval of verb conjugations for different languages.

class ConjugationManager {
  static let shared = ConjugationManager()

  private init() {}

  /// Returns nested structure: [TenseTitle: [TypeTitle: [(pronoun, conjugatedForm)]]]
  func getConjugations(
    verb: String,
    language: String
  ) -> [(String, [(String, [(String, String)])])]? {

    let contract = ContractManager.shared.loadContract(language: language)

    guard let conjugations = contract.conjugations else {
      return nil
    }

    var result: [(String, [(String, [(String, String)])])] = []

    for (_, tenseGroup) in conjugations.sorted(by: {
      Int($0.key) ?? 0 < Int($1.key) ?? 0
    }) {
      var conjugationTypes: [(String, [(String, String)])] = []

      for (_, conjugationType) in tenseGroup.conjugationTypes.sorted(by: {
        Int($0.key) ?? 0 < Int($1.key) ?? 0
      }) {
        var forms: [(String, String)] = []

        for (pronoun, columnName) in conjugationType.conjugationForms {
          let conjugatedForm = queryConjugatedForm(
            verb: verb,
            columnName: columnName,
            language: language
          )
          forms.append((pronoun, conjugatedForm))
        }

        conjugationTypes.append((conjugationType.title, forms))
      }

      result.append((tenseGroup.title, conjugationTypes))
    }

    return result.isEmpty ? nil : result
  }

  private func queryConjugatedForm(
    verb: String,
    columnName: String,
    language: String
  ) -> String {
    if columnName.contains("[") {
      return parseComplexForm(verb: verb, columnName: columnName, language: language)
    } else {
      // Simple column query
      let results = LanguageDBManager.shared.queryVerb(of: verb, with: [columnName])
      let result = results.first ?? ""

      return result
    }
  }

  private func parseComplexForm(
    verb: String,
    columnName: String,
    language: String
  ) -> String {
    // Extract "[auxiliaryPart]" and "mainColumn"
    let pattern = "\\[(.*?)\\]"
    guard let regex = try? NSRegularExpression(pattern: pattern),
          let match = regex.firstMatch(in: columnName, range: NSRange(columnName.startIndex..., in: columnName)) else {
      return ""
    }

    let auxiliaryPart = (columnName as NSString).substring(with: match.range(at: 1))
    let mainColumn = columnName.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
      .trimmingCharacters(in: .whitespaces)

    // Get the main verb form (e.g., "gegangen")
    guard let mainForm = LanguageDBManager.shared.queryVerb(of: verb, with: [mainColumn]).first,
          !mainForm.isEmpty else {
      return ""
    }

    // Check if it's dynamic lookup (German style: "indicativePresentFirstPersonSingular auxiliaryVerb")
    let auxWords = auxiliaryPart.split(separator: " ")
    if auxWords.count > 1 {
      let targetForm = String(auxWords.first!)  // e.g., "indicativePresentFirstPersonSingular"
      let auxColumn = String(auxWords.last!)    // e.g., "auxiliaryVerb"

      // Get the auxiliary verb identifier
      if let auxVerbId = LanguageDBManager.shared.queryVerb(of: verb, with: [auxColumn]).first,
         !auxVerbId.isEmpty {

        // Try querying by wdLexemeId first
        var auxConjugated = LanguageDBManager.shared.queryVerb(
          of: auxVerbId,
          identifierColumn: "wdLexemeId",
          with: [targetForm]
        ).first

        // Fallback: try by infinitive
        if auxConjugated?.isEmpty ?? true {
          auxConjugated = LanguageDBManager.shared.queryVerb(
            of: auxVerbId,
            with: [targetForm]
          ).first
        }

        if let auxConjugated = auxConjugated, !auxConjugated.isEmpty {
          return "\(auxConjugated) \(mainForm)"
        }
      }
    }

    // Fallback: use auxiliary as-is
    return "\(auxiliaryPart) \(mainForm)"
  }
}
