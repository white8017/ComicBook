//
//  1111.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/17.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit
import AVFoundation

class m4_OderFrorm: UIViewController, UIApplicationDelegate, UITableViewDelegate, UITableViewDataSource,NSURLSessionDelegate, NSURLSessionDownloadDelegate,AVCaptureMetadataOutputObjectsDelegate {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var DynamicView=UIView(frame: CGRectMake(0, Screen.height*1.2, Screen.width, Screen.height/2))
    let btnBack   = UIButton(type: UIButtonType.Custom) as UIButton
    var dataArray = [AnyObject]()
    var i = 0
    var totalArray = [AnyObject]()
    var sum = 0
    var imgQRCode:UIImageView = UIImageView()
    var qrcodeImage: CIImage!
    
    var captureSession:AVCaptureSession?
    var previewLayer:AVCaptureVideoPreviewLayer?
    var name = ""
    
    
    @IBOutlet weak var myTableView: UITableView!
    func alertPg (txt: String) {
        let alert = UIAlertController(title: txt , message:nil , preferredStyle: .Alert)
        let action = UIAlertAction(title: "完成付款", style: .Default, handler: { (alert:UIAlertAction) -> Void in

        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true){}
    }

    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    //http://ithelp.ithome.com.tw/question/10159865
    //自訂back
    @IBAction func backButton(sender: AnyObject) {
        //http://www.cocoachina.com/bbs/read.php?tid=260688
        //self.navigationController?.popViewControllerAnimated(true)
        //self.navigationController?.pushViewController(self.storyboard?.instantiateViewControllerWithIdentifier("HomePage") as! t1_NewsViewContorller, animated: true)
        //tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        setTabBarVisible(!tabBarIsVisible(), animated: true)
        
        
        let userLbl = self.view.viewWithTag(301) as! UILabel
        if appDelegate.vip == "1" {
            userLbl.text = ""
        }else {
            userLbl.text = "\(appDelegate.account) 的訂單"
        }
        btnBack.frame = CGRectMake(DynamicView.frame.width*0.1, DynamicView.frame.height*0.1, Screen.width * 0.1, Screen.width * 0.1)
        btnBack.setTitle("返回", forState: .Normal)
        btnBack.layer.cornerRadius = 10
        //        btnBack.layer.shadowRadius = 2.9
        btnBack.layer.shadowOpacity = 0.3
        btnBack.backgroundColor = UIColor(red: 1, green: 0.7, blue: 0, alpha: 1)
        btnBack.addTarget(self, action: "btnBack:", forControlEvents: UIControlEvents.TouchUpInside)
        DynamicView.addSubview(btnBack)
        
        let a = DynamicView.frame.width/2
        imgQRCode.frame = CGRectMake(DynamicView.frame.width/2-a/2, DynamicView.frame.height/2-a/2, a, a)
        DynamicView.addSubview(imgQRCode)
        
        
            // QRCode 掃描
        print("vip = \(appDelegate.vip)")
        if appDelegate.vip == "1" {
            print("我跑囉")
            //        view.backgroundColor = UIColor.blackColor()
            captureSession = AVCaptureSession()
            
            let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            let videoInput: AVCaptureDeviceInput
            
            do {
                videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                return
            }
            
            if (captureSession!.canAddInput(videoInput)) {
                captureSession!.addInput(videoInput)
            } else {
                failed();
                return;
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (captureSession!.canAddOutput(metadataOutput)) {
                captureSession!.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
                metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            } else {
                failed()
                return
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
            previewLayer!.frame = view.layer.bounds;
            previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill;
            view.layer.addSublayer(previewLayer!);
            
            captureSession!.startRunning();
            // 到這
        }

    }

    
    override func viewDidLoad() {
        loadOrderForm()
     
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession!.startRunning();
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession!.stopRunning();
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession!.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func foundCode(code: String) {
        // 掃描後做的事情
        updateOrderForm(code.componentsSeparatedByString("!")[1])
        Checkout(code.componentsSeparatedByString("!")[0])
        self.navigationController?.popToRootViewControllerAnimated(true)
        sleep(1)
        NSNotificationCenter.defaultCenter().postNotificationName("check", object: nil)

    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    //http://www.jianshu.com/p/56c8b3c1403c
    //hide Tabbar
    func btnBack(sender:AnyObject) {
        
        UIView.transitionWithView(self.view, duration: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.DynamicView.frame = CGRectMake(0, Screen.height*1.2, Screen.width, Screen.height/2)
            self.DynamicView.backgroundColor = UIColor(red: 0.4, green: 1, blue: 1, alpha: 0.0)
            
            
//            self.imgQRCode.image = nil
//            self.qrcodeImage = nil

            }) { (Bool) -> Void in
                return true
                
        }

    }
    
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
    
    
    //以下豪哥
    

    @IBAction func btnCheck(sender: AnyObject) {
//        Checkout()
//        DynamicView.backgroundColor=UIColor.greenColor()
        DynamicView.layer.cornerRadius=25
        DynamicView.layer.borderWidth=2
        DynamicView.targetForAction("view2", withSender: self)
        self.view.addSubview(DynamicView)
        UIView.transitionWithView(self.view, duration: 0.7, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.DynamicView.frame = CGRectMake(0, Screen.height*0.2, Screen.width, Screen.height/2)
            self.DynamicView.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 1, alpha: 0.7)
            
            }) { (Bool) -> Void in
                return true
        }
        
        // QRCode
        if qrcodeImage == nil {
            let data = "deposit=\(sum)&phoneNumber=\(appDelegate.phoneNumber)!\(appDelegate.account)".dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            print(name)
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            imgQRCode.image = UIImage(CIImage: qrcodeImage)
        }else {
//            imgQRCode.image = nil
//            qrcodeImage = nil
        }
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let lblTotal = self.view.viewWithTag(101) as! UILabel
        let lblBookName = cell.viewWithTag(202) as! UILabel
        let lblNowStage = cell.viewWithTag(203) as! UILabel
        let lblPrice = cell.viewWithTag(204) as! UILabel
        
        lblBookName.text = dataArray[indexPath.row]["bookName"] as? String
        lblNowStage.text = dataArray[indexPath.row]["nowStage"] as? String
        lblPrice.text = "\((dataArray[indexPath.row]["price"] as? String)!) 元"
        
        lblTotal.text = "總計 : \(String(format: "%d", sum)) 元"
        
        return cell
        
    }
    
    func loadOrderForm() {
        let url = NSURL(string: "http://sashihara.100hub.net/vip/rentHistoryOrderFrom.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        //        let submitName = ""
        
        let submitBody: String = "name=\(appDelegate.account)"
//        print("loadOrderForm : \(appDelegate.account)")
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
        
    }
    func updateOrderForm(sqlName:String) {
        let url = NSURL(string: "http://sashihara.100hub.net/vip/rentHistoryOrderUpdate.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        let submitBody: String = "name=\(sqlName)"

        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
        
    }
    
    func Checkout(sqlBody:String) {
        let url = NSURL(string: "http://sashihara.100hub.net/vip/updateDepositCheckout.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        //        let submitName = ""
        print(sum)
        
        let submitBody: String = "\(sqlBody)"
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
        print("ok")
        sum = 0
        
    }
    
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        if sum == 0 {
            do {
                let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                
                dataArray = dataDic["rentHistory"]! as! [AnyObject]
                print("\(dataArray.count) 筆資料")
                print("\(dataArray)")
                
                for var q = 0 ; q < dataArray.count ; q++ {
                    totalArray.append((dataArray[q]["price"] as? String)!)
                }
                print(totalArray)
                
                for (var i = 0; i < dataArray.count; i++) {
                    sum = sum + Int(totalArray[i] as! String)!
                }
                
                
                myTableView.reloadData()
            }catch {
                print("ERROR rentHistory")
            }
        }
    }
    
    
    func theToggleMenu(sender:UIBarButtonItem) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    func toHome(sender:UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
