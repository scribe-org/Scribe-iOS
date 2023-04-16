//
//  LoadData.swift
//
//  Function for loading in data to the keyboards.
//

import Foundation
import SwiftyJSON
import GRDB


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
    let addScribeQuery = "INSERT INTO nouns (noun, plural, form) VALUES (?, ?, ?)"
    writeDBRow(query: addScribeQuery, args: ["Scribe", "Scribes", ""])
    writeDBRow(query: addScribeQuery, args: ["Scribes", "isPlural", "PL"])
  }

  // Add German compound prepositions to the prepositions table so they also receive annotations.
  if controllerLanguage == "German" {
    let query = "INSERT INTO prepositions (preposition, form) VALUES (?, ?)"
    for (p, f) in contractedGermanPrepositions {
      writeDBRow(query: query, args: [p, f])
    }
  }
}


/// Creates a table in the language database from which autocompletions will be drawn.
/// Note: this function also calls expandLanguageDataset prior to creating the lexicon.
///
/// - Steps:
///   - Create a base lexicon of noun, preposition, autosuggestion and emoji keys.
///   - Remove words that have capitalized or upper case versions in the nouns table to make sure that just these versions are in autocomplete.
///   - Filter out words that are less than three characters, numbers and hyphenated words.
func createAutocompleteLexicon() {
  expandLanguageDataset()

  // Dropping the table before it's made to reset the values in case they change (potentially new data).
  let dropLexiconTableQuery = "DROP TABLE IF EXISTS autocomplete_lexicon"
  do {
    try languageDB.write { db in
      try db.execute(sql: dropLexiconTableQuery)
    }
  } catch let error as DatabaseError {
    let errorMessage = error.message
    let errorSQL = error.sql
    print(
      "An error '\(String(describing: errorMessage))' occurred in the query: \(String(describing: errorSQL))"
    )
  } catch {}

  let createLexiconTableQuery = "CREATE TABLE IF NOT EXISTS autocomplete_lexicon (word Text)"
  do {
    try languageDB.write { db in
      try db.execute(sql: createLexiconTableQuery)
    }
  } catch let error as DatabaseError {
    let errorMessage = error.message
    let errorSQL = error.sql
    print(
      "An error '\(String(describing: errorMessage))' occurred in the query: \(String(describing: errorSQL))"
    )
  } catch {}

  let createLexiconQuery = """
    INSERT INTO autocomplete_lexicon (word)

    WITH full_lexicon AS (
      SELECT
        noun AS word
      FROM
        nouns
      WHERE
        LENGTH(noun) > 2

      UNION

      SELECT
        preposition AS word
      FROM
        prepositions
      WHERE
        LENGTH(preposition) > 2

      UNION

      SELECT
        -- For short words we want lower case versions.
        -- The SELECT DISTINCT cases later will make sure that nouns are appropriately selected.
        CASE
          WHEN
            LENGTH(word) = 3
          THEN
            LOWER(word)
          ELSE
            word
        END AS word
      FROM
        autosuggestions
      WHERE
        LENGTH(word) > 2

      UNION

      SELECT
        word AS word
      FROM
        emoji_keywords
    )

    SELECT DISTINCT
      -- Select an upper case or capitalized noun if it's available.
      CASE
        WHEN
          UPPER(lex.word) = nouns_upper.noun
        THEN
          nouns_upper.noun

        WHEN
          UPPER(SUBSTR(lex.word, 1, 1)) || SUBSTR(lex.word, 2) = nouns_cap.noun
        THEN
          nouns_cap.noun

        ELSE
          lex.word
      END

    FROM
      full_lexicon AS lex

    LEFT JOIN
      nouns AS nouns_upper

    ON
      UPPER(lex.word) = nouns_upper.noun

    LEFT JOIN
      nouns AS nouns_cap

    ON
      UPPER(SUBSTR(lex.word, 1, 1)) || SUBSTR(lex.word, 2) = nouns_cap.noun

    WHERE
      LENGTH(lex.word) > 1
      AND lex.word NOT LIKE '%-%'
      AND lex.word NOT LIKE '%/%'
      AND lex.word NOT LIKE '%(%'
      AND lex.word NOT LIKE '%)%'
    """
  do {
    try languageDB.write { db in
      try db.execute(sql: createLexiconQuery)
    }
  } catch let error as DatabaseError {
    let errorMessage = error.message
    let errorSQL = error.sql
    print(
      "An error '\(String(describing: errorMessage))' occurred in the query: \(String(describing: errorSQL))"
    )
  } catch {}

  // Note: the following lines are for checking the total of the autocomplete lexicon if needed.
//  let checkLexiconTotal = "SELECT CAST(COUNT(?) AS Text) AS word_count FROM autocomplete_lexicon"
//  let args = ["words"]
//  let outputCols = ["word_count"]
//  let lexicon_count = queryDBRow(query: checkLexiconTotal, outputCols: outputCols, args: args)[0]
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
