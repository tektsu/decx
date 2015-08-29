//
//  Card_Extension.swift
//  decx
//
//  Created by Steve Baker on 8/23/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa

extension Card {

  convenience init(context: NSManagedObjectContext) {
    let entityDescription = NSEntityDescription.entityForName("Card", inManagedObjectContext: context)!
    self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
  }

  func addColor(value: Color) {
    let items = self.mutableSetValueForKey("colors")
    items.addObject(value)
  }

}
