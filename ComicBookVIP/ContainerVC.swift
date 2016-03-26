//
//  ContainerVC.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/15.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit
class ContainerVC : UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftContainer: UIView!
    @IBOutlet weak var rightContainer: UIView!
    
    var name:String!
    
//    let SCREEN_SIZE = UIScreen.mainScreen().bounds // 擷取螢幕尺寸
    let leftMenuWidth:CGFloat = 260

    func showAlert(){

        let alert = UIAlertController(title: nil , message:nil , preferredStyle: .Alert)
        let action = UIAlertAction(title: "完成付款", style: .Default, handler: { (alert:UIAlertAction) -> Void in
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("ContainerVC.swift")
        NSNotificationCenter.defaultCenter().postNotificationName("openAppCheck", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "logoutCloseMenu", name: "logoutCloseMenu", object: nil)
    }
    
    func logoutCloseMenu() {
        closeMenu()
    }
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAlert", name: "check", object: nil)
        //http://www.thorntech.com/2015/06/want-to-implement-a-slideout-menu-in-your-swift-app-heres-how/
        // Initially close menu programmatically.  This needs to be done on the main thread initially in order to work.
        dispatch_async(dispatch_get_main_queue()) {
            self.closeMenu(false)
        }
        
        // Tab bar controller's child pages have a top-left button toggles the menu
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu", name: "toggleMenu", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMenuViaNotification", name: "closeMenuViaNotification", object: nil)
        
        // Close the menu when the device rotates
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        // LeftMenu sends openModalWindow
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "openModalWindow0", name: "openModalWindow0", object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "openModalWindow1", name: "openModalWindow1", object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "openModalWindow2", name: "openModalWindow2", object: nil)
        
    }

    /*
    override func viewDidAppear(animated: Bool) {
        
        scrollView.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)
        leftContainer.frame = CGRectMake(0, 0, 260, SCREEN_SIZE.height)
        rightContainer.frame = CGRectMake(leftContainer.frame.width, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)
        
    }
    */
    
    //Modal方法
    /*
    func openModalWindow0(){
        performSegueWithIdentifier("openModalWindow0", sender: nil)
    }
    
    func openModalWindow1(){
        performSegueWithIdentifier("openModalWindow1", sender: nil)
    }
    
    func openModalWindow2(){
        performSegueWithIdentifier("openModalWindow2", sender: nil)
    }
    */
    
    func toggleMenu(){
        scrollView.contentOffset.x == 0  ? closeMenu() : openMenu()
    }
    
    // This wrapper function is necessary because
    // closeMenu params do not match up with Notification
    func closeMenuViaNotification(){
        closeMenu()
    }
    
    // Use scrollview content offset-x to slide the menu.
    func closeMenu(animated:Bool = true){
        scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
    }
    
    // Open is the natural state of the menu because of how the storyboard is setup.
    func openMenu(){
        NSNotificationCenter.defaultCenter().postNotificationName("reloadData", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("checkLogin", object: nil)
        print("opening menu")
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // Cleanup notifications added in viewDidLoad
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // see http://stackoverflow.com/questions/25666269/ios8-swift-how-to-detect-orientation-change
    // close the menu when rotating to landscape.
    // Note: you have to put this on the main queue in order for it to work
    func rotated(){
        if UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) {
            dispatch_async(dispatch_get_main_queue()) {
                print("closing menu on rotate")
                self.closeMenu()
            }
        }
    }
    
}

extension ContainerVC : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrollView.contentOffset.x:: \(scrollView.contentOffset.x)")
    }
    
    // http://www.4byte.cn/question/49110/uiscrollview-change-contentoffset-when-change-frame.html
    // When paging is enabled on a Scroll View,
    // a private method _adjustContentOffsetIfNecessary gets called,
    // presumably when present whatever controller is called.
    // The idea is to disable paging.
    // But we rely on paging to snap the slideout menu in place
    // (if you're relying on the built-in pan gesture).
    // So the approach is to keep paging disabled.
    // But enable it at the last minute during scrollViewWillBeginDragging.
    // And then turn it off once the scroll view stops moving.
    //
    // Approaches that don't work:
    // 1. automaticallyAdjustsScrollViewInsets -- don't bother
    // 2. overriding _adjustContentOffsetIfNecessary -- messing with private methods is a bad idea
    // 3. disable paging altogether.  works, but at the loss of a feature
    // 4. nest the scrollview inside UIView, so UIKit doesn't mess with it.  may have worked before,
    //    but not anymore.
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollView.pagingEnabled = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollView.pagingEnabled = false
    }
}
    

