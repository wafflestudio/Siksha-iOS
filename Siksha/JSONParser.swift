//
//  JSONParser.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 21..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

class JSONParser {
    
    static func getLocalJSON() -> NSArray? {
        let fileManager = NSFileManager()
        let filePath = NSTemporaryDirectory() + "restaurants.json"
        
        if !fileManager.fileExistsAtPath(filePath) {
            println("JSON file doesn't exist.")
        }
        
        let fileHandle = NSFileHandle(forReadingAtPath: filePath)
        let data = fileHandle!.readDataToEndOfFile()
        fileHandle!.closeFile()
 
        var err: NSError?
        if let JSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSArray {
            if (err != nil) {
                // If there is an error parsing JSON, print it to the console.
                println("JSON Serialization Error \(err!.localizedDescription)")
            }
            
            return JSON
        }
        
        return nil
    }
    
}