//
//  SequenceTableViewController.swift
//  Siksha-iOS
//
//  Created by 강규 on 2015. 8. 7..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class SequenceTableViewController: UITableViewController {
    
    var segueType: Int = -1 // 0 : Bookmark sequence, 1 : Normal sequence
    var array: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        if segueType == 0 {
            array = (Preference.load(Preference.PREF_KEY_BOOKMARK) as! String).componentsSeparatedByString("/")
        }
        else {
            array = (Preference.load(Preference.PREF_KEY_SEQUENCE) as! String).componentsSeparatedByString("/")
        }
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func editButtonClicked(sender: AnyObject) {
        self.editing = !self.editing
        
        if self.editing {
            self.navigationItem.rightBarButtonItem!.title = "확인"
        }
        else {
            self.navigationItem.rightBarButtonItem!.title = "편집"
            
            var sequenceString = ""
            for item in array {
                if sequenceString == "" {
                    sequenceString = item
                }
                else {
                    sequenceString = "\(sequenceString)/\(item)"
                }
            }
            
            if segueType == 0 {
                Preference.save(sequenceString, key: Preference.PREF_KEY_BOOKMARK)
            }
            else {
                Preference.save(sequenceString, key: Preference.PREF_KEY_SEQUENCE)
            }
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return array.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SequenceTableViewCell", forIndexPath: indexPath) as! SequenceTableViewCell
        
        // Configure the cell...

        cell.nameLabel.text = array[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell = tableView.dequeueReusableCellWithIdentifier("SequenceTableViewHeaderCell") as! SequenceTableViewHeaderCell
        
        if self.editing {
            headerCell.messageLabel.text = "확인 버튼을 눌러 순서를 저장하세요."
        }
        else {
            headerCell.messageLabel.text = "편집 버튼을 눌러 순서를 바꿔보세요."
        }

        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

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
        let item: String = array[fromIndexPath.row]
        array.removeAtIndex(fromIndexPath.row)
        array.insert(item, atIndex: toIndexPath.row)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
