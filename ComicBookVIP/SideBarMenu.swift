//
//  SideBarMenu.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/16.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class SideBarMenu: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnLogout: UIButton!

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
        lblName.text = "嗨～書蟲"
        btnLogout.hidden = true
        menuTableView.reloadData()
    }
    
    let loginMeun = ["登      入"]
    let sideMenu = ["會  員  資  訊", "借  閱  紀  錄", "租     書     籃", "餘額："]
    let bossMenu = ["儲         值", "查  詢  訂  單", "QRCode  結  帳"]

    override func viewDidAppear(animated: Bool) {
        
        
    }
    func checkLogin() {
        
        if appDelegate.phoneNumber != "" {
            lblName.text = "嗨～\(appDelegate.account)"
            btnLogout.hidden = false
        }else {
            lblName.text = "嗨～書蟲"
            btnLogout.hidden = true
        }
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
            cell.textLabel?.text = sideMenu[indexPath.row]
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
            case 3:
                NSNotificationCenter.defaultCenter().postNotificationName("openPushWindow3", object: nil)
            default:
                print("indexPath.row: \(indexPath.row)")
            }
        } else if appDelegate.vip == "1" {
            switch indexPath.row {
            case 0:
                NSNotificationCenter.defaultCenter().postNotificationName("openPushWindow0", object: nil)
            case 1:
                NSNotificationCenter.defaultCenter().postNotificationName("openPushWindow1", object: nil)
            case 2:
                NSNotificationCenter.defaultCenter().postNotificationName("openPushWindow2", object: nil)
            default:
                print("indexPath.row: \(indexPath.row)")
            }
        }
        
        //關閉View
        NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
    }
}
