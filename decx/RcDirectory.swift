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

  private func downloadFile(url: String, fileName: String) -> Bool {

    //var url = NSURL(string: url)
    var request = NSURLRequest(URL: NSURL(string: url)!)
    var response: NSURLResponse?
    var error: NSError?
    var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
    if (error != nil) {
      return false
    }

    var httpResponse = response as! NSHTTPURLResponse
    if httpResponse.statusCode != 200 {
      return false
    }

    data!.writeToFile(fileName, atomically: true)
    return true
  }

  private func downloadAllCards() {
    downloadFile("http://mtgjson.com/json/AllCards-x.json", fileName: pathToAllCards())
  }

  private func pathToAllCards() -> String {
    let path = "\(topDirectory)/AllCards-x.json"
    return path
  }

  func getPathToAllCards() -> String {
    let path = pathToAllCards()
    var checkValidation = NSFileManager.defaultManager()
    if (!checkValidation.fileExistsAtPath(path)) {
      downloadAllCards()
    }
    return path
  }
}
