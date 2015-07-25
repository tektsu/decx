//
//  RcDirectory.swift
//  decx
//
//  Created by Steve Baker on 7/25/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Foundation

class RcDirectory {
  static let sharedRc = RcDirectory()
  private let topDirectory = "~/.decxrc".stringByExpandingTildeInPath

  init() {
    var checkValidation = NSFileManager.defaultManager()
    if (!checkValidation.fileExistsAtPath(topDirectory)) {
      var error: NSError?
      NSFileManager.defaultManager() .createDirectoryAtPath(topDirectory, withIntermediateDirectories: false, attributes: nil, error: &error)
    }
  }

  private func pathToAllCards() -> String {
    let path = "\(topDirectory)/AllCards-x.json"
    return path
  }

  func getPathToAllCards() -> String {
    let path = pathToAllCards()
    var checkValidation = NSFileManager.defaultManager()
    if (!checkValidation.fileExistsAtPath(topDirectory)) {
    }
    return path
  }
}
