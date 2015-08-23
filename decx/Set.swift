//
//  Set.swift
//  
//
//  Created by Steve Baker on 8/23/15.
//
//

import Foundation
import CoreData

class Set: NSManagedObject {

    @NSManaged var border: String
    @NSManaged var code: String
    @NSManaged var magicCardsInfoCode: String
    @NSManaged var name: String
    @NSManaged var releaseDate: NSDate
    @NSManaged var type: String
    @NSManaged var cards: NSSet

}
