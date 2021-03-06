//
//  UserSignUpViewController.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/22.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit

let Screen = UIScreen.mainScreen().bounds
class UserSignUpViewController: UIViewController,NSURLSessionDelegate, NSURLSessionDownloadDelegate{
    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    let signupImage = UIImage(named: "L_SignupButton") as UIImage?
    let btnSignUp   = UIButton(type: UIButtonType.Custom) as UIButton
    
    let okImage = UIImage(named: "ok") as UIImage?
    let btnOK   = UIButton(type: UIButtonType.Custom) as UIButton
    
    let txtVerificationCode: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 5, y: 85,width:10, height: 40))
    let txtAdess: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+35*6,width:20, height: 40))
    let txtPasswd: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+35*4,width:20, height: 40))
    let txtPasswdCheck: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+35*5,width:20, height: 40))
    let txtBirthday: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+35*3,width:20, height: 40))
    let txtPhone: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+35*2,width:20, height: 40))
    let txtName: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+35,width:20, height: 40))
    
    
    var check:String!
    var dataArray = [AnyObject]()
    var smsStr:String!
    var verificationCodeStr:String!
    
    
    let border = CALayer()
    
    let width = CGFloat(2.0)
    
    func alertPg (txt: String) {
        let alert = UIAlertController(title: txt , message:nil , preferredStyle: .Alert)
        let action = UIAlertAction(title: "返回填寫", style: .Default, handler: { (alert:UIAlertAction) -> Void in
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
    }
    
    // 點背景收起鍵盤
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func SMS () {
        
        
        smsStr = txtPhone.text
        let ns1 = smsStr as NSString
        verificationCodeStr = ns1.substringFromIndex(1)
        
        if txtPhone.text != "" {
            SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: verificationCodeStr as String, zone: "886", customIdentifier: nil) { (error : NSError!) -> Void in
                
                
                if (error == nil)
                {
                    print("電話\(ns1.substringFromIndex(1))")
                    print("成功,請等待簡訊～")
                    self.alertPg("成功，請等待簡訊")
                }
                else
                {
                    // 错误码可以参考‘SMS_SDK.framework / SMSSDKResultHanderDef.h’
                    print("失敗", error)
                    self.alertPg("電話有誤或每分鐘發短信數量超出限制")
                }
                
            }
        }else {
            alertPg("請輸入電話")
        }
        
    }
    
    func singUp() {
        let url = NSURL(string: "http://sashihara.100hub.net/vip/UpLoad.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        let submitBody:String = "name=\(txtName.text!)&phoneNumber=\(txtPhone.text!)&birthday=\(txtBirthday.text!)&password=\(txtPasswd.text!)&adess=\(txtAdess.text!)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
        
        
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
            print("wddd\(dataArray[dataArray.count-1]["name"] as! String)")
            
        }catch {
            print("ERROR")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        
        txtPasswd.secureTextEntry = true
        txtPasswdCheck.secureTextEntry = true
        
        txtAdess.text = "台中市南屯區公益路51號20樓"
        txtBirthday.text = "2016-01-01"
        txtName.text = "韓家豪"
        txtPasswd.text = "123"
        txtPasswdCheck.text = "123"
        txtPhone.text = "0931520406"
        
        print("我到了")
        
    }
    
    func btnOK (sender: AnyObject) {
        SMSSDK.commitVerificationCode(txtVerificationCode.text, phoneNumber: verificationCodeStr, zone: "886") { (error : NSError!) -> Void in
            if(error == nil){
                print("驗證成功")
                let alert = UIAlertController(title: nil, message:"註冊成功", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                    self.singUp()
//                    let sinup1 = UserLoginViewController()
//                    self.presentViewController(sinup1, animated: true, completion: nil)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true){}
            }else{
                print("電話驗證有誤", error)
                self.alertPg("電話驗證有誤")
            }
        }
        
    }
    
    
    func btnSignUp(sender: AnyObject) {
        
        if self.txtName.text == "" || self.txtPasswd.text == "" || self.txtBirthday.text == "" || self.txtPhone.text == "" || self.txtAdess.text == "" {
            self.alertPg("資料填寫未完成")
        }else if self.txtPasswd.text != self.txtPasswdCheck.text{
            self.alertPg("密碼確認錯誤")
        }else{
            self.check = "check"
            for var i = 0 ; i <= self.dataArray.count-1 ; i++ {
                if self.dataArray[i]["phoneNumber"] as! String == self.txtPhone.text {
                    self.alertPg("此電話已申請過")
                    self.check = "XX"
                }else if i == self.dataArray.count-1 && self.check != "XX"{
                    
                    SMS()
                    
                    
                    UIView.transitionWithView(self.view, duration: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        
                        self.txtAdess.alpha = 0.0
                        self.txtBirthday.alpha = 0.0
                        self.txtName.alpha = 0.0
                        self.txtPasswd.alpha = 0.0
                        self.txtPasswdCheck.alpha = 0.0
                        self.txtPhone.alpha = 0.0
                        self.btnSignUp.alpha = 0.0
                        self.btnOK.alpha = 1
                        
                        }) { (Bool) -> Void in
                            return true
                    }
                    
                    // 驗證碼的動畫
                    UIView.transitionWithView(self.view, duration: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        
                        self.txtVerificationCode.frame = CGRectMake(Screen.width / 2 - 150, 85, 300, 40)
                        self.txtVerificationCode.alpha = 1
                        
                        self.border.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6).CGColor //底線的顏色
                        
                        self.border.frame = CGRect(x: 0, y: self.txtVerificationCode.frame.size.height - self.width, width:  self.txtVerificationCode.frame.size.width, height: self.txtVerificationCode.frame.size.height)
                        
                        self.border.borderWidth = self.width
                        self.txtVerificationCode.alpha = 0.7
                        self.txtVerificationCode.layer.addSublayer(self.border)
                        self.txtVerificationCode.layer.masksToBounds = true
                        
                        self.view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
                        
                        }) { (Bool) -> Void in
                            return true
                    }
                    
                }
            }
        }
        
    }
    
//    func btnDemo(sender:AnyObject) {
//        
//    
//    }
    
    
    override func viewDidAppear(animated: Bool) {
        
//        let btnDemo   = UIButton(type: UIButtonType.Custom) as UIButton
//        btnDemo.frame = CGRectMake(Screen.width/2*1.7, Screen.height/2, Screen.width * 0.1, Screen.width * 0.6 / 18 * 3)
////        btnDemo.backgroundColor = UIColor.whiteColor()
//        btnDemo.setTitle("", forState: UIControlState.Normal)
//        btnDemo.addTarget(self, action: "btnDemo:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(btnDemo)
        
//        btnSignUp.frame = CGRectMake(0, Screen.height/2+100, Screen.width, 60)
        btnSignUp.frame = CGRectMake(Screen.width/10*2, Screen.height/2+100, Screen.width * 0.6, Screen.width * 0.6 / 8 * 3)
        btnSignUp.setImage(signupImage, forState: .Normal)
        btnSignUp.addTarget(self, action: "btnSignUp:", forControlEvents:.TouchUpInside)
        btnSignUp.alpha = 0
        self.view.addSubview(btnSignUp)
        
        btnOK.frame = CGRectMake(0, Screen.height/2 - 190, Screen.width, 60)
        btnOK.setImage(okImage, forState: .Normal)
        btnOK.addTarget(self, action: "btnOK:", forControlEvents:.TouchUpInside)
        btnOK.alpha = 0
        self.view.addSubview(btnOK)
        self.txtVerificationCode.alpha = 0
        
        UIView.transitionWithView(self.view, duration: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.btnSignUp.alpha = 1
            
            self.border.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6).CGColor //底線的顏色
            self.border.frame = CGRect(x: 0, y: self.txtVerificationCode.frame.size.height - self.width, width:  self.txtVerificationCode.frame.size.width, height: self.txtVerificationCode.frame.size.height)
            
            self.border.borderWidth = self.width
            self.txtVerificationCode.layer.addSublayer(self.border)
            self.txtVerificationCode.layer.masksToBounds = true
            self.txtVerificationCode.text = ""
            self.txtVerificationCode.font = UIFont.italicSystemFontOfSize(30)
            self.txtVerificationCode.textColor = UIColor.whiteColor()
            self.txtVerificationCode.attributedPlaceholder = NSAttributedString(string: "簡訊驗證碼", attributes: [NSForegroundColorAttributeName: UIColor.brownColor()])
            self.view.addSubview(self.txtVerificationCode)
            
            let borderAdess = CALayer()
            self.txtAdess.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+35*7.5, 300, 40)
            self.txtAdess.layer.addSublayer(borderAdess)
            self.txtAdess.layer.masksToBounds = true
            self.txtAdess.textColor = UIColor.whiteColor()
            self.txtAdess.font = UIFont.italicSystemFontOfSize(30)
            self.txtAdess.attributedPlaceholder = NSAttributedString(string: "住址", attributes: [NSForegroundColorAttributeName: UIColor.brownColor()])
            self.txtAdess.alpha = 0.7
            self.borderStyle(self.txtAdess,borderNom: borderAdess)
            self.view.addSubview(self.txtAdess)
            
            let borderName = CALayer()
            self.txtName.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+35*1.5, 300, 40)
            self.txtName.layer.addSublayer(borderName)
            self.txtName.layer.masksToBounds = true
            self.txtName.textColor = UIColor.whiteColor()
            self.txtName.font = UIFont.italicSystemFontOfSize(30)
            self.txtName.attributedPlaceholder = NSAttributedString(string: "會員姓名", attributes: [NSForegroundColorAttributeName: UIColor.brownColor()])
            self.txtName.alpha = 0.7
            self.borderStyle(self.txtName,borderNom: borderName)
            self.view.addSubview(self.txtName)
            
            let borderPhone = CALayer()
            self.txtPhone.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+35*2.7, 300, 40)
            self.txtPhone.layer.addSublayer(borderPhone)
            self.txtPhone.layer.masksToBounds = true
            self.txtPhone.textColor = UIColor.whiteColor()
            self.txtPhone.font = UIFont.italicSystemFontOfSize(30)
            self.txtPhone.attributedPlaceholder = NSAttributedString(string: "聯絡電話（格式：0912345678）", attributes: [NSForegroundColorAttributeName: UIColor.brownColor()])
            self.txtPhone.alpha = 0.7
            self.borderStyle(self.txtPhone,borderNom: borderPhone)
            self.view.addSubview(self.txtPhone)
            
            let borderPasswd = CALayer()
            self.txtPasswd.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+35*5.1, 300, 40)
            self.txtPasswd.layer.addSublayer(borderPasswd)
            self.txtPasswd.layer.masksToBounds = true
            self.txtPasswd.textColor = UIColor.whiteColor()
            self.txtPasswd.font = UIFont.italicSystemFontOfSize(30)
            self.txtPasswd.attributedPlaceholder = NSAttributedString(string: "設定會員密碼", attributes: [NSForegroundColorAttributeName: UIColor.brownColor()])
            self.txtPasswd.alpha = 0.7
            self.borderStyle(self.txtPasswd,borderNom: borderPasswd)
            self.view.addSubview(self.txtPasswd)
            
            let borderPasswdCheck = CALayer()
            self.txtPasswdCheck.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+35*6.3, 300, 40)
            self.txtPasswdCheck.layer.addSublayer(borderPasswdCheck)
            self.txtPasswdCheck.layer.masksToBounds = true
            self.txtPasswdCheck.textColor = UIColor.whiteColor()
            self.txtPasswdCheck.font = UIFont.italicSystemFontOfSize(30)
            self.txtPasswdCheck.attributedPlaceholder = NSAttributedString(string: "再次輸入會員密碼", attributes: [NSForegroundColorAttributeName: UIColor.brownColor()])
            self.txtPasswdCheck.alpha = 0.7
            self.borderStyle(self.txtPasswdCheck,borderNom: borderPasswdCheck)
            self.view.addSubview(self.txtPasswdCheck)
            
            let borderBirthday = CALayer()
            self.txtBirthday.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+35*3.9, 300, 40)
            self.txtBirthday.layer.addSublayer(borderBirthday)
            self.txtBirthday.layer.masksToBounds = true
            self.txtBirthday.textColor = UIColor.whiteColor()
            self.txtBirthday.font = UIFont.italicSystemFontOfSize(30)
            self.txtBirthday.attributedPlaceholder = NSAttributedString(string: "生日（格式：2016-01-01）", attributes: [NSForegroundColorAttributeName: UIColor.brownColor()])
            self.txtBirthday.alpha = 0.7
            self.borderStyle(self.txtBirthday,borderNom: borderBirthday)
            self.view.addSubview(self.txtBirthday)
            
            }) { (Bool) -> Void in
                return true
        }
        
        
        
        
        UIView.transitionWithView(self.view, duration: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            
            }) { (Bool) -> Void in
                return true
        }
        
        
        setTabBarVisible(!tabBarIsVisible(), animated: true)
        
        
    }
    
    func borderStyle (txtStyle:UITextField, borderNom:CALayer) {
        borderNom.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.4).CGColor //底線的顏色
        borderNom.frame = CGRect(x: 0, y: txtStyle.frame.size.height - width, width:  txtStyle.frame.size.width, height: txtStyle.frame.size.height)
        borderNom.borderWidth = width
        
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
    
    
}
