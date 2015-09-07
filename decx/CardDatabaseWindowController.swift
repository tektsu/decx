//
//  CardDatabaseWindowController.swift
//  decx
//
//  Created by Steve Baker on 9/7/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa

class CardDatabaseWindowController: NSWindowController, NSTableViewDataSource {

  @IBOutlet weak var searchField: NSSearchField!

  @IBOutlet weak var dbView: NSTableView!
  var dbViewData: [String] = []

  override var windowNibName: String? {
    return "CardDatabaseWindowController"
  }

  override func windowDidLoad() {
    super.windowDidLoad()
    var dataStore = DataStoreSQL.sharedInstance
    dbView.reloadData()
  }

  @IBAction func doSearch(sender: AnyObject) {
    dbViewData = []
    if searchField.stringValue != "" {
      println("Ping! \(searchField.stringValue)")

      let dataStore = DataStoreSQL.sharedInstance
      let db = dataStore.getConnection()!
      let statement = db.prepare("SELECT cardName, cardColor, cardType FROM cards WHERE cardName LIKE ? OR cardText LIKE ? ORDER BY cardName", "%\(searchField.stringValue)%", "%\(searchField.stringValue)%")
      for row in statement {
        dbViewData.append(row[0] as! String)
      }
    }
    dbView.reloadData()
  }

  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    return dbViewData.count
  }

  func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
    return dbViewData[row]
  }

}
