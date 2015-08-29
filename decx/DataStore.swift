//
//  DataStore.swift
//  decx
//
//  Created by Steve Baker on 8/23/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa

class DataStore {
  static let sharedInstance = DataStore()
  private var error = false
  private var errorMessage = ""
  private let context = (NSApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!

  func getContext() -> NSManagedObjectContext {
    return context
  }

  init() {}

  func loadData() {
    println("Loading data")
    let fetchRequest = NSFetchRequest(entityName: "Color")
    if let fetchResults = context.executeFetchRequest(fetchRequest, error: nil) as? [Color] {
      if (fetchResults.count == 0) {
        loadDataFromUrl("http://mtgjson.com/json/AllSets-x.json")
      }
    }
    println("Done loading data")
  }

  func loadDataFromUrl(address: String) {
    println("Downloading \(address)")
    let url = NSURL(string: address)
    let sharedSession = NSURLSession.sharedSession()
    let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(url!, completionHandler: {
        (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
      
        println("Done downloading")
        var urlContents = NSString(contentsOfURL: location, encoding: NSUTF8StringEncoding, error: nil) as! String
        var json: AnyObject? = self.parseJson(urlContents)
        if (self.error) {
          self.errorMessage += "\nUnable to parse data from \(address)"
          return
        }

        self.loadDataFromJson(json!)

    })
    downloadTask.resume()
  }

  func parseJson(jsonString: String) -> AnyObject? {
    var jsonError: NSError?
    let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!,
      options: nil, error:&jsonError)
    if (json == nil) {
      self.error = true
      if (jsonError != nil) {
        self.errorMessage = jsonError!.localizedDescription
      }
      else {
        self.errorMessage = "Unable to parse contents json data"          }
    }
    return json
  }

  func loadDataFromJson(json: AnyObject) {
    println("Loading tables")
    clearData()

    var setObjects = [String: Set]()
    var colorObjects = [String: Color]()
    var typeObjects = [String: Type]()
    var subtypeObjects = [String: Subtype]()

    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "%Y-%m-%d"

    func loadSet(set: AnyObject) -> String {
      var setCode = set["code"] as! String
      if setObjects[setCode] == nil {
        let newSet = Set(context: context)
        newSet.code = setCode
        if let border = set["border"] as! String? {
          newSet.border = border
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
      return setCode
    }

    func loadColor(color: String) -> Color {
      if colorObjects[color] == nil {
        let newColor = Color(context: context)
        newColor.color = color
        colorObjects[color] = newColor;
      }
      return colorObjects[color]!
    }

    func loadType(type: String) {
      if typeObjects[type] == nil {
        let newType = Type(context: context)
        newType.type = type
        typeObjects[type] = newType;
      }
    }

    func loadSubtype(subtype: String) {
      if subtypeObjects[subtype] == nil {
        let newSubtype = Subtype(context: context)
        newSubtype.subtype = subtype
        subtypeObjects[subtype] = newSubtype;
      }
    }

    func saveContext(context: NSManagedObjectContext) -> (success: Bool, error: NSError?) {
      var error: NSError?
      let success = context.save(&error)
      return (success, error)
    }

    for setId in json.allKeys {
      if let set: AnyObject = json.objectForKey(setId) {
        var setCode = loadSet(set)
        if let cards = set["cards"] as? [AnyObject] {
          for card in cards {
            let newCard = Card(context: context)
            newCard.sets = setObjects[setCode]!
            if let artist = card["artist"] as! String? {
              newCard.artist = artist
            }
            if let cmc = card["cmc"] as! NSNumber? {
              newCard.cmc = cmc
            }
            if let colors = card["colors"] as! Array<String>? {
              for color in colors {
                var colorEntry = loadColor(color)
                newCard.addColor(colorEntry)
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
                loadSubtype(subtype)
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
                loadType(type)
                cardTypes.addObject(typeObjects[type]!)
              }
            }
          }
        }
      }
      //break
    }

    let result = saveContext(context)
    if (!result.success) {
      println("Could not save data \(result.error), \(result.error?.userInfo)")
      exit(1)
    }

    println("Done loading tables")

    let colorFetchRequest = NSFetchRequest(entityName: "Color")
    if let colorFetchResults = context.executeFetchRequest(colorFetchRequest, error: nil) as? [Color] {
      println(colorFetchResults.count)
      for color in colorFetchResults {
        println("- \(color.color)")
        for card in color.cards {
          //println("    " + card.name)
        }
      }
    }

  }

  func clearData() {
    clearEntity("Card")
    //clearEntity("Color")
    //clearEntity("Type")
    //clearEntity("Subtype")
    //clearEntity("Set")
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