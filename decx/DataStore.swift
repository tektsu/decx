//
//  DataStore.swift
//  decx
//
//  Created by Steve Baker on 8/23/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa

class DataStore {

  let context = (NSApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!

  //func getContext() -> managedObjectContext {
  //
  //}

  init() {

  }

  init(file: String) {
    loadDataFromFile(file)
  }

  func loadDataFromFile(file: String) {
    
    let reader = JsonFileReader(pathToFile: file.stringByExpandingTildeInPath)
    if (!reader.worked()) {
      println("json parse error")
      return
    }
    if let json: AnyObject = reader.getJson() {
      loadDataFromJson(json)
    }
  }

  func loadDataFromJson(json: AnyObject) {
    clearData()

    var setObjects = [String: Set]()
    var colorObjects = [String: Color]()
    var typeObjects = [String: Type]()
    var subtypeObjects = [String: Subtype]()

    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "%Y-%m-%d"

    for setId in json.allKeys {
      var setCode: String = setId as! String
      if let set: AnyObject = json.objectForKey(setId) {
        if setObjects[setCode] == nil {
          var newSet = NSEntityDescription.insertNewObjectForEntityForName("Set", inManagedObjectContext: context) as! Set
          newSet.code = setCode
          if let border = set["border"] as! String? {
            newSet.border = border
          }
          if let code = set["code"] as! String? {
            newSet.code = code
          }
          if let magicCardsInfoCode = set["magicCardsInfoCode"] as! String? {
            newSet.magicCardsInfoCode = magicCardsInfoCode
          }
          if let name = set["name"] as! String? {
            newSet.name = name
          }
          if let type = set["type"] as! String? {
            newSet.type = type
          }
          if let releaseDate = set["releaseDate"] as! String? {
            newSet.releaseDate = dateFormatter.dateFromString(releaseDate)!
          }
          setObjects[setCode] = newSet;
        }
        if let cards = set["cards"] as? [AnyObject] {
          for card in cards {
            var newCard = NSEntityDescription.insertNewObjectForEntityForName("Card", inManagedObjectContext: context) as! Card
            newCard.sets = setObjects[setCode]!
            if let artist = card["artist"] as! String? {
              newCard.artist = artist
            }
            if let cmc = card["cmc"] as! NSNumber? {
              newCard.cmc = cmc
            }
            if let colors = card["colors"] as! Array<String>? {
              let cardColors = newCard.mutableSetValueForKey("colors")
              for color in colors {
                if colorObjects[color] == nil {
                  let newColor = NSEntityDescription.insertNewObjectForEntityForName("Color", inManagedObjectContext: context) as! Color
                  newColor.color = color
                  colorObjects[color] = newColor;
                }
                cardColors.addObject(colorObjects[color]!)
              }
            }
            if let flavor = card["flavor"] as! String? {
              newCard.flavor = flavor
            }
            if let imageName = card["imageName"] as! String? {
              newCard.imageName = imageName
            }
            if let layout = card["layout"] as! String? {
              newCard.layout = layout
            }
            if let manaCost = card["manaCost"] as! String? {
              newCard.manaCost = manaCost
            }
            if let multiverseId = card["multiverseId"] as! NSNumber? {
              newCard.multiverseId = multiverseId
            }
            if let name = card["name"] as! String? {
              newCard.name = name
            }
            if let number = card["number"] as! String? {
              newCard.number = number
            }
            if let rarity = card["rarity"] as! String? {
              newCard.rarity = rarity
            }
            if let subtypes = card["subtypes"] as! Array<String>? {
              let cardSubtypes = newCard.mutableSetValueForKey("subtypes")
              for subtype in subtypes {
                if subtypeObjects[subtype] == nil {
                  let newSubtype = NSEntityDescription.insertNewObjectForEntityForName("Subtype", inManagedObjectContext: context) as! Subtype
                  newSubtype.subtype = subtype
                  subtypeObjects[subtype] = newSubtype;
                }
                cardSubtypes.addObject(subtypeObjects[subtype]!)
              }
            }
            if let text = card["text"] as! String? {
              newCard.text = text
            }
            if let type = card["type"] as! String? {
              newCard.type = type
            }
            if let types = card["types"] as! Array<String>? {
              let cardTypes = newCard.mutableSetValueForKey("types")
              for type in types {
                if typeObjects[type] == nil {
                  let newType = NSEntityDescription.insertNewObjectForEntityForName("Type", inManagedObjectContext: context) as! Type
                  newType.type = type
                  typeObjects[type] = newType;
                }
                cardTypes.addObject(typeObjects[type]!)
              }
            }
          }
        }
      }
      //break
    }

    var error: NSError?
    if !context.save(&error)  {
      println("Could not save data \(error), \(error?.userInfo)")
      exit(1)
    }
  }

  func clearData() {
    clearEntity("Card")
  }

  private func clearEntity(entity: String) {
    let fetchRequest = NSFetchRequest(entityName: entity)
    var error: NSError?
    let fetchedResults = context.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
    if let results = fetchedResults
    {
      for (var i=0; i < results.count; i++)
      {
        let value = results[i]
        context.deleteObject(value)
        context.save(nil)
      }
    }
  }
}