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

func readFile(path: String) -> NSString {
  var error: NSError?
  let fullPath = path.stringByExpandingTildeInPath
  let fileContent = NSString(contentsOfFile: fullPath, encoding: NSUTF8StringEncoding, error: nil)
  if (fileContent == nil) {
    println("Unable to read file: " + fullPath)
    exit(0)
  }
  return fileContent!;
}

func parseJson(data: NSString) -> NSDictionary {
  var jsonError: NSError?
  let json = NSJSONSerialization.JSONObjectWithData(fileContent.dataUsingEncoding(NSUTF8StringEncoding)!, options: nil, error: &jsonError) as! NSDictionary
  if (jsonError != nil) {
    println("Error parsing JSON")
    exit(0)
  }
  return json;
}

let fileContent = readFile(Opts.allCardsFile)
let json = parseJson(fileContent)

for key in json.allKeys {
  //println(json.objectForKey(key)!)
  let entry = Entry(card: json.objectForKey(key)!)
  var out = entry.getName() + ", " + entry.getColor() + ", " + entry.getType()
  if (entry.getSupertype() != nil) {
    out = out + ", " + entry.getSupertype()!
  }
  println(out)
}

