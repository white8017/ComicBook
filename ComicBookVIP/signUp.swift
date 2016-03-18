//
//  ViewController.swift
//  線上資料庫
//
//  Created by 韓家豪 on 2016/2/24.
//  Copyright © 2016年 韓家豪. All rights reserved.
//

import UIKit

let Screen = UIScreen.mainScreen().bounds
class ViewController: UIViewController,NSURLSessionDelegate, NSURLSessionDownloadDelegate{


//    @IBOutlet weak var txtAdess: UITextField!
//    @IBOutlet weak var txtPasswdCheck: UITextField!
//    @IBOutlet weak var txtPasswd: UITextField!
//    @IBOutlet weak var txtBirthday: UITextField!
//    @IBOutlet weak var txtPhone: UITextField!
//    @IBOutlet weak var txtName: UITextField!
//    @IBOutlet weak var verificationCode: UITextField!
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var btnOk: UIButton!

    let txtVerificationCode: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 5, y: 35,width:10, height: 40))
    let txtAdess: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+45*6,width:20, height: 40))
    let txtPasswd: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+45*4,width:20, height: 40))
    let txtPasswdCheck: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+45*5,width:20, height: 40))
    let txtBirthday: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+45*3,width:20, height: 40))
    let txtPhone: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+45*2,width:20, height: 40))
    let txtName: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 10, y: Screen.height / 8.5+45,width:20, height: 40))

    
    
    
    var check:String!
    var dataArray = [AnyObject]()
    var smsStr:String!
    var verificationCodeStr:String!


    let border = CALayer()

    let width = CGFloat(2.0)
    
    func alertPg (txt: String) {
        let alert = UIAlertController(title: txt , message:nil , preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
    }

    @IBAction func btnVerificationCode(sender: AnyObject) {
        SMSSDK.commitVerificationCode(txtVerificationCode.text, phoneNumber: verificationCodeStr, zone: "886") { (error : NSError!) -> Void in
            if(error == nil){
                print("驗證成功")
                let alert = UIAlertController(title: nil, message:"註冊成功", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                    self.singUp()
                    self.performSegueWithIdentifier("singup", sender: nil)
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true){}
            }else{
                print("電話驗證有誤", error)
                self.alertPg("電話驗證有誤")
            }
        }
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
    
    @IBAction func btnUpdate(sender: AnyObject) {
        
        
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
                                self.btnGo.alpha = 0.0
                                
                                }) { (Bool) -> Void in
                                    return true
                            }

                            // 驗證碼的動畫
                            UIView.transitionWithView(self.view, duration: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in

                                self.txtVerificationCode.frame = CGRectMake(Screen.width / 2 - 150, 35, 300, 40)
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
        
//        let txtVerificationCode: UITextField = UITextField(frame: CGRect(x: Screen.width / 2 - 150, y: 35,width:300, height: 40));
        
        
        

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewDidAppear(animated: Bool) {

            self.txtVerificationCode.alpha = 0
        UIView.transitionWithView(self.view, duration: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.border.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6).CGColor //底線的顏色
            self.border.frame = CGRect(x: 0, y: self.txtVerificationCode.frame.size.height - self.width, width:  self.txtVerificationCode.frame.size.width, height: self.txtVerificationCode.frame.size.height)
            
            self.border.borderWidth = self.width
            self.txtVerificationCode.layer.addSublayer(self.border)
            self.txtVerificationCode.layer.masksToBounds = true
            self.txtVerificationCode.text = ""
            self.txtVerificationCode.textColor = UIColor.whiteColor()
            self.txtVerificationCode.attributedPlaceholder = NSAttributedString(string: "簡訊驗證碼", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            self.view.addSubview(self.txtVerificationCode)
            
            let borderAdess = CALayer()
            self.txtAdess.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+45*6, 300, 40)
            self.txtAdess.layer.addSublayer(borderAdess)
            self.txtAdess.layer.masksToBounds = true
            self.txtAdess.textColor = UIColor.whiteColor()
            self.txtAdess.attributedPlaceholder = NSAttributedString(string: "住址", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            self.txtAdess.alpha = 0.7
            self.borderStyle(self.txtAdess,borderNom: borderAdess)
            self.view.addSubview(self.txtAdess)
            
            let borderName = CALayer()
            self.txtName.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+45, 300, 40)
            self.txtName.layer.addSublayer(borderName)
            self.txtName.layer.masksToBounds = true
            self.txtName.textColor = UIColor.whiteColor()
            self.txtName.attributedPlaceholder = NSAttributedString(string: "姓名", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            self.txtName.alpha = 0.7
            self.borderStyle(self.txtName,borderNom: borderName)
            self.view.addSubview(self.txtName)
            
            let borderPhone = CALayer()
            self.txtPhone.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+45*2, 300, 40)
            self.txtPhone.layer.addSublayer(borderPhone)
            self.txtPhone.layer.masksToBounds = true
            self.txtPhone.textColor = UIColor.whiteColor()
            self.txtPhone.attributedPlaceholder = NSAttributedString(string: "電話:0912345678", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            self.txtPhone.alpha = 0.7
            self.borderStyle(self.txtPhone,borderNom: borderPhone)
            self.view.addSubview(self.txtPhone)
            
            let borderPasswd = CALayer()
            self.txtPasswd.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+45*4, 300, 40)
            self.txtPasswd.layer.addSublayer(borderPasswd)
            self.txtPasswd.layer.masksToBounds = true
            self.txtPasswd.textColor = UIColor.whiteColor()
            self.txtPasswd.attributedPlaceholder = NSAttributedString(string: "密碼", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            self.txtPasswd.alpha = 0.7
            self.borderStyle(self.txtPasswd,borderNom: borderPasswd)
            self.view.addSubview(self.txtPasswd)
            
            let borderPasswdCheck = CALayer()
            self.txtPasswdCheck.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+45*5, 300, 40)
            self.txtPasswdCheck.layer.addSublayer(borderPasswdCheck)
            self.txtPasswdCheck.layer.masksToBounds = true
            self.txtPasswdCheck.textColor = UIColor.whiteColor()
            self.txtPasswdCheck.attributedPlaceholder = NSAttributedString(string: "確認密碼", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            self.txtPasswdCheck.alpha = 0.7
            self.borderStyle(self.txtPasswdCheck,borderNom: borderPasswdCheck)
            self.view.addSubview(self.txtPasswdCheck)
            
            let borderBirthday = CALayer()
            self.txtBirthday.frame = CGRectMake(Screen.width / 2 - 150, Screen.height / 8.5+45*3, 300, 40)
            self.txtBirthday.layer.addSublayer(borderBirthday)
            self.txtBirthday.layer.masksToBounds = true
            self.txtBirthday.textColor = UIColor.whiteColor()
            self.txtBirthday.attributedPlaceholder = NSAttributedString(string: "生日:1992-04-06", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
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


}

