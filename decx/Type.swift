//
//  Type.swift
//  
//
//  Created by Steve Baker on 8/23/15.
//
//

import Foundation
import CoreData

class Type: NSManagedObject {

    @NSManaged var type: String
    @NSManaged var cards: NSSet

}
