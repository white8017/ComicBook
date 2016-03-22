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
    
    @IBOutlet weak var myTableView: UITableView!
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
            bookNameLbl.text = dataArray[indexPath.row]["bookName"] as? String
        }
        
        restStr = String(format: "%f",interval1)
        
        print(restStr)
        
        return cell
    }

    func loadData() {
        
        let url = NSURL(string: "http://sashihara.100hub.net/vip/rentHistoryBoss.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
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
