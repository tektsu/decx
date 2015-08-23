//
//  MainWindowController.swift
//  decx
//
//  Created by Steve Baker on 8/16/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa

class MainWindowController : NSWindowController {

  let managedContext = (NSApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!


  override var windowNibName: String? {
    return "MainWindowController"
  }

  override func windowDidLoad() {
    super.windowDidLoad()

    var dataStore = DataStore(file: "~/Development/decx/AllSets.json")

    let colorFetchRequest = NSFetchRequest(entityName: "Color")
    if let colorFetchResults = managedContext.executeFetchRequest(colorFetchRequest, error: nil) as? [Color] {
      println(colorFetchResults.count)
      for color in colorFetchResults {
        println("- \(color.color)")
        for card in color.cards {
          //println("    " + card.name)
        }
      }
    }
  }
}
