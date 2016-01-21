//
//  ViewController.h
//  AdsumReader
//
//  Created by Reynes Martial on 21/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<ADSumMapViewController.h>

@interface ViewController : UIViewController<ADSumMapViewControllerDelegate>

@property (nonatomic, strong) ADSumMapViewController * adSumMapViewController;


@end

