//
//  FileReader.swift
//  decx
//
//  Created by Steve Baker on 7/25/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Foundation

class FileReader {
  private var error = false
  private var errorMessage = ""
  private var fileContent: String? = nil

  init(pathToFile: String) {
    var fileError: NSError?
    let fullPathToFile = pathToFile.stringByExpandingTildeInPath
    fileContent = NSString(contentsOfFile: fullPathToFile, encoding: NSUTF8StringEncoding, error: &fileError) as String?
    if (fileContent == nil) {
      error = true
      if (fileError != nil) {
        errorMessage = fileError!.localizedDescription
      }
      else {
        errorMessage = "Unable to read file " + fullPathToFile
      }
    }
  }

  func worked() -> Bool {
    return !error
  }

  func getError() -> String {
    return errorMessage
  }

  func contents() -> String {
    return fileContent!
  }

}