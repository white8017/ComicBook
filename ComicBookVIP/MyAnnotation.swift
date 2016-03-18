//
//  MyAnnotation.swift
//  SidebarMenu
//
//  Created by MakoAir on 2016/3/14.
//  Copyright © 2016年 AppCoda. All rights reserved.
//

import Foundation
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    
    var coordinate:CLLocationCoordinate2D
    var title:String?
    var subtitle:String?
    
    //加入自訂圖標
    init(theCoordinate:CLLocationCoordinate2D, theTitle:String, theSubTitle:String) {
        coordinate = theCoordinate
        title = theTitle
        subtitle = theSubTitle
        super.init()
    }
    
}
