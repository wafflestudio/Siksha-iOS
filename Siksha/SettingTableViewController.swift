//
//  SettingTableViewController.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 28..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var versionMessageLabel: UILabel!
    @IBOutlet weak var emptyMenuVisibilitySwitch: UISwitch!
    @IBOutlet weak var refreshTimestamp: UILabel!
    
    let REFRESH_NOTIFICATION_KEY = "refresh_notification"
    
    var currentAppVersion = ""
    var latestAppVersion = ""
    var isLatest: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        logoView.contentMode = .ScaleAspectFit
        logoView.image = UIImage(named: "ic_launcher")
        self.navigationItem.titleView = logoView

        currentAppVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        latestAppVersion = Preference.load(Preference.PREF_KEY_LATEST_APP_VERSION) as! String
        isLatest = isCurrentAppVersionLatest()
        
        if isLatest {
            versionMessageLabel.text = "최신 버전 이용 중"
        }
        else {
            versionMessageLabel.text = "최신 버전 이용 중이지 않음"
        }
        
        refreshTimestamp.text = Preference.load(Preference.PREF_KEY_REFRESH_TIMESTAMP) as? String
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRefreshFinished", name: REFRESH_NOTIFICATION_KEY, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        let emptyMenuVisibility = Preference.load(Preference.PREF_KEY_EMPTY_MENU_VISIBILITY) as! String

        if emptyMenuVisibility == "" || emptyMenuVisibility == "visible" {
            emptyMenuVisibilitySwitch.on = false
        }
        else {
            emptyMenuVisibilitySwitch.on = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: REFRESH_NOTIFICATION_KEY, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func isCurrentAppVersionLatest() -> Bool {
        if currentAppVersion == latestAppVersion {
            return true
        }
        else {
            return currentAppVersion < latestAppVersion ? false : true
        }
    }
    
    @IBAction func emptyMenuVisibilitySwitched(sender: AnyObject) {
        if emptyMenuVisibilitySwitch.on {
            Preference.save("invisible", key: Preference.PREF_KEY_EMPTY_MENU_VISIBILITY)
        }
        else {
            Preference.save("visible", key: Preference.PREF_KEY_EMPTY_MENU_VISIBILITY)
        }
    }

    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }
    */

    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    */

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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            JSONDownloader().startDownloadService(JSONDownloader.TYPE_REFRESH)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func onRefreshFinished() -> Void {
        println("onRefreshFinished()")
        
        refreshTimestamp.text = Preference.load(Preference.PREF_KEY_REFRESH_TIMESTAMP) as? String
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    
        if segue.identifier == "ShowVersion" {
            let versionViewController = segue.destinationViewController as! VersionViewController
            
            versionViewController.currentAppVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
            versionViewController.latestAppVersion = Preference.load(Preference.PREF_KEY_LATEST_APP_VERSION) as! String
            versionViewController.isLatest = self.isLatest
        }
        else if segue.identifier == "ModifyBookmarkSequence" {
            let sequenceTableViewController = segue.destinationViewController as! SequenceTableViewController
            
            let array = (Preference.load(Preference.PREF_KEY_BOOKMARK) as! String).componentsSeparatedByString("/")
            sequenceTableViewController.segueType = 0
            sequenceTableViewController.array = array
        }
        else if segue.identifier == "ModifySequence" {
            let sequenceTableViewController = segue.destinationViewController as! SequenceTableViewController
            
            let array = (Preference.load(Preference.PREF_KEY_SEQUENCE) as! String).componentsSeparatedByString("/")
            sequenceTableViewController.segueType = 1
            sequenceTableViewController.array = array
        }
        else if segue.identifier == "ShowDeveloper" {
            
        }
    }

}
