//
//  GenerateLists.swift
//  decx
//
//  Created by Steve Baker on 7/24/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Foundation

class GenerateListsCommand: Command {

  private var allCardsFile: String = "AllCards-x-json"

  override func commandName() -> String  {
    return "generate_lists"
  }

  override func commandShortDescription() -> String  {
    return "List All Cards"
  }

  override func handleOptions() {
    onKeys(["-a", "--all-cards-file"], usage: "path to all-cards json file", valueSignature: "allCards") {(key, value) in
      self.allCardsFile = value;
    }
  }

  override func execute() -> ExecutionResult {
    println(self.allCardsFile)
    var listApp = GenerateLists(path: self.allCardsFile)
    listApp.execute()
    return success()
  }
  
}

class GenerateLists {

  private var allCardsFile = ""

  private func readFile(path: String) -> NSString {
    var error: NSError?
    let fullPath = allCardsFile.stringByExpandingTildeInPath
    let fileContent = NSString(contentsOfFile: fullPath, encoding: NSUTF8StringEncoding, error: nil)
    if (fileContent == nil) {
      println("Unable to read file: " + fullPath)
      exit(0)
    }
    return fileContent!;
  }

  private func parseJson(data: NSString) -> NSDictionary {
    var jsonError: NSError?
    let json = NSJSONSerialization.JSONObjectWithData(data.dataUsingEncoding(NSUTF8StringEncoding)!, options: nil, error: &jsonError) as! NSDictionary
    if (jsonError != nil) {
      println("Error parsing JSON")
      exit(0)
    }
    return json;
  }

  init(path: String) {
    self.allCardsFile = path
  }
  
  func execute() {
    
    var lists = EntryList();

    let fileContent = readFile(self.allCardsFile)
    let json = parseJson(fileContent)

    for name in json.allKeys {
      let entry = Entry(card: json.objectForKey(name)!)
      lists.addEntry(entry)
    }

    //println(lists.getListNames())
    println(lists.getListForName("Green-Tribal"))
  }
  
}
