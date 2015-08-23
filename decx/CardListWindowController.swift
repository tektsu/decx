//
//  MainWindowController.swift
//  decx
//
//  Created by Steve Baker on 8/15/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa

class CardListWindowController: NSWindowController {

  dynamic var displayText: NSAttributedString = NSAttributedString(string: "")

  // NSTextView does not support weak references.
  @IBOutlet var textView: NSTextView!
  
  override var windowNibName: String? {
    return "CardListWindowController"
  }

  private func outputListsToScreen(lists: EntryList) {
    clear()
    let listNames = lists.getListNames()
    for listName in listNames {
      var textToAdd = "\n[\(listName)]\n"
      let cardNames = lists.getListForName(listName)
      for cardName in cardNames {
        textToAdd += "\(cardName)\n"
      }
      appendToDisplay(textToAdd)
    }
  }

  private func outputLists(lists: EntryList) {
    outputListsToScreen(lists)
  }
  
  override func windowDidLoad() {

    var cardLists = EntryList()

    let reader = AllCardsFileReader(pathToFile: "/Users/steve/Development/decx/AllCards-x.json".stringByExpandingTildeInPath)
    if (!reader.worked()) {
      appendToDisplay(reader.getError())
      return
    }
    let json = reader.getJson()

    for name in json.allKeys {
      let entry = Entry(card: json.objectForKey(name)!)
      cardLists.addEntry(entry)
    }

    outputLists(cardLists)
  }

  private func clear() {
    displayText = NSAttributedString(string: "")
  }

  private func appendToDisplay(textToAdd: String) {
    let mutableText = displayText.mutableCopy() as! NSMutableAttributedString
    mutableText.appendAttributedString(NSAttributedString(string: textToAdd))
    displayText = mutableText.copy() as! NSAttributedString
  }
}
