//
//  BookmarkTableViewController.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 23..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class BookmarkTableViewController: UITableViewController {

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
    }

    override func viewDidAppear(animated: Bool) {
        dataArray = [Menu]()
        
        for restaurant in restaurants {
            if isBookmarked(restaurant) {
                dataArray.append(dictionary[restaurant]!)
            }
        }
        
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
        var recordedBookmarks = Preference.load(Preference.PREF_KEY_BOOKMARK) as! String
        let bookmarks = recordedBookmarks.componentsSeparatedByString("/")
        let rowIndex = sender.tag
        
        var newBookmarkString: String = ""
        
        for bookmark in bookmarks {
            if bookmark != dataArray[rowIndex].restaurant {
                if newBookmarkString == "" {
                    newBookmarkString = bookmark
                }
                else {
                    newBookmarkString = "\(newBookmarkString)/\(bookmark)"
                }
            }
        }
        
        Preference.save(newBookmarkString, key: Preference.PREF_KEY_BOOKMARK)
        println("Current bookmark string : \(Preference.load(Preference.PREF_KEY_BOOKMARK))")
        
        self.viewDidAppear(false)
        
        if Preference.load(Preference.PREF_KEY_BOOKMARK) as! String == "" {
            var alertController = UIAlertController(title: "즐겨찾는 식당이 없습니다!", message: "OK를 누르면 식단 탭으로 이동합니다.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { Void in
                self.tabBarController!.selectedIndex = 1 })
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
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
        
        return dataArray.count
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
            
            let rowIndex = find(XMLParser.sharedInstance.informations["restaurants"]!, dataArray[sender!.tag].restaurant)
            aboutViewController.restaurantName = (XMLParser.sharedInstance.informations["restaurants"]!)[rowIndex!]
            aboutViewController.operatingHour = (XMLParser.sharedInstance.informations["operating_hours"]!)[rowIndex!].stringByReplacingOccurrencesOfString("\\n", withString: "\n")
            aboutViewController.location = (XMLParser.sharedInstance.informations["locations"]!)[rowIndex!].stringByReplacingOccurrencesOfString("\\n", withString: "\n")
        }

    }

}
