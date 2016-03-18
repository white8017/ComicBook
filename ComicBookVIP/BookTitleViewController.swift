//  BookTitleViewController.swift
//  collection
//  Created by plasma018 on 2016/3/10.
//  Copyright © 2016年 plasma018. All rights reserved.


import UIKit
private let reuseIdentifier = "Cell"

class BookTitleViewController: UIViewController,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,NSURLSessionDelegate,NSURLSessionDownloadDelegate,UIPopoverPresentationControllerDelegate{
	var scroll:UIScrollView!
	var scrollContent:UIScrollView!
    var mydb:COpaquePointer=nil;
	var items = [String]()
	var customSC = UISegmentedControl()
    var bookContent:[CostumCollectionView] = []
	var myIndicator: UIActivityIndicatorView!

	
	
    override func viewDidAppear(animated: Bool) {
//			print("view Did Appear")
		    }
	
	
	func setView(){
		let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height/10))
		navigationBar.backgroundColor = UIColor.whiteColor()
		let navigationItem = UINavigationItem()
		navigationItem.title = "漫畫分類"
		let leftButton =  UIBarButtonItem(title: "Save", style:   UIBarButtonItemStyle.Plain, target: self, action: nil)
		let rightButton = UIBarButtonItem(title: "Right", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
		navigationItem.leftBarButtonItem = leftButton
		navigationItem.rightBarButtonItem = rightButton
		
		
		navigationBar.items = [navigationItem]
		self.view.addSubview(navigationBar)
		

		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 10)
		layout.itemSize = CGSize(width: 100, height: 140)
		let itemsWidth = self.view.frame.size.width/3
		
		
		//漫畫分類選單滑動容器
		self.scroll = UIScrollView(frame: CGRect(x: 0, y:navigationBar.frame.maxY, width: self.view.frame.size.width, height: self.view.frame.size.height/15))
		self.scroll.showsHorizontalScrollIndicator = false
		self.scroll.showsVerticalScrollIndicator = false
		self.scroll.contentSize = CGSize(width:itemsWidth*CGFloat(self.items.count), height: self.view.frame.size.height/15)
		
		self.scroll.backgroundColor = UIColor.redColor()
		self.scroll.delegate = self
		self.scroll.tag = 1
		
		
		
		
		//漫畫分類選單按鈕 UISegmentedControl
		
		self.customSC = UISegmentedControl(items: self.items)
		self.customSC.selectedSegmentIndex = 0
		self.customSC.frame = CGRectMake(0,0,itemsWidth*CGFloat(self.items.count),self.scroll.frame.height)
		
		self.customSC.layer.cornerRadius = 5
		self.customSC.backgroundColor = UIColor.blackColor()
		self.customSC.tintColor = UIColor.whiteColor()
		self.customSC.addTarget(self, action: "pageChange:", forControlEvents: UIControlEvents.ValueChanged)
		
		
		
		//漫畫內容滑動容器
		self.scrollContent =  UIScrollView(frame: CGRect(x: 0, y: self.scroll.frame.maxY, width:  self.view.frame.size.width, height:self.view.frame.size.height-self.scroll.frame.maxY))
		self.scrollContent.contentSize = CGSize(width:self.view.frame.size.width*CGFloat(self.items.count), height: self.view.frame.size.width)
		self.scrollContent.tag = 2
		self.scrollContent.delegate = self
		self.scrollContent.pagingEnabled = true
		
		
		self.view.addSubview(self.scrollContent)
        self.view.addSubview(self.scroll)
        self.scroll.addSubview(self.customSC)
        
       
		//曼會內容
        for(var i=0; i<self.items.count; i++){
			let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
			layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 10)
			layout.itemSize = CGSize(width: 100, height: 140)
            
            self.bookContent.append(CostumCollectionView(frame:CGRect(x:self.scrollContent.frame.size.width*CGFloat(i), y:0, width:self.scrollContent.frame.size.width, height: self.scrollContent.frame.size.height), collectionViewLayout: layout,bookItems: self.items[i]))
            
            print(self.items[i])
            self.scrollContent.addSubview( self.bookContent[i])
        }
	}
	
	
	
	
	

	func scrollViewDidScroll(scrollView: UIScrollView) {
		
		if scrollView.tag == 1{
			//漫畫分類長拉新增分類項目
         
            let width = scrollView.contentSize.width - scrollView.frame.size.width
			
	if scrollView.contentOffset.x > width+20 {
				
				print(items.count)
				let alertController=UIAlertController(title: "漫畫分類", message: "", preferredStyle: UIAlertControllerStyle.Alert)
				alertController.addTextFieldWithConfigurationHandler { (textField:UITextField) -> Void in
					textField.placeholder="分類名稱"
				}
				let cancelAction=UIAlertAction(title: "add", style: UIAlertActionStyle.Cancel) { (sender:UIAlertAction) -> Void in
					var newItem = "預設"

	if (alertController.textFields?.first?.text)! != ""{
					newItem = (alertController.textFields?.first?.text)!
					}
                    
                    
                    
    let itemsWidth = self.view.frame.size.width/3
					
    self.customSC.insertSegmentWithTitle(newItem, atIndex: self.items.count, animated: true)
    self.items.append(newItem)
	scrollView.contentSize = CGSize(width: itemsWidth*CGFloat(self.items.count), height: self.view.frame.size.height/15)
    self.customSC.frame = CGRectMake(0,0,itemsWidth*CGFloat(self.items.count),scrollView.frame.height)
                    
    self.scrollContent.contentSize = CGSize(width:self.view.frame.size.width*CGFloat(self.items.count), height: self.view.frame.size.width)

    self.scroll.scrollRectToVisible(CGRectMake(itemsWidth*CGFloat(self.items.count-1),0,self.view.frame.size.width,scrollView.frame.height), animated: true)
                    
	self.customSC.selectedSegmentIndex = self.items.count-1
					
	self.pageChange(self.customSC)
					
	print("新增漫畫項目:\(self.items)")
					
	//add 新的漫畫資料
	let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
	layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 10, right: 15)
	layout.itemSize = CGSize(width: 100, height: 120)

					
	self.bookContent.append(CostumCollectionView(frame:CGRect(x:self.scrollContent.frame.size.width*CGFloat(self.items.count-1), y:0, width:self.scrollContent.frame.size.width, height: self.scrollContent.frame.size.height), collectionViewLayout: layout,bookItems:newItem))
					
	self.scrollContent.addSubview( self.bookContent[self.items.count-1])
                    
					self.upload(newItem)

				}
    let clearAction=UIAlertAction(title: "cancel", style: UIAlertActionStyle.Default, handler:nil)
        alertController.addAction(cancelAction)
        alertController.addAction(clearAction)
            
    self.presentViewController(alertController, animated: true, completion: nil)
				
			
			}
        }else if scrollView.tag == 5{
        
            print(scrollView.contentOffset.y)
            if scrollView.contentOffset.y < -25{
               
                self.bookContent[0].performBatchUpdates({ () -> Void in
                    self.bookContent[0].bookName.append("四射")
                    print(self.bookContent[0].bookName)
                    
                    
                    var arrayWithIndexPaths:[NSIndexPath] = []
                    for(var i=self.bookContent[0].bookName.count-1;i<self.bookContent[0].bookName.count;i++){
                        arrayWithIndexPaths.append(  NSIndexPath(forRow:i, inSection: 0))
                    }
                    
                    
                    self.bookContent[0].insertItemsAtIndexPaths(arrayWithIndexPaths)
                    print(0)
                    }, completion: nil)

        }
        }}
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.tag == 2{
            for var i=0;i<scrollView.subviews.count;i++
            {
                if scrollView.convertPoint(scrollView.subviews[i].frame.origin, toView: self.view).x==0.0{
                    self.customSC.selectedSegmentIndex = i
                    self.pageChange(customSC)
                    print("ininder")
                }
            
            }
        }
		
	}
	
	//按下漫畫分類選單 改變 顯示內容
	func pageChange(sender: UISegmentedControl){
		var pageWidth =  scrollContent.frame.size.width
		var pageHeight =  scrollContent.frame.size.height
		let page = NSInteger(sender.selectedSegmentIndex)
		print("sender.selectedSegmentIndex:\(sender.selectedSegmentIndex)")
        
		scrollContent.scrollRectToVisible(CGRectMake(pageWidth*CGFloat(page),0, pageWidth, pageHeight), animated: true)
        pageWidth = scroll.frame.size.width/3
        pageHeight = scroll.frame.size.height
		scroll.scrollRectToVisible(CGRectMake(pageWidth*CGFloat(page-1),0,self.view.frame.size.width, pageHeight), animated: true)
	
	}
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print("view did load")
		let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
		dispatch_async(queue) { () -> Void in
			self.download()
			
			dispatch_async(dispatch_get_main_queue(), {
				let pending = UIAlertController(title: "LODING", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .Alert)
				
				//create an activity indicator
				let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
				indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
				//indicator.backgroundColor = UIColor.redColor()
				
				pending.view.addSubview(indicator)
				indicator.userInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
				indicator.startAnimating()
				
				//			self.presentViewController(pending, animated: true, completion: nil)
				self.presentViewController(pending, animated: true, completion: { () -> Void in
				})
			})
		}

		
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

	
	
//updata to 網路資料庫 //新曾資料
	func upload(newItems:String) {
		let url = NSURL(string: "http://sashihara.100hub.net/vip/wuBookSortUpload.php")
		let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
		let submitBody:String = "bookSort=\(newItems)"
		print("newItems:\(newItems)")
		request.HTTPMethod = "POST"
		request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
		
		let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
		let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		
		let dataTask = session.downloadTaskWithRequest(request)
		dataTask.resume()
	}
	
	
	
// dowload from	網路資料庫
	func download(){
	
		let url = NSURL(string: "http://sashihara.100hub.net/vip/bookDownload.php")
		let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
		
		request.HTTPMethod = "POST"
		
		let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
		
		let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		
		let dataTask = session.downloadTaskWithRequest(request)
		print("dataTask:\(dataTask)")
		dataTask.resume()
	}
	
	func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
		do {
			let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
				let dataArray = dataDic["bookSort"]!
				for(var i = 0 ;i<dataArray.count ;i++){
					//書籍分類資料
					print((dataArray[i]["bookSort"]) as! String)
					let itmesName = dataArray[i]["bookSort"] as! String
					items.append(itmesName)
				}
			
				self.setView()
				self.dismissViewControllerAnimated(true, completion: nil)
		}catch {
				print("new bookItems:ERROR")
		}
		
	}
}
