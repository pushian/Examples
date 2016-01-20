//
//  ViewController.m
//  BasicDemo
//
//  Created by Reynes Martial on 20/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Allocate memory to the ADSumMapViewController
    self.adSumMapViewController = [[ADSumMapViewController alloc] init];
    //Setup the size of the ADSumMapViewController display
    self.adSumMapViewController.AdactiveParentRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //Register your view controller as delegate to receive ADSumMapViewController events
    self.adSumMapViewController.delegate = self;
    //Setup the background color
    self.adSumMapViewController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor =[ UIColor whiteColor];
    //Add the ADSumMapViewController view to your ViewController view
    [self.view addSubview:self.adSumMapViewController.view];
    //Launch the downloading or update of the map data
    [self.adSumMapViewController update];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataDidFinishUpdating:(id)adSumViewController
{
    [self.adSumMapViewController start];
}

-(void)dataDidFinishUpdating:(id)adSumViewController withError:(NSError *)error
{
    //Check if there are map data allready downloaded
    if([self.adSumMapViewController isMapDataAvailable]){
        // You can start the map since map data are present
        [self.adSumMapViewController start];
        //[self.adSumMapViewController setSiteView]; // mkmodif test
        
    }else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"update finished with errors"
                                                          message:nil
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (void)mapDidFinishLoading:(id)adSumViewController
{
    //Customize the color of the inactive places to show the user those places don't behave like the others
    [self.adSumMapViewController customizeInactivePlaces:[UIColor redColor]];
    //Setup the type of camera you want (here 3D)
    [self.adSumMapViewController setCameraMode:FULL];
    
    [self.adSumMapViewController setCurrentFloor:0];
}

- (void)adSumViewController:(id)adSumViewController OnPOIClicked:(NSArray *)poiIDs placeId:(long)placeId
{
    //Unlight all the POIs previously highlighted
    [self.adSumMapViewController unLightAll];
    //Center the camera on the place the user clicked
    [self.adSumMapViewController centerOnPlace:placeId];
    //HighLight the first POI linked to the place the user clicked
    [self.adSumMapViewController highLightPlace:placeId color:[UIColor greenColor]];
}

@end