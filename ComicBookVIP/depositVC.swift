//
//  depositVC.swift
//  線上資料庫
//
//  Created by 韓家豪 on 2016/3/9.
//  Copyright © 2016年 韓家豪. All rights reserved.
//

import UIKit

class depositVC: UIViewController, NSURLSessionDelegate  {

    @IBOutlet weak var txtDeposit: UITextField!
    @IBOutlet weak var txtPhone: UITextField!

    var total = 0
    
    let img50 = UIImage(named: "50NT") as UIImage?
    let btn50   = UIButton(type: UIButtonType.Custom) as UIButton
    
    let img100 = UIImage(named: "100NT") as UIImage?
    let btn100   = UIButton(type: UIButtonType.Custom) as UIButton
    
    let img200 = UIImage(named: "200NT") as UIImage?
    let btn200   = UIButton(type: UIButtonType.Custom) as UIButton
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.transitionWithView(self.view, duration: 1.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.view.backgroundColor = UIColor.blackColor()
            }) { (Bool) -> Void in
                return true
        }
        

        
        btn50.frame = CGRectMake(Screen.width/2+30, 30, 150, 150)
        btn50.setImage(img50, forState: .Normal)
        btn50.addTarget(self, action: "btn50:", forControlEvents:.TouchUpInside)
        self.view.addSubview(btn50)

        
        btn100.frame = CGRectMake(Screen.width/2+30, 210, 150, 150)
        btn100.setImage(img100, forState: .Normal)
        btn100 .addTarget(self, action: "btn100:", forControlEvents:.TouchUpInside)
        self.view.addSubview(btn100)
        
        
        btn200.frame = CGRectMake(Screen.width/2+30, 390, 150, 150)
        btn200.setImage(img200, forState: .Normal)
        btn200 .addTarget(self, action: "btn200:", forControlEvents:.TouchUpInside)
        self.view.addSubview(btn200)
    }
    
    func btn50(sender:AnyObject) {
        total = total + 50
        txtDeposit.text = String(format: "%d", total)
    }
    func btn100(sender:AnyObject) {
        total = total + 100
        txtDeposit.text = String(format: "%d", total)
    }
    func btn200(sender:AnyObject) {
        
        total = total + 200
        txtDeposit.text = String(format: "%d", total)
    }
    
    
    
    func alertPg (txt: String) {
        let alert = UIAlertController(title: txt , message:nil , preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
    }
    
    
    @IBAction func btnDeposit(sender: AnyObject) {
        if txtPhone.text! == ""  {
            txtPhone.placeholder = "請輸入電話！"
        }else if txtDeposit.text! == "" {
            txtDeposit.placeholder = "請輸入金額！"
        }else {
            let alert = UIAlertController(title: "儲值確認", message: "電話為\(txtPhone.text!)\n儲值金額\(txtDeposit.text!)", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                self.alertPg("儲值完畢")
                self.loadData()

                
            })
            let action2 = UIAlertAction(title: "取消", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                
            })
            alert.addAction(action)
            alert.addAction(action2)
            self.presentViewController(alert, animated: true){}
        }
    }

    func loadData() {

        let url = NSURL(string: "http://sashihara.100hub.net/vip/updateDeposit.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        let submitBody:String = "deposit=\(txtDeposit.text!)&phoneNumber=\(txtPhone.text!)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
