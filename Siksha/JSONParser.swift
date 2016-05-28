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
        let filePath = NSTemporaryDirectory() + "menus.json"
        
        let fileHandle = NSFileHandle(forReadingAtPath: filePath)
        let data = fileHandle!.readDataToEndOfFile()
        fileHandle!.closeFile()
        
        do {
            let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            return JSON as? [String: AnyObject]
        } catch (let e as NSError) {
            // If there is an error parsing JSON, print it to the console.
            print("JSON Serialization Error \(e.localizedDescription)")
        }
        
        return nil
    }
    
}