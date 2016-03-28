//
//  t3_FavoriteViewController.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/17.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class t3_FavoriteViewController: TabVCTemplate, UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate,  NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var SegControl: UISegmentedControl!
    @IBOutlet weak var MyTableView: UITableView!

    var dataArray = [AnyObject]() // 作者名稱資料
    var newAuthor = ""
    var newI = 0
    var DeleteS:String!
    var name = ""
    var authorORbookName:String!
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var activityIndicator = UIActivityIndicatorView()
    
    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    @IBAction func SegControl(sender: AnyObject) {
        let to = SegControl.titleForSegmentAtIndex(SegControl.selectedSegmentIndex)!
        print(to) // 印出來
        if to == "作者" {
            authorORbookName = "author"
            self.loadData()
            print("\(authorORbookName) 作者")
        }else if to == "漫畫"{
            authorORbookName = "bookName"
            self.loadData()
            print("\(authorORbookName) 漫畫")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTab = 2
        // do stuff here
        

        authorORbookName = "bookName"
        self.loadData()
        
        self.myFavorites()
        
        
        print(name)
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        setTabBarVisible(!tabBarIsVisible(), animated: true)
    }
    //http://www.jianshu.com/p/56c8b3c1403c
    //appear Tabbar
    func setTabBarVisible(visible:Bool, animated:Bool) {
        if (tabBarIsVisible() == visible) {
            return
        }
        
        let frame = self.tabBarController?.tabBar.frame
        let onsetY = (visible ? -49.0 : CGFloat(0))
        
        let duration:NSTimeInterval = (animated ? 0.1 : 0.0)
        
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, onsetY)
                return
            }
        }
    }
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    
    
    
    ///////////////////////以下豪哥/////////////////////////
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let authorLbl = cell.viewWithTag(101) as! UILabel
        var newStage = cell.viewWithTag(102) as! UILabel
        
        switch authorORbookName{
        case "author":
            authorLbl.text = dataArray[indexPath.row]["author"] as? String
            newStage.text = ""
            break
        case "bookName":
            
            authorLbl.text = dataArray[indexPath.row]["bookName"] as? String
            var DDD:String!
            DDD = dataArray[indexPath.row]["newStage"] as? String
            newStage.text = "     \(DDD) "

            break
        default:
            print("cellForRow XX")
            
        }
        
        return cell
        
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch authorORbookName{
        case "author":
            newI = indexPath.row
            self.performSegueWithIdentifier("favorites", sender: nil)
            
            print(dataArray[indexPath.row]["author"] as! String)
            break
        case "bookName":
            
            break
        default:
            print("didSelect")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch authorORbookName{
        case "author":
            if segue.identifier == "favorites" {
                let nextViewController = segue.destinationViewController as!
                    t3_2_Favorite2ViewController
                // 傳作者值
                nextViewController.author = dataArray[newI]["author"] as! String
                // 傳name值
                nextViewController.name = name
                print("~\(newI)")
                
                
                
                
                
                //dataArray[newI]["author"] as! String
                
            }
            break
        case "bookName":
            print("xx")
            break
        default:
            print("prepare xx")
        }
    }
    
    
    func loadData() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        
        switch authorORbookName{
            // 作者名稱
        case "author":
            
            let url = NSURL(string: "http://sashihara.100hub.net/vip/download.php")
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
            
            request.HTTPMethod = "POST"
            
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            
            let dataTask = session.downloadTaskWithRequest(request)
            dataTask.resume()
            break
            
            // 追蹤漫畫
        case "bookName":
            
            let url = NSURL(string: "http://sashihara.100hub.net/vip/favoritesNameSelect.php")
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
            
            let submitBody: String = "name=\(appDelegate.account)"
            print("account:\(appDelegate.account)")
            
            request.HTTPMethod = "POST"
            request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            
            let dataTask = session.downloadTaskWithRequest(request)
            dataTask.resume()
            
            break
        default:
            print("loadData xx")
        }
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            
            DeleteS = dataArray[indexPath.row]["bookName"] as! String
            dataArray.removeAtIndex(indexPath.row)
            self.deleteData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }

        
    }
    
    func deleteData () {
        let url = NSURL(string: "http://sashihara.100hub.net/vip/deleteFavoritesName.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        let submitBody: String = "name=\(appDelegate.account)&bookName=\(DeleteS)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
        
    }
    
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        switch authorORbookName {
            
        case "author":
            do {
                let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                
                dataArray = dataDic["bookDetails"]! as! [AnyObject]
                print("\(dataArray.count) 筆資料")
                print("\(dataArray)")
                
                MyTableView.reloadData()
            }catch {
                print("ERROR Author")
            }
            break
            
        case "bookName":
            do {
                let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                
                dataArray = dataDic["favorites"]! as! [AnyObject]
                print("\(dataArray.count) 筆資料")
                print(dataArray)
                
                MyTableView.reloadData()
            }catch {
                print("ERROR bookName")
            }
            
            break
        default:
            print("didFinish xx")
            
        }
//        activityIndicator.stopAnimating()
    }
    
    
    func myFavorites () {
        SegControl.setTitle("作者", forSegmentAtIndex: 0)
        SegControl.setTitle("漫畫", forSegmentAtIndex: 1)
    }
    
    
    
    
    
    
}
