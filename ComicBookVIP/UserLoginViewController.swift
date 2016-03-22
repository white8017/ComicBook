//
//  Log&RegViewController.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/22.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate  {
    
    var dataArray = [AnyObject]()
    var i = 0;
    let width = CGFloat(2.0)
    
    let txtPhone: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 110, y: Screen.height / 8.5,width:20, height: 40))
    let txtPasswd: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 110, y: Screen.height / 8.5+45*1,width:20, height: 40))
    
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.transitionWithView(self.view, duration: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.view.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1)
            
            let borderPhone = CALayer()
            self.txtPhone.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5, 180, 40)
            self.txtPhone.layer.addSublayer(borderPhone)
            self.txtPhone.layer.masksToBounds = true
            self.txtPhone.textColor = UIColor.brownColor()
            self.txtPhone.attributedPlaceholder = NSAttributedString(string: "電話", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
            self.txtPhone.alpha = 0.7
            self.borderStyle(self.txtPhone,borderNom: borderPhone)
            self.view.addSubview(self.txtPhone)
            
            let borderPasswd = CALayer()
            self.txtPasswd.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+45, 180, 40)
            self.txtPasswd.layer.addSublayer(borderPasswd)
            self.txtPasswd.layer.masksToBounds = true
            self.txtPasswd.textColor = UIColor.brownColor()
            self.txtPasswd.attributedPlaceholder = NSAttributedString(string: "密碼", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
            self.txtPasswd.alpha = 0.7
            self.borderStyle(self.txtPasswd,borderNom: borderPasswd)
            self.view.addSubview(self.txtPasswd)
            
            }) { (Bool) -> Void in
                return true
        }
        
        
    }
    
    func borderStyle (txtStyle:UITextField, borderNom:CALayer) {
        borderNom.borderColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.6).CGColor //底線的顏色
        borderNom.frame = CGRect(x: 0, y: txtStyle.frame.size.height - width, width:  txtStyle.frame.size.width, height: txtStyle.frame.size.height)
        borderNom.borderWidth = width
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "in" {
            var nextViewController = segue.destinationViewController as! ContainerVC
            nextViewController.name = dataArray[i]["name"] as! String
            
        }
    }
    
    
    
    @IBAction func btnLogin(sender: AnyObject) {
        
        var isConnected = checkNetworkConnection()
        
        let alert = UIAlertView()
        
        if isConnected {
            
        } else {
            alert.message = "請確認網路，尚未連線"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
        for i = 0 ; i <= dataArray.count-1 ; i++ {
            var OrNamePhone:String!
            var OrNamePasswd:String!
            OrNamePhone = dataArray[i]["phoneNumber"] as! String
            OrNamePasswd = dataArray[i]["password"] as! String
            if txtPhone.text == OrNamePhone && txtPasswd.text == OrNamePasswd {
                
                let alert = UIAlertController(title: nil, message:"登入成功", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                    self.performSegueWithIdentifier("in", sender: nil)
                    print("yes!")
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true){}
                break
            }
            else  {
                if i == dataArray.count-1{
                    let alert = UIAlertController(title: nil, message:"電話或密碼錯誤", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                    })
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true){}
                }
                print("--------------\(i)")
                print(dataArray[i]["phoneNumber"]as!String)
                print(dataArray[i]["password"]as!String)
                print("--------------")
                
            }
        }
        //        print(dataArray[i-1]["name"] as! String)
        
    }
    
    
    
    
    
    func loadData() {
        let url = NSURL(string: "http://sashihara.100hub.net/vip/memberDownload.php")
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
            
            dataArray = dataDic["member"]! as! [AnyObject]
            print("\(dataArray.count) 筆資料")
            print(dataArray[dataArray.count-1]["name"] as! String)
            
            
        }catch {
            print("ERROR")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        
        txtPasswd.secureTextEntry = true
        // Do any additional setup after loading the view.
        
        var isConnected = checkNetworkConnection()
        
        let alert = UIAlertView()
        
        if isConnected {
            
        } else {
            alert.message = "請確認網路，尚未連線"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
        
    }
    
    func checkNetworkConnection() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: NetworkStatus = reachability.currentReachabilityStatus()
        
        print(networkStatus.rawValue)
        
        switch (networkStatus.rawValue) {
        case 0:
            print("[Network Status]: NotReachable")
        case 1:
            print("[Network Status]: ReachableViaWWAN")
        case 2:
            print("[Network Status]: ReachableViaWiFi")
        default:
            break
        }
        
        return networkStatus.rawValue != 0
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
