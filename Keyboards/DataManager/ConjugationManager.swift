// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation

/// Manages retrieval of verb conjugations for different languages.

class ConjugationManager {
  static let shared = ConjugationManager()

  private init() {}

   /// Retrieves conjugation data for a given verb and language.
   ///
   /// - Parameters:
   ///  - verb: The infinitive form of the verb to conjugate.
   ///  - language: The language code (e.g., "de", "en").
   /// - Returns nested structure: [TenseTitle: [TypeTitle: [(pronoun, conjugatedForm)]]]
  func getConjugations(
    verb: String,
    language: String
  ) -> [(String, [(String, [(String, String)])])]? {

    let contract = ContractManager.shared.loadContract(language: language)

    guard let conjugations = contract.conjugations else {
      return nil
    }

    var result: [(String, [(String, [(String, String)])])] = []

    for (_, conjugationSection) in conjugations.sorted(by: {
      $0.key < $1.key
    }) {
      var conjugationTenses: [(String, [(String, String)])] = []

      for (_, conjugationTense) in conjugationSection.tenses.sorted(by: {
        $0.key < $1.key
      }) {
        var forms: [(String, String)] = []

        for (_, tenseForm) in conjugationTense.tenseForms.sorted(by: {
            $0.key < $1.key
        }) {
          let conjugatedForm = queryConjugatedForm(
            verb: verb,
            columnName: tenseForm.value,
            language: language
          )
          forms.append((tenseForm.label, conjugatedForm))
        }

        conjugationTenses.append((conjugationTense.tenseTitle, forms))
      }

      result.append((conjugationSection.sectionTitle, conjugationTenses))
    }

    return result.isEmpty ? nil : result
  }

    /// Queries the conjugated form for a given verb and column name.
    ///
    /// - Parameters:
    ///  - verb: The infinitive form of the verb.
    ///  - columnName: The column name to query (may include complex forms).
    ///  - language: The language code.
    /// - Returns: The conjugated form as a string.
  private func queryConjugatedForm(
    verb: String,
    columnName: String,
    language: String
  ) -> String {
    if columnName.contains("[") {
      return parseComplexForm(verb: verb, columnName: columnName, language: language)
    } else {
      // Simple column query.
      let results = LanguageDBManager.shared.queryVerb(of: verb, with: [columnName])
      let result = results.first ?? ""

      return result
    }
  }

    /// Parses and retrieves complex verb forms that involve auxiliary verbs.
    ///
    /// - Parameters:
    ///  - verb: The infinitive form of the verb.
    ///  - columnName: The complex column name containing auxiliary information.
    ///  - language: The language code.
  private func parseComplexForm(
    verb: String,
    columnName: String,
    language: String
  ) -> String {
    // Extract "[auxiliaryPart]" and "mainColumn".
    let pattern = "\\[(.*?)\\]"
    guard let regex = try? NSRegularExpression(pattern: pattern),
          let match = regex.firstMatch(in: columnName, range: NSRange(columnName.startIndex..., in: columnName)) else {
      return ""
    }

    let auxiliaryPart = (columnName as NSString).substring(with: match.range(at: 1))
    let mainColumn = columnName.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
      .trimmingCharacters(in: .whitespaces)

    // Get the main verb form (e.g., "gegangen").
    guard let mainForm = LanguageDBManager.shared.queryVerb(of: verb, with: [mainColumn]).first,
          !mainForm.isEmpty else {
      return ""
    }

    // Check if it's dynamic lookup (German style: "indicativePresentFirstPersonSingular auxiliaryVerb").
    let auxWords = auxiliaryPart.split(separator: " ")
    if auxWords.count > 1 {
      let targetForm = String(auxWords.first!)  // e.g., "indicativePresentFirstPersonSingular"
      let auxColumn = String(auxWords.last!)    // e.g., "auxiliaryVerb"

      // Get the auxiliary verb identifier.
      if let auxVerbId = LanguageDBManager.shared.queryVerb(of: verb, with: [auxColumn]).first,
         !auxVerbId.isEmpty {

        // Try querying by wdLexemeId first.
        var auxConjugated = LanguageDBManager.shared.queryVerb(
          of: auxVerbId,
          identifierColumn: "wdLexemeId",
          with: [targetForm]
        ).first

        // Fallback: try by infinitive.
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

    // Fallback: use auxiliary as-is.
    return "\(auxiliaryPart) \(mainForm)"
  }
}
