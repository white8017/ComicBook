//
//  m2_TransactionHistory.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/17.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class m2_TransactionHistory: UIViewController, UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    
    var dataArray = [AnyObject]()
    var SelectStr = "未還"
    var name = "curry"
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBAction func valueChange(sender: AnyObject) {
        let to = segControl.titleForSegmentAtIndex(segControl.selectedSegmentIndex)!
        print(to) // 印出來
        if to == "未還紀錄" {
            SelectStr = "未還"
            loadData()
            
        }else if to == "歸還紀錄"{
            SelectStr = "已還"
            
            loadData()
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    
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
    
    
    
    //以下豪哥
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let bookNameLbl = cell.viewWithTag(101) as! UILabel
        let rentDateLbl = cell.viewWithTag(102) as! UILabel
        let returnDateLbl = cell.viewWithTag(103) as! UILabel
        let restLbl = cell.viewWithTag(104) as! UILabel
        let returnDoneLbl = cell.viewWithTag(105) as! UILabel
        let nowStageLbl = cell.viewWithTag(106) as! UILabel
        
        
        switch SelectStr {
        case "未還" :
            var rDate:String!
            let now = NSDate()
            
            //            var formatter = NSDateFormatter()
            //            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            //            formatter.timeZone = NSTimeZone(abbreviation: "HKT") // CST北京
            //            let utcTimeZoneStr = formatter.stringFromDate(now)
            //            print(utcTimeZoneStr) //現在時間
            //
            //            var formatDate = NSDateFormatter()
            //            formatDate.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            //            formatDate.timeZone = NSTimeZone(abbreviation: "HKT")
            //            let now8 = formatDate.dateFromString(utcTimeZoneStr)
            //            print(now8!)
            
            
            
            
            // 租的時間
            rDate = dataArray[indexPath.row]["returnDate"] as? String
            print("rDate= \(rDate)")
            let dateString = rDate // change to your date format
            // 字串轉Date
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            //            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") // 註解是因為now -8 所以讓資料庫下來時也-8
            let date = dateFormatter.dateFromString(dateString)
            print("date= \(date!)")
            print("now=\(now)")
            
            
            
            
            let interval1 = date!.timeIntervalSinceDate(now) / (3600*24) + 1
            var restStr:String!
            // Double轉String
            restStr = String(format: "%d",Int(interval1))
            
            
            
            bookNameLbl.text = dataArray[indexPath.row]["bookName"] as? String
            rentDateLbl.text = "租: \(dataArray[indexPath.row]["rentDate"] as! String)"
            returnDateLbl.text = "還: \(dataArray[indexPath.row]["returnDate"] as! String)"
            restLbl.text = " \(restStr) 天"
            nowStageLbl.text = dataArray[indexPath.row]["nowStage"] as? String
            returnDoneLbl.text = ""
            if (interval1 > 0 && interval1 < 1) {
                restLbl.text = " 今天"
                restLbl.textColor = UIColor(red: 0.9 , green: 0, blue: 0, alpha: 1)
                scheduleNotification(12345);
                print(interval1)
            } else if (interval1 < 0) {
                restLbl.text = " 過期"
                restLbl.textColor = UIColor(red: 0.9 , green: 0, blue: 0, alpha: 1)
            }
            
            break
        case "已還" :
            
            
            bookNameLbl.text = dataArray[indexPath.row]["bookName"] as? String
            rentDateLbl.text = ""
            returnDateLbl.text = ""
            restLbl.text = ""
            returnDoneLbl.text = "租: \(dataArray[indexPath.row]["rentDate"] as! String)"
            
            break
        default:
            print("有問題喔喔！！")
        }
        return cell
    }
    
    
    func loadData() {
        
        switch SelectStr {
        case "未還" :
            let url = NSURL(string: "http://sashihara.100hub.net/vip/rentHistory.php")
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
            
            //        let submitName = ""
            let submitBody: String = "name=\(name)"
            
            request.HTTPMethod = "POST"
            request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            
            let dataTask = session.downloadTaskWithRequest(request)
            dataTask.resume()
            break
        case "已還":
            let url = NSURL(string: "http://sashihara.100hub.net/vip/returnHistory.php")
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
            
            
            let submitBody: String = "name=\(name)"
            
            request.HTTPMethod = "POST"
            request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            
            let dataTask = session.downloadTaskWithRequest(request)
            dataTask.resume()
            break
        default:
            print("loadData XX")
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do {
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
            
            dataArray = dataDic["rentHistory"]! as! [AnyObject]
            print("\(dataArray.count) 筆資料")
            print("\(dataArray)")
            
            myTableView.reloadData()
        }catch {
            print("ERROR Author")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SelectStr = "未還"
        loadData()
        segControl.setTitle("未還紀錄", forSegmentAtIndex: 0)
        segControl.setTitle("歸還紀錄", forSegmentAtIndex: 1)
        
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //发送通知消息
        //        scheduleNotification(12345);
        //清除所有本地推送
        
    }
    
    //发送通知消息
    func scheduleNotification(itemID:Int){
        //如果已存在该通知消息，则先取消
        cancelNotification(itemID)
        
        //创建UILocalNotification来进行本地消息通知
        let localNotification = UILocalNotification()
        //推送时间（设置为30秒以后）
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
        //时区
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        //推送内容
        localNotification.alertBody = "有漫畫今天要還囉！～"
        //声音
        localNotification.soundName = UILocalNotificationDefaultSoundName
        //额外信息
        localNotification.userInfo = ["ItemID":itemID]
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    //取消通知消息
    func cancelNotification(itemID:Int){
        //通过itemID获取已有的消息推送，然后删除掉，以便重新判断
        let existingNotification = self.notificationForThisItem(itemID) as UILocalNotification?
        if existingNotification != nil {
            //如果existingNotification不为nil，就取消消息推送
            UIApplication.sharedApplication().cancelLocalNotification(existingNotification!)
        }
    }
    //通过遍历所有消息推送，通过itemid的对比，返回UIlocalNotification
    func notificationForThisItem(itemID:Int)-> UILocalNotification? {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications
        for notification in allNotifications! {
            let info = notification.userInfo as! [String:Int]
            let number = info["ItemID"]
            if number != nil && number == itemID {
                return notification as UILocalNotification
            }
        }
        return nil
    }
    
    
    
}
