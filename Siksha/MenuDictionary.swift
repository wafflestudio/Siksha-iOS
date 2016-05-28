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
    
    func initialize(JSON: [AnyObject]) -> Bool {
        dictionaries = []
        
        var breakfastDictionary = [String: Menu]()
        var lunchDictionary = [String: Menu]()
        var dinnerDictionary = [String: Menu]()
        
        /* dictionary 생성 */
        for data in JSON {
            let breakfastObject: Menu = Menu()
            let lunchObject: Menu = Menu()
            let dinnerObject: Menu = Menu()
            
            var breakfastFoods = [AnyObject]()
            var lunchFoods = [AnyObject]()
            var dinnerFoods = [AnyObject]()
            
            if let dictionary = data as? [String: AnyObject] {
                for food in dictionary["foods"] as! [AnyObject] {
                    if food["time"] as! String == "breakfast" {
                        breakfastFoods.append(food)
                    }
                    else if food["time"] as! String == "lunch" {
                        lunchFoods.append(food)
                    }
                    else if food["time"] as! String == "dinner" {
                        dinnerFoods.append(food)
                    }
                }
                
                breakfastObject.restaurant = dictionary["restaurant"] as! String
                lunchObject.restaurant = dictionary["restaurant"] as! String
                dinnerObject.restaurant = dictionary["restaurant"] as! String
            }
            
            breakfastObject.isEmpty = breakfastFoods.count == 0
            lunchObject.isEmpty = lunchFoods.count == 0
            dinnerObject.isEmpty = dinnerFoods.count == 0
            
            breakfastObject.foods = breakfastFoods
            lunchObject.foods = lunchFoods
            dinnerObject.foods = dinnerFoods
            
            breakfastDictionary[breakfastObject.restaurant] = breakfastObject
            lunchDictionary[lunchObject.restaurant] = lunchObject
            dinnerDictionary[dinnerObject.restaurant] = dinnerObject
        }
        
        dictionaries.append(breakfastDictionary)
        dictionaries.append(lunchDictionary)
        dictionaries.append(dinnerDictionary)
        
        AppData.save(dictionaries, key: AppData.KEY_DICTIONARIES)
        
        return true
    }
    
}
