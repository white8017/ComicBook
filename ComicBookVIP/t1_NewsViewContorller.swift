//
//  FirstViewController.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/15.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class t1_NewsViewContorller: TabVCTemplate {
    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTab = 0
        // do stuff here
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

}

