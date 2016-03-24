//
//  CollectionViewCell.swift
//  collection
//
//  Created by iii-user on 2016/3/2.
//  Copyright © 2016年 plasma018. All rights reserved.
//

import UIKit
protocol  CollectionViewCellDelegate{
	func changeArray(src:String , dis:String , img:UIImage)
}
class CollectionViewCell: UICollectionViewCell,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverPresentationControllerDelegate
	,ViewControllerDelegate{
	var textLabel: UILabel!
	var testImage : UIImage!
	var imageView = UIImageView()
	var bookItems = "預設"
	var textLabel1: UILabel!
	var deleteButton = UIButton(type: UIButtonType.System)
	var deleteB1 = UIImageView()
	var source : String!
    let indicator = UIActivityIndicatorView()
	var cellID : Int!
	var delegate : CollectionViewCellDelegate?
	override init(frame: CGRect) {
		super.init(frame:frame)

        let base = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
       
		
        indicator.frame =  CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        indicator.color = UIColor.blueColor()
        indicator.startAnimating()
        indicator.transform = CGAffineTransformMakeScale(3, 3)
        
		//cell照片樣式
		imageView.image = UIImage(named: "img_not_available")
		imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.grayColor().CGColor
        imageView.layer.borderWidth = 1.0
        imageView.clipsToBounds = true
		//cell文字樣式
		textLabel = UILabel(frame: CGRect(x: 0, y: frame.size.height-30, width: frame.size.width, height: frame.size.height/3))
		textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
		textLabel.text = "預設"
		textLabel.font = textLabel.font.fontWithSize(20)
		textLabel.textColor = UIColor.whiteColor()
		textLabel.textAlignment = .Center
		self.textLabel.layer.cornerRadius = 10
		self.textLabel.layer.borderColor = UIColor.grayColor().CGColor
		self.textLabel.layer.borderWidth = 1.0
		self.textLabel.clipsToBounds = true
		//cell文字背景
		textLabel1 = UILabel(frame: CGRect(x: 0, y: frame.size.height-30, width: frame.size.width, height: frame.size.height/3))
		textLabel1.backgroundColor=UIColor.blackColor()
		textLabel1.alpha=0.5
		self.textLabel1.layer.cornerRadius = 10
		self.textLabel1.layer.borderColor = UIColor.grayColor().CGColor
		self.textLabel1.layer.borderWidth = 1.0
		self.textLabel1.clipsToBounds = true
		
		self.addSubview(base)
		self.addSubview(imageView)
		self.addSubview(textLabel1)
		self.addSubview(textLabel)
		self.addSubview(indicator)

		deleteButton.setImage(UIImage(named: "delete_32px_1189401_easyicon.net"), forState: UIControlState.Normal)
		deleteButton.frame = CGRectMake(-10,-10,40,40)
		deleteButton.layer.cornerRadius = 0.5 * deleteButton.bounds.size.width
		deleteButton.backgroundColor = UIColor.whiteColor()
//		deleteButton.contentMode = UIViewContentMode.ScaleToFill
		self.addSubview(deleteButton)
		
		// cell點2呼交功能
		let tapRecognizer = UITapGestureRecognizer(target: self,action:"changePhoto:")
		tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 2
		
        // cell點1跳下一頁
		let tap = UITapGestureRecognizer(target: self, action: "toPage:")
		self.gestureRecognizers = [tap,tapRecognizer]
		tap.numberOfTapsRequired = 1
		tap.numberOfTouchesRequired = 1
		print("create cell ok")
		
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		imageView.image = UIImage(named: "img_not_available")
	}
	
    
	//cell點一下功能
	func toPage(recognizer:UITapGestureRecognizer){
		print("touch: one")
		let bookdetail = bookdetailViewController()
//		let navController = UINavigationController(rootViewController: bookdetail )
		
		bookdetail.bookName.text = textLabel.text
		bookdetail.bookImage.image = imageView.image
		
		
		self.window?.rootViewController!.presentViewController(bookdetail, animated: true, completion: nil)
	}
	
	
	
	//cell點2下的功能
	func changePhoto(recognizer:UITapGestureRecognizer) {
		print("touch: teice")
		
       let menuViewController = Plasma018ViewController()
        menuViewController.modalPresentationStyle = .Popover
        menuViewController.preferredContentSize = CGSizeMake((self.window?.frame.size.width)!/1.5, (self.window?.frame.size.height)!/2)
	
		menuViewController.imageView.image = self.imageView.image
		menuViewController.textLabel1.text = self.textLabel.text
		menuViewController.booktextfield.text = self.textLabel.text
		menuViewController.delegate = self
		menuViewController.bookItems = bookItems
        let popoverMenuViewController = menuViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = self.window
        popoverMenuViewController?.sourceRect =  CGRect(
            x: (self.window?.frame.size.width)!/2,
            y: (self.window?.frame.size.height)!/2,
            width: 0,
            height: 0)
      
        self.window?.rootViewController?.presentViewController(
            menuViewController,
            animated: true,
            completion: nil)
	}
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    
	//儲存編輯後的結果
	func saveEditing( image : UIImage, bookName : String) {
		imageView.image = image
		textLabel.text = bookName
		
		self.delegate?.changeArray(source, dis:bookName,img:image )
		source = bookName
		print("//儲存編輯後的結果")
	}
	
	

}

