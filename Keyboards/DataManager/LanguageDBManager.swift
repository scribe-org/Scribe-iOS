// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Functions for loading in data to the keyboards.
 */

import Foundation
import GRDB
import SwiftyJSON

class LanguageDBManager {
  static let shared = LanguageDBManager(translate: false)
  static let translations = LanguageDBManager(translate: true)
  private var database: DatabaseQueue?

  private init(translate: Bool) {
    if translate {
      database = openDBQueue("TranslationData")
    } else {
      database = openDBQueue("\(getControllerLanguageAbbr().uppercased())LanguageData")
    }
  }

  /// Makes a connection to the language database given the value for controllerLanguage.
  private func openDBQueue(_ dbName: String) -> DatabaseQueue {
    let dbResourcePath = Bundle.main.path(forResource: dbName, ofType: "sqlite")!
    let fileManager = FileManager.default
    do {
      let dbPath = try fileManager
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("\(dbName).sqlite")
        .path
      if fileManager.fileExists(atPath: dbPath) {
        try fileManager.removeItem(atPath: dbPath)
      }
      try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
      let dbQueue = try DatabaseQueue(path: dbPath)
      return dbQueue
    } catch {
      print("An error occurred: UILexicon not available")
      let dbQueue = try! DatabaseQueue(path: dbResourcePath)
      return dbQueue
    }
  }

  /// Loads a JSON file that contains grammatical information into a dictionary.
  ///
  /// - Parameters
  ///  - filename: the name of the JSON file to be loaded.
  func loadJSON(filename fileName: String) -> JSON {
    let url = Bundle.main.url(forResource: fileName, withExtension: "json")!
    let data = NSData(contentsOf: url)
    let jsonData = try! JSON(data: data! as Data)
    return jsonData
  }

  /// Returns a row from the language database given a query and arguments.
  ///
  /// - Parameters
  ///   - query: the query to run against the language database.
  ///   - outputCols: the columns from which the values should come.
  ///   - args: arguments to pass to `query`.
  private func queryDBRow(query: String, outputCols: [String], args: StatementArguments) -> [String] {
    var outputValues = [String]()
    do {
      try database?.read { db in
        if let row = try Row.fetchOne(db, sql: query, arguments: args) {
          for col in outputCols {
            if let stringValue = row[col] as? String {
              outputValues.append(stringValue)
            } else {
              outputValues.append("")  // default to empty string if NULL or wrong type
            }
          }
        }
      }
    } catch let error as DatabaseError {
      let errorMessage = error.message
      let errorSQL = error.sql
      let errorArguments = error.arguments
      print(
        "An error '\(String(describing: errorMessage))' occurred in the query: \(String(describing: errorSQL)) (\(String(describing: errorArguments)))"
      )
    } catch {}

    if outputValues.isEmpty {
      // Append an empty string so that we can check for it and trigger commandState = .invalid.
      outputValues.append("")
    }

    return outputValues
  }

  /// Returns rows from the language database given a query and arguments.
  ///
  /// - Parameters:
  ///   - query: the query to run against the language database.
  ///   - outputCols: the columns from which the values should come.
  ///   - args: arguments to pass to `query`.
  private func queryDBRows(query: String, outputCols: [String], args: StatementArguments) -> [String] {
    var outputValues = [String]()
    do {
      guard let languageDB = database else { return [] }
      let rows = try languageDB.read { db in
        try Row.fetchAll(db, sql: query, arguments: args)
      }
      for r in rows {
        // Loop through all columns.
        for col in outputCols {
            if let value = r[col] as? String,
                   !value.trimmingCharacters(in: .whitespaces).isEmpty {
                    outputValues.append(value)
                }
            }
        }
    } catch let error as DatabaseError {
      let errorMessage = error.message
      let errorSQL = error.sql
      let errorArguments = error.arguments
      print(
        "An error '\(String(describing: errorMessage))' occurred in the query: \(String(describing: errorSQL)) (\(String(describing: errorArguments)))"
      )
    } catch {}

    if outputValues == [String]() {
      // Append an empty string so that we can check for it and trigger commandState = .invalid.
      outputValues.append("")
    }

    return outputValues
  }

  /// Writes a row of a language database table given a query and arguments.
  ///
  /// - Parameters
  ///   - query: the query to run against the language database.
  ///   - args: arguments to pass to `query`.
  private func writeDBRow(query: String, args: StatementArguments) {
    do {
      try database?.write { db in
        try db.execute(sql: query, arguments: args)
      }
    } catch let error as DatabaseError {
      let errorMessage = error.message
      let errorSQL = error.sql
      let errorArguments = error.arguments
      print(
        "An error '\(String(describing: errorMessage))' occurred in the query: \(String(describing: errorSQL)) (\(String(describing: errorArguments)))"
      )
    } catch {}
  }

  /// Deletes rows from the language database given a query and arguments.
  ///
  /// - Parameters:
  ///   - query: the query to run against the language database.
  ///   - args: arguments to pass to `query`.
  private func deleteDBRow(query: String, args: StatementArguments? = nil) {
    do {
      try database?.write { db in
        guard let args = args else {
          try db.execute(sql: query)
          return
        }
        try db.execute(sql: query, arguments: args)
      }
    } catch let error as DatabaseError {
      let errorMessage = error.message
      let errorSQL = error.sql
      print(
        "An error '\(String(describing: errorMessage))' occurred in the query: \(String(describing: errorSQL))"
      )
    } catch {}
  }
}

// MARK: Database operations

extension LanguageDBManager {
  /// Delete non-unique values in case the lexicon has added words that were already present.
  func deleteNonUniqueAutocompletions() {
    let query = """
    DELETE FROM
      autocomplete_lexicon

    WHERE rowid NOT IN (
      SELECT
        MIN(rowid)

      FROM
        autocomplete_lexicon

      GROUP BY
        word
    )
    """

    deleteDBRow(query: query)
  }

  /// Add words  to autocompletions.
  func insertAutocompleteLexicon(of word: String) {
    let query = """
    INSERT OR IGNORE INTO
      autocomplete_lexicon (word)

    VALUES (?)
    """
    let args = [word]

    writeDBRow(query: query, args: StatementArguments(args))
  }

  /// Returns the next three words in the `autocomplete_lexicon` that follow a given word.
  ///
  /// - Parameters
  ///   - word: the word that autosuggestions should be returned for.
  func queryAutocompletions(word: String) -> [String] {
    let autocompletionsQuery = """
    SELECT
      word

    FROM
      autocomplete_lexicon

    WHERE
      LOWER(word) LIKE ?

    ORDER BY
      word COLLATE NOCASE ASC

    LIMIT
      3
    """
    let outputCols = ["word"]
    let args = ["\(word.lowercased())%"]

    return queryDBRows(query: autocompletionsQuery, outputCols: outputCols, args: StatementArguments(args))
  }

  /// Query the suggestion of word in `autosuggestions`.
  func queryAutosuggestions(of word: String) -> [String] {
    let query = """
    SELECT
      *

    FROM
      autosuggestions

    WHERE
      word = ?
    """
    let args = [word]
    let outputCols = ["autosuggestion_0", "autosuggestion_1", "autosuggestion_2"]

    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }

  /// Query emojis of word in `emoji_keywords`.
  func queryEmojis(of word: String) -> [String] {
    let query = """
    SELECT
      *

    FROM
      emoji_keywords

    WHERE
      word = ?
    """
    let outputCols = ["emoji_keyword_0", "emoji_keyword_1", "emoji_keyword_2"]
    let args = [word]

    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }

  /// Query the noun form of word in `nonuns`.
  func queryNounForm(of word: String) -> [String] {
    let language = getControllerLanguageAbbr()
    let contract = ContractManager.shared.loadContract(language: language)

    let queries = GenderManager.shared.buildGenderQueries(word: word, contract: contract)

    for queryInfo in queries {
      let result = queryDBRow(
        query: queryInfo.query,
        outputCols: queryInfo.outputCols,
        args: StatementArguments(queryInfo.args)
      )

      // For canonical gender: return the actual gender value from DB
      if queryInfo.fallbackGender == nil {
        if !result.isEmpty && !result[0].isEmpty {
          return result
        }
      }
      // For masculine/feminine: if word found, return the fallback gender
      else {
        if !result.isEmpty && !result[0].isEmpty {
          return [queryInfo.fallbackGender!]
        }
      }
    }

    return [""]
  }

  /// Query the plural form of word in `nouns`.
  func queryNounPlural(of word: String) -> [String] {
    let language = getControllerLanguageAbbr()
    let contract = ContractManager.shared.loadContract(language: language)

    let queryInfos = PluralManager.shared.buildPluralQuery(
      word: word,
      contract: contract
    )

    // Try each query until we find a result.
    for queryInfo in queryInfos {
      let result = queryDBRow(
        query: queryInfo.query,
        outputCols: queryInfo.outputCols,
        args: StatementArguments(queryInfo.args)
      )

      // If we found a result, return it.
      if result.count >= 2 && !result[1].isEmpty {
        return [result[1]]
      }
    }

    return []
  }

  /// Query all plural forms for the current language.
  func queryAllPluralForms() -> [String]? {
    let language = getControllerLanguageAbbr()
    let contract = ContractManager.shared.loadContract(language: language)

    guard let queryInfo = PluralManager.shared.buildAllPluralsQuery(contract: contract) else {
      return nil
    }

    let result = queryDBRows(
      query: queryInfo.query,
      outputCols: queryInfo.outputCols,
      args: StatementArguments()
    )

    return result == [""] ? nil : result
  }

  /// Query preposition form of word in `prepositions`.
  func queryPrepForm(of word: String) -> [String] {
    let query = """
    SELECT
      *

    FROM
      prepositions

    WHERE
      preposition = ?
    """
    let outputCols = ["form"]
    let args = [word]

    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }

  /// Query the translation of word in the current language. Only works with the `translations` manager.
  func queryTranslation(of word: String) -> [String] {
    let translateLanguage = getKeyInDict(givenValue: getControllerTranslateLangCode(), dict: languagesAbbrDict)
    let query = """
    SELECT
      *

    FROM
      \(translateLanguage)

    WHERE
      word = ?
    """
    let outputCols = [getControllerLanguageAbbr()]
    let args = [word]

    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }

  /// Query the verb form of word in `verbs`.
  func queryVerb(of word: String) -> [String] {
    let query = """
    SELECT
      *

    FROM
      verbs

    WHERE
      verb = ?
    """
    let outputCols = ["verb"]
    let args = [word]

    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }

  /// Query specific form of word in `verbs`.
  ///
  /// - Parameters:
  ///   - outputCols: Specific form want to output
  func queryVerb(of word: String, with outputCols: [String]) -> [String] {
    let query = """
    SELECT
      *

    FROM
      verbs

    WHERE
      verb = ?
    """
    let args = [word]

    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }
}
