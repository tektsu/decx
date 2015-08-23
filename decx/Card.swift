//
//  Card.swift
//  
//
//  Created by Steve Baker on 8/23/15.
//
//

import Foundation
import CoreData

class Card: NSManagedObject {

    @NSManaged var artist: String
    @NSManaged var cmc: NSNumber
    @NSManaged var flavor: String
    @NSManaged var imageName: String
    @NSManaged var layout: String
    @NSManaged var manaCost: String
    @NSManaged var multiverseId: NSNumber
    @NSManaged var name: String
    @NSManaged var power: NSNumber
    @NSManaged var rarity: String
    @NSManaged var text: String
    @NSManaged var toughness: NSNumber
    @NSManaged var type: String
    @NSManaged var number: String
    @NSManaged var colors: NSSet
    @NSManaged var sets: NSManagedObject
    @NSManaged var subtypes: NSSet
    @NSManaged var types: NSSet

}
