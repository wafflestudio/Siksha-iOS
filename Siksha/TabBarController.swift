//
//  TabBarController.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 29..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    var alertController: UIAlertController = UIAlertController(title: "즐겨찾는 식당이 없습니다!", message: "별 모양 아이콘을 눌러 즐겨찾는 식당을 추가해보세요.", preferredStyle: .Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.delegate = self
        
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        alertController.view.tintColor = UIColor(red: 0.99, green: 0.65, blue: 0.66, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            if Preference.load(Preference.PREF_KEY_BOOKMARK) as! String == "" {
                tabBarController.selectedIndex = 1 // 식단 탭
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
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
