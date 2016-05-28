//
//  JSONDownloader.swift
//  Siksha
//
//  Created by 강규 on 2015. 6. 30..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

import Alamofire

class JSONDownloader {
    
    let SERVER_URL: String = "http://siksha.kr:8230"
    
    let ROUTE_MENU_VIEW = "/menu/view"
    
    let QUERY_TODAY: String = "?date=today"
    let QUERY_TOMORROW: String = "?date=tomorrow"
    
    let OPTION_CRAWLING_INSTANTLY: Int = 0
    let OPTION_CACHED_TODAY: Int = 1
    let OPTION_CACHED_TOMORROW: Int = 2
    
    let NORMAL_NOTIFICATION_KEY: String = "normal_notification"
    let DATA_UPDATE_NOTIFICATION_KEY: String = "data_update_notification"
    let REFRESH_NOTIFICATION_KEY: String = "refresh_notification"
    
    static let TYPE_NORMAL = 0
    static let TYPE_DATA_UPDATE = 1
    static let TYPE_REFRESH = 2
    
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
    
    func getDownloadDate(downloadOption: Int) -> String {
        let date = NSDate()
        
        if downloadOption == OPTION_CACHED_TOMORROW {
            return date.getTomorrowTimestamp()
        }
        else {
            return date.getTodayTimestamp()
        }
    }
    
    func getFullURL(downloadOption: Int) -> NSURL! {
        let BASE_URL: String = SERVER_URL + ROUTE_MENU_VIEW
        var url: NSURL?
        
        switch downloadOption {
        case OPTION_CACHED_TODAY:
            url = NSURL(string: BASE_URL + QUERY_TODAY)
        case OPTION_CACHED_TOMORROW:
            url = NSURL(string: BASE_URL + QUERY_TOMORROW)
        default:
            url = NSURL(string: BASE_URL)
        }

        return url
    }
    
    private func fetchJSON(option: Int) -> NSString? {
        let request = NSURLRequest(URL: getFullURL(option))
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
            return NSString(data: data, encoding: NSUTF8StringEncoding)!
        }
        catch (let e) {
            print(e)
        }
        return nil
    }
    
    private func writeJSONToInternalStorage(data: NSString?) -> Bool {
        // Error checking about fetchJSON()
        if data == nil {
            return false
        }
        
        let filePath = NSTemporaryDirectory() + "menus.json"
        do {
            try data!.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
        }
        catch (let e) {
            print(e)
            return false
        }
        
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
    
    private func notifyDownloadQuitted(downloadType: Int) -> Void {
        if downloadType == JSONDownloader.TYPE_NORMAL {
            NSNotificationCenter.defaultCenter().postNotificationName(NORMAL_NOTIFICATION_KEY, object: self)
            NSNotificationCenter.defaultCenter().postNotificationName(REFRESH_NOTIFICATION_KEY, object: self)
        }
        else if downloadType == JSONDownloader.TYPE_DATA_UPDATE {
            NSNotificationCenter.defaultCenter().postNotificationName(DATA_UPDATE_NOTIFICATION_KEY, object: self)
            NSNotificationCenter.defaultCenter().postNotificationName(REFRESH_NOTIFICATION_KEY, object: self)
        }
        else {
            NSNotificationCenter.defaultCenter().postNotificationName(REFRESH_NOTIFICATION_KEY, object: self)
        }
    }
    
    func startDownloadService(downloadType: Int) -> Void {
        let downloadOption: Int = getDownloadOption()
        let downloadDate: String = getDownloadDate(downloadOption)
        let isSuccess: Bool = writeJSONToInternalStorage(fetchJSON(downloadOption))
        
        print("startDownloadService() / isSuccess : \(isSuccess) / downloadDate : \(downloadDate) / downloadOption : \(downloadOption)")
        
        if isSuccess {
            saveDownloadDateToPreference(downloadDate)
        }
        
        notifyDownloadQuitted(downloadType)
    }
    
}
