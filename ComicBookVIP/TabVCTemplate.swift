//
//  TabVCTemplate.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/15.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class TabVCTemplate : UIViewController {
    
    // placeholder for the tab's index
    var selectedTab = 0
    
    override func viewDidLoad() {
        
        // Sent from LeftMenu
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openPushWindow0", name: "openPushWindow0", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openPushWindow1", name: "openPushWindow1", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openPushWindow2", name: "openPushWindow2", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openPushWindow3", name: "openPushWindow3", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openPushWindow1_1", name: "openPushWindow1_1", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openPushWindow1_2", name: "openPushWindow1_2", object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
        view.endEditing(true)
    }
    
    func openPushWindow0(){
        if tabBarController?.selectedIndex == selectedTab {
            performSegueWithIdentifier("openPushWindow0", sender: nil)
        }
    }
    func openPushWindow1(){
        if tabBarController?.selectedIndex == selectedTab {
            performSegueWithIdentifier("openPushWindow1", sender: nil)
        }
    }
    func openPushWindow2(){
        if tabBarController?.selectedIndex == selectedTab {
            performSegueWithIdentifier("openPushWindow2", sender: nil)
        }
    }
    func openPushWindow3(){
        if tabBarController?.selectedIndex == selectedTab {
            performSegueWithIdentifier("openPushWindow3", sender: nil)
        }
    }
    func openPushWindow1_1(){
        if tabBarController?.selectedIndex == selectedTab {
            performSegueWithIdentifier("openPushWindow1_1", sender: nil)
        }
    }
    func openPushWindow1_2(){
        if tabBarController?.selectedIndex == selectedTab {
            performSegueWithIdentifier("openPushWindow1_2", sender: nil)
        }
    }
    
}
