#!/usr/bin/env xcrun swift -F /Library/Frameworks
//
//  main.swift
//  decx
//
//  Created by Steve Baker on 7/19/15.
//  Copyright (c) 2015 Steve Baker. All rights reserved.
//

import Foundation
//import Darwin

struct Opts {
  static let allCardsFile = "~/Development/decx/AllCards-x.json"
}

var error: NSError?
let fileContent = NSString(contentsOfFile: Opts.allCardsFile.stringByExpandingTildeInPath, encoding: NSUTF8StringEncoding, error: nil)
if (fileContent == nil) {
  println("Unable to read file: " + Opts.allCardsFile)
  exit(0)
}
//println(fileContent)

var jsonError: NSError?
let json = NSJSONSerialization.JSONObjectWithData(fileContent!.dataUsingEncoding(NSUTF8StringEncoding)!, options: nil, error: &jsonError) as! NSDictionary
if (jsonError != nil) {
  println("Error parsing JSON")
  exit(0)
}

//println(json["Air Elemental"])

for key in json.allKeys {
  //println(json.objectForKey(key)!)
  let entry = Entry(card: json.objectForKey(key)!)
  println(entry.getName() + ", " + entry.getColor() + ", " + entry.getType() + ", " + entry.getSupertype())
}
