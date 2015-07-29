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
    @IBOutlet weak var statusImageView: UIImageView!
    
    let pastelPink = UIColor(red: 1.00, green: 0.82, blue: 0.83, alpha: 1.0)
    let checkImage = UIImage(named: "ic_check")
    let updateImage = UIImage(named: "ic_update")
    
    var currentVersion: String = ""
    var latestVersion: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        currentVersionLabel.text = "현재 버전 : \(currentVersion)"
        messageLabel.layer.cornerRadius = 10
        messageLabel.layer.backgroundColor = UIColor.whiteColor().CGColor
        messageLabel.layer.borderColor = pastelPink.CGColor
        messageLabel.layer.borderWidth = 2
        statusImageView.layer.cornerRadius = 10
        statusImageView.layer.backgroundColor = pastelPink.CGColor
        
        if currentVersion == "1.0" {
            messageLabel.text = "최신 버전을 이용하고 있습니다."
            statusImageView.image = checkImage
        }
        
        /* 다음 버전부터 사용될 버전 비교 기능 만들기 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
