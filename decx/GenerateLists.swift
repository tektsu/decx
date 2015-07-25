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

  init(path: String) {
    self.allCardsFile = path
  }
  
  func execute() {
    
    var lists = EntryList();

    let reader = AllCardsFileReader(pathToFile: allCardsFile)
    if (!reader.worked()) {
      println(reader.getError())
      exit(0)
    }
    let json = reader.getJson()

    for name in json.allKeys {
      let entry = Entry(card: json.objectForKey(name)!)
      lists.addEntry(entry)
    }

    //println(lists.getListNames())
    println(lists.getListForName("Green-Tribal"))
  }
  
}
