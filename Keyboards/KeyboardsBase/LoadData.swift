//
//  LoadData.swift
//
//  Function for loading in data to the keyboards.
//

import Foundation

/// Loads a JSON file that contains grammatical information into a dictionary.
///
/// - Parameters
///  - filename: the name of the JSON file to be loaded.
func loadJSONToDict(filename fileName: String) -> [String: AnyObject]? {
  if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
    do {
      let data = try Data(contentsOf: url)
      let jsonData = try JSONSerialization.jsonObject(with: data)
      return jsonData as? [String: AnyObject]
    } catch {
      print("error:\(error)")
    }
  }
  return nil
}
