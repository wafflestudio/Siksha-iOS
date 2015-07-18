//
//  ViewController.swift
//  Siksha
//
//  Created by 강규 on 2015. 6. 29..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var restaurants: [String] = ["학생회관 식당", "농생대 3식당", "919동 기숙사 식당", "자하연 식당", "302동 식당",
        "솔밭 간이 식당", "동원관 식당", "감골 식당", "사범대 4식당", "두레미담",
        "301동 식당", "예술계복합연구동 식당", "공대 간이 식당", "상아회관 식당", "220동 식당",
        "대학원 기숙사 식당", "85동 수의대 식당", "소담마루", "샤반"]
    
    var pageCount = 3
    var expandedRows = [NSIndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let scrollViewWidth: CGFloat = scrollView.frame.width
        let scrollViewHeight: CGFloat = scrollView.frame.height
        
        var breakTableView = UITableView(frame: (CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)), style: UITableViewStyle.Plain)
        var lunchTableView = UITableView(frame: (CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)), style: UITableViewStyle.Plain)
        var dinnerTableView = UITableView(frame: (CGRectMake(0, 0, scrollViewWidth, scrollViewHeight)), style: UITableViewStyle.Plain)
        breakTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "restaurant")
        lunchTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "restaurant")
        dinnerTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "restaurant")
        breakTableView.delegate = self
        lunchTableView.delegate = self
        dinnerTableView.delegate = self
        breakTableView.dataSource = self
        lunchTableView.dataSource = self
        dinnerTableView.dataSource = self
        
        scrollView.addSubview(breakTableView)
        scrollView.addSubview(lunchTableView)
        scrollView.addSubview(dinnerTableView)
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return restaurants.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        cell.textLabel!.text = restaurants[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! UITableViewCell
        headerCell.backgroundColor = UIColor.grayColor()
        
        switch (section) {
        case 0:
            headerCell.textLabel!.text = "직영"
        case 1:
            headerCell.textLabel!.text = "준직영"
        case 2:
            headerCell.textLabel!.text = "대학원"
        default:
            headerCell.textLabel!.text = "기본값"
        }
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        // expand/collapse cell
        var result = find(expandedRows, indexPath)
        if (result == nil) {
            expandedRows.append(indexPath)
            // cell.setExpanded(true, animated: false)
        }
        else {
            expandedRows.removeAtIndex(result!)
            // cell.setExpanded(false, animated: false)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}