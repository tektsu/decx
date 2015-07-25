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
    var listApp = GenerateLists(pathToFile: self.allCardsFile)
    listApp.execute()
    return success()
  }
  
}

class GenerateLists {

  private var allCardsFile = ""

  init(pathToFile: String) {
    self.allCardsFile = pathToFile
  }

  private func outputListsToScreen(lists: EntryList) {
    let listNames = lists.getListNames()
    for listName in listNames {
      println("\n[" + listName + "]")
      let cardNames = lists.getListForName(listName)
      for cardName in cardNames {
        println(cardName)
      }
    }
  }

  private func outputLists(lists: EntryList) {
    outputListsToScreen(lists)
  }
  
  func execute() {
    
    var cardLists = EntryList();

    let reader = AllCardsFileReader(pathToFile: allCardsFile)
    if (!reader.worked()) {
      println(reader.getError())
      exit(0)
    }
    let json = reader.getJson()

    for name in json.allKeys {
      let entry = Entry(card: json.objectForKey(name)!)
      cardLists.addEntry(entry)
    }

    outputLists(cardLists)

  }
  
}
