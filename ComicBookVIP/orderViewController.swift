//
//  orderViewController.swift
//  ComicBookVIP
//
//  Created by plasma018 on 2016/3/26.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class orderViewController: UIViewController {
    var indicator:UIActivityIndicatorView!
    var enterBty = UIButton(type: UIButtonType.System)
    override func viewDidAppear(animated: Bool) {
        let viewS = self.view.frame.size
        
        // 標題列
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:self.view.frame.size.height/5))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "謝謝借閱");
        navBar.setItems([navItem], animated: false);
        
        // 按鈕

        let clearBty = UIButton(type: UIButtonType.System)
        
        enterBty.setTitle("ENTER", forState: UIControlState.Normal)
        clearBty.setTitle("CLEAR", forState: UIControlState.Normal)
        enterBty.tintColor = UIColor.redColor()
        let buttonW = viewS.width/2
        let buttonH = viewS.height/6
        enterBty.frame = CGRectMake(0,self.view.frame.maxY-buttonH,buttonW,buttonH)
        clearBty.frame = CGRectMake(viewS.width/2,self.view.frame.maxY-buttonH,buttonW,buttonH)
      
        clearBty.addTarget(self, action: "clear", forControlEvents: UIControlEvents.AllTouchEvents)
        self.view.addSubview(clearBty)
        self.view.addSubview(enterBty)
        //
        indicator = UIActivityIndicatorView(frame: self.view.bounds)
        indicator.color = UIColor.blackColor()
        indicator.transform =  CGAffineTransformMakeScale(3, 3)
        indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        indicator.userInteractionEnabled = false;
        self.view.addSubview(indicator)
       
        
        
    }
    func clear(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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