//
//  bookdetailViewController.swift
//  collection
//
//  Created by iii-user on 2016/3/9.
//  Copyright © 2016年 plasma018. All rights reserved.
//

import UIKit

class bookdetailViewController: UIViewController,UIScrollViewDelegate {
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
	

	
	func back(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	
	
	
	
	override func viewDidAppear(animated: Bool) {
		
		//表頭
		self.navigationItem.title = "作品詳情"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "BACK", style: UIBarButtonItemStyle.Done, target: self, action: "back:")
		
		let viewS = self.view.frame.size
		
		scrollView.frame = CGRect(x: 0, y:self.navigationController!.navigationBar.frame.maxY, width: viewS.width, height: viewS.height)
		
		scrollView.contentSize = CGSize(width:viewS.width, height: viewS.height*2)
		
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
		
		
		//按鈕選單
		let enterBty = UIButton(type: UIButtonType.System)
		let clearBty = UIButton(type: UIButtonType.System)
		
		
	enterBty.setTitle("借閱", forState: UIControlState.Normal)
	clearBty.setTitle("評分", forState: UIControlState.Normal)
	enterBty.backgroundColor = UIColor.grayColor()
	let buttonW = titleView.frame.width/3
	let buttonH = titleView.frame.height/8
	enterBty.frame = CGRectMake(titleView.frame.midX-buttonW/2,bookImage.frame.maxY+10,buttonW,buttonH/6*8)

		titleView.addSubview(enterBty)
		
		
		
		

		self.view.addSubview(scrollView)
		
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()
//		bookImage.image = UIImage(named: "一拳超人")
//		bookName.text = "一拳超人"
		author.text = "村田雄介"
		episode.text = "第12集"
		bookState.text = "借出"
		scrollView.delegate = self
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.y > 40{
			print(scrollView.contentOffset.y)
			self.navigationItem.title = bookName.text
		}else{
			self.navigationItem.title = "作品詳情"
		}
	}
    
	


}
