//
//  LoadData.swift
//
//  Function for loading in data to the keyboards.
//

import Foundation
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
