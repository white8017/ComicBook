//
//  rentBookBoss.swift
//  ComicBookVIP
//
//  Created by 韓家豪 on 2016/3/21.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class rentBookBoss: UIViewController,UITableViewDelegate, UITableViewDataSource,NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    
    
    
    var dataArray = [AnyObject]()

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
     
        let bookNameLbl = cell.viewWithTag(101) as! UILabel
        let txtViewName = cell.viewWithTag(102) as! UITextView
        
        
    }
    
    func loadData() {
    
            let url = NSURL(string: "http://sashihara.100hub.net/vip/rentBookStageBoss.php.php")
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
    


}
