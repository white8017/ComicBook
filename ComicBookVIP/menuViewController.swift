//
//  menuViewController.swift
//  collection
//
//  Created by iii-user on 2016/3/21.
//  Copyright © 2016年 plasma018. All rights reserved.
//

import UIKit

class menuViewController: UIViewController,NSURLSessionDelegate,UITableViewDataSource,UITableViewDelegate{
	//漫畫總數
	var amount = 0
	//漫畫金流
	var money = 100
	
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	var menuArray = [menuO]()
	var bookimage = [String:UIImage]()
	var book = [[String]]()
	var open = [CGFloat]()
	var tableView =  UITableView()
	var booknumber = UILabel()
	var bookmoney = UILabel()
	
	var epsoide = ["第1集","第2集","第3集","第4集","第5集","第6集","第7集","第8集","第9集","第10集","第11集","第12集","第13集","第14集","第15集","第16集","第17集","第18集","第19集","第20集","第21集","第22集","第23集","第24集","第25集","第26集","第27集","第28集","第29集","第30集","第31集","第32集","第33集","第34集","第35集","第36集","第37集","第38集","第39集","第40集","第41集","第42集","第43集","第44集","第45集","第46集","第47集","第48集","第49集","第50集","第51集","第52集","第53集","第54集","第55集"]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print("借閱書籍:\(appDelegate.orderBooktTitle)")
		print("借閱書本數:\(appDelegate.orderBookNumber)")
		
		
		for(var i = 0;i<appDelegate.orderBookNumber.count;i++){
			open.append(0)
		}
		for number in appDelegate.orderBookNumber{
			for _ in number.1{
				amount++
			}
		}
		print("書本總數=\(amount)")
		
		let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height/10))
		navigationBar.backgroundColor = UIColor.whiteColor()
		let navigationItem = UINavigationItem()
		let leftButton = UIBarButtonItem(title: "CANCEL", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
		navigationItem.leftBarButtonItem = leftButton
		navigationItem.title = "我的訂單"
		navigationBar.items = [navigationItem]
		self.view.addSubview(navigationBar)
		
		
		tableView = UITableView(frame:CGRect(x:0, y: navigationBar.frame.maxY, width: self.view.frame.size.width, height: self.view.frame.size.height/10*9), style: UITableViewStyle.Plain)
		tableView.separatorColor = UIColor.clearColor()
		self.view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
		
		
		let bottom = UIView(frame:CGRect(x: 0, y:  self.view.frame.size.height*7/8, width: self.view.frame.size.width, height: self.view.frame.size.height/8))
		bottom.backgroundColor = UIColor.grayColor()
		self.view.addSubview(bottom)
		
		let tap = UITapGestureRecognizer(target: self, action:"sendOrder")
		bottom.addGestureRecognizer(tap)
		
		
		let book = UIImageView(frame: CGRect(x:bottom.frame.size.width/6, y: bottom.frame.size.height/8, width: bottom.frame.size.width/6, height: bottom.frame.size.height/8*6))
		booknumber.frame = CGRect(x:book.frame.maxX+20, y: bottom.frame.size.height/8, width: bottom.frame.size.width/6, height: bottom.frame.size.height/8*6)
		booknumber.text = "\(amount)"
		booknumber.font = UIFont.systemFontOfSize(30)
		let money = UIImageView(frame: CGRect(x: booknumber.frame.maxX, y: bottom.frame.size.height/8, width: bottom.frame.size.width/6, height: bottom.frame.size.height/8*6))
		bookmoney.frame = CGRect(x:money.frame.maxX+20, y: bottom.frame.size.height/8, width: bottom.frame.size.width/6, height: bottom.frame.size.height/8*6)
		bookmoney.text = "\(5*amount)"
		bookmoney.font = UIFont.systemFontOfSize(30)
		
		money.image = UIImage(named: "attach_money_48px_1181665_easyicon.net")
		book.image = UIImage(named: "book_bookmark_36.463519313305px_1185565_easyicon.net")
		bottom.addSubview(booknumber)
		bottom.addSubview(book)
		bottom.addSubview(money)
		bottom.addSubview(bookmoney)
		
	}
	
	func cancel(){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	
	//借閱訂單
	func sendOrder(){
		print(appDelegate.orderBooktTitle)
		let alertController=UIAlertController(title: "謝謝借閱", message: "\n\n\n\n", preferredStyle: UIAlertControllerStyle.Alert)
		
		
		let indicator = UIActivityIndicatorView(frame: alertController.view.bounds)
		indicator.color = UIColor.blackColor()
		indicator.transform =  CGAffineTransformMakeScale(3, 3)
		indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		alertController.view.addSubview(indicator)
		indicator.userInteractionEnabled = false;
		
		
		
		let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
		let enterAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.Destructive) { (UIAlertAction) -> Void in
			let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
			dispatch_async(queue, { () -> Void in
				for order in self.appDelegate.orderBookNumber{
					for a in order.1{
						print(self.epsoide[Int(a)!])
						self.updateData(5, name: self.appDelegate.account, bookName: order.0, nowStage: self.epsoide[Int(a)!])
					}
					
				}
				self.appDelegate.orderBooktTitle = []
				NSNotificationCenter.defaultCenter().postNotificationName("addMenu", object: self)
				self.appDelegate.orderBookNumber = [String:[String]]()
				
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					indicator.startAnimating()
					
				})
				
			})
			
			
			
			
			
			
			
		}
		
		alertController.addAction(cancelAction)
		alertController.addAction( enterAction)
//		self.presentViewController(alertController, animated:alertController, completion: nil)
		self.presentViewController(alertController, animated: true) { () -> Void in
		
		}
		
		
		
		
	}
	
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//展開選單
	func tap(gestureReconizer: UITapGestureRecognizer){
		
		print((gestureReconizer.view?.tag)!)
		
		if open[(gestureReconizer.view?.tag)!] == 0{
			open[(gestureReconizer.view?.tag)!]  = 80
		}else{
			open[(gestureReconizer.view?.tag)!]  = 0
		}
		for (var i = 0;i<open.count;i++){
			if i != (gestureReconizer.view?.tag)!{
				open[i] = 0
			}
		}
		tableView.reloadData()
	}
	
	
	//tableView功能
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return appDelegate.orderBooktTitle.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return appDelegate.orderBookNumber[appDelegate.orderBooktTitle[section]]!.count
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuTableViewCell
		cell.cellEpisode.text = epsoide[Int(appDelegate.orderBookNumber[appDelegate.orderBooktTitle[indexPath.section]]![indexPath.row])!]
		
		return cell
	}
	
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return CGFloat(open[indexPath.section])
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		menuArray.append(menuO(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80)))
		
		menuArray[section].tag = section
		
		menuArray[section].celltitle.text = appDelegate.orderBooktTitle[section]
		
		menuArray[section].cellImageView.image = appDelegate.orderBookImage[appDelegate.orderBooktTitle[section]]
		
		menuArray[section].cellNumber.text = String(appDelegate.orderBookNumber[appDelegate.orderBooktTitle[section]]!.count)
		
		menuArray[section].cellmoney.text =	"$"+String(appDelegate.orderBookNumber[appDelegate.orderBooktTitle[section]]!.count*5)
		let tap = UITapGestureRecognizer(target: self, action:"tap:")
		menuArray[section].addGestureRecognizer(tap)
		
		return menuArray[section]
		
	}
	
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 80
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete{
			appDelegate.orderBookNumber[appDelegate.orderBooktTitle[indexPath.section]]?.removeAtIndex(indexPath.row)
		}
		amount--
		booknumber.text = "\(amount)"
		bookmoney.text = "\(5*amount)"
		
		if appDelegate.orderBookNumber[appDelegate.orderBooktTitle[indexPath.section]]! == []{
			appDelegate.orderBooktTitle.removeAtIndex(indexPath.section)
		}
		
		NSNotificationCenter.defaultCenter().postNotificationName("addMenu", object: self)
		tableView.reloadData()
		print("訂閱書本總數:\(appDelegate.orderBookNumber)")
		print("訂閱書本:\(appDelegate.orderBooktTitle)")
		
		
	}
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print(indexPath.section)
		print(indexPath.row)
	}
	
	//上傳訂單
	var now = NSDate()
	func updateData(price:Int,name:String,bookName:String,nowStage:String) {
		let to = NSDate(timeIntervalSinceNow: (24*60*60) * 5)
		let interval1 = to.timeIntervalSinceDate(now) / (3600*24)
		
		// now 改時區
		let formatter = NSDateFormatter();
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
		formatter.timeZone = NSTimeZone(abbreviation: "HKT")
		let now8 = formatter.stringFromDate(now)
		let to8 = formatter.stringFromDate(to)
		print(now8)
		print(to8)
		
		
		print(interval1)
		let url = NSURL(string: "http://sashihara.100hub.net/vip/historyUpload.php")
		let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
		let submitBody:String = "rentDate=\(now8)&returnDate=\(to8)&price=\(price)&name=\(name)&bookName=\(bookName)&nowStage=\(nowStage)"
		
		request.HTTPMethod = "POST"
		request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
		
		let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
		let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		
		let dataTask = session.downloadTaskWithRequest(request)
		dataTask.resume()
		
//		dispatch_async(dispatch_get_main_queue()) { () -> Void in
//			
//			self.dismissViewControllerAnimated(true, completion: nil)
//		}
		
	}
}

class menuO:UIView {
	var cellImageView = UIImageView()
	var celltitle = UILabel()
	var cellNumber = UILabel()
	var cellmoney = UILabel()
	var amount = 0
	var money = 100
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.grayColor()
		
		
		cellImageView.frame =  CGRect(x: 20, y: 0, width: self.bounds.size.width/4, height: self.bounds.size.height)
		celltitle.frame = CGRect(x: cellImageView.frame.maxX+20, y: 0, width: self.bounds.size.width/4, height: self.bounds.size.height)
		cellNumber.frame = CGRect(x: celltitle.frame.maxX+20, y: 0, width: self.bounds.size.width/8, height: self.bounds.size.height)
		cellNumber.backgroundColor = UIColor.redColor()
		cellNumber.textAlignment = NSTextAlignment.Center
		cellmoney.frame = CGRect(x: cellNumber.frame.maxX+20, y: 0, width: self.bounds.size.width/8, height: self.bounds.size.height)
		
		cellNumber.text = String(amount)
		cellmoney.text = "$"+String(money)
		
		cellImageView.image = UIImage(named: "第一神拳")
		celltitle.text = "第ㄧ神拳"
		self.addSubview(cellImageView)
		self.addSubview(celltitle)
		self.addSubview(cellNumber)
		self.addSubview(cellmoney)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}


