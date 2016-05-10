//
//  SharedData.swift
//  Siksha
//
//  Created by 강규 on 2015. 8. 8..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

class SharedData {
  
  static let SHARED_KEY_BOOKMARK: String = "bookmark_list"
  static let SHARED_KEY_SEQUENCE: String = "restaurant_current_sequence"
  static let SHARED_KEY_DICTIONARIES: String = "menu_dictionaries"
  
  static let defaults = NSUserDefaults(suiteName: "group.com.wafflestudio.siksha")
  
  var dictionaries: [[String: Menu]] = []
  
  static func save(data: Int, key: String) -> Void {
    defaults!.setInteger(data, forKey: key)
    defaults!.synchronize()
  }
  
  static func save(data: AnyObject?, key: String) -> Void {
    if data as? String != nil {
      defaults!.setObject(data, forKey: key)
    }
    else {
      defaults!.setObject(NSKeyedArchiver.archivedDataWithRootObject(data!), forKey: SharedData.SHARED_KEY_DICTIONARIES)
    }
    
    defaults!.synchronize()
  }
  
  static func load(key: String) -> AnyObject {
    if defaults!.objectForKey(key) == nil {
      return ""
    }
    else {
      let object: AnyObject? = defaults!.objectForKey(key)
      
      if object as? Int != nil {
        return defaults!.integerForKey(key)
      }
      else if object as? String != nil {
        return defaults!.stringForKey(key)!
      }
      else if object as? NSData != nil {
        return NSKeyedUnarchiver.unarchiveObjectWithData(defaults!.dataForKey(key)!)!
      }
      else {
        return defaults!.objectForKey(key)!
      }
    }
  }
  
}