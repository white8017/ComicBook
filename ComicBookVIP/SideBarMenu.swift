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
        print("name = \(appDelegate.account)")
        NSNotificationCenter.defaultCenter().postNotificationName("logoutCloseMenu", object: nil)
        btnLogout.hidden = true
    }
    
    let sideMenu = ["會  員  資  訊", "借  閱  紀  錄", "儲  值  餘  額", "租     書     籃"]

    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkLogin", name: "checkLogin", object: nil)
    }
    func checkLogin() {
        
        if appDelegate.phoneNumber != "" {
            lblName.text = "嗨～\(appDelegate.account)"
            btnLogout.hidden = false
        }else {
            lblName.text = "嗨～蟲蟲"
            btnLogout.hidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //使TableView的Cell線條消失
        menuTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //TableView固定不滑動
        menuTableView.scrollEnabled = false
        
        
    }
    
    
    
    
    // UITableViewDataSource methods
    //設定TableView數量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //設定Cell數量
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenu.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath)
        cell.textLabel?.text = sideMenu[indexPath.row]
        
        //let t = cell.viewWithTag(75) as! UILabel
        //t.text = sideMenu[indexPath.row]
        
        return cell
    }
    
    // UITableViewDelegate methods
    //設定動作目的地指標
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //判斷指標&動作
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
        
        //關閉View
        NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
    }
}
