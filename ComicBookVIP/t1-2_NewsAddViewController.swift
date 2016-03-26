//
//  t1-2_NewsAddViewController.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/27.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class t1_2_NewsAddViewController: UIViewController {

    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    @IBAction func backHome(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        setTabBarVisible(!tabBarIsVisible(), animated: true)
    }
    //http://www.jianshu.com/p/56c8b3c1403c
    //hide Tabbar
    func setTabBarVisible(visible:Bool, animated:Bool) {
        if (tabBarIsVisible() == visible) {
            return
        }
        let frame = self.tabBarController?.tabBar.frame
        let offsetY = (visible ? CGFloat(0) : 49.0)
        
        let duration:NSTimeInterval = (animated ? 0.08 : 0.0)
        
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY)
                return
            }
        }
    }
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    
}
