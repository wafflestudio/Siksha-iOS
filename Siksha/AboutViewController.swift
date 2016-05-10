//
//  AboutViewController.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 27..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
  
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var operatingHourLabel: UILabel!
  @IBOutlet weak var operatingHourTextView: UITextView!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var locationTextView: UITextView!
  
  var restaurantName: String = ""
  var operatingHour: String = ""
  var location: String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    nameLabel.text = restaurantName
    operatingHourTextView.text = operatingHour
    locationTextView.text = location
  }
  
  override func viewDidLayoutSubviews() {
    let contentSize = self.operatingHourTextView.sizeThatFits(self.operatingHourTextView.bounds.size)
    var frame = self.operatingHourTextView.frame
    frame.size.height = contentSize.height
    self.operatingHourTextView.frame = frame
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
