//
//  FirstViewController.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/15.
//  Copyright © 2016年 Mako. All rights reserved.
//
//https://autolayout.club/2015/10/29/%E8%87%AA%E5%B7%B1%E5%8A%A8%E6%89%8B%E9%80%A0%E6%97%A0%E9%99%90%E5%BE%AA%E7%8E%AF%E5%9B%BE%E7%89%87%E8%BD%AE%E6%92%AD/

import UIKit

class t1_NewsViewContorller: TabVCTemplate, UITableViewDelegate, UITableViewDataSource {
    
    var count = 0
    var name:String!
    
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var headImagePageControl: UIPageControl!
    @IBOutlet var leftSwipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var rightSwipeGesture: UISwipeGestureRecognizer!
    
    @IBAction func swipeActionHandler(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Left {
            headImagePageControl.currentPage++
            headImageView.image = UIImage(named: "0\(headImagePageControl.currentPage+1)")
        } else {
            headImagePageControl.currentPage--
            headImageView.image = UIImage(named: "0\(headImagePageControl.currentPage+1)")
        }
        headImageView.image = UIImage(named: "0\(headImagePageControl.currentPage+1)")
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTab = 0
        // do stuff here
        
        //Page View Control
        headImageView.userInteractionEnabled = true
        //headImageView.contentMode = UIViewContentMode.ScaleAspectFill
        headImageView.image = UIImage(named: "0\(headImagePageControl.currentPage+1)")
        headImageView.addGestureRecognizer(leftSwipeGesture)
        headImageView.addGestureRecognizer(rightSwipeGesture)
        
        NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: Selector("changePic:"), userInfo: nil, repeats: true)
        
    }
    
    func changePic(sender:NSTimer) {
        count++
        headImagePageControl.currentPage = count % 4
        headImageView.image = UIImage(named: "0\(headImagePageControl.currentPage+1)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        setTabBarVisible(!tabBarIsVisible(), animated: true)
    }
    //http://www.jianshu.com/p/56c8b3c1403c
    //appear Tabbar
    func setTabBarVisible(visible:Bool, animated:Bool) {
        if (tabBarIsVisible() == visible) {
            return
        }
        
        let frame = self.tabBarController?.tabBar.frame
        let onsetY = (visible ? -49.0 : CGFloat(0))
            
        let duration:NSTimeInterval = (animated ? 0.1 : 0.0)
            
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, onsetY)
                return
            }
        }
        
    }
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath)
        //cell.textLabel?.text = sideMenu[indexPath.row]
        
        // Configure the cell...
        if indexPath.row == 0 {
            //cell.postImageView.image = UIImage(named: "watchkit-intro")
            cell.textLabel?.text = "03/08 - 本店將於3月14日進行水電陸整修，該日暫停營業一天，歸還書籍請投遞至門口還書箱，不便之處敬請見諒。"
            //cell.authorLabel.text = "Simon Ng"
            //cell.authorImageView.image = UIImage(named: "author")
            
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "02/07 - 恭賀新禧，猴年如意！本店祝各位新年快樂～"
            
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "02/06 - 為地震災區居民集氣！台南加油！"
            
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "02/02 - 本店新年期間不休店，歡迎各位光臨。"
            
        } else if indexPath.row == 4 {
            cell.textLabel?.text = "01/29 - “ 第四屆TICA台北國際動漫節 ” 開跑，將於 2016/2/10 (三) 至 2016/2/14 (日) 台北世貿南港展覽館舉行，千萬別錯過！"
            
        } else if indexPath.row == 5 {
            cell.textLabel?.text = "01/09 - 寒流來襲，各位顧客出門前記得注意自身保暖！"
            
        } else if indexPath.row == 6 {
            cell.textLabel?.text = "01/01 - 2016 Happy New Year! 從 1/1 到 1/31 凡會員來店消費，滿百即送十二元優惠金。"
            
        } else if indexPath.row == 7 {
            cell.textLabel?.text = "12/10 - 年末清倉，多本舊書作品低價出售，詳情請到本店洽詢。"
            
        } else if indexPath.row == 8 {
            cell.textLabel?.text = "11/29 - 凡 12/1 至 12/31 來店會員消費累滿50元即贈送精美動漫周邊精品。"

        } else {
            cell.textLabel?.text = "11/26 - 本店 11/27 將延後一小時於 12:00 開店，不便之處敬請見諒。"
            
        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let optionMenu = UIAlertController(title: nil, message: "本店將於3月14日進行水電陸整修，該日暫停營業一天，歸還書籍請投遞至門口還書箱，不便之處敬請見諒。", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "返    回", style: .Cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else if indexPath.row == 1 {
            let optionMenu = UIAlertController(title: nil, message: "恭賀新禧，猴年如意！本店祝各位新年快樂～", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "返    回", style: .Cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else if indexPath.row == 2 {
            let optionMenu = UIAlertController(title: nil, message: "為地震災區居民集氣！台南加油！", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "返    回", style: .Cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else if indexPath.row == 3 {
            let optionMenu = UIAlertController(title: nil, message: "本店新年期間不休店，歡迎各位光臨。", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "返    回", style: .Cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else if indexPath.row == 4 {
            let optionMenu = UIAlertController(title: nil, message: "“ 第四屆TICA台北國際動漫節 ” 開跑，將於 2016/2/10 (三) 至 2016/2/14 (日) 台北世貿南港展覽館舉行，千萬別錯過！", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "返    回", style: .Cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else if indexPath.row == 5 {
            let optionMenu = UIAlertController(title: nil, message: "寒流來襲，各位顧客出門前記得注意自身保暖！", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "返    回", style: .Cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else if indexPath.row == 6 {
            let optionMenu = UIAlertController(title: nil, message: "2016 Happy New Year! 從 1/1 到 1/31 凡會員來店消費，滿百即送十二元優惠金。", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "返    回", style: .Cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else if indexPath.row == 7 {
            let optionMenu = UIAlertController(title: nil, message: "年末清倉，多本舊書作品低價出售，詳情請到本店洽詢。", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "返    回", style: .Cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else if indexPath.row == 8 {
            let optionMenu = UIAlertController(title: nil, message: "凡 12/1 至 12/31 來店會員消費累滿50元即贈送精美動漫周邊精品。", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "返    回", style: .Cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else {
            let optionMenu = UIAlertController(title: nil, message: "本店 11/27 將延後一小時於 12:00 開店，不便之處敬請見諒。", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "返    回", style: .Cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        }
    }
    

}

