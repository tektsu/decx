//
//  Type_Extension.swift
//  decx
//
//  Created by Steve Baker on 8/29/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa

extension Type {

  convenience init(context: NSManagedObjectContext) {
    let entityDescription = NSEntityDescription.entityForName("Type", inManagedObjectContext: context)!
    self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
  }

}