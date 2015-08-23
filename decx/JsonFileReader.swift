//
//  AllSetsFileReader.swift
//  decx
//
//  Created by Steve Baker on 8/16/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Foundation

class JsonFileReader {
  private var error = false
  private var errorMessage = ""
  private var json: AnyObject? = nil

  init(pathToFile: String) {
    var reader = FileReader(pathToFile: pathToFile);
    if (!reader.worked()) {
      errorMessage = reader.getError()
      error = true
      return
    }

    var jsonError: NSError?
    json = NSJSONSerialization.JSONObjectWithData(reader.contents().dataUsingEncoding(NSUTF8StringEncoding)!, options: nil, error: &jsonError)!
    if (jsonError != nil) {
      error = true
      if (jsonError != nil) {
        errorMessage = jsonError!.localizedDescription
      }
      else {
        errorMessage = "Unable to parse file " + reader.contents()
      }
    }
  }

  func worked() -> Bool {
    return !error
  }

  func getError() -> String {
    return errorMessage
  }

  func getJson() -> AnyObject? {
    return json
  }
}
