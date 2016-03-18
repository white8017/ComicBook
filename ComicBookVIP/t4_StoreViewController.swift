//
//  t4_StoreViewController.swift
//  ComicBookVIP
//
//  Created by MakoAir on 2016/3/17.
//  Copyright © 2016年 Mako. All rights reserved.
//

import UIKit
import MapKit

class t4_StoreViewController: TabVCTemplate, MKMapViewDelegate {

    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    //    var store:String? = "白成租書坊"
    //    var address:String? = "434台中市龍井區台灣大道五段3巷62弄77號"
    //    var lat:Double? = 24.182468
    //    var lon:Double? = 120.590806
    
    var store:String?
    var phone:String?
    var address:String?
    var lat:Double?
    var lon:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTab = 3
        // do stuff here
        
        self.addressLabel.text = "龍井區台灣大道五段3巷62弄77號"
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

    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        self.addAnnotationsForMapView(mapView) //載入後呼叫自己建立的自訂圖標方法
    }
    
    func addAnnotationsForMapView(mapView:MKMapView) {
        
        store = String("白成租書坊")
        phone = String("0987-226-084")
        lat = 24.182468
        lon = 120.590806
        
        let theLocation = CLLocationCoordinate2D(latitude: lat!, longitude: lon!);
        let anno = MyAnnotation(theCoordinate: CLLocationCoordinate2D(latitude: theLocation.latitude, longitude: theLocation.longitude), theTitle: store!, theSubTitle: phone!)
        
        mapView.addAnnotations(Array(arrayLiteral: anno))
        
        //http://toyo0103.blogspot.tw/2015/03/swift-ios-2.html
        //將map中心點定在目前所在的位置
        //span是地圖zoom in, zoom out的級距
        let _span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025);
        self.mapView.setRegion(MKCoordinateRegion(center: theLocation, span: _span), animated: true);
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title! == store {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.title!)
            pin.pinTintColor = UIColor.purpleColor() //pin顏色
            pin.canShowCallout = true
            pin.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) //圖標資訊右側
            //pin.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "")) //圖標資訊左側
            //pin.animatesDrop = true
            return pin
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if view.reuseIdentifier == store {
            print("aaaa" + String(view.reuseIdentifier))
            
            let phoneNumber = "telprompt://0987226084" //telprompt -> 詢問；tel -> 默許
            UIApplication.sharedApplication().openURL(NSURL(string: phoneNumber)!)
        }
        
        //        if view.reuseIdentifier == "aaaaaa" {
        //            let kagaPlacemark = MKPlacemark(coordinate: (CLLocationCoordinate2D(latitude: 24.150478, longitude: 120.649538)), addressDictionary: nil)
        //
        //            let destination1 = MKMapItem(placemark: kagaPlacemark)
        //
        //            destination1.name = "加賀安安"
        //            destination1.openInMapsWithLaunchOptions(Dictionary(dictionaryLiteral: (MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsDirectionsModeKey)))
        //        }
        
    }

}

//Map
extension t4_StoreViewController {
    
    
    
}
