//
//  Subtype.swift
//  
//
//  Created by Steve Baker on 8/23/15.
//
//

import Foundation
import CoreData

class Subtype: NSManagedObject {

    @NSManaged var subtype: String
    @NSManaged var cards: NSSet

}
