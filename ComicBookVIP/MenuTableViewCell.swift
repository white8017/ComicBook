//
//  MenuTableViewCell.swift
//  collection
//
//  Created by plasma018 on 2016/3/19.
//  Copyright © 2016年 plasma018. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    var cellEpisode = UILabel()
	var cellMoney = UILabel()
	var amount = 0
	var money = 5
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(cellEpisode)
		self.contentView.addSubview(cellMoney)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
		cellEpisode.frame =  CGRect(x: 20, y: 0, width: self.bounds.size.width/4, height: self.bounds.size.height)
		cellMoney.frame =  CGRect(x: cellEpisode.frame.maxX, y: 0, width: self.bounds.size.width/4, height: self.bounds.size.height)
		cellMoney.text = "$"+String(money)
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
