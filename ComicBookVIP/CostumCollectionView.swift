//  CostumCollectionView.swift
//  collection
//  Created by plasma018 on 2016/3/11.
//  Copyright © 2016年 plasma018. All rights reserved.
import UIKit

class CostumCollectionView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NSURLSessionDelegate,NSURLSessionDownloadDelegate,CollectionViewCellDelegate{
	
    private let reuseIdentifier = "Cell"
    var arrayfirst = 0;
    var arrayfinal = 0;
    var snapshot:UIView? = nil;
    var sourceIndexPath:NSIndexPath? = nil;
	//漫畫所屬的漫畫分類
	var bookItems = "預設"
//	//collectionView顯示的漫畫內容
//var bookName = ["一拳超人", "七原罪", "山田和七個魔女", "火星异种", "东京食尸", "召唤恶魔", "名侦探柯南", "死神", "妖精的尾巴", "美食的俘虏", "食戟之灵", "浪人劍客", "海賊王", "第一神拳", "黑子的篮球", "暗殺教室", "滑头鬼之孙", "監獄學園"]
	var bookName = [String]()
	var bookImage = [String:UIImage]()
	
	var testImage : UIImage!
	init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout,bookItems:String){
		
        super.init(frame: frame, collectionViewLayout: layout)
		self.delegate = self
	
		loadData(bookItems)
		self.bookItems = bookItems
		

		self.backgroundColor = UIColor.whiteColor()
        let longPress = UILongPressGestureRecognizer(target: self, action:"longPressGestureRecognize:")
        self.addGestureRecognizer(longPress)
		//漫畫分類
		print("漫畫所屬類別:\(bookItems)   漫畫內容:\(bookName)")
//		downloadImage()
		
//		print("create collectionview ok")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	
	//長壓collectionView的
    func longPressGestureRecognize(gestureReconizer: UILongPressGestureRecognizer){
        let state = gestureReconizer.state
        //長壓的位置
        let location = gestureReconizer.locationInView(self)
        print("location:\(location)")
        //長壓的cell編號
        let indexPath = self.indexPathForItemAtPoint(location)
        print("indexPath:\(indexPath)")
		//長壓後的cell狀態：
        switch state{
            
        case UIGestureRecognizerState.Began:
            
          
		
            if (indexPath != nil){
                arrayfirst = (indexPath?.row)!
                
                sourceIndexPath = indexPath
                
                
                let cell = self.cellForItemAtIndexPath(indexPath!)
                
                snapshot = self.customSnapshotFromView(cell!)
         
                //一開時浮出來的位置
                var center = cell!.center;
                snapshot!.center = center;
                snapshot!.alpha = 0.0;
                self.addSubview(snapshot!)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    //常壓cell畫面浮起來
                    center.y = center.y+1;
                    center.x = center.x+1;
                    
                    self.snapshot!.center = center;
                    
                    //畫面變大
                    self.snapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    self.snapshot!.alpha = 0.98;
                    
                    // Fade out.
                    cell!.alpha = 0.5;
                    }, completion: { (Bool) -> Void in
                        cell!.hidden = true;
                        
                })
                
            }
            
            
            
        case UIGestureRecognizerState.Changed:
            if(snapshot != nil){
                print("Changed:")
                //邊移動交換位置
                var center = snapshot!.center
                center.y = location.y
                center.x = location.x
                snapshot!.center = center
                
                //確認cell移動後目的地正確 以及 不同於本來位置
                let indexPathBool = (indexPath != nil)
                let indexPathSame = indexPath?.isEqual(sourceIndexPath)
				
                if indexPathSame != nil{
//                      print("indexPathSame:\(!indexPathSame!)")
                    if indexPathBool && !indexPathSame!{
//            print("sourceIndexPath:\(sourceIndexPath?.row)..........................")
						
            self.moveItemAtIndexPath(sourceIndexPath!, toIndexPath: indexPath!)
                        sourceIndexPath = indexPath;
                        
                    }
                }
            }
            
            
        default:
            
            if(sourceIndexPath != nil){
//                print("default::::::::::::::")
                arrayfinal = (sourceIndexPath?.row)!
            
     
                let cell = self.cellForItemAtIndexPath(sourceIndexPath!)
                print("sourceIndexPath:\(sourceIndexPath!.row)")
                //底下cell已存在
                cell!.hidden = false
                print(cell!.hidden)
                cell?.alpha = 0.0
                //放下的動話
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.snapshot!.center = cell!.center;
                    self.snapshot!.transform = CGAffineTransformIdentity;
              
                    self.snapshot!.alpha = 0.0;
                    //                print(12)
                    // Undo fade out.
                    cell!.alpha = 1.0                }, completion: { (Bool) -> Void in
                        self.sourceIndexPath = nil
                        
                        self.snapshot = nil
                        
				//	交換書單的位置
//                      print("self.bookName1:\(self.bookName)")
                if(self.arrayfirst<self.arrayfinal){
                    self.bookName.insert(self.bookName[self.arrayfirst], atIndex: self.arrayfinal+1)
                    self.bookName.removeAtIndex(self.arrayfirst)
                    
                }else{
                    self.bookName.insert(self.bookName[self.arrayfirst], atIndex: self.arrayfinal)
                    self.bookName.removeAtIndex(self.arrayfirst+1)
                     }
				
				print("交換後的漫畫陣列:\(self.bookName)\n")
						self.uploadData(self.bookName)
                })
                
            }
        }
    }
	

    
    
    func customSnapshotFromView(inputView: UIView)->UIImageView{
        
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0);
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        let snapshot = UIImageView(image: image)
        
        snapshot.layer.masksToBounds = false;
        snapshot.layer.cornerRadius = 0.0;
        snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
        snapshot.layer.shadowRadius = 5.0;
        snapshot.layer.shadowOpacity = 0.4;
        return snapshot
    }
	
	
	
//	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
////		if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height{
//        print(scrollView.contentOffset.y)
//        if scrollView.contentOffset.y < 1{
//			
//			self.performBatchUpdates({ () -> Void in
//                self.bookName.insert("預設", atIndex: 0)
//				print(self.bookName)
//				
//				
//				var arrayWithIndexPaths:[NSIndexPath] = []
//				for(var i=0;i<1;i++){
//					arrayWithIndexPaths.append(  NSIndexPath(forRow:i, inSection: 0))
//					
//					
//				}
//			
//            self.insertItemsAtIndexPaths(arrayWithIndexPaths)
//			
//				self.upload("預設",items:self.bookItems)
//				
//				}, completion: nil)
//
//			
//        }
//	}
//	
    func scrollViewDidScroll(scrollView: UIScrollView) {
		print(scrollView.contentOffset.y)
		if scrollView.contentOffset.y < -40{
			
			self.performBatchUpdates({ () -> Void in
				self.bookName.insert("預設", atIndex: 0)
				print(self.bookName)
				
				
				var arrayWithIndexPaths:[NSIndexPath] = []
				for(var i=0;i<1;i++){
					arrayWithIndexPaths.append(  NSIndexPath(forRow:i, inSection: 0))
					
					
				}
				
				self.insertItemsAtIndexPaths(arrayWithIndexPaths)
				
				self.upload("預設",items:self.bookItems)
				
				}, completion: nil)
			
			
		}

    }
	
	
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookName.count
    }
	
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
            as! CollectionViewCell
		
		
        cell.textLabel.text = bookName[indexPath.row]
    

        
		if (bookImage[bookName[indexPath.row]] != nil){
			cell.imageView.image = bookImage[bookName[indexPath.row]]
		}else{
			downloadImage(bookName[indexPath.row], imageview:cell.imageView)
		}
		//DELETE
        cell.deleteButton.tag = indexPath.row
        let TapGesture = UITapGestureRecognizer(target: self, action:"deleteCell:")
		cell.deleteButton.addGestureRecognizer(TapGesture)
		cell.bookItems = bookItems
		
		//笨方法
		cell.source = bookName[indexPath.row]
		cell.delegate = self
        return cell
        
    }
    
    
    func deleteCell(sender: UITapGestureRecognizer){
        let location = sender.locationInView(self)
		//點選delete按鈕的位置
		print("delete button 的位置:\(location)")
        //按鈕cell的編號
        let indexPath = self.indexPathForItemAtPoint(location)
        print("delete cell 的編號:\(indexPath?.row)")
		
		//刪除
        self.performBatchUpdates({ () -> Void in
			//刪除線上資料庫的書本
			self.deleteBook(self.bookName[(indexPath?.row)!])
			//刪除本地的正烈
            self.bookName.removeAtIndex((indexPath?.row)!)
            let indexPath = NSIndexPath.init(forRow: (indexPath?.row)!, inSection: 0)
            self.deleteItemsAtIndexPaths([indexPath])
            print("delete完後的漫畫陣列：\(self.bookName)")
			}, completion: { (Bool) -> Void in
				
		})
		
    }

	func changeArray(src:String , dis:String , img:UIImage){
		print("src:\(src)")
		print("dis:\(dis)")
		let first = bookName.indexOf(src)
		bookName.insert(dis, atIndex: first!)
		bookName.removeAtIndex(first!+1)
		print("編輯後的陣列:\(bookName)")
		
		bookImage[dis]=img
	
	}
	
	
	
	
	
	
	
//線上資料庫有關的動作
	
//下載線上資料
	func loadData(bookItems:String) {
		let url = NSURL(string:"http://sashihara.100hub.net/vip/downloadBook.php")
		let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
		
		let submitName = bookItems
		let submitBody: String = "bookSort=\(submitName)"
		
		request.HTTPMethod = "POST"
		request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
		
		let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
		
		let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		
		let dataTask = session.downloadTaskWithRequest(request)
		dataTask.resume()
	}
	
	
	func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
		
		do {
			let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
			let dataArray = dataDic["bookDetails"]!
			
			for(var i = 0 ;i<dataArray.count ;i++){
				//書籍分類資料
				let bookName = dataArray[i]["bookName"] as! String
				print(bookName)
				self.bookName.append(bookName)
			}
			self.delegate = self
			self.dataSource = self
			self.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
			//
		}catch {
			self.delegate = self
			self.dataSource = self
			self.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
			print("load collectionViewdown:ERROR")
		}
		
	}
	
//新增漫畫
	func upload(bookName:String,items:String) {
		let url = NSURL(string: "http://sashihara.100hub.net/vip/wuBookDetailsUpload.php")
		let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
		let submitBody:String = "bookSort=\(items)&bookName=\(bookName)"
		print("新增漫畫名稱:\(bookName)")
		print("新增漫話類別:\(items)")
		
		request.HTTPMethod = "POST"
		request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
		
		let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
		let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		let dataTask = session.downloadTaskWithRequest(request)
		dataTask.resume()
	}
	
	
//修改資料
	func uploadData(bookNameArray:[String]) {
		
		let url = NSURL(string: "http://sashihara.100hub.net/vip/wuBookDetailsUpdate.php")
		let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
		
		for(var i = 0;i<bookNameArray.count;i++){
		
		let submitBody:String = "orderN=\(i)&bookName=\(bookNameArray[i])"
		print("order:\(i) bookName:\(bookNameArray[i])")
		request.HTTPMethod = "POST"
		request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
		
		let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
		let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		
		let dataTask = session.downloadTaskWithRequest(request)
		dataTask.resume()
		}
	}
	
//刪除書本
	func deleteBook (bookName:String) {
		let url = NSURL(string: "http://sashihara.100hub.net/vip/wuBookDetailsDelete.php")
		let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
		print("deleteBookName:\(bookName)")
		let submitBody: String = "bookName=\(bookName)"
		
		request.HTTPMethod = "POST"
		request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
		
		
		let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
		
		let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		
		let dataTask = session.downloadTaskWithRequest(request)
		dataTask.resume()
	}
	
	
//下載圖片資料
	
	func downloadImage(bookName:String, imageview:UIImageView){
        
		let link = "http://sashihara.100hub.net/vip/img/img/a\(bookName).jpg"
//		print(link)
        let url:NSURL =  NSURL(string: link.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
       
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.timeoutInterval = 10
        let task = session.dataTaskWithRequest(request){(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            var image = UIImage(data: data!)
            if (image != nil)
            {
                
                func set_image()
                {
                    self.bookImage[bookName] = image
                    imageview.image = image
                }
                dispatch_async(dispatch_get_main_queue(), set_image)
            }else{
                
                func set_image1()
                {
                    
                self.bookImage[bookName]=UIImage(named:"img_not_available")
                    imageview.image = UIImage(named:"img_not_available")
    
                }
                dispatch_async(dispatch_get_main_queue(), set_image1)
            
            }
           
        }
        task.resume()
	}

	

	
	
	
	
}




