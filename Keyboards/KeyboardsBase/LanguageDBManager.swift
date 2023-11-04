//
//  LoadData.swift
//
//  Function for loading in data to the keyboards.
//

import Foundation
import GRDB
import SwiftyJSON


class LanguageDBManager {
  static let shared = LanguageDBManager()
  private lazy var languageDB = openDBQueue()
  
  private init() {}
  
  /// Makes a connection to the language database given the value for controllerLanguage.
  private func openDBQueue() -> DatabaseQueue {
    let dbName = "\(String(describing: get_iso_code(keyboardLanguage: controllerLanguage).uppercased()))LanguageData"
    let dbPath = Bundle.main.path(forResource: dbName, ofType: "sqlite")!
    let dbQueue = try! DatabaseQueue(path: dbPath)

    return dbQueue
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
      try languageDB.read { db in
        if let row = try Row.fetchOne(db, sql: query, arguments: args) {
          for col in outputCols {
            outputValues.append(row[col])
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
  
  /// Returns rows from the language database given a query and arguments
  ///
  /// - Parameters:
  ///   - query: the query to run against the language database.
  ///   - outputCols: the columns from which the values should come.
  ///   - args: arguments to pass to `query`.
  private func queryDBRows(query: String, outputCols: [String], args: StatementArguments) -> [String] {
    var outputValues = [String]()
    do {
      let rows = try languageDB.read { db in
        try Row.fetchAll(db, sql: query, arguments: args)
      }
      for r in rows {
        outputValues.append(r["word"])
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
      try languageDB.write { db in
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
  
  /// Deletes rows from the language database given a query and arguments
  ///
  /// - Parameters:
  ///   - query: the query to run against the language database.
  ///   - args: arguments to pass to `query`.
  private func deleteDBRow(query: String, args: StatementArguments? = nil) {
    do {
      try languageDB.write{ db in
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

// MARK: - Database operations
extension LanguageDBManager {
  /// Query the translation of word in `translations`
  func queryTranslation(of word: String) -> [String] {
    let query = "SELECT * FROM translations WHERE word = ?"
    let outputCols = ["translation"]
    let args = [word.lowercased()]
    
    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }
  
  /// Query the suggestion of word in `autosuggestions`
  func queryAutosuggestions(of word: String) -> [String] {
    let query = "SELECT * FROM autosuggestions WHERE word = ?"
    let args = [word.lowercased()]
    let outputCols = ["suggestion_0", "suggestion_1", "suggestion_2"]
    
    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
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
  
  /// Query the plural form of word in `nouns`
  func queryNounPlural(of word: String) -> [String] {
    let query = "SELECT * FROM nouns WHERE noun = ?"
    let outputCols = ["plural"]
    let args = [word.lowercased()]
    
    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }
  
  /// Query the noun form of word in `nonuns`
  func queryNounForm(of word: String) -> [String] {
    let query = "SELECT * FROM nouns WHERE noun = ?"
    let outputCols = ["form"]
    let args = [word.lowercased()]
    
    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }
  
  /// Query the verb form of word in `verbs`
  func queryVerb(of word: String) -> [String] {
    let query = "SELECT * FROM verbs WHERE verb = ?"
    let outputCols = ["verb"]
    let args = [word.lowercased()]
    
    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }
  
  /// Query specific form of word in `verbs`
  ///
  /// - Parameters:
  ///   - outputCols: Specific form want to output
  func queryVerb(of word: String, with outputCols: [String]) -> [String] {
    let query = "SELECT * FROM verbs WHERE verb = ?"
    let args = [word.lowercased()]
    
    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }
  
  /// Query preposition form of word in `prepositions`
  func queryPrepForm(of word: String) -> [String] {
    let query = "SELECT * FROM prepositions WHERE preposition = ?"
    let outputCols = ["form"]
    let args = [word.lowercased()]
    
    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }
  
  /// Query emojis of word in `emoji_keywords`
  func queryEmojis(of word: String) -> [String] {
    let query = "SELECT * FROM emoji_keywords WHERE word = ?"
    let outputCols = ["emoji_0", "emoji_1", "emoji_2"]
    let args = [word.lowercased()]
    
    return queryDBRow(query: query, outputCols: outputCols, args: StatementArguments(args))
  }
  
  /// Add words  to autocompletions.
  func insertAutocompleteLexion(of word: String) {
    let query = "INSERT OR IGNORE INTO autocomplete_lexicon (word) VALUES (?)"
    let args = [word]
    
    writeDBRow(query: query, args: StatementArguments(args))
  }
  
  /// Delete non-unique values in case the lexicon has added words that were already present.
  func deleteNonUniqueAutosuggestions() {
    let query = """
      DELETE FROM autocomplete_lexicon
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
}
