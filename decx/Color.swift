//
//  Color.swift
//  
//
//  Created by Steve Baker on 8/23/15.
//
//

import Foundation
import CoreData

class Color: NSManagedObject {

    @NSManaged var color: String
    @NSManaged var cards: NSSet

}
