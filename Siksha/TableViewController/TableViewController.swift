//
//  TableViewController.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 18..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let restaurants: [String] = ["학생회관 식당", "농생대 3식당", "919동 기숙사 식당", "자하연 식당", "302동 식당",
        "솔밭 간이 식당", "동원관 식당", "감골 식당", "사범대 4식당", "두레미담",
        "301동 식당", "예술계복합연구동 식당", "공대 간이 식당", "상아회관 식당", "220동 식당",
        "대학원 기숙사 식당", "85동 수의대 식당", "소담마루", "샤반"]
    
    var pageIndex = 0
    
    var dictionary: [String: Menu] = [:]
    var dataArray = [Menu]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
        for restaurant in restaurants {
            dataArray.append(dictionary[restaurant]!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func aboutButtonClicked(sender: AnyObject) {
        let aboutButton = sender as! UIButton
        self.performSegueWithIdentifier("ShowInformations", sender: aboutButton)
    }
    
    @IBAction func bookmarkButtonClicked(sender: AnyObject) {
        let bookmarkButton = sender as! UIButton
        let rowIndex = sender.tag
        var recordedBookmarks = Preference.load(Preference.PREF_KEY_BOOKMARK) as! String
        
        /* 북마크 되어있으면 텅빈 별로 바꾸고, 되어있지 않으면 꽉찬 별로 바꾼다. */
        if isBookmarked(restaurants[rowIndex]) {
            let star = UIImage(named: "ic_star")
            bookmarkButton.setImage(star, forState: .Normal)
        }
        else {
            let starFilled = UIImage(named: "ic_star_filled")
            bookmarkButton.setImage(starFilled, forState: .Normal)
        }
        
        /* 북마크 정보를 Preference에 기록한다. */
        if recordedBookmarks == "" {
            Preference.save(restaurants[rowIndex], key: Preference.PREF_KEY_BOOKMARK)
        }
        else if !isBookmarked(restaurants[rowIndex]) {
            Preference.save("\(recordedBookmarks)/\(restaurants[rowIndex])", key: Preference.PREF_KEY_BOOKMARK)
        }
        else {
            var newBookmarkString: String = ""
            let bookmarks = recordedBookmarks.componentsSeparatedByString("/")
                
            for bookmark in bookmarks {
                if bookmark != restaurants[rowIndex] {
                    if newBookmarkString == "" {
                        newBookmarkString = bookmark
                    }
                    else {
                        newBookmarkString = "\(newBookmarkString)/\(bookmark)"
                    }
                }
            }
                
            Preference.save(newBookmarkString, key: Preference.PREF_KEY_BOOKMARK)
        }
        
        println("Current bookmark string : \(Preference.load(Preference.PREF_KEY_BOOKMARK))")
    }
    
    func isBookmarked(name: String) -> Bool {
        let bookmarks: [String] = (Preference.load(Preference.PREF_KEY_BOOKMARK) as! String).componentsSeparatedByString("/")
        
        for bookmark in bookmarks {
            if bookmark == name {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return restaurants.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        var menu: Menu = dataArray[section]
        
        if menu.menus.count == 0 {
            menu.isEmpty = true
            return 1
        }
        else {
            menu.isEmpty = false
            return menu.menus.count
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.

        if segue.identifier == "ShowInformations" {
            let aboutViewController = segue.destinationViewController as! AboutViewController
            
            let rowIndex = sender!.tag
            aboutViewController.restaurantName = dataArray[rowIndex].restaurant
            aboutViewController.operatingHour = (XMLParser.sharedInstance.informations["operating_hours"]!)[rowIndex].stringByReplacingOccurrencesOfString("\\n", withString: "\n")
            aboutViewController.location = (XMLParser.sharedInstance.informations["locations"]!)[rowIndex].stringByReplacingOccurrencesOfString("\\n", withString: "\n")
        }
    }

}
