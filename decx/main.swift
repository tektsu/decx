#!/usr/bin/env xcrun swift -F /Library/Frameworks
//
//  main.swift
//  decx
//
//  Created by Steve Baker on 7/19/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Foundation
//import Darwin

struct Opts {
  static let allCardsFile = "~/Development/decx/AllCards-x.json"
}

func readFile(path: String) -> NSString {
  var error: NSError?
  let fullPath = path.stringByExpandingTildeInPath
  let fileContent = NSString(contentsOfFile: fullPath, encoding: NSUTF8StringEncoding, error: nil)
  if (fileContent == nil) {
    println("Unable to read file: " + fullPath)
    exit(0)
  }
  return fileContent!;
}

func parseJson(data: NSString) -> NSDictionary {
  var jsonError: NSError?
  let json = NSJSONSerialization.JSONObjectWithData(data.dataUsingEncoding(NSUTF8StringEncoding)!, options: nil, error: &jsonError) as! NSDictionary
  if (jsonError != nil) {
    println("Error parsing JSON")
    exit(0)
  }
  return json;
}

func generateLists() {

  var lists = EntryList();

  let fileContent = readFile(Opts.allCardsFile)
  let json = parseJson(fileContent)

  for name in json.allKeys {
    let entry = Entry(card: json.objectForKey(name)!)
    lists.addEntry(entry)
  }

  println(lists.getListNames())
  println(lists.getListForName("Green-Tribal"))
}

CLI.setup(
  name: "decx",
  version: "0.1.0",
  description: "MTG Card Operations"
)
CLI.registerChainableCommand(commandName: "generate_lists")
  .withExecutionBlock {(arguments, options) in
    generateLists()
    return success()
}
CLI.go()


