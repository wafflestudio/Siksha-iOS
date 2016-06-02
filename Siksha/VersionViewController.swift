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
    @IBOutlet weak var messageLabel: UILabel!
    
    var currentAppVersion: String = ""
    var latestAppVersion: String = ""
    var isLatest: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        currentVersionLabel.text = "현재 버전 : \(currentAppVersion)"
        messageLabel.layer.cornerRadius = 10
        messageLabel.layer.borderColor = UIColor.orangeColor().CGColor
        messageLabel.layer.borderWidth = 1
        
        checkLatest()
        switchAlertMessage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkLatest() {
        isLatest = currentAppVersion == latestAppVersion ? true : false
        print("currentAppVersion : \(currentAppVersion) / latestAppVersion : \(latestAppVersion)")
    }
    
    func switchAlertMessage() {
        if isLatest {
            messageLabel.text = "최신 버전을 이용하고 있습니다."
        }
        else {
            messageLabel.text = "앱 스토어에서 앱을 업데이트해주세요."
        }
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
