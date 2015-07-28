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
    
    var breakfastMenuDictionary: [String: Menu]
    var lunchMenuDictionary: [String: Menu]
    var dinnerMenuDictionary: [String: Menu]
    
    private init() {
        breakfastMenuDictionary = [String: Menu]()
        lunchMenuDictionary = [String: Menu]()
        dinnerMenuDictionary = [String: Menu]()
    }
    
    func initialize(JSON: NSArray?) -> Bool {
        if JSON == nil {
            return false
        }
        
        for data in JSON! {
            var breakfastMenuObject: Menu = Menu()
            var lunchMenuObject: Menu = Menu()
            var dinnerMenuObject: Menu = Menu()
            
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
                
                breakfastMenuObject.restaurant = dictionary["restaurant"] as! String
                lunchMenuObject.restaurant = dictionary["restaurant"] as! String
                dinnerMenuObject.restaurant = dictionary["restaurant"] as! String
            }
            
            breakfastMenuObject.isEmpty = breakfastMenus.count == 0
            lunchMenuObject.isEmpty = lunchMenus.count == 0
            dinnerMenuObject.isEmpty = dinnerMenus.count == 0
            
            breakfastMenuObject.menus = breakfastMenus
            lunchMenuObject.menus = lunchMenus
            dinnerMenuObject.menus = dinnerMenus
            
            breakfastMenuDictionary[breakfastMenuObject.restaurant] = breakfastMenuObject
            lunchMenuDictionary[lunchMenuObject.restaurant] = lunchMenuObject
            dinnerMenuDictionary[dinnerMenuObject.restaurant] = dinnerMenuObject
        }
        
        return true
    }
    
}
