//
//  SideBarMenu.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/16.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class SideBarMenu: UIViewController, UITableViewDelegate, UITableViewDataSource,NSURLSessionDelegate,NSURLSessionDownloadDelegate {

    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    var money = [AnyObject]()
    var nowMoney = ""
    @IBAction func btnLogout(sender: AnyObject) {

        appDelegate.userDefault.setObject("", forKey: "name")
        appDelegate.userDefault.setObject("", forKey: "phoneNumber")
        appDelegate.userDefault.setObject("", forKey: "vip")
        
        let alert = UIAlertController(title: "登出成功"  , message:nil , preferredStyle: .Alert)
        let action = UIAlertAction(title: "確定", style: .Default, handler: { (alert:UIAlertAction) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("logoutCloseMenu", object: nil)
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
        btnLogout.hidden = true
        NSNotificationCenter.defaultCenter().postNotificationName("reloadData", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("UserStateChange", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("plusChange", object: nil)
        lblName.text = "嗨～書蟲"
        btnLogout.hidden = true
        menuTableView.reloadData()
    }
    
    let loginMeun = ["登          入"]
    var sideMenu = ["會  員  資  訊", "借  閱  紀  錄", "租     書     籃", "餘 額 ： "]
    let bossMenu = ["儲  值  設  定", "出  借  清  單", "QRcode訂單"]

    
    func checkLogin() {
        
        if appDelegate.phoneNumber != "" {
            lblName.text = "嗨～\(appDelegate.account)"
            btnLogout.hidden = false
        } else {
            lblName.text = "嗨～書蟲"
            btnLogout.hidden = true
        }
        loadData()
        menuTableView.reloadData()
        
        
    }
    
    func openAppCheck() {
        if appDelegate.phoneNumber != "" {
            lblName.text = "嗨～\(appDelegate.account)"
            btnLogout.hidden = false
        }else {
            lblName.text = "嗨～書蟲"
            btnLogout.hidden = true
        }
        loadData()
        menuTableView.reloadData()
        
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //使TableView的Cell線條消失
        menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //TableView固定不滑動
        menuTableView.scrollEnabled = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkLogin", name: "checkLogin", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openAppCheck", name: "openAppCheck", object: nil)
    }
    
    
    
    
    // UITableViewDataSource methods
    //設定TableView數量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //設定Cell數量
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if appDelegate.vip == "0" {
            count = sideMenu.count
        }else if  appDelegate.vip == ""{
            count = loginMeun.count
        }else if appDelegate.vip == "1" {
            count = bossMenu.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath)
        
        if appDelegate.vip == "0"{
            sideMenu[3] = "餘 額 ： \(nowMoney)"
            cell.textLabel?.text = sideMenu[indexPath.row]
            if indexPath.row == 3 {
                cell.accessoryType = .None
                cell.userInteractionEnabled = false
            }
        }else if appDelegate.vip == ""{
            cell.textLabel?.text = loginMeun[indexPath.row]
        }else if appDelegate.vip == "1" {
            cell.textLabel?.text = bossMenu[indexPath.row]
        }
        //let t = cell.viewWithTag(75) as! UILabel
        //t.text = sideMenu[indexPath.row]
        
        return cell
    }
    
    // UITableViewDelegate methods
    //設定動作目的地指標
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //判斷指標&動作
        if appDelegate.vip == "0" || appDelegate.vip == "" {
            switch indexPath.row {
            case 0:
                NSNotificationCenter.defaultCenter().postNotificationName("openPushWindow0", object: nil)
            case 1:
                NSNotificationCenter.defaultCenter().postNotificationName("openPushWindow1", object: nil)
            case 2:
                NSNotificationCenter.defaultCenter().postNotificationName("openPushWindow2", object: nil)
//            case 3:
//                NSNotificationCenter.defaultCenter().postNotificationName("openPushWindow3", object: nil)
            default:
                print("indexPath.row: \(indexPath.row)")
            }
        } else if appDelegate.vip == "1" {
            switch indexPath.row {
            case 0:
                NSNotificationCenter.defaultCenter().postNotificationName("openPushWindow1_1", object: nil)
            case 1:
                NSNotificationCenter.defaultCenter().postNotificationName("openPushWindow1_2", object: nil)
            case 2:
                NSNotificationCenter.defaultCenter().postNotificationName("openPushWindow2", object: nil)
            default:
                print("indexPath.row: \(indexPath.row)")
            }
        }
        
        //關閉View
        NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
    }
    func loadData() {
        
        let url = NSURL(string: "http://sashihara.100hub.net/vip/selectDeposit.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        let submitBody:String = "phoneNumber=\(appDelegate.phoneNumber)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
        
    }
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do {
            let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
            
            
            money = dataDic["member"]! as! [AnyObject]
            //            print(money[0]["deposit"] as! String)
            nowMoney = money[0]["deposit"] as! String
            print(nowMoney)
            
            
        }catch {
            print("ERROR member")
        }
        menuTableView.reloadData()
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
}
