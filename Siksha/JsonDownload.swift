//
//  JsonDownload.swift
//  Siksha
//
//  Created by 강규 on 2015. 6. 30..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

class JsonDownload {
    let SERVER_URL: String = "http://siksha.kr:3280/menus/view";
    let REDIRECT_SERVER_URL: String = "http://kanggyu94.fun25.co.kr:13204/menus/view";
    
    let QUERY_TODAY: String = "?date=today";
    let QUERY_TOMORROW: String = "?date=tomorrow";
    
    let KEY_OPTION: String = "download_option";
    let KEY_DATE: String = "download_date";
    
    let OPTION_CRAWLING_INSTANTLY: Int = 0;
    let OPTION_CACHED_TODAY: Int = 1;
    let OPTION_CACHED_TOMORROW: Int = 2;
    
    func isJsonUpdated(downloadDate: String) -> Bool {
        let recordedDate = Preference.load(Preference.PREF_KEY_JSON) as! String
        
        return recordedDate == downloadDate
    }
    
    func isVetDataUpdated(downloadDate: String) -> Bool {
        let recordedDate = Preference.load(Preference.PREF_KEY_VET_DATA) as! String
    
        return recordedDate == downloadDate
    }
    
    func getDownloadOption() -> Int {
        let date = NSDate()
        let hour = date.getHour()
        let minute = date.getMinute()
    
        if hour == 0 && minute < 5 {
            return OPTION_CRAWLING_INSTANTLY // request server for crawling web page instantly
        }
        else if hour < 21 {
            return OPTION_CACHED_TODAY // request server for fetching cached json about today contents
        }
        else {
            return OPTION_CACHED_TOMORROW // request server for fetching cached json about tomorrow contents
        }
    }
    
    func getDownloadDate(option: Int) -> String {
        let date = NSDate()
        
        if option == OPTION_CACHED_TOMORROW {
            return date.getTomorrowDate()
        }
        else {
            return date.getTodayDate()
        }
    }
    
    func getFullURL(option: Int, isAlive: Bool) -> NSURL {
        let BASE_URL: String = isAlive ? SERVER_URL : REDIRECT_SERVER_URL
        var url: NSURL
    
        switch option {
        case OPTION_CACHED_TODAY:
            url = NSURL(fileURLWithPath: "\(BASE_URL)\(QUERY_TODAY)")!
        case OPTION_CACHED_TOMORROW:
            url = NSURL(fileURLWithPath: "\(BASE_URL)\(QUERY_TOMORROW)")!
        default:
            url = NSURL(fileURLWithPath: "\(BASE_URL)")!
        }
    
        return url
    }
    
    func fetchJsonFromServer(option: Int) -> NSData? {
        var url = getFullURL(option, isAlive: true)
        var request = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error: NSError?
        
        println("Send Request To Server!")
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &error)
        
        if error != nil {
            // error handling
            url = self.getFullURL(option, isAlive: false)
            request = NSURLRequest(URL: url)
            
            println("Send Request To Server Again!")
            data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &error)
        }
        
        return data
    }
    
    func writeJsonOnInternalStorage(data: NSData?) -> Bool {
        // Error checking about fetchJsonFromServer()
        if data == nil {
            return false
        }
        
        let fileManager = NSFileManager.defaultManager()
        var documentDir: String?
        var filePath: String?
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        documentDir = dirPaths[0] as? String
        filePath = documentDir?.stringByAppendingPathComponent("restaurants.json")
        
        let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: filePath!)
        file?.writeData(data!)
        file?.closeFile()
    
        // Success to write json on internal storage
        return true;
    }
}
