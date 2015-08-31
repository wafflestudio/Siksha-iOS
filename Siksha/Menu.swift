//
//  Menu.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 21..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

@objc(Menu)
class Menu: NSObject, NSCoding {
    
    var restaurant: String = ""
    
    var isEmpty: Bool = false
    
    var menus: NSArray = []
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        
        self.restaurant = aDecoder.decodeObjectForKey("restaurant") as! String
        self.isEmpty = aDecoder.decodeObjectForKey("is_empty") as! Bool
        self.menus = aDecoder.decodeObjectForKey("menus") as! NSArray
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.restaurant, forKey: "restaurant")
        aCoder.encodeObject(self.isEmpty, forKey: "is_empty")
        aCoder.encodeObject(self.menus, forKey: "menus")
    }
    
}