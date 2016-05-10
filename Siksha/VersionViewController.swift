//
//  VersionViewController.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 27..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class VersionViewController: UIViewController {
  
  @IBOutlet weak var currentVersionLabel: UILabel!
  @IBOutlet weak var messageButton: UIButton!
  @IBOutlet weak var statusImageView: UIImageView!
  
  var checkImage = UIImage(named: "ic_check")
  var updateImage = UIImage(named: "ic_update")
  
  var currentAppVersion: String = ""
  var latestAppVersion: String = ""
  var isLatest: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    currentVersionLabel.text = "현재 버전 : \(currentAppVersion)"
    messageButton.layer.cornerRadius = 10
    messageButton.layer.borderColor = UIColor.orangeColor().CGColor
    messageButton.layer.borderWidth = 1
    
    checkLatest()
    switchAlertMessage()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func messageButtonClicked(sender: AnyObject) {
    if !isLatest {
      let APP_STORE_URL = NSURL(string: "itms-apps://geo.itunes.apple.com/kr/app/sigsya-seouldaehaggyo-sigdan/id1032700617?mt=8")
      if UIApplication.sharedApplication().canOpenURL(APP_STORE_URL!) == true {
        UIApplication.sharedApplication().openURL(APP_STORE_URL!)
      }
    }
  }
  
  func checkLatest() {
    isLatest = currentAppVersion == latestAppVersion ? true : false
    print("currentAppVersion : \(currentAppVersion) / latestAppVersion : \(latestAppVersion)")
  }
  
  func switchAlertMessage() {
    if isLatest {
      messageButton.setTitle("최신 버전을 이용하고 있습니다.", forState: .Normal)
      statusImageView.image = checkImage
    }
    else {
      messageButton.setTitle("앱을 업데이트를 하려면 터치하세요.", forState: .Normal)
      statusImageView.image = updateImage
    }
    
    statusImageView.layer.contentsScale = 0.85
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
