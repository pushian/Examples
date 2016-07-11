//
//  ViewController.h
//  AdsumReader
//
//  Created by Reynes Martial on 21/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdsumIOSAPI/ADSumMapViewController.h>

@interface ViewController : UIViewController<ADSumMapViewControllerDelegate>

@property (nonatomic, strong) ADSumMapViewController * adSumMapViewController;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressCircle;

@property NSArray<ADSPoi*> *pois;
@property long currentPoiId;
@property AdsumCoreDataManager *dataManager;

-(NSString*)switch2D3D;
-(void)changeFloorsButtonClicked:(UIButton*)button;
-(void)backButtonClicked;
-(void)centerOnPlace:(NSNumber*)placeId;
-(void)loadMap:(NSString*)xml forceUpdate:(BOOL)forceUpdate;

@end

