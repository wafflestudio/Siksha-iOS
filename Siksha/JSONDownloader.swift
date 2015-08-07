//
//  JSONDownloader.swift
//  Siksha
//
//  Created by 강규 on 2015. 6. 30..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

class JSONDownloader {
    
    let SERVER_URL: String = "http://siksha.kr:3280"
    let REDIRECT_SERVER_URL: String = "http://kanggyu94.fun25.co.kr:13204"
    
    let ROUTE_MENU_VIEW = "/menus/view"
    
    let QUERY_TODAY: String = "?date=today"
    let QUERY_TOMORROW: String = "?date=tomorrow"
    
    let OPTION_CRAWLING_INSTANTLY: Int = 0
    let OPTION_CACHED_TODAY: Int = 1
    let OPTION_CACHED_TOMORROW: Int = 2
    
    let DOWNLOAD_NOTIFICATION_KEY = "download_notification"
    let REFRESH_NOTIFICATION_KEY = "refresh_notification"
    
    static func isJSONUpdated(downloadDate: String) -> Bool {
        let recordedDate = Preference.load(Preference.PREF_KEY_JSON) as! String
        
        return recordedDate == downloadDate
    }
    
    static func isVetDataUpdated(downloadDate: String) -> Bool {
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
            return date.getTomorrowTimestamp()
        }
        else {
            return date.getTodayTimestamp()
        }
    }
    
    func getFullURL(option: Int, isAlive: Bool) -> NSURL {
        let BASE_URL: String = (isAlive ? SERVER_URL : REDIRECT_SERVER_URL) + ROUTE_MENU_VIEW
        var url: NSURL
    
        switch option {
        case OPTION_CACHED_TODAY:
            url = NSURL(string: BASE_URL + QUERY_TODAY)!
        case OPTION_CACHED_TOMORROW:
            url = NSURL(string: BASE_URL + QUERY_TOMORROW)!
        default:
            url = NSURL(string: BASE_URL)!
        }

        return url
    }
    
    private func fetchJSON(option: Int) -> NSString? {
        var request = NSURLRequest(URL: getFullURL(option, isAlive: true))
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error: NSError?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &error)
        
        if error != nil {
            // error handling
            request = NSURLRequest(URL: getFullURL(option, isAlive: false))
            
            println("Send request to another server.")
            error = nil
            data = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &error)
            
            if error != nil {
                return nil
            }
        }
        
        return NSString(data: data!, encoding: NSUTF8StringEncoding)!
    }
    
    private func writeJSONToInternalStorage(data: NSString?) -> Bool {
        // Error checking about fetchJSON()
        if data == nil {
            return false
        }
        
        let fileManager = NSFileManager()
        let filePath = NSTemporaryDirectory() + "restaurants.json"
    
        /* let file: NSFileHandle? = NSFileHandle(forWritingAtPath: filePath)
        file?.writeData(data!)
        file?.closeFile() */
        
        data!.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
    
        // Success to write json on internal storage
        return true
    }
    
    private func saveDownloadDateToPreference(downloadDate: String) -> Void {
        // 설정 탭에서 refresh 기록을 표시하기 위해서 저장
        Preference.save(Calendar.getRefreshTimestamp(), key: Preference.PREF_KEY_REFRESH_TIMESTAMP)
        
        Preference.save(downloadDate, key: Preference.PREF_KEY_JSON)
        
        if Calendar.isVetDataUpdateTime() {
            Preference.save(downloadDate, key: Preference.PREF_KEY_VET_DATA)
        }
    }
    
    private func notifyDownloadQuitted() -> Void {
        NSNotificationCenter.defaultCenter().postNotificationName(DOWNLOAD_NOTIFICATION_KEY, object: self)
        NSNotificationCenter.defaultCenter().postNotificationName(REFRESH_NOTIFICATION_KEY, object: self)
    }
    
    func startDownloadService() -> Void {
        let downloadOption: Int = getDownloadOption()
        let downloadDate: String = getDownloadDate(downloadOption)
        let isSuccess: Bool = writeJSONToInternalStorage(fetchJSON(downloadOption))
        
        println("onStartDownloadService() / isSuccess : \(isSuccess) downloadDate : \(downloadDate) downloadOption : \(downloadOption)")
        
        if isSuccess {
            saveDownloadDateToPreference(downloadDate)
        }
        
        notifyDownloadQuitted()
    }
    
}
