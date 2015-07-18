//
//  ViewController.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 18..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var dateLabel: UILabel!
    
    var pageCount = 3 // breakfast, lunch, dinner
    
    private func getPageItemController(index: Int) -> TableViewController? {
        var pageItemController: TableViewController?
        
        switch index {
        case 0:
            pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("BreakfastTableViewController") as! BreakfastTableViewController
            pageItemController!.pageIndex = index
        case 1:
            pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("LunchTableViewController") as! LunchTableViewController
            pageItemController!.pageIndex = index
        case 2:
            pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("DinnerTableViewController") as! DinnerTableViewController
            pageItemController!.pageIndex = index
        default:
            pageItemController = nil
            pageItemController!.pageIndex = 0
        }
        
        return pageItemController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let pageItemController = viewController as! TableViewController
        
        if pageItemController.pageIndex > 0 {
            return getPageItemController(pageItemController.pageIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let pageItemController = viewController as! TableViewController
        
        if pageItemController.pageIndex < pageCount - 1 {
            return getPageItemController(pageItemController.pageIndex + 1)
        }
        
        return nil
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        dateLabel.text = DateUtil.getDateLabelString()
        
        let pageViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pageViewController.dataSource = self
        
        let startingViewController = getPageItemController(0)!
        let viewControllers: NSArray = [startingViewController]
        pageViewController.setViewControllers(viewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    
        addChildViewController(pageViewController)
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        pageViewController.view.frame = CGRect(x: 0, y: 125, width: screenBounds.width, height: screenBounds.height - 175)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
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
