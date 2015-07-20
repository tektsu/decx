//
//  EntryList.swift
//  decx
//
//  Created by Steve Baker on 7/19/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Foundation

class EntryList {
  var lists = [String: [String]]()

  private func generateKey(entry: Entry) -> String {
    var key = entry.getColor() + "-" + entry.getType()
    if (entry.getSupertype() != nil) {
      key = key + "-" + entry.getSupertype()!
    }
    return key
  }

  func addEntry(entry: Entry) {
    let listName = self.generateKey(entry)
    if (lists[listName] == nil) {
      lists[listName] = [String]()
    }
    lists[listName]!.append(entry.getName())
  }

  func getListNames() -> [String] {
    var listNames = [String]()
    for (listName, _) in lists {
      listNames.append(listName)
    }
    return listNames
  }

  func getListForName(listName: String) -> [String] {
    return lists[listName]!.sorted({ (first, second) -> Bool in
      return first.lowercaseString < second.lowercaseString
    })
  }
}
