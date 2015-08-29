//
//  Set_Extension.swift
//  decx
//
//  Created by Steve Baker on 8/29/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa

extension Set {

  convenience init(context: NSManagedObjectContext) {
    let entityDescription = NSEntityDescription.entityForName("Set", inManagedObjectContext: context)!
    self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
  }

}
