//
//  MainWindowController.swift
//  decx
//
//  Created by Steve Baker on 8/16/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa

class MainWindowController : NSWindowController {

  override var windowNibName: String? {
    return "MainWindowController"
  }

  override func windowDidLoad() {
    super.windowDidLoad()
    var dataStore = DataStore.sharedInstance
    dataStore.loadData()
  }
}
