//
//  DrawPathViewController.h
//  AdsumDemo
//
//  Created by Reynes Martial on 15/02/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ViewController.h"
#import "AdsumCoreDataManager.h"

@interface DrawPathViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property MainViewController *mvc;
@property ViewController *vc;
@property AdsumCoreDataManager *dataManager;

@end
