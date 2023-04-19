//
//  LoadData.swift
//
//  Function for loading in data to the keyboards.
//

import Foundation
import GRDB
import SwiftyJSON

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

/// Makes a connection to the language database given the value for controllerLanguage.
func openDBQueue() -> DatabaseQueue {
  let dbName = "\(String(describing: get_iso_code(keyboardLanguage: controllerLanguage).uppercased()))LanguageData"
  let dbPath = Bundle.main.path(forResource: dbName, ofType: "sqlite")!
  let dbQueue = try! DatabaseQueue(path: dbPath)

  return dbQueue
}

// Variable to be replaced with the result of openDBQueue.
var languageDB = try! DatabaseQueue()

/// Returns a row from the language database given a query and arguments.
///
/// - Parameters
///   - query: the query to run against the language database.
///   - outputCols: the columns from which the values should come.
///   - args: arguments to pass to `query`.
func queryDBRow(query: String, outputCols: [String], args: [String]) -> [String] {
  var outputValues = [String]()
  do {
    try languageDB.read { db in
      if let row = try Row.fetchOne(db, sql: query, arguments: StatementArguments(args)) {
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

/// Writes a row of a language database table given a query and arguments.
///
/// - Parameters
///   - query: the query to run against the language database.
///   - args: arguments to pass to `query`.
func writeDBRow(query: String, args: StatementArguments) {
  do {
    try languageDB.write { db in
      try db.execute(
        sql: query,
        arguments: args
      )
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

/// Performs a few minor edits to language data to make sure that certain values are included.
func expandLanguageDataset() {
  // Make sure that Scribe shows up in auto actions.
  let checkScribeQuery = "SELECT * FROM nouns WHERE noun = ?"
  let args = ["Scribe"]
  let outputCols = ["noun"]
  let scribeOrEmptyString = queryDBRow(query: checkScribeQuery, outputCols: outputCols, args: args)[0]

  if scribeOrEmptyString == "" {
    let addScribeQuery = "INSERT OR IGNORE INTO nouns (noun, plural, form) VALUES (?, ?, ?)"
    writeDBRow(query: addScribeQuery, args: ["Scribe", "Scribes", ""])
    writeDBRow(query: addScribeQuery, args: ["Scribes", "isPlural", "PL"])
  }

  // Add German compound prepositions to the prepositions table so they also receive annotations.
  if controllerLanguage == "German" {
    let prepositionsInsertQuery = "INSERT OR IGNORE INTO prepositions (preposition, form) VALUES (?, ?)"
    for (p, f) in contractedGermanPrepositions {
      writeDBRow(query: prepositionsInsertQuery, args: [p, f])
    }

    let autocompletionsInsertQuery = "INSERT OR IGNORE INTO autocomplete_lexicon (word) VALUES (?)"
    for (p, _) in contractedGermanPrepositions {
      writeDBRow(query: autocompletionsInsertQuery, args: [p])
    }
  }
}

/// Returns the next three words in the `autocomplete_lexicon` that follow a given word.
///
/// - Parameters
///   - word: the word that autosuggestions should be returned for.
func queryAutocompletions(word: String) -> [String] {
  var autocompletions = [String]()

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
  let patterns = ["\(word.lowercased())%"]

  do {
    let rows = try languageDB.read { db in
      try Row.fetchAll(db, sql: autocompletionsQuery, arguments: StatementArguments(patterns))
    }
    for r in rows {
      autocompletions.append(r["word"])
    }
  } catch let error as DatabaseError {
    let errorMessage = error.message
    let errorSQL = error.sql
    let errorArguments = error.arguments
    print(
      "An error '\(String(describing: errorMessage))' occurred in the query: \(String(describing: errorSQL)) (\(String(describing: errorArguments)))"
    )
  } catch {}

  if autocompletions == [String]() {
    // Append an empty string so that we can check for it and trigger nothing being shown.
    autocompletions.append("")
  }

  return autocompletions
}
