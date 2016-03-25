import UIKit

class bookdetailViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIPopoverPresentationControllerDelegate,NSURLSessionDelegate,NSURLSessionDownloadDelegate,UITextFieldDelegate{
	var titleView = UIView()
	let good = UIView()
	var bookImage = UIImageView()
	var bookName  = UILabel()
	var author    = UILabel()
	var episode   = UILabel()
	var ButtonstackView=UIStackView()
	var scrollView = UIScrollView()
	var contentView = UIView()
	var bookState = UILabel()
	var titleView1 = UIView()
	var bookSummary = UITextView()
	var tableview = UITableView()
	var edting : UIView!
	var edtingAuthor = UITextField()
	var stepperlabel = UILabel()
	var edtingbookState : UISegmentedControl!
	var edtingSummary = UITextView()
	var borrowBook = [String]()
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	let navigationBar = UINavigationBar()
	let NavigationItem = UINavigationItem()
	var rentTime = [String:String]()
	var indicator = UIActivityIndicatorView()
	var summary = ""
	var test = ["第1集","第2集","第3集","第4集","第5集","第6集","第7集","第8集","第9集","第10集","第11集","第12集","第13集","第14集","第15集","第16集","第17集","第18集","第19集","第20集","第21集","第22集","第23集","第24集","第25集","第26集","第27集","第28集","第29集","第30集","第31集","第32集","第33集","第34集","第35集","第36集","第37集","第38集","第39集","第40集","第41集","第42集","第43集","第44集","第45集","第46集","第47集","第48集","第49集","第50集","第51集","第52集","第53集","第54集","第55集"]
	
	var bookAmount:[String]!
	var rightButton = UIBarButtonItem()
	
	
	
	func back(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func setView(){
		
		let viewS = self.view.frame.size
		//畫面設定
		self.view.backgroundColor = UIColor.redColor()
		navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height/10)
		navigationBar.backgroundColor = UIColor.whiteColor()
		let leftButton = UIBarButtonItem(title: "BACK", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
		rightButton = UIBarButtonItem(title: "編輯", style: UIBarButtonItemStyle.Plain, target: self, action: "edting1")
		NavigationItem.leftBarButtonItem = leftButton
		if appDelegate.vip == "1"{
		NavigationItem.rightBarButtonItem = rightButton
		}
		NavigationItem.title = "作品詳情"
		navigationBar.items = [NavigationItem]
		self.view.addSubview(navigationBar)
		
		
		scrollView.frame = CGRect(x: 0, y:navigationBar.frame.maxY, width: viewS.width, height: viewS.height)
		scrollView.bounces = false
		scrollView.tag = 1
		
		titleView.frame = CGRect(x: 0, y:0, width:viewS.width, height: viewS.height/2)
		titleView.backgroundColor = UIColor.redColor()
		
		
		//書本圖片
		bookImage.frame = CGRect(x:titleView.frame.size.width/20, y: titleView.frame.size.height/20, width:titleView.frame.size.width/2.5, height:titleView.frame.size.height/1.5)
		bookImage.contentMode = UIViewContentMode.ScaleToFill
		titleView.addSubview(bookImage)
		scrollView.addSubview(titleView)
		self.view.addSubview(scrollView)
		
		
		//書名,作者,最新集數
		//書名
		bookName.font = bookName.font.fontWithSize(25)
		bookName.textColor = UIColor.blackColor()
		bookName.textAlignment =  NSTextAlignment.Left
		bookName.frame = CGRect(x:bookImage.frame.maxX+titleView.frame.size.width/20, y: titleView.frame.size.height/20, width:titleView.frame.size.width/2, height:bookImage.frame.size.height/8)
		titleView.addSubview(bookName)
		
		//作者
		author.textAlignment =  NSTextAlignment.Left
		episode.textAlignment = NSTextAlignment.Left
		bookState.textAlignment = NSTextAlignment.Left
		
		//評分
		let star = UIImageView(image:UIImage(named: "star_lybn_26px"))
		let star1 = UIImageView(image:UIImage(named: "star_lybn_26px"))
		let star2 = UIImageView(image:UIImage(named: "star_lybn_26px"))
		let star3 = UIImageView(image:UIImage(named: "star_lybn_26px"))
		let star4 = UIImageView(image:UIImage(named: "star_lybn_26px"))
		let starstack = UIStackView(arrangedSubviews: [star,star1,star2,star3,star4])
		starstack.frame = CGRect(x:bookName.frame.minX, y: bookName.frame.maxY+titleView.frame.size.width/50, width:titleView.frame.size.width/2.5, height:titleView.frame.size.height/8)
		starstack.axis = .Horizontal
		starstack.distribution = .FillEqually
		let grade = UITapGestureRecognizer(target: self, action: "grade")
		grade.numberOfTapsRequired = 1
		starstack.addGestureRecognizer(grade)
		
		
		//書本資訊分類
		let stackView = UIStackView(arrangedSubviews: [author,episode,bookState])
		
		stackView.frame =  CGRect(x:bookName.frame.minX, y: starstack.frame.maxY+titleView.frame.size.width/20, width:titleView.frame.size.width/3, height:titleView.frame.size.height/4)
		stackView.axis = .Vertical
		stackView.distribution = .FillEqually
		stackView.alignment = .Fill
		stackView.spacing = 2
		stackView.layer.borderColor = UIColor.blackColor().CGColor
		stackView.layer.borderWidth = 10
		titleView.addSubview(stackView)
		titleView.addSubview(starstack)
		
		let enterBty = UIButton(type: UIButtonType.System)
		let clearBty = UIButton(type: UIButtonType.System)
		
		
		enterBty.setTitle("借閱", forState: UIControlState.Normal)
		clearBty.setTitle("評分", forState: UIControlState.Normal)
		enterBty.addTarget(self, action: "borrow", forControlEvents: UIControlEvents.AllTouchEvents)
		enterBty.backgroundColor = UIColor.grayColor()
		let buttonW = titleView.frame.width/3
		let buttonH = titleView.frame.height/8
		enterBty.frame = CGRectMake(titleView.frame.midX-buttonW/2,bookImage.frame.maxY+10,buttonW,buttonH/6*8)
		
		titleView.addSubview(enterBty)
		
		// 書籍簡介
		bookSummary.frame = CGRect(x: 0, y:titleView.frame.maxY+10, width:viewS.width, height: viewS.height/2)
		bookSummary.backgroundColor = UIColor.orangeColor()
		scrollView.addSubview(bookSummary)
		let tap = UITapGestureRecognizer(target: self, action: "ShowPage")
		bookSummary.addGestureRecognizer(tap)
		tap.numberOfTapsRequired = 1
		bookSummary.delegate = self
		bookSummary.font = UIFont.systemFontOfSize(20)
		
		//借閱人數
		
		tableview = UITableView(frame: CGRect(x: 0, y:titleView.frame.maxY+50, width:viewS.width, height: 40*CGFloat(bookAmount.count+2)), style: UITableViewStyle.Grouped)
		
		tableview.userInteractionEnabled = false
		
		
		
		tableview.delegate = self
		tableview.dataSource = self
		tableview.scrollEnabled = false
		tableview.allowsMultipleSelection = true
		tableview.userInteractionEnabled = true
		scrollView.contentSize = CGSize(width:viewS.width, height:titleView.frame.maxY+100+tableview.frame.size.height)
		scrollView.addSubview(tableview)
		self.view.addSubview(scrollView)
		
		//編輯頁面
		edting = UIView(frame: CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.size.width, height: self.view.frame.size.height/2))
		edting.backgroundColor = UIColor.whiteColor()
		self.view.addSubview(edting)
		
		
		
		let stateArray = ["未完結","完結"]
		edtingbookState = UISegmentedControl(items: stateArray)
		edtingbookState.frame = CGRect(x:self.view.frame.size.width/4, y: 70 , width:self.view.frame.size.width/2, height: 40)
		edtingbookState.selectedSegmentIndex = stateArray.indexOf(bookState.text!)!
		print("edtingbookState.selectedSegmentIndex:\(edtingbookState.selectedSegmentIndex)")
		
		
		
		edtingAuthor.frame = CGRect(x:self.view.frame.size.width/4, y: 20, width:self.view.frame.size.width/2, height: 40)
		edtingAuthor.layer.borderWidth = 1
		edtingAuthor.layer.borderColor = UIColor.grayColor().CGColor
		edtingAuthor.layer.cornerRadius = 5
		edtingAuthor.backgroundColor = UIColor.whiteColor()
		edtingAuthor.delegate = self
		
		
		
		
		stepperlabel.frame = CGRect(x: self.view.frame.size.width/4, y: 120 , width: 80, height: 40)
		stepperlabel.text = self.episode.text
		let stepper = UIStepper(frame: CGRect(x: stepperlabel.frame.maxX+5, y: 120 , width: 160, height: 40))
		stepper.value = Double(test.indexOf(episode.text!)!+1)
		stepper.addTarget(self, action: "bookVolum:", forControlEvents: UIControlEvents.ValueChanged)
		
		edting.addSubview(edtingAuthor)
		edting.addSubview(edtingbookState)
		edting.addSubview(stepper)
		edting.addSubview(stepperlabel)
		edtingSummary = UITextView()
		edtingSummary.frame = CGRect(x: 0, y: edtingbookState.frame.maxY+50, width:edting.frame.size.width, height: edting.frame.size.height-edtingbookState.frame.maxY-50)
		edtingSummary.backgroundColor = UIColor.whiteColor()
		edtingSummary.layer.borderWidth = 1
		edtingSummary.layer.borderColor = UIColor.grayColor().CGColor
		edtingSummary.font = UIFont.systemFontOfSize(20)
		edtingSummary.delegate = self
		edting.addSubview(edtingSummary)
		edting.userInteractionEnabled = true
		
		self.view.addSubview(indicator)
	}
	
	
	//借書
	func borrow(){
		
		if borrowBook != []{
			appDelegate.orderBookImage[bookName.text!] = bookImage.image
			appDelegate.orderBookNumber[bookName.text!] = borrowBook
			for (var i = 0;i<appDelegate.orderBooktTitle.count;i++){
				if appDelegate.orderBooktTitle[i] == bookName.text!{
					appDelegate.orderBooktTitle.removeAtIndex(appDelegate.orderBooktTitle.indexOf(bookName.text!)!)
				}
			}
			appDelegate.orderBooktTitle.append(bookName.text!)
		}
		
		NSNotificationCenter.defaultCenter().postNotificationName("addMenu", object: self)
		
		
		
		self.dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	func bookVolum(sender:UIStepper){
		
		
		stepperlabel.text = NSString(format: "第%.0f集", sender.value) as String
	}
	
	func ShowPage(){
		UIView.transitionWithView(tableview, duration: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
			if self.tableview.frame.minY < self.bookSummary.frame.minY+50{
				
				self.tableview.frame =  CGRect(x: 0, y:self.bookSummary.frame.maxY, width:self.view.frame.size.width, height:40*CGFloat(self.bookAmount.count+2))
				self.scrollView.contentSize = CGSize(width:self.view.frame.width, height:self.titleView.frame.maxY+100+self.tableview.frame.size.height+self.view.frame.size.height/2-40)
				
			}else{
				self.tableview.frame =  CGRect(x: 0, y:self.titleView.frame.maxY+50, width:self.view.frame.size.width, height: 40*CGFloat(self.bookAmount.count+2))
				self.scrollView.contentSize = CGSize(width:self.view.frame.size.width, height:self.titleView.frame.maxY+100+self.tableview.frame.size.height)
				
			}
			}) { (ture) -> Void in
				
		}
		
	}
	
	
	
	func edting1(){
		
		if edting.frame.minY == self.view.frame.maxY{
			rightButton.title = "完成"
			UIView.transitionWithView(edting, duration: 1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
				self.edtingAuthor.text = self.author.text
				self.stepperlabel.text = self.episode.text
				self.edtingbookState.selectedSegmentIndex = 0
				self.edtingSummary.text = self.bookSummary.text
				
				self.edting.frame = CGRect(x: 0, y: self.view.frame.maxY/2, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
				
				
				}, completion: { (Bool) -> Void in
					
					
					
			})
			
			
			
		}else{
			rightButton.title = "編輯"
			UIView.transitionWithView(edting, duration: 1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
				
				self.author.text = self.edtingAuthor.text
				self.episode.text = self.stepperlabel.text
				self.bookState.text = self.edtingbookState.titleForSegmentAtIndex(self.edtingbookState.selectedSegmentIndex)
				self.bookSummary.text = self.edtingSummary.text
				
				
				
				self.edting.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
				}, completion: { (Bool) -> Void in
					
					self.bookAmount = self.test
					self.bookAmount.removeRange(Range<Int>(start: self.bookAmount.indexOf(self.episode.text!)!+1, end: self.bookAmount.count))
					
					
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						
						self.tableview.frame = CGRect(x: 0, y:self.titleView.frame.maxY+50, width:self.view.frame.size.width, height: 40*CGFloat(self.bookAmount.count+2))
						self.tableview.reloadData()
						self.scrollView.contentSize = CGSize(width:self.view.frame.size.width, height:self.titleView.frame.maxY+100+self.tableview.frame.size.height)
						
					})
					self.uploadData(self.author.text!, newStage: self.episode.text!, bookOutline: self.bookSummary.text, published: self.bookState.text!, bookName: self.bookName.text! )
					
			})
			
			
		}
		
		
		
		
	}
	
	func adaptivePresentationStyleForPresentationController(
		controller: UIPresentationController) -> UIModalPresentationStyle {
			return .None
	}
	
	
	
	
	//書籍評分
	func grade(){
		let alertController=UIAlertController(title: "grade", message: "\n\n\n\n", preferredStyle: UIAlertControllerStyle.Alert)
		let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Cancel, handler: nil)
		alertController.addAction(cancelAction)
		self.presentViewController(alertController, animated: true, completion: nil)
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func keyboardShow(notification:NSNotification){
		print("keyboardShow")
		let userInfo:NSDictionary = notification.userInfo!
		let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
		let keyboardRectangle = keyboardFrame.CGRectValue()
		let keyboardHeight = keyboardRectangle.minY
		UIView.transitionWithView(edting, duration: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
				self.edting.frame = CGRect(x: 0, y: keyboardHeight-self.view.frame.size.height/2, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
			}, completion: nil)
	
	}
	func keyboardHide(){
		print("keyboardHide")
		
		UIView.transitionWithView(edting, duration: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
			self.edtingAuthor.text = self.author.text
			self.stepperlabel.text = self.episode.text
			self.edtingbookState.selectedSegmentIndex = 0
			self.edtingSummary.text = self.bookSummary.text
			
			self.edting.frame = CGRect(x: 0, y: self.view.frame.maxY/2, width: self.view.frame.size.width, height: self.view.frame.size.height/2)
			}, completion: nil)
		
	
	
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name:UIKeyboardDidShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide", name:UIKeyboardDidHideNotification, object: nil)
		
		indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
		indicator.color = UIColor.blackColor()
		indicator.transform =  CGAffineTransformMakeScale(3, 3)
		indicator.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		indicator.startAnimating()
		indicator.userInteractionEnabled = false
		author.text = "作者"
		episode.text = "第8集"
		bookState.text = "完結"
		scrollView.delegate = self
		bookSummary.text = summary
		bookAmount = test
		setView()
		
		
		download()
		downloadTwo()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.tag == 1{
			if scrollView.contentOffset.y > 40{
				print(scrollView.contentOffset.y)
				NavigationItem.title = bookName.text
			}else{
				NavigationItem.title = "作品詳情"
			}
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = cellView(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
		cell.title.text = bookAmount[indexPath.row]
		cell.date.text = rentTime[bookAmount[indexPath.row]]
		for a in rentTime{
			if a.0 == bookAmount[indexPath.row]{
				cell.userInteractionEnabled = false
				
			}
		}
		
		
		return cell
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 40
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return bookAmount.count
	}
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return tableView.rowHeight
	}
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "借閱"
	}
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		borrowBook.append(String(indexPath.row))
		print("要借的書:\(borrowBook)")
	}
	
	func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		borrowBook.removeAtIndex(borrowBook.indexOf("\(indexPath.row)")!)
		print("要借的書:\(borrowBook)")
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	
	
	
	//資料庫
	//上傳更新
	func uploadData(author:String,newStage:String,bookOutline:String,published:String,bookName:String) {
		
		let url = NSURL(string: "http://sashihara.100hub.net/vip/wuBookDetailsUpdate2.php")
		let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
		
		let submitBody:String = "author=\(author)&newStage=\(newStage)&bookOutline=\(bookOutline)&published=\(published)&bookName=\(bookName)"
		request.HTTPMethod = "POST"
		request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
		
		let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
		let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		
		let dataTask = session.downloadTaskWithRequest(request)
		dataTask.resume()
	}
	
	
	
	
	
	
	//下載資料
	func download(){
		let url = NSURL(string: "http://sashihara.100hub.net/vip/wuBookDetailsDownload.php")
		let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
		let submitBody:String = "bookName=\(bookName.text!)"
		print("bookName.text!:\(bookName.text!)")
		request.HTTPMethod = "POST"
		request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
		let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
		
		let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		
		let dataTask = session.downloadTaskWithRequest(request)
		print("dataTask:\(dataTask)")
		dataTask.resume()
	}
	
	func downloadTwo(){
		
		let url = NSURL(string: "http://sashihara.100hub.net/vip/wuReturnBookDownload.php")
		let request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
		
		let submitBody:String = "bookName=\(bookName.text!)"
		print("bookName.text!:\(bookName.text!)")
		request.HTTPMethod = "POST"
		request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
		
		let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
		
		let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
		
		let dataTask = session.downloadTaskWithRequest(request)
		print("dataTask:\(dataTask)")
		dataTask.resume()
	}
	
	func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
		
		do {
			let dataDic = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
			if dataDic["bookDetails"] != nil{
				if(dataDic["bookDetails"]![0]["author"]as? String == ""){
					
				}else{
//					print(dataDic["bookDetails"]![0])
					author.text = (dataDic["bookDetails"]![0]["author"]) as? String
					episode.text = (dataDic["bookDetails"]![0]["newStage"]) as? String
					bookState.text = (dataDic["bookDetails"]![0]["published"]) as? String
					bookSummary.text  = (dataDic["bookDetails"]![0]["bookOutline"]) as? String
					
				}
				
				bookAmount = test
				bookAmount.removeRange(Range<Int>(start: bookAmount.indexOf(episode.text!)!+1, end: bookAmount.count))
				
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					self.setView()
					
				})
				
			}else if(dataDic["rentHistory"] != nil) {
				
				print(dataDic["rentHistory"])
				
				for (var i = 0; i<dataDic["rentHistory"]?.count ; i++){
					let nowStage = dataDic["rentHistory"]![i]["nowStage"] as! String
					rentTime[nowStage] = dataDic["rentHistory"]![i]["returnDate"] as? String
				}
				print(rentTime)
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					
					self.tableview.reloadData()
					self.indicator.stopAnimating()
				})
			}
			
		}catch{
			bookAmount = test
			bookAmount.removeRange(Range<Int>(start: bookAmount.indexOf(episode.text!)!+1, end: bookAmount.count))
			print(bookAmount)
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.setView()
				self.indicator.stopAnimating()
				
			})
			print("new bookItems:ERROR")
		}
		
	}
}

class cellView: UITableViewCell {
	var title = UILabel()
	var date = UILabel()
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.addSubview(title)
		self.addSubview(date)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		title.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width/4, height: self.bounds.size.height)
		title.font = UIFont.systemFontOfSize(25)
		date.frame =  CGRect(x:title.frame.maxX, y: 0, width: self.bounds.size.width/2, height: self.bounds.size.height)
		date.font = UIFont.systemFontOfSize(25)
		
	}
	
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	
}


