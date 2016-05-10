//
//  Calendar.swift
//  Siksha
//
//  Created by 강규 on 2015. 6. 30..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

extension NSDate {
  
  func getMonth() -> Int {
    let components = NSCalendar.currentCalendar().components(.Month, fromDate: self)
    
    return components.month
  }
  
  func getDay() -> Int {
    let components = NSCalendar.currentCalendar().components(.Day, fromDate: self)
    
    return components.day
  }
  
  func getWeekday() -> Int {
    let components = NSCalendar.currentCalendar().components(.Weekday, fromDate: self)
    
    return components.weekday
  }
  
  func getDayOfWeek() -> String {
    let weekday = getWeekday()
    var dayOfWeek: String
    
    switch weekday {
    case 1:
      dayOfWeek = "일"
    case 2:
      dayOfWeek = "월"
    case 3:
      dayOfWeek = "화"
    case 4:
      dayOfWeek = "수"
    case 5:
      dayOfWeek = "목"
    case 6:
      dayOfWeek = "금"
    case 7:
      dayOfWeek = "토"
    default:
      dayOfWeek = ""
    }
    
    return dayOfWeek
  }
  
  func getTimeSlot() -> String {
    var timeSlot: String
    let hour: Int = getHour()
    
    if (hour <= 9 || hour >= 21) {
      timeSlot = "아침"
    }
    else if (hour >= 10 && hour <= 14) {
      timeSlot = "점심"
    }
    else {
      timeSlot = "저녁"
    }
    
    return timeSlot
  }
  
  func getHour() -> Int {
    let components = NSCalendar.currentCalendar().components(.Hour, fromDate: self)
    
    return components.hour
  }
  
  func getMinute() -> Int {
    let components = NSCalendar.currentCalendar().components(.Minute, fromDate: self)
    
    return components.minute
  }
  
  func getTodayTimestamp() -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    return formatter.stringFromDate(self)
  }
  
  func getTomorrowTimestamp() -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    return formatter.stringFromDate(self.dateByAddingTimeInterval(24 * 60 * 60))
  }
  
}

class Calendar {
  
  static func getDateLabelTimestamp(index: Int) -> String {
    var date = NSDate()
    
    if date.getHour() >= 21 {
      date = date.dateByAddingTimeInterval(24 * 60 * 60)
    }
    
    let month: Int = date.getMonth()
    let day: Int = date.getDay()
    let dayOfWeek: String = date.getDayOfWeek()
    
    if index == 0 {
      return "\(month)/\(day) (\(dayOfWeek)) 아침"
    }
    else if index == 1 {
      return "\(month)/\(day) (\(dayOfWeek)) 점심"
    }
    else {
      return "\(month)/\(day) (\(dayOfWeek)) 저녁"
    }
  }
  
  static func getRefreshTimestamp() -> String {
    let date = NSDate()
    let month: Int = date.getMonth()
    let day: Int = date.getDay()
    let hour: Int = date.getHour()
    let minute: Int = date.getMinute()
    
    return "\(month)월 \(day)일 \(hour):\(minute)"
  }
  
  static func getInitialPageIndex() -> Int {
    let date = NSDate()
    let timeSlot: String = date.getTimeSlot()
    
    if timeSlot == "아침" {
      return 0
    }
    else if timeSlot == "점심" {
      return 1
    }
    else {
      return 2
    }
  }
  
  static func isVetDataUpdateTime() -> Bool {
    let date = NSDate()
    let weekday = date.getWeekday()
    let hour = date.getHour()
    
    return weekday == 2 && (hour >= 10 && hour < 21)
  }
  
}