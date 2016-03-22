//
//  delayRerutnBookBoss.swift
//  ComicBookVIP
//
//  Created by 韓家豪 on 2016/3/21.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class delayRerutnBookBoss: UIViewController,UITableViewDataSource,UITableViewDelegate,NSURLSessionDownloadDelegate,NSURLSessionDelegate {

    var dataArray = [AnyObject]()
    var delayName:String!
    var selectStr = "update"
    let btnLoad   = UIButton(type: UIButtonType.Custom) as UIButton
    let btnUpdate   = UIButton(type: UIButtonType.Custom) as UIButton
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        btnUpdate.setTitle("更新", forState: UIControlState.Normal)
        btnUpdate
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let bookNameLbl = cell.viewWithTag(101) as! UILabel
        
        var rDate:String!
        var now = NSDate()
        // 租的時間
        rDate = dataArray[indexPath.row]["returnDate"] as? String
        print("rDate= \(rDate)")
        let dateString = rDate // change to your date format
        // 字串轉Date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") // 註解是因為now -8 所以讓資料庫下來時也-8
        let date = dateFormatter.dateFromString(dateString)
//        print("date= \(date!)") // 到期時間
//        print("now = \(now)") // 現在時間
        var interval1 = date!.timeIntervalSinceDate(now) / (3600*24) + 1
        var restStr:String!
        // Double轉String
        if interval1 < 0.0  {
            delayName = dataArray[indexPath.row]["name"] as? String
            print(delayName)
        }
        selectStr = "update"
        restStr = String(format: "%f",interval1)
        
        print(restStr)
        
        return cell
    }

    func loadData() {
        
        switch selectStr {
        case "load":
            let url = NSURL(string: "http://sashihara.100hub.net/vip/rentHistoryBoss.php")
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
            
            request.HTTPMethod = "POST"
            
            
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            
            let dataTask = session.downloadTaskWithRequest(request)
                dataTask.resume()
            break
            
        case "update":

            let url = NSURL(string: "http://sashihara.100hub.net/vip/delayRentBookUpdateBoss.php")
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
            
            let submitBody:String = "name=\(delayName)"
            
            request.HTTPMethod = "POST"
            request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
            
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            
            let dataTask = session.downloadTaskWithRequest(request)
            dataTask.resume()
//            selectStr = "load"
            break
        default:
            print("load error")
        }
    }
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        switch selectStr {
        case "load":
        do {
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
            
            dataArray = dataDic["rentHistory"]! as! [AnyObject]
            print("\(dataArray.count) 筆資料")
            print("\(dataArray)")
            
            myTableView.reloadData()
        }catch {
            print("ERROR Author")
        }
            break
        default:
            print("update")
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
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
