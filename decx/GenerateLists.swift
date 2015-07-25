//
//  GenerateLists.swift
//  decx
//
//  Created by Steve Baker on 7/24/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Foundation

class GenerateListsCommand: Command {

  private var writeListsToFiles = false
  private var outputDirectory = "."

  override func commandName() -> String  {
    return "generate_lists"
  }

  override func commandShortDescription() -> String  {
    return "List All Cards"
  }

  override func handleOptions() {
    onKeys(["-o", "--output-directory"], usage: "path to file output directory", valueSignature: "outputDirectory") {(key, value) in
      var checkValidation = NSFileManager.defaultManager()
      if (!checkValidation.fileExistsAtPath(value)) {
        println("Directory does not exist: " + value)
        exit(1)
      }
      self.writeListsToFiles = true;
      self.outputDirectory = value;
    }
  }

  override func execute() -> ExecutionResult {
    var listApp = GenerateLists(writeListsToFiles: self.writeListsToFiles, outputDirectory: self.outputDirectory)
    listApp.execute()
    return success()
  }
  
}

class GenerateLists {

  private var writeListsToFiles = false;
  private var outputDirectory = ""
  private var rc = RcDirectory.sharedRc

  init(writeListsToFiles: Bool, outputDirectory: String) {
    self.writeListsToFiles = writeListsToFiles
    self.outputDirectory = outputDirectory
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

  private func outputListsToFiles(lists: EntryList) {
    let listNames = lists.getListNames()
    for listName in listNames {
      let cardNames = lists.getListForName(listName)
      let fileName = "\(outputDirectory)/mtgcards-\(listName).txt"
      println(fileName)
      (cardNames as NSArray).writeToFile(fileName, atomically: false)
    }
  }

  private func outputLists(lists: EntryList) {
    if (writeListsToFiles) {
      outputListsToFiles(lists)
    }
    else {
      outputListsToScreen(lists)
    }
  }
  
  func execute() {
    
    var cardLists = EntryList();

    let reader = AllCardsFileReader(pathToFile: rc.getPathToAllCards())
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
