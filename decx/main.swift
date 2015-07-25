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

CLI.setup(
  name: "decx",
  version: "0.1.0",
  description: "MTG Card Operations"
)
CLI.registerCommand(GenerateListsCommand())
CLI.go()


