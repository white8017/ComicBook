//  ViewController.swift
//  collection
//  Created by plasma018 on 2016/3/13.
//  Copyright © 2016年 plasma018. All rights reserved.

import UIKit
protocol ViewControllerDelegate
{
	func saveEditing(var image : UIImage,var bookName : String)
}
class Plasma018ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,NSURLSessionDelegate{
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var imageView = UIImageView()
    var textLabel: UILabel!
    var textLabel1 = UITextField()
	var booktextfield = UITextField()
	var img:UIImage!
	var mySummary = UITextView()
	var dataArray = [UITextField]()
	let count = 3
	var delegate : ViewControllerDelegate?
	var orderBookName = ""
	var bookItems = ""
	//漫畫名稱
	var bookName = ""
	//漫畫分類
	var items = ""
	//漫畫簡介
	var summary = ""
	//漫畫集數
	var number = ""
	//漫畫作者
	var author = ""

	
	
    override func viewDidAppear(animated: Bool) {
        let viewS = self.view.frame.size
		orderBookName = booktextfield.text!
        // 標題列
		let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:self.view.frame.size.height/5))
		self.view.addSubview(navBar);
		let navItem = UINavigationItem(title: "SomeTitle");
		let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "changeImage:");
		navItem.rightBarButtonItem = doneItem;
		navBar.setItems([navItem], animated: false);
		
        // 按鈕
        let enterBty = UIButton(type: UIButtonType.System)
        let clearBty = UIButton(type: UIButtonType.System)
      
        
        enterBty.setTitle("ENTER", forState: UIControlState.Normal)
        clearBty.setTitle("CLEAR", forState: UIControlState.Normal)
        let buttonW = viewS.width/2
        let buttonH = viewS.height/8
        enterBty.frame = CGRectMake(0,self.view.frame.maxY-buttonH,buttonW,buttonH)
        clearBty.frame = CGRectMake(viewS.width/2,self.view.frame.maxY-buttonH,buttonW,buttonH)
        enterBty.addTarget(self, action: "enter", forControlEvents: .TouchDown)
        
        
        let borderTop = UIView(frame: CGRectMake(0,0,viewS.width,0.8))
        let borderCenter = UIView(frame: CGRectMake(viewS.width/2,0,1,buttonH))
        
        borderTop.backgroundColor = UIColor.grayColor()
        borderCenter.backgroundColor = UIColor.grayColor()
        
        enterBty.addSubview(borderTop)
        enterBty.addSubview(borderCenter)
        self.view.addSubview(clearBty)
        self.view.addSubview(enterBty)
		
		
//        let scrollView = UIScrollView(frame:CGRectMake(0,navBar.frame.maxY+10,viewS.width,viewS.height/2))
//        scrollView.contentSize = CGSize(width:viewS.width*3 , height:scrollView.frame.size.height)
//
//
//		
//        scrollView.pagingEnabled = true
//        scrollView.showsHorizontalScrollIndicator = false
//    
//        self.view.addSubview(scrollView)
		
		let imgWidth = self.view.frame.size.width*0.6
		let imgHeight = self.view.frame.size.height*0.6
		
		
        //圖片編輯
        imageView.frame = CGRect(x: self.view.frame.width/2-imgWidth/2, y: navBar.frame.maxY+5, width:  imgWidth, height: imgHeight)
        imageView.contentMode = UIViewContentMode.ScaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.grayColor().CGColor
        imageView.layer.borderWidth = 1.0
        imageView.clipsToBounds = true
		
        
//        textLabel = UILabel(frame: CGRect(x: 0, y:(imageView.frame.size.height-imageView.frame.size.height/3), width: imageView.frame.size.width, height: imageView.frame.size.height/3))
//        textLabel.backgroundColor=UIColor.blackColor()
//        textLabel.alpha=0.5
//        textLabel.textAlignment = .Center
		
		booktextfield.frame = CGRect(x: 0, y:(imageView.frame.size.height-imageView.frame.size.height/3), width: imageView.frame.size.width, height: imageView.frame.size.height/3)
		booktextfield.textAlignment = .Center
		booktextfield.textColor = UIColor.whiteColor()
		booktextfield.backgroundColor = UIColor.blackColor()
		booktextfield.placeholder = "title"
		booktextfield.keyboardType = UIKeyboardType.Default
		booktextfield.returnKeyType = .Done
		booktextfield.delegate = self
		booktextfield.font = UIFont.systemFontOfSize(20)
		imageView.userInteractionEnabled = true
		
//        textLabel1.frame = CGRect(x: 0, y:(imageView.frame.size.height-imageView.frame.size.height/3), width: imageView.frame.size.width, height: imageView.frame.size.height/3)
//        textLabel1.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
//        textLabel1.font = textLabel.font.fontWithSize(20)
//        textLabel1.textColor = UIColor.whiteColor()
//        textLabel1.textAlignment = .Center
		self.view.addSubview(imageView)
//        imageView.addSubview(textLabel)
		imageView.addSubview(booktextfield)
		
        
        //簡介編輯
//		mySummary = UITextView(frame: CGRect(x:scrollView.frame.size.width+10, y:10, width: scrollView.frame.size.width-20, height: scrollView.frame.height-20))
//        
//        mySummary.backgroundColor = UIColor.whiteColor()
//        mySummary.layer.borderWidth = 2
//        mySummary.layer.borderColor = UIColor.grayColor().CGColor
//        mySummary.layer.cornerRadius = 10
//        scrollView.addSubview(mySummary)
//		
//		
//		
//		let tabletextfield = UITableView(frame:CGRect(x:scrollView.frame.size.width*2, y: 0, width: viewS.width, height: viewS.height), style: UITableViewStyle.Plain)
//		
//		tabletextfield.delegate = self
//		tabletextfield.dataSource = self
//		tabletextfield.layer.borderWidth = 1
//		tabletextfield.layer.borderColor = UIColor.grayColor().CGColor
//		tabletextfield.layer.cornerRadius = 10
//		tabletextfield.scrollEnabled = false
//		tabletextfield.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
//		scrollView.addSubview(tabletextfield)
    }
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
//		
//		//        cell.accessoryType = UITableViewCellAccessoryNone;
//		cell.selectionStyle = UITableViewCellSelectionStyle.None
//		cell.backgroundColor = UIColor.clearColor()
//		
//		let label = UILabel(frame: CGRect(x: 10, y: 0, width: cell.frame.size.width/6, height: cell.frame.size.height))
//		
//		
//		label.text = "title"
//		
//		textfield = UITextField(frame: CGRect(x: label.frame.maxX, y: 0, width: cell.frame.size.width/3, height: cell.frame.size.height))
//		
//		
//		
//		
//		textfield.adjustsFontSizeToFitWidth = true;
//		//textfield.textColor = [UIColor blackColor];
//		//textfield.backgroundColor = [UIColor whiteColor];
//		textfield.autocorrectionType = UITextAutocorrectionType.No;
//		textfield.autocapitalizationType = UITextAutocapitalizationType.None;
//		textfield.clearButtonMode = UITextFieldViewMode.Never;
//		textfield.delegate = self
//		
//		if indexPath.row == 0{
//			label.text = "title"
//			textfield.placeholder = "title"
//			dataArray.append(textfield)
//		}
//		if indexPath.row == 1{
//			label.text = "AUTHOR"
//			textfield.placeholder = "author"
//			dataArray.append(textfield)
//		}
//		if indexPath.row == 2{
//			label.text = "volumn"
//			dataArray.append(textfield)
//		}
//		
//		
//		cell.layer.borderColor = UIColor.grayColor().CGColor
//		cell.layer.borderWidth = 1
//		
//		cell.addSubview(label)
//		cell.addSubview(textfield)
//		
		return cell
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("You selected cell #\(indexPath.row)!")
	}
	
	
    func enter(){
//		print("編輯漫畫名稱:\(dataArray[0].text)")
//		print("編輯漫畫作者:\(dataArray[1].text)")
//		print("編輯漫畫集數:\(dataArray[2].text)")
//		print("編輯漫畫簡介:\(mySummary.text)")
		
		
		
		if((self.delegate) != nil)
		{
		upload(booktextfield.text!,items: bookItems)
		delegate?.saveEditing(imageView.image!, bookName:booktextfield.text!)
		myImageUploadRequest()
		self.dismissViewControllerAnimated(true, completion: nil)
		}
		self.dismissViewControllerAnimated(true, completion: nil)
    }
	
	

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
//	選取照片的功能
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		let theInfo:NSDictionary = info as NSDictionary
		img=theInfo.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
		imageView.image = img
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func changeImage(sender: AnyObject) {
		let image = UIImagePickerController()
		image.delegate = self
		image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		self.presentViewController(image, animated: true, completion: nil)
	}
	
	
	//新增漫畫
	func upload(bookName:String,items:String) {
		let url = NSURL(string: "http://sashihara.100hub.net/vip/wuBookDetailsUpload1.php")
		let number = appDelegate.bookName.indexOf(orderBookName)
		print(number)
		let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
		let submitBody:String = "bookSort=\(items)&bookName=\(bookName)"
		print("新增漫畫名稱:\(bookName)")
		print("新增漫話類別:\(items)")
		print("漫畫序號:\(number)")
		request.HTTPMethod = "POST"
		request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
		
		let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
		let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		let dataTask = session.downloadTaskWithRequest(request)
		dataTask.resume()
	}
	
	
	//UPloadImage
//	func myImageUploadRequest(){
//		let myUrl = NSURL(string: "http://sashihara.100hub.net/vip/img/imgUpload.php");
//		
//		let request = NSMutableURLRequest(URL:myUrl!);
//		request.HTTPMethod = "POST";
//	
//	
//	
//	
//	}

	
	func myImageUploadRequest()
	{
		
		let myUrl = NSURL(string: "http://sashihara.100hub.net/vip/img/imgUpload.php");
		//let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
		
		let request = NSMutableURLRequest(URL:myUrl!);
		request.HTTPMethod = "POST";
		
		let param = [
			"firstName"  : "Sergey",
			"lastName"   : "Kargopolov",
			"userId"    : "9"
		]
		
		let boundary = generateBoundaryString()
		
		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		
		// 圖片資料
		let imageData = UIImageJPEGRepresentation(resizeImage(imageView.image!, newWidth: 300, newHeight: 400),1)
		print("imageView.image:\(imageView.image)")
		if(imageData==nil)  { return; }
		
		request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
		
		
//		
//		actIV.startAnimating();
		
		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
			data, response, error in
			
			if error != nil {
				print("error=\(error)")
				return
			}
			
			dispatch_async(dispatch_get_main_queue(),{
//				self.actIV.stopAnimating()
				//                self.myImgView.image = nil;
			});
			
		
			
		}
		
		task.resume()
		
	}
	
	
	
	
	
	func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
		let body = NSMutableData();
		
		if parameters != nil {
			for (key, value) in parameters! {
				body.appendString("--\(boundary)\r\n")
				body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
				body.appendString("\(value)\r\n")
			}
		}
		
		let textStr = "a"
		
		let filename = "\(textStr)\(booktextfield.text!).jpg"
		
		let mimetype = "image/jpg"
		
		body.appendString("--\(boundary)\r\n")
		body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
		body.appendString("Content-Type: \(mimetype)\r\n\r\n")
		body.appendData(imageDataKey)
		body.appendString("\r\n")
		
		
		
		body.appendString("--\(boundary)--\r\n")
		
		return body
	}
	
	
	func generateBoundaryString() -> String {
		return "Boundary-\(NSUUID().UUIDString)"
	}
	
}

extension NSMutableData {
	
	func appendString(string: String) {
		let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
		appendData(data!)
	}
}

//改變圖片大小
func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
	
	let scale = newWidth / image.size.width
	let newHeight = image.size.height * scale
	UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
	image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
	let newImage = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	
	return newImage
}

