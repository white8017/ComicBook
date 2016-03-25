//
//  1111.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/17.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class m4_OderFrorm: UIViewController, UIApplicationDelegate, UITableViewDelegate, UITableViewDataSource,NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var dataArray = [AnyObject]()
    var i = 0
    var totalArray = [AnyObject]()
    var sum = 0
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    //http://ithelp.ithome.com.tw/question/10159865
    //自訂back
    @IBAction func backButton(sender: AnyObject) {
        //http://www.cocoachina.com/bbs/read.php?tid=260688
        //self.navigationController?.popViewControllerAnimated(true)
        //self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("HomePage") as! t1_NewsViewContorller, animated: true)
        //tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    override func viewDidLoad() {
        loadOrderForm()
    }
    
    override func viewDidAppear(animated: Bool) {
        setTabBarVisible(!tabBarIsVisible(), animated: true)
        
        
        let userLbl = self.view.viewWithTag(301) as! UILabel
        userLbl.text = "\(appDelegate.account) 的訂單"
        
        
        
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
    
    
    //以下豪哥
    

    @IBAction func btnCheck(sender: AnyObject) {
        Checkout()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let lblTotal = self.view.viewWithTag(101) as! UILabel
        let lblBookName = cell.viewWithTag(202) as! UILabel
        let lblNowStage = cell.viewWithTag(203) as! UILabel
        let lblPrice = cell.viewWithTag(204) as! UILabel
        
        lblBookName.text = dataArray[indexPath.row]["bookName"] as? String
        lblNowStage.text = dataArray[indexPath.row]["nowStage"] as? String
        lblPrice.text = "\((dataArray[indexPath.row]["price"] as? String)!) 元"
        
        lblTotal.text = "總計 : \(String(format: "%d", sum)) 元"
        
        return cell
        
    }
    
    func loadOrderForm() {
        let url = NSURL(string: "http://sashihara.100hub.net/vip/rentHistory.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        //        let submitName = ""
        
        let submitBody: String = "name=\(appDelegate.account)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
        
    }
    
    func Checkout() {
        let url = NSURL(string: "http://sashihara.100hub.net/vip/updateDepositCheckout.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        //        let submitName = ""
        print(sum)
        
        let submitBody: String = "deposit=\(sum)&phoneNumber=\(appDelegate.phoneNumber)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
        print("ok")
        sum = 0
        
    }
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        if sum == 0 {
            do {
                let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                
                dataArray = dataDic["rentHistory"]! as! [AnyObject]
                print("\(dataArray.count) 筆資料")
                print("\(dataArray)")
                
                for var q = 0 ; q < dataArray.count ; q++ {
                    totalArray.append((dataArray[q]["price"] as? String)!)
                }
                print(totalArray)
                
                for (var i = 0; i < dataArray.count; i++) {
                    sum = sum + Int(totalArray[i] as! String)!
                }
                
                
                myTableView.reloadData()
            }catch {
                print("ERROR rentHistory")
            }
        }
    }
    
    
    func theToggleMenu(sender:UIBarButtonItem) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    func toHome(sender:UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
