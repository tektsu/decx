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

  private func outputListsToScreen(lists: [String:[String:Bool]]) {
    clear()
    let listNames = Array(lists.keys).sorted(<)
    for listName in listNames {
      println(listName)
      var textToAdd = "\n[\(listName)]\n"
      let cardNames = Array(lists[listName]!.keys).sorted(<)
      for cardName in cardNames {
        textToAdd += "\(cardName)\n"
      }
      appendToDisplay(textToAdd)
    }
  }

  private func outputLists(lists: [String:[String:Bool]]) {
    outputListsToScreen(lists)
  }

  // Generate a type name based on the type components we care about
  private func getNormalizedCardType(type: String) -> String {
    var listName = ""
    var typeArray = type.componentsSeparatedByString(" ")
    var hyphen = false
    for component in typeArray {
      if component == "" {
        continue
      }
      if component == "\u{2014}" {
        hyphen = true
        continue
      }
      var validComponent: String? = nil
      if hyphen {
        // Use only these subtypes
        if component == "Aura" || component == "Equipment" {
          validComponent = component
        }
      }
      else {
        if component == "Summon" {
          validComponent = "Creature"
        }
        else if component == "Interrupt" {
          validComponent = "Instant"
        }
        // Ignore these supertypes
        else if component == "Legendary" || component == "Snow" || component == "World" || component == "Ongoing" {
        }
        else {
          validComponent = component
        }
      }
      if let name = validComponent {
        listName += " \(name)"
      }
    }
    return listName
  }

  override func windowDidLoad() {

    let dataStore = DataStoreSQL.sharedInstance
    let db = dataStore.getConnection()!
    let tableCards = db["cards"]
    let cardName = dataStore.cardName
    let cardColor = dataStore.cardColor
    let cardType = dataStore.cardType
    var cardLists = [String:[String:Bool]]()

    for entry in tableCards.select(cardName, cardColor, cardType).order(cardName) {
      var listName: String = entry[cardColor]
      if let type: String = entry[cardType] {
        listName += getNormalizedCardType(type)
      }
      //println("\(listName): \(entry[cardName])")

      if cardLists[listName] == nil {
        cardLists[listName] = [String: Bool]()
      }
      cardLists[listName]![entry[cardName]] = true
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
