//
//  JSONParser.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 21..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

class JSONParser {
  
  static func getLocalJSON() -> [String: AnyObject]? {
    let fileManager = NSFileManager()
    let filePath = NSTemporaryDirectory() + "restaurants.json"
    
    if !fileManager.fileExistsAtPath(filePath) {
      print("JSON file doesn't exist.")
    }
    
    let fileHandle = NSFileHandle(forReadingAtPath: filePath)
    let data = fileHandle!.readDataToEndOfFile()
    fileHandle!.closeFile()
    
    do {
      if let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject] {
        return JSON
      }
    } catch (let e as NSError) {
      // If there is an error parsing JSON, print it to the console.
      print("JSON Serialization Error \(e.localizedDescription)")
    }
    
    return nil
  }
  
}