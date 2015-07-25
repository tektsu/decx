//
//  Entry.swift
//  decx
//
//  Created by Steve Baker on 7/19/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Foundation

class Entry {
  private var name: String = ""
  private var color: String = ""
  private var type: String? = nil
  private var supertype: String? = nil

  init(card: AnyObject) {
    setName(card)
    setColor(card)
    setType(card)
    setSupertype(card)
  }

  private func setName(card: AnyObject) {
    self.name = card["name"] as! String
    let first = self.name.startIndex
    if (self.name[first] == "Æ") {
      self.name.removeAtIndex(first)
      self.name.splice("AE", atIndex: first)
    }
  }

  private func setColor(card: AnyObject) {
    if (card["colors"] === nil) {
      self.color = "Colorless"
    }
    else {
      let colors = (card["colors"] as! NSArray) as Array
      if (colors.count > 1) {
        self.color = "Multicolored"
      }
      else {
        self.color = colors[0] as! String
      }
    }
  }

  private func setType(card: AnyObject) {
    if (card["types"] === nil) {
      return
    }
    let types = (card["types"] as! NSArray) as Array
    self.type = types[0] as? String
  }

  private func setSupertype(card: AnyObject) {
    if (card["supertypes"] === nil) {
      return
    }
    let supertypes = (card["supertypes"] as! NSArray) as Array
    self.supertype = supertypes[0] as? String
  }

  func getName() -> String {
    return self.name
  }

  func getColor() -> String {
    return self.color
  }

  func getType() -> String? {
    return self.type
  }

  func getSupertype() -> String? {
    return self.supertype
  }
}
