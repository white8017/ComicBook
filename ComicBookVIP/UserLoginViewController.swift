//
//  Log&RegViewController.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/22.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController, NSURLSessionDelegate, NSURLSessionDownloadDelegate  {

    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var dataArray = [AnyObject]()
    var i = 0;
    let width = CGFloat(2.0)
    
//    var userDefault = NSUserDefaults.standardUserDefaults() // 就像是在 Android 上的 SharedPreference一樣，暫存於 App 中，直到程式被移除才會消失
    
    var txtPhone: UITextField = UITextField(frame: CGRect(x: Screen.width / 2, y: Screen.height / 5, width:20, height: 40))
    var txtPasswd: UITextField = UITextField(frame: CGRect(x: Screen.width / 2, y: Screen.height / 5 * 1.5, width:20, height: 40))
    
    let loginW = Screen.width * 0.25
    let loginH = Screen.width * 0.25 / 43 * 16
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    // 點背景收起鍵盤
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
            print("phoneNumber: \(appDelegate.phoneNumber)")

//        print("storedNumber : \(appDelegate.storedNumber!)")
        
        UIView.transitionWithView(self.view, duration: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            //背景
            self.view.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.9)
            
            //登入電話
            let borderPhone = CALayer()
            self.txtPhone.frame = CGRectMake(Screen.width / 5, Screen.height / 5, Screen.width / 5 * 3, 40)
            self.txtPhone.layer.addSublayer(borderPhone)
            self.txtPhone.layer.masksToBounds = true
            self.txtPhone.textColor = UIColor.brownColor()
            self.txtPhone.attributedPlaceholder = NSAttributedString(string: "電話", attributes: [NSForegroundColorAttributeName: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.85)])
            self.txtPhone.alpha = 1
            self.borderStyle(self.txtPhone, borderNom: borderPhone)
            self.view.addSubview(self.txtPhone)
            //登入密碼
            let borderPasswd = CALayer()
            self.txtPasswd.frame = CGRectMake(Screen.width / 5, Screen.height / 5 * 1.5, Screen.width / 5 * 3, 40)
            self.txtPasswd.layer.addSublayer(borderPasswd)
            self.txtPasswd.layer.masksToBounds = true
            self.txtPasswd.textColor = UIColor.brownColor()
            self.txtPasswd.attributedPlaceholder = NSAttributedString(string: "密碼", attributes: [NSForegroundColorAttributeName: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.85)])
            self.txtPasswd.alpha = 1
            self.borderStyle(self.txtPasswd, borderNom: borderPasswd)
            self.view.addSubview(self.txtPasswd)
            
            
            
            
            }) { (Bool) -> Void in
                return true
        }
        
        print("[ Screen width : Screen height => \(Screen.width) : \(Screen.height) ]")
        
        
        //hide tabbar 
        setTabBarVisible(!tabBarIsVisible(), animated: true)

        
        
//        btnLogin.frame = CGRect(x: Screen.width / 4, y: Screen.height / 2, width: loginW, height: loginH)
//        btnSignup.frame = CGRect(x: Screen.width / 4, y: Screen.height / 2 * 1.5, width: loginW, height: loginH)
        
//        btnLogin.frame.size.width = loginW
//        btnLogin.frame.size.height = loginH
//        
//        btnSignup.frame.size.width = loginW
//        btnSignup.frame.size.height = loginH
//        
//        btnLogin.center = CGPointMake(Screen.width / 2, Screen.height / 5 * 2.5)
//        btnSignup.center = CGPointMake(Screen.width / 2, Screen.height / 5 * 3.7)
        
//        print("AAAAAA\(btnLogin.center.x)")
//        self.view.addSubview(self.btnLogin)
//        self.view.addSubview(self.btnSignup)
        
        
    }
    
    func borderStyle (txtStyle:UITextField, borderNom:CALayer) {
        borderNom.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1).CGColor //底線的顏色
        borderNom.frame = CGRect(x: 0, y: txtStyle.frame.size.height - width, width:  txtStyle.frame.size.width, height: txtStyle.frame.size.height)
        borderNom.borderWidth = width
        
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
//                    self.performSegueWithIdentifier("in", sender: nil)

                    
                    self.appDelegate.account = self.dataArray[self.i]["name"] as! String
//                    self.appDelegate.phoneNumber = self.dataArray[self.i]["phoneNumber"] as! String
                    self.appDelegate.userDefault.setObject(self.dataArray[self.i]["phoneNumber"] as! String, forKey: "phoneNumber")
                    self.appDelegate.userDefault.setObject(self.dataArray[self.i]["name"] as! String, forKey: "name")
                    self.appDelegate.userDefault.synchronize()
                    
//                    var storedNumber = self.userDefault.objectForKey("phoneNumber")
                    
//                    self.appDelegate.phoneNumber = storedNumber! as! String
                    print("appDelegatePhone \(self.appDelegate.phoneNumber)")
                    
                    
                    let storyboard : UIStoryboard = UIStoryboard(
                        name: "Main",
                        bundle: nil)
                    //var a: ContainerVC = storyboard.instantiateViewControllerWithIdentifier("VC") as! ContainerVC
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                    //self.presentViewController(a, animated: true, completion: nil)
                    
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
    
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
