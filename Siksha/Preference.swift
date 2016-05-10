//
//  Preference.swift
//  Siksha
//
//  Created by 강규 on 2015. 6. 30..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

class Preference {
  
  static let PREF_KEY_JSON: String = "json_date"
  static let PREF_KEY_VET_DATA: String = "vet_data_date"
  static let PREF_KEY_REFRESH_TIMESTAMP = "refresh_timestamp"
  static let PREF_KEY_SEQUENCE: String = "restaurant_current_sequence"
  static let PREF_KEY_BOOKMARK: String = "bookmark_list"
  static let PREF_KEY_CURRENT_APP_VERSION: String = "current_app_version"
  static let PREF_KEY_LATEST_APP_VERSION: String = "latest_app_version"
  
  static let PREF_KEY_EMPTY_MENU_VISIBILITY = "empty_menu_visibility"
  
  static let preferences = NSUserDefaults.standardUserDefaults()
  
  static func save(data: Int, key: String) -> Void {
    preferences.setInteger(data, forKey: key)
    preferences.synchronize()
  }
  
  static func save(data: AnyObject?, key: String) -> Void {
    preferences.setObject(data, forKey: key)
    preferences.synchronize()
  }
  
  static func load(key: String) -> AnyObject {
    if preferences.objectForKey(key) == nil {
      return ""
    }
    else {
      let object: AnyObject? = preferences.objectForKey(key)
      
      if object as? Int != nil {
        return preferences.integerForKey(key)
      }
      else if object as? String != nil {
        return preferences.stringForKey(key)!
      }
      else {
        return preferences.objectForKey(key)!
      }
    }
  }
  
}
