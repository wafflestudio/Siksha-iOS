//
//  AppData.swift
//  Siksha
//
//  Created by 강규 on 2015. 8. 8..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

class AppData {
    
    static let sharedInstance = AppData()
    
    static let KEY_BOOKMARK: String = "bookmark_list"
    static let KEY_SEQUENCE: String = "restaurant_current_sequence"
    static let KEY_DICTIONARIES: String = "menu_dictionaries"
    
    static let defaults = NSUserDefaults(suiteName: "group.com.wafflestudio.siksha")
    
    var restaurants = [
        "학생회관 식당", "농생대 3식당", "919동 기숙사 식당", "자하연 식당",
        "302동 식당", "솔밭 간이 식당", "동원관 식당", "감골 식당",
        "사범대 4식당", "두레미담", "301동 식당", "예술계복합연구동 식당",
        "공대 간이 식당", "상아회관 식당", "220동 식당", "대학원 기숙사 식당",
        "85동 수의대 식당"];
    var information: [AnyObject]?
    var version: String?
    
    static func save(data: Int, key: String) -> Void {
        defaults!.setInteger(data, forKey: key)
        defaults!.synchronize()
    }
    
    static func save(data: AnyObject?, key: String) -> Void {
        if data as? String != nil {
            defaults!.setObject(data, forKey: key)
        }
        else {
            defaults!.setObject(NSKeyedArchiver.archivedDataWithRootObject(data!), forKey: KEY_DICTIONARIES)
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