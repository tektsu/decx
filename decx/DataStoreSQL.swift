//
//  DataStoreSQL.swift
//  decx
//
//  Created by Steve Baker on 9/4/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Cocoa
import SQLite

class DataStoreSQL {
  static let sharedInstance = DataStoreSQL()
  private let fileManager = NSFileManager.defaultManager()
  private var dbPath = ""
  private var connection: SQLite.Database? = nil
  private var error = false
  private var errorMessages: [String] = []

  // Column Descriptions
  let id = Expression<Int64>("id")
  let setCode = Expression<String>("setCode")
  let setName = Expression<String>("setName")
  let setBorder = Expression<String?>("setBorder")
  let setMagicCardsInfoCode = Expression<String?>("setMagicCardsInfoCode")
  let setType = Expression<String?>("setType")
  let setReleaseDate = Expression<String?>("setReleaseDate")
  let cardName = Expression<String>("cardName")
  let cardColor = Expression<String>("cardColor")
  let cardArtist = Expression<String?>("cardArtist")
  let cardFlavor = Expression<String?>("cardFlavor")
  let cardImageName = Expression<String?>("cardImageName")
  let cardLayout = Expression<String?>("cardLayout")
  let cardManaCost = Expression<String?>("cardManaCost")
  let cardNumber = Expression<String?>("cardNumber")
  let cardText = Expression<String?>("cardText")
  let cardType = Expression<String?>("cardType")
  let cardCmc = Expression<Int64?>("cardCmc")
  let cardMultiverseId = Expression<Int64?>("cardMultiverseId")
  let cardPower = Expression<Int64?>("cardPower")
  let cardToughness = Expression<Int64?>("cardToughness")
  let cardSetId = Expression<Int64>("setId")
  let cardRarityId = Expression<Int64?>("rarityId")
  let typeName = Expression<String>("typeName")
  let subtypeName = Expression<String>("subtypeName")
  let supertypeName = Expression<String>("supertypeName")
  let colorName = Expression<String>("colorName")
  let rarityName = Expression<String>("rarityName")
  let cardId = Expression<Int64>("cardId")
  let typeId = Expression<Int64>("typeId")
  let subtypeId = Expression<Int64>("subtypeId")
  let supertypeId = Expression<Int64>("supertypeId")
  let colorId = Expression<Int64>("colorId")

  init() {
    if let path = getDatabasePath() {
      dbPath = path
    }
    else {
      exit(1)
    }
    if (!fileManager.fileExistsAtPath(dbPath)) {
      createDatabase()
      if !self.error {
        loadData()
        if error {
          for errorMessage in errorMessages {
            println(errorMessage)
          }
        }
      }
    }
    else {
      connection = Database(dbPath)
    }

  }

  func getConnection() -> SQLite.Database? {
    return connection
  }

  private func clearErrors() {
    error = false
    errorMessages.removeAll()
  }

  private func getApplicationSupportDirectory() -> String? {
    var error: NSError?
    if let appSupportTop = fileManager.URLForDirectory(
      NSSearchPathDirectory.ApplicationSupportDirectory,
      inDomain: NSSearchPathDomainMask.UserDomainMask,
      appropriateForURL: nil,
      create: true,
      error: &error
      )?.path {
      return appSupportTop.stringByAppendingPathComponent(NSBundle.mainBundle().bundleIdentifier!)
    }
    return nil
  }

  private func getDatabasePath() -> String? {
    if let appSupportDirectory = getApplicationSupportDirectory() {
      return appSupportDirectory.stringByAppendingPathComponent("decx.sqlite3")
    }
    return nil
  }

  private func createDatabase() {
    clearErrors()
    connection = Database(dbPath)
    let db = connection!
    db.foreignKeys = true

    let tableSets = db["sets"]
    db.create(table: tableSets) { t in
      t.column(id, primaryKey: .Autoincrement)
      t.column(setCode, unique: true)
      t.column(setName, unique: true)
      t.column(setBorder)
      t.column(setMagicCardsInfoCode)
      t.column(setType)
      t.column(setReleaseDate)
    }

    let tableCards = db["cards"]
    let tableRarities = db["rarities"]
    db.create(table: tableCards) { t in
      t.column(id, primaryKey: .Autoincrement)
      t.column(cardName)
      t.column(cardColor)
      t.column(cardArtist)
      t.column(cardFlavor)
      t.column(cardImageName)
      t.column(cardLayout)
      t.column(cardManaCost)
      t.column(cardNumber)
      t.column(cardText)
      t.column(cardType)
      t.column(cardCmc)
      t.column(cardMultiverseId)
      t.column(cardPower)
      t.column(cardToughness)
      t.column(cardSetId, references: tableSets)
      t.column(cardRarityId, references: tableRarities)
    }

    let tableTypes = db["types"]
    db.create(table: tableTypes) { t in
      t.column(id, primaryKey: .Autoincrement)
      t.column(typeName, unique: true)
    }

    let tableSubtypes = db["subtypes"]
    db.create(table: tableSubtypes) { t in
      t.column(id, primaryKey: .Autoincrement)
      t.column(subtypeName, unique: true)
    }

    let tableSupertypes = db["supertypes"]
    db.create(table: tableSupertypes) { t in
      t.column(id, primaryKey: .Autoincrement)
      t.column(supertypeName, unique: true)
    }

    let tableColors = db["colors"]
    db.create(table: tableColors) { t in
      t.column(id, primaryKey: .Autoincrement)
      t.column(colorName, unique: true)
    }

    db.create(table: tableRarities) { t in
      t.column(id, primaryKey: .Autoincrement)
      t.column(rarityName, unique: true)
    }

    let tableCardsTypes = db["cards_types"]
    db.create(table: tableCardsTypes) { t in
      t.column(id, primaryKey: .Autoincrement)
      t.column(cardId, references: tableCards)
      t.column(typeId, references: tableTypes)
    }

    let tableCardsSubtypes = db["cards_subtypes"]
    db.create(table: tableCardsSubtypes) { t in
      t.column(id, primaryKey: .Autoincrement)
      t.column(cardId, references: tableCards)
      t.column(subtypeId, references: tableSubtypes)
    }

    let tableCardsSupertypes = db["cards_supertypes"]
    db.create(table: tableCardsSupertypes) { t in
      t.column(id, primaryKey: .Autoincrement)
      t.column(cardId, references: tableCards)
      t.column(supertypeId, references: tableSupertypes)
    }

    let tableCardsColors = db["cards_colors"]
    db.create(table: tableCardsColors) { t in
      t.column(id, primaryKey: .Autoincrement)
      t.column(cardId, references: tableCards)
      t.column(colorId, references: tableColors)
    }
  }

  func clearData() {
    clearErrors()
    var db = connection!
    let tables: [String] = [
      "cards_colors",
      "cards_subtypes",
      "cards_supertypes",
      "cards_types",
      "colors",
      "subtypes",
      "supertypes",
      "types",
      "cards",
      "sets",
      "rarities"
    ]
    for table in tables {
      let delete = db[table].delete()
      if self.error {
        self.errorMessages.append(delete.statement.reason!)
        return
      }
    }
  }

  func loadData() {
    clearData()
    if self.error {
      return
    }

    let location = "/Users/steve/Downloads/AllSets.json"
    let fileContents = NSString(contentsOfFile: location, encoding: NSUTF8StringEncoding, error: nil)
    var json: AnyObject? = self.parseJson(fileContents! as String)
    self.loadDataFromJson(json!)
    return

    var address = "http://mtgjson.com/json/AllSets.json"
    println("Downloading \(address)")
    let db = connection!
    let url = NSURL(string: address)
    let sharedSession = NSURLSession.sharedSession()
    let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(url!, completionHandler: {
      (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in

      println("Done downloading")
      var urlContents = NSString(contentsOfURL: location, encoding: NSUTF8StringEncoding, error: nil) as! String
      var json: AnyObject? = self.parseJson(urlContents)
      if (self.error) {
        self.errorMessages.append("Unable to parse data from \(address)")
        return
      }

      self.loadDataFromJson(json!)

    })
    downloadTask.resume()
  }

  private func parseJson(jsonString: String) -> AnyObject? {
    var jsonError: NSError?
    let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonString.dataUsingEncoding(NSUTF8StringEncoding)!,
      options: nil, error:&jsonError)
    if (json == nil) {
      self.error = true
      if (jsonError != nil) {
        self.errorMessages.append(jsonError!.localizedDescription)
      }
      else {
        self.errorMessages.append("Unable to parse contents json data")          }
    }
    return json
  }

  private func loadDataFromJson(json: AnyObject) {
    let db = connection!
    var typeIndex = [String: Int64]()
    var subtypeIndex = [String: Int64]()
    var supertypeIndex = [String: Int64]()
    var colorIndex = [String: Int64]()
    var rarityIndex = [String: Int64]()

    func objectToInt64(obj: AnyObject?) -> Int64? {
      var val: Int64? = nil
      if let num: AnyObject = obj {
        val = Int64(num.integerValue)
      }
      return val
    }

    func loadSet(set: AnyObject) -> Int64? {
      let insert = db["sets"].insert(
        setCode <- (set["code"] as! String),
        setName <- (set["name"] as! String),
        setBorder <- (set["border"] as! String?),
        setMagicCardsInfoCode <- (set["magicCardsInfoCode"] as! String?),
        setType <- (set["type"] as! String?),
        setReleaseDate <- (set["releaseDate"] as! String?)
      )
      if insert.statement.failed {
        self.error = true
        self.errorMessages.append(insert.statement.reason!)
      }
      if insert.statement.failed {
        self.error = true
        self.errorMessages.append(insert.statement.reason!)
      }
      return insert.rowid
    }

    func loadType(type: String) -> Int64? {
      let insert = db["types"].insert(
        typeName <- type
      )
      if insert.statement.failed {
        self.error = true
        self.errorMessages.append(insert.statement.reason!)
      }
      return insert.rowid
    }

    func loadTypeRelation(cardRef: Int64, typeRef: Int64) -> Int64? {
      let insert = db["cards_types"].insert(
        cardId <- cardRef,
        typeId <- typeRef
      )
      if insert.statement.failed {
        self.error = true
        self.errorMessages.append(insert.statement.reason!)
      }
      return insert.rowid
    }

    func loadSubtype(subtype: String) -> Int64? {
      let insert = db["subtypes"].insert(
        subtypeName <- subtype
      )
      if insert.statement.failed {
        self.error = true
        self.errorMessages.append(insert.statement.reason!)
      }
      return insert.rowid
    }

    func loadSubtypeRelation(cardRef: Int64, subtypeRef: Int64) -> Int64? {
      let insert = db["cards_subtypes"].insert(
        cardId <- cardRef,
        subtypeId <- subtypeRef
      )
      if insert.statement.failed {
        self.error = true
        self.errorMessages.append(insert.statement.reason!)
      }
      return insert.rowid
    }
    
    func loadSupertype(supertype: String) -> Int64? {
      let insert = db["supertypes"].insert(
        supertypeName <- supertype
      )
      if insert.statement.failed {
        self.error = true
        self.errorMessages.append(insert.statement.reason!)
      }
      return insert.rowid
    }

    func loadSupertypeRelation(cardRef: Int64, supertypeRef: Int64) -> Int64? {
      let insert = db["cards_supertypes"].insert(
        cardId <- cardRef,
        supertypeId <- supertypeRef
      )
      if insert.statement.failed {
        self.error = true
        self.errorMessages.append(insert.statement.reason!)
      }
      return insert.rowid
    }
    
    func loadColor(color: String) -> Int64? {
      let insert = db["colors"].insert(
        colorName <- color
      )
      if insert.statement.failed {
        self.error = true
        self.errorMessages.append(insert.statement.reason!)
      }
      return insert.rowid
    }

    func loadColorRelation(cardRef: Int64, colorRef: Int64) -> Int64? {
      let insert = db["cards_colors"].insert(
        cardId <- cardRef,
        colorId <- colorRef
      )
      if insert.statement.failed {
        self.error = true
        self.errorMessages.append(insert.statement.reason!)
      }
      return insert.rowid
    }

    func loadRarity(rarity: String) -> Int64? {
      var rarityId = rarityIndex[rarity]
      if rarityId == nil {
        let insert = db["rarities"].insert(
          rarityName <- rarity
        )
        if insert.statement.failed {
          self.error = true
          self.errorMessages.append(insert.statement.reason!)
        }
        rarityId = insert.rowid
        rarityIndex[rarity] = rarityId
      }
      return rarityId
    }

    func getColorRepresentation(colors: AnyObject?) -> String {
      var representation: String = "Colorless"
      if let colorArray = colors as! Array<String>? {
        if colorArray.count == 1 {
          representation = colorArray[0]
        }
        else if colorArray.count > 1 {
          representation = "Multicolored"
        }
      }
      return representation
    }

    func normalizeName(name: String) -> String {
      var normalizedName = name
      let first = normalizedName.startIndex
      if (normalizedName[first] == "Æ") {
        normalizedName.removeAtIndex(first)
        normalizedName.splice("AE", atIndex: first)
      }
      return normalizedName
    }
    
    println("Loading tables")
    let start = NSDate()
    for setCode in json.allKeys {
      if let set: AnyObject = json.objectForKey(setCode) {
        let setId = loadSet(set)
        if error {
          return
        }
        if let cards = set["cards"] as? [AnyObject] {
          for card in cards {
            var rarityRowId = loadRarity(card["rarity"] as! String)
            if error {
              return
            }
            let insert = db["cards"].insert(
              cardName <- normalizeName(card["name"] as! String),
              cardColor <- getColorRepresentation(card["colors"]),
              cardArtist <- (card["artist"] as! String?),
              cardFlavor <- (card["flavor"] as! String?),
              cardImageName <- (card["imageName"] as! String?),
              cardLayout <- (card["layout"] as! String?),
              cardManaCost <- (card["manaCost"] as! String?),
              cardNumber <- (card["number"] as! String?),
              cardText <- (card["text"] as! String?),
              cardType <- (card["type"] as! String?),
              cardCmc <- objectToInt64(card["cmc"]),
              cardMultiverseId <- objectToInt64(card["multiverseid"]),
              cardPower <- objectToInt64(card["power"]),
              cardToughness <- objectToInt64(card["toughness"]),
              cardSetId <- setId!,
              cardRarityId <- rarityRowId
            )
            if insert.statement.failed {
              self.error = true
              self.errorMessages.append(insert.statement.reason!)
              return
            }
            let cardRowId = insert.rowid!

            if let types = card["types"] as! Array<String>? {
              for type in types {
                var typeId = typeIndex[type]
                if (typeId == nil) {
                  typeId = loadType(type)
                  if error {
                    return
                  }
                  typeIndex[type] = typeId
                }
                loadTypeRelation(cardRowId, typeId!)
                if error {
                  return
                }
              }
            }

            if let subtypes = card["subtypes"] as! Array<String>? {
              for subtype in subtypes {
                var subtypeId = subtypeIndex[subtype]
                if (subtypeId == nil) {
                  subtypeId = loadSubtype(subtype)
                  if error {
                    return
                  }
                  subtypeIndex[subtype] = subtypeId
                }
                loadSubtypeRelation(cardRowId, subtypeId!)
                if error {
                  return
                }
              }
            }

            if let supertypes = card["supertypes"] as! Array<String>? {
              for supertype in supertypes {
                var supertypeId = supertypeIndex[supertype]
                if (supertypeId == nil) {
                  supertypeId = loadSupertype(supertype)
                  if error {
                    return
                  }
                  supertypeIndex[supertype] = supertypeId
                }
                loadSupertypeRelation(cardRowId, supertypeId!)
                if error {
                  return
                }
              }
            }

            if let colors = card["colors"] as! Array<String>? {
              for color in colors {
                var colorId = colorIndex[color]
                if (colorId == nil) {
                  colorId = loadColor(color)
                  if error {
                    return
                  }
                  colorIndex[color] = colorId
                }
                loadColorRelation(cardRowId, colorId!)
                if error {
                  return
                }
              }
            }
          }
        }
      }
      //break
    }
    let stop = NSDate()
    println("Done loading tables")
    let timeInterval: Double = stop.timeIntervalSinceDate(start);
    println("Time to load tables: \(timeInterval) seconds");
  }

}
