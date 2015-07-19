//
//  EntryList.swift
//  decx
//
//  Created by Steve Baker on 7/19/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Foundation

class EntryList {
  var lists: NSDictionary = NSDictionary()

  private func generateKey(entry: Entry) -> String {
    var key = entry.getName() + ", " + entry.getColor() + ", " + entry.getType()
    if (entry.getSupertype() != nil) {
      key = key + ", " + entry.getSupertype()!
    }
    return key
  }

  init(entry: Entry) {

  }
}
