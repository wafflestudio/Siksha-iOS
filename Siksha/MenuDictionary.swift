//
//  MenuDictionary.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 21..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

class MenuDictionary {
    static let sharedInstance = MenuDictionary()
    
    var dictionaries: [[String: Menu]] = []
    
    func initialize(JSON: NSArray?) -> Bool {
        if JSON == nil {
            return false
        }
        
        dictionaries = []
        
        var breakfastDictionary = [String: Menu]()
        var lunchDictionary = [String: Menu]()
        var dinnerDictionary = [String: Menu]()
        
        /* dictionary 생성 */
        for data in JSON! {
            let breakfastObject: Menu = Menu()
            let lunchObject: Menu = Menu()
            let dinnerObject: Menu = Menu()
            
            var breakfastMenus = [AnyObject]()
            var lunchMenus = [AnyObject]()
            var dinnerMenus = [AnyObject]()
            
            if let dictionary = data as? NSDictionary {
                for menu in dictionary["menus"] as! NSArray {
                    if menu["time"] as! String == "breakfast" {
                        breakfastMenus.append(menu)
                    }
                    else if menu["time"] as! String == "lunch" {
                        lunchMenus.append(menu)
                    }
                    else if menu["time"] as! String == "dinner" {
                        dinnerMenus.append(menu)
                    }
                }
                
                breakfastObject.restaurant = dictionary["restaurant"] as! String
                lunchObject.restaurant = dictionary["restaurant"] as! String
                dinnerObject.restaurant = dictionary["restaurant"] as! String
            }
            
            breakfastObject.isEmpty = breakfastMenus.count == 0
            lunchObject.isEmpty = lunchMenus.count == 0
            dinnerObject.isEmpty = dinnerMenus.count == 0
            
            breakfastObject.menus = breakfastMenus
            lunchObject.menus = lunchMenus
            dinnerObject.menus = dinnerMenus
            
            breakfastDictionary[breakfastObject.restaurant] = breakfastObject
            lunchDictionary[lunchObject.restaurant] = lunchObject
            dinnerDictionary[dinnerObject.restaurant] = dinnerObject
        }
        
        dictionaries.append(breakfastDictionary)
        dictionaries.append(lunchDictionary)
        dictionaries.append(dinnerDictionary)
        
        SharedData.save(dictionaries, key: SharedData.SHARED_KEY_DICTIONARIES)
        
        return true
    }
    
}
