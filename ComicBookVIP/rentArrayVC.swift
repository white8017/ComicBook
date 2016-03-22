//
//  rentArrayVC.swift
//  ComicBookVIP
//
//  Created by 韓家豪 on 2016/3/22.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class rentArrayVC: UIViewController,NSURLSessionDelegate,NSURLSessionDownloadDelegate {

    var dataArray = [AnyObject]()
    var nameArray = [AnyObject]()
    var i = 0
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
//            print(dataArray)
            
            

            var rDate:String!
            var now = NSDate()
            for i = 0; i < dataArray.count ; i++ {
            // 租的時間
            rDate = dataArray[i]["returnDate"] as? String
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
                nameArray.append((dataArray[i]["name"] as? String)!)
            }
            print("nameArray: \(nameArray)")
            restStr = String(format: "%f",interval1)
            
            print(restStr)
        
            }
            

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

}
