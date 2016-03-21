//
//  FirstViewController.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/15.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class t1_NewsViewContorller: TabVCTemplate, UITableViewDelegate, UITableViewDataSource {
    
    var count = 0
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var headImagePageControl: UIPageControl!
    @IBOutlet var leftSwipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var rightSwipeGesture: UISwipeGestureRecognizer!
    
    @IBAction func swipeActionHandler(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Left {
            headImagePageControl.currentPage++
            headImageView.image = UIImage(named: "0\(headImagePageControl.currentPage+1)")
        } else {
            headImagePageControl.currentPage--
            headImageView.image = UIImage(named: "0\(headImagePageControl.currentPage+1)")
        }
        headImageView.image = UIImage(named: "0\(headImagePageControl.currentPage+1)")
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTab = 0
        // do stuff here
        
        //Page View Control
        headImageView.userInteractionEnabled = true
        headImageView.contentMode = UIViewContentMode.ScaleAspectFill
        headImageView.image = UIImage(named: "0\(headImagePageControl.currentPage+1)")
        headImageView.addGestureRecognizer(leftSwipeGesture)
        headImageView.addGestureRecognizer(rightSwipeGesture)
        
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("changePic:"), userInfo: nil, repeats: true)
    }
    
    func changePic(sender:NSTimer) {
        count++
        headImagePageControl.currentPage = count % 4
        headImageView.image = UIImage(named: "0\(headImagePageControl.currentPage+1)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        setTabBarVisible(!tabBarIsVisible(), animated: true)
    }
    //http://www.jianshu.com/p/56c8b3c1403c
    //appear Tabbar
    func setTabBarVisible(visible:Bool, animated:Bool) {
        if (tabBarIsVisible() == visible) {
            return
        }
        
        let frame = self.tabBarController?.tabBar.frame
        let onsetY = (visible ? -49.0 : CGFloat(0))
            
        let duration:NSTimeInterval = (animated ? 0.1 : 0.0)
            
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, onsetY)
                return
            }
        }
        
    }
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath)
        //cell.textLabel?.text = sideMenu[indexPath.row]
        
        // Configure the cell...
        if indexPath.row == 0 {
            //cell.postImageView.image = UIImage(named: "watchkit-intro")
            cell.textLabel?.text = "WatchKit Introduction: Building a Simple Guess Game"
            //cell.authorLabel.text = "Simon Ng"
            //cell.authorImageView.image = UIImage(named: "author")
            
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "WatchKit Introduction: Building a Simple Guess Game"
            
        } else {
            cell.textLabel?.text = "WatchKit Introduction: Building a Simple Guess Game"
            
        }
        
        return cell
    }

    

}

