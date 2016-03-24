//  menuTbleView.swift
//  collection
//  Created by iii-user on 2016/3/21.
//  Copyright © 2016年 plasma018. All rights reserved.

import UIKit

class menuTbleView: UITableView,UITableViewDelegate,UITableViewDataSource{
	var bookimage = [String:UIImage]()
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	var orderbook = [String]()
	var orderbook2 = [String:[String]]()
	var book = [[String]]()
	var open = [CGFloat]()
	var menuArray = [menu]()
	var epsoide = ["第1集","第2集","第3集","第4集","第5集","第6集","第7集","第8集","第9集","第10集","第11集","第12集","第13集","第14集","第15集","第16集","第17集","第18集","第19集","第20集","第21集","第22集","第23集","第24集","第25集","第26集","第27集","第28集","第29集","第30集","第31集","第32集","第33集","第34集","第35集","第36集","第37集","第38集","第39集","第40集","第41集","第42集","第43集","第44集","第45集","第46集","第47集","第48集","第49集","第50集","第51集","第52集","第53集","第54集","第55集"]
	
	override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
		self.delegate = self
		self.dataSource = self
		self.registerClass(MenuTableViewCell.self, forCellReuseIdentifier: "cell")
		
		orderbook2 = appDelegate.orderBookA
		orderbook = appDelegate.orderbook
		
		
		for(var i = 0;i<orderbook2.count;i++){
			open.append(0)
		}
		
		
		
	}
	
	func tap(gestureReconizer: UITapGestureRecognizer){
		
		print((gestureReconizer.view?.tag)!)
		
		if open[(gestureReconizer.view?.tag)!] == 0{
			open[(gestureReconizer.view?.tag)!]  = 80
			
			self.reloadData()
		}else{
			open[(gestureReconizer.view?.tag)!]  = 0
			self.reloadData()
		}
		
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	 func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return orderbook2.count
	}
	
	 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		print("book[section].count:\(book[section].count)")
		return orderbook2[orderbook[section]]!.count
	}

	
	
	
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuTableViewCell
		cell.cellEpisode.text = epsoide[Int(orderbook2[orderbook[indexPath.section]]![indexPath.row])!]
		
		return cell
	}
	
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return CGFloat(open[indexPath.section])
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		menuArray.append(menu(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 80)))
		menuArray[section].tag = section
		menuArray[section].celltitle.text = orderbook[section]
		menuArray[section].cellImageView.image = appDelegate.orderBookImage[orderbook[section]]
		menuArray[section].cellNumber.text = String(orderbook2[orderbook[section]]!.count)
		menuArray[section].cellmoney.text =	"$"+String(orderbook2[orderbook[section]]!.count*5)
		let tap = UITapGestureRecognizer(target: self, action:"tap:")
		menuArray[section].addGestureRecognizer(tap)
		return menuArray[section]
		
	}
	
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 80
	}
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            appDelegate.orderBookA[appDelegate.orderbook[indexPath.section]]?.removeAtIndex(indexPath.row)
        }
        print("appDelegate.orderBookA:\(appDelegate.orderBookA)")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
             self.reloadData()
             self.window?.rootViewController?.view.reloadInputViews()
        }
       
    
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.section)
        print(indexPath.row)
    }
	
	

	
	

	
	
}


class menu:UIView {
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




