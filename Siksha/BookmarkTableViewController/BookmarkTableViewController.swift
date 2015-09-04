//
//  BookmarkTableViewController.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 23..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class BookmarkTableViewController: UITableViewController {

    var restaurants: [String] = []
    
    var pageIndex = 0
    
    var dictionary: [String: Menu] = [:]
    var dataArray = [Menu]()
    
    let alertController = UIAlertController(title: "즐겨찾는 식당이 없습니다!", message: "OK를 누르면 식단 탭으로 이동합니다.", preferredStyle: .Alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { Void in
            self.tabBarController!.selectedIndex = 1 }))
        alertController.view.tintColor = UIColor(red: 0.96, green: 0.55, blue: 0.36, alpha: 0.55)
    }

    override func viewWillAppear(animated: Bool) {
        resetData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetData() {
        let bookmarks = Preference.load(Preference.PREF_KEY_BOOKMARK) as! String
        
        if bookmarks != "" {
            restaurants = bookmarks.componentsSeparatedByString("/")
        }
        else {
            restaurants = []
        }
        
        dataArray = [Menu]()
        for restaurant in restaurants {
            dataArray.append(dictionary[restaurant]!)
        }
        
        self.tableView.reloadData()
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
        SharedData.save(newBookmarkString, key: SharedData.SHARED_KEY_BOOKMARK)
        
        println("Current bookmark string(Preference) : \(Preference.load(Preference.PREF_KEY_BOOKMARK))")
        println("Current bookmark string(SharedData) : \(SharedData.load(SharedData.SHARED_KEY_BOOKMARK))")
        
        resetData()
        
        if Preference.load(Preference.PREF_KEY_BOOKMARK) as! String == "" {
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
        
        return menu.menus.count == 0 ? 1 : menu.menus.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
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

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let item = dataArray[fromIndexPath.row]
        dataArray.removeAtIndex(fromIndexPath.row)
        dataArray.insert(item, atIndex: toIndexPath.row)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }

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
