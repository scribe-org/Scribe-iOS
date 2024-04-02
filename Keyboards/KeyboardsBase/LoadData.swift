/**
 * Function for loading in data to the keyboards.
 *
 * Copyright (C) 2023 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import Foundation
import GRDB
import SwiftyJSON

/// Loads a JSON file that contains grammatical information into a dictionary.
///
/// - Parameters
///  - filename: the name of the JSON file to be loaded.
func loadJSON(filename fileName: String) -> JSON? {
  guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
        let data = try? Data(contentsOf: url),
        let jsonData = try? JSON(data: data)
  else {
    return nil
  }
  return jsonData
}

/// Makes a connection to the language database given the value for controllerLanguage.
func openDBQueue() -> DatabaseQueue {
  let dbName = "\(String(describing: get_iso_code(keyboardLanguage: controllerLanguage).uppercased()))LanguageData"
  guard let dbPath = Bundle.main.path(forResource: dbName, ofType: "sqlite") else {
    fatalError("Failed to locate database file.")
  }
  do {
    let dbQueue = try DatabaseQueue(path: dbPath)
    return dbQueue
  } catch {
    fatalError("Failed to initialize DatabaseQueue: \(error)")
  }
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
