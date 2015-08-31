//
//  BookmarkViewController.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 22..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let pageCount: Int = 3 // breakfast, lunch, dinner
    var currentPageIndex: Int = 0
    
    private func viewControllerAtIndex(index: Int) -> BookmarkTableViewController? {
        var pageItemController: BookmarkTableViewController?
        
        switch index {
        case 0:
            pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("BreakfastBookmarkTableViewController") as! BreakfastBookmarkTableViewController
            pageItemController!.dictionary = MenuDictionary.sharedInstance.dictionaries[index]
            pageItemController!.pageIndex = index
        case 1:
            pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("LunchBookmarkTableViewController") as! LunchBookmarkTableViewController
            pageItemController!.dictionary = MenuDictionary.sharedInstance.dictionaries[index]
            pageItemController!.pageIndex = index
        case 2:
            pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("DinnerBookmarkTableViewController") as! DinnerBookmarkTableViewController
            pageItemController!.dictionary = MenuDictionary.sharedInstance.dictionaries[index]
            pageItemController!.pageIndex = index
        default:
            pageItemController = nil
            pageItemController!.pageIndex = -1
        }
        
        return pageItemController
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let beforeViewController = viewController as! BookmarkTableViewController
        var index: Int = beforeViewController.pageIndex
        
        if index == 0 {
            return nil
        }
        
        index = index - 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let afterViewController = viewController as! BookmarkTableViewController
        var index: Int = afterViewController.pageIndex
        
        index = index + 1
        
        if index == pageCount {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if completed {
            currentPageIndex = (pageViewController.viewControllers[0] as! BookmarkTableViewController).pageIndex
            pageControl.currentPage = currentPageIndex
            dateLabel.text = Calendar.getDateLabelTimestamp(currentPageIndex)
        }
    }
    
    private func setPageViewController() {
        // 시간(아침, 점심, 저녁)에 맞는 페이지 인덱스를 구한다.
        currentPageIndex = Calendar.getInitialPageIndex()
        
        pageControl.currentPage = currentPageIndex
        dateLabel.text = Calendar.getDateLabelTimestamp(currentPageIndex)
        
        let pageViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        let viewControllers: [AnyObject] = [viewControllerAtIndex(currentPageIndex)!]
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        pageViewController.view.frame = CGRect(x: 0, y: 125, width: screenBounds.width, height: screenBounds.height - 175)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        logoView.contentMode = .ScaleAspectFit
        logoView.image = UIImage(named: "ic_launcher")
        self.navigationItem.titleView = logoView
        
        setPageViewController()
    }
    
    func refresh() {
        let childViewControllers = self.childViewControllers
        
        for childViewController in childViewControllers {
            if let viewController = childViewController as? UIPageViewController {
                viewController.view.removeFromSuperview()
                viewController.removeFromParentViewController()
            }
        }
        
        setPageViewController()
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
