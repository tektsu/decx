//
//  CardDatabaseWindowController.swift
//  decx
//
//  Created by Steve Baker on 9/7/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa

class CardDatabaseWindowController: NSWindowController {

  override var windowNibName: String? {
    return "CardDatabaseWindowController"
  }

  override func windowDidLoad() {
    super.windowDidLoad()
    var dataStore = DataStoreSQL.sharedInstance
  }
    
}
