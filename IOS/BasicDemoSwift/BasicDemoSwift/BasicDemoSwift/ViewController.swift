//
//  ViewController.swift
//  BasicDemoSwift
//
//  Created by Reynes Martial on 01/02/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, ADSumMapViewControllerDelegate {
    
    var adSumMapViewController: ADSumMapViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.adSumMapViewController = ADSumMapViewController()
        self.adSumMapViewController.AdactiveParentRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.adSumMapViewController.delegate = self
        self.adSumMapViewController.view.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.adSumMapViewController.view)
        var data: AdsumCoreDataManager;
        data.get
        self.adSumMapViewController.update()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataDidFinishUpdating(adSumViewController: AnyObject!) {
        self.adSumMapViewController.start()
    }
    
    func dataDidFinishUpdating(adSumViewController: AnyObject!, withError error: NSError!) {
        if(self.adSumMapViewController .isMapDataAvailable()) {
            self.adSumMapViewController.start()
        } else {
            let alert = UIAlertController(title: "Update finished with errors", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let yesButton = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(yesButton)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func mapDidFinishLoading(adSumViewController: AnyObject!) {
        //self.adSumMapViewController.customizeInactivePlaces(UIColor.redColor())

        self.adSumMapViewController.setCameraMode(ObjectiveBridge().Get_CameraMode_FULL());


        
        self.adSumMapViewController.setCurrentFloor(2);
        
        self.adSumMapViewController.setZoom(0.1);
        
        //if([self.delegate respondsToSelector:@selector(adSumViewController:OnPOIClicked:placeId:)])
        
        let canWork = self.respondsToSelector(Selector("mapDidFinishLoading:"))
        if canWork==false {
            NSLog(" BUG ");
        }
        else {
            NSLog(" OK");
        }
        
        
        //- (void)adSumViewController:(id)adSumViewController OnPOIClicked:(NSArray *)poiIds placeId:(long)placeId;
        let canWork2 = self.respondsToSelector(Selector("adSumViewController:OnPOIClicked:placeId:"))
            if canWork2==false {
            NSLog(" BUG ");
        }
            else {
            NSLog(" OK");
        }

    }
 //   func OnPOIClicked(poiIds: [AnyObject]!, adSumViewController: AnyObject!, placeId: NSNumber!) {
  //      NSLog(" EEEE");
  //  }
   /*func OnPOIClicked(poiIds: [AnyObject]!, placeId: NSNumber!, adSumViewController: AnyObject!) {
    NSLog(" EEEE");
}*/
    
    func OnPOIClicked(poiIds: [AnyObject]!, placeId: Int, adSumViewController: AnyObject!) {
        NSLog(" EEEE");
    }

    /*
    func adSumViewController(adSumViewController: AnyObject!, onPOIClicked poiIds: [AnyObject]!, placeId: AnyObject!) {
        NSLog(" ahah");
       // self.adSumMapViewController.unLightAll()
       // self.adSumMapViewController.centerOnPlace(placeId)
       // self.adSumMapViewController.highLightPlace(placeId, color: UIColor.greenColor())
    }*/
    /*
    func adSumViewController(adSumViewController: AnyObject!, onPOIClicked poiIds: [AnyObject]!, placeId: Int) {
        self.adSumMapViewController.unLightAll()
        self.adSumMapViewController.centerOnPlace(placeId)
        self.adSumMapViewController.highLightPlace(placeId, color: UIColor.greenColor())
    }*/
}
