//
//  AppDelegate.swift
//  Siksha
//
//  Created by 강규 on 2015. 6. 29..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  let NORMAL_NOTIFICATION_KEY = "normal_notification"
  let DATA_UPDATE_NOTIFICATION_KEY: String = "data_update_notification"
  let BUNDLE_IDENTIFIER = NSBundle.mainBundle().bundleIdentifier
  
  var JSONData: [String: AnyObject]?
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    // 초기 JSON 메뉴 다운로드에 관한 Download Receiver를 설정한다.
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.onDownloadFinished), name: NORMAL_NOTIFICATION_KEY, object: nil)
    
    checkLocalJSONStatus(JSONDownloader.TYPE_NORMAL)
    checkLatestAppVersion()
    
    // 운영 시간, 위치 등의 정보가 담긴 data.xml을 파싱하여 객체에 저장한다.
    XMLParser.sharedInstance.parseXMLFile("data")
    
    // 초기 식당 목록 순서를 결정한다.
    setInitialSequence()
    
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMSe message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSNotificationCenter.defaultCenter().removeObserver(self, name: DATA_UPDATE_NOTIFICATION_KEY, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: NORMAL_NOTIFICATION_KEY, object: nil)
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.onDownloadFinished), name: NORMAL_NOTIFICATION_KEY, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.onDataUpdated), name: DATA_UPDATE_NOTIFICATION_KEY, object: nil)
    checkLocalJSONStatus(JSONDownloader.TYPE_DATA_UPDATE)
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSNotificationCenter.defaultCenter().removeObserver(self, name: NORMAL_NOTIFICATION_KEY, object: nil)
  }
  
  private func checkLocalJSONStatus(downloadType: Int) -> Void {
    let date = NSDate()
    var timestamp: String
    
    if date.getHour() >= 21 {
      timestamp = date.getTomorrowTimestamp()
    }
    else {
      timestamp = date.getTodayTimestamp()
    }
    
    if JSONDownloader.isJSONUpdated(timestamp) {
      print("JSON is already updated.")
      
      if !JSONDownloader.isVetDataUpdated(timestamp) && Calendar.isVetDataUpdateTime() {
        JSONDownloader().startDownloadService(downloadType)
      }
      else {
        onDownloadFinished()
      }
    }
    else {
      print("JSON is not updated!")
      
      JSONDownloader().startDownloadService(downloadType)
    }
  }
  
  func onDownloadFinished() -> Void {
    print("onDownloadFinished()")
    
    JSONData = JSONParser.getLocalJSON()
    MenuDictionary.sharedInstance.initialize(JSONData!["data"] as! [AnyObject])
    
    // 즐겨찾기 목록 유무에 따라서 시작 탭을 나눈다.
    setInitialTab(true)
  }
  
  func onDataUpdated() -> Void {
    print("onDataUpdated()")
    
    JSONData = JSONParser.getLocalJSON()
    MenuDictionary.sharedInstance.initialize(JSONData!["data"] as! [AnyObject])
    
    // 즐겨찾기 목록 유무에 따라서 시작 탭을 나눈다.
    setInitialTab(false)
  }
  
  private func checkLatestAppVersion() -> Void {
    var version: String = ""
    
    let BASE_APP_PAGE_URL = "http://itunes.apple.com/kr/lookup?bundleId="
    let request = NSURLRequest(URL: NSURL(string: BASE_APP_PAGE_URL + BUNDLE_IDENTIFIER!)!)
    let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil

    let data: NSData?
    do {
      data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
      let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
      let results: NSArray = JSON.objectForKey("results") as! NSArray
      
      if results.count != 0 {
        version = (results.objectAtIndex(0).objectForKey("version") as? String)!
      }
      else {
        version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
      }
    } catch _ {
      version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    Preference.save(version, key: Preference.PREF_KEY_LATEST_APP_VERSION)
  }
  
  private func setInitialSequence() {
    if (Preference.load(Preference.PREF_KEY_SEQUENCE) as! String) == "" {
      let restaurants = XMLParser.sharedInstance.informations["restaurants"]
      var sequenceString: String = ""
      
      for restaurant in restaurants! {
        if sequenceString == "" {
          sequenceString = restaurant
        }
        else {
          sequenceString = "\(sequenceString)/\(restaurant)"
        }
      }
      
      Preference.save(sequenceString, key: Preference.PREF_KEY_SEQUENCE)
    }
  }
  
  private func setInitialTab(isNormalDownload: Bool) -> Void {
    if #available(iOS 8.0, *) {
      let rootViewController = self.window!.rootViewController as! TabBarController
      if Preference.load(Preference.PREF_KEY_BOOKMARK) as! String == "" {
        rootViewController.selectedIndex = 1 // 식단 탭
        
        if !isNormalDownload {
          (rootViewController.selectedViewController!.childViewControllers[0] as! MenuViewController).refresh()
        }
      }
      else {
        rootViewController.selectedIndex = 0 // 즐겨찾기 탭
        
        if !isNormalDownload {
          (rootViewController.selectedViewController!.childViewControllers[0] as! BookmarkViewController).refresh()
        }
      }
    } else {
      // Fallback on earlier versions
    }
  }
  
}