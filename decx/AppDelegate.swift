//
//  AppDelegate.swift
//  decx
//
//  Created by Steve Baker on 8/15/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var cardDatabaseWindowController: CardDatabaseWindowController?
  var cardListWindowController: CardListWindowController?

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let cardDatabaseWindowController = CardDatabaseWindowController()
    self.cardDatabaseWindowController = cardDatabaseWindowController
    self.cardDatabaseWindowController!.showWindow(self)
  }

  @IBAction func viewCardList(sender: AnyObject?) {
    if (cardListWindowController == nil) {
      // Create a window controller
      let cardListWindowController = CardListWindowController()
      self.cardListWindowController = cardListWindowController
    }

    // Put the window of the window controller on screen
    self.cardListWindowController!.showWindow(self)
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }
}

