//
//  DrawPathViewController.h
//  AdsumReader
//
//  Created by Reynes Martial on 29/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPGTextField.h"
#import "MainViewController.h"
#import "ViewController.h"
#import <AdsumIOSAPI/AdsumCoreDataManager.h>


@interface DrawPathViewController : UIViewController<MPGTextFieldDelegate, UITextFieldDelegate>

@property MainViewController *mvc;
@property ViewController *vc;
@property AdsumCoreDataManager *dataManager;

@end
