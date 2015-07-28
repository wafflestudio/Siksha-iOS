//
//  LunchTableViewController.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 18..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class LunchTableViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if dataArray[indexPath.section].isEmpty {
            var cell: TableViewEmptyCell = tableView.dequeueReusableCellWithIdentifier("LunchTableViewEmptyCell", forIndexPath: indexPath) as! TableViewEmptyCell
            
            // Configure the cell...
            cell.emptyMessageLabel!.text = "메뉴가 없습니다."
            
            return cell
        }
        else {
            var cell: TableViewCell = tableView.dequeueReusableCellWithIdentifier("LunchTableViewCell", forIndexPath: indexPath) as! TableViewCell
            
            // Configure the cell...
            cell.nameLabel!.text = dataArray[indexPath.section].menus[indexPath.row]["name"] as? String
            cell.priceLabel!.text = dataArray[indexPath.section].menus[indexPath.row]["price"] as? String
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell = tableView.dequeueReusableCellWithIdentifier("LunchTableViewHeaderCell") as! TableViewHeaderCell
        
        headerCell.nameLabel!.text = restaurants[section]
        headerCell.bookmarkButton!.tag = section
        headerCell.aboutButton!.tag = section
        
        if isBookmarked(restaurants[section]) {
            headerCell.bookmarkButton!.setImage(UIImage(named: "ic_star_filled"), forState: .Normal)
        }
        else {
            headerCell.bookmarkButton!.setImage(UIImage(named: "ic_star"), forState: .Normal)
        }
        
        return headerCell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
