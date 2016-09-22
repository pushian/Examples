//
//  ViewController.m
//  AdsumDemo
//
//  Created by Reynes Martial on 20/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import "Pods/ActionSheetPicker-3.0/Pickers/ActionSheetPicker.h"

@interface ViewController ()

@end



CameraMode currentCameraMode = CameraMode_FULL;
MainViewController *vcMain;

@implementation ViewController



-(NSString*) switch2D3D
{
    NSString *newButtonText;
    
    if (currentCameraMode==CameraMode_FULL)
    {
        currentCameraMode = CameraMode_ORTHO;
        newButtonText = @"3D"; //[bu3d setTitle:@"3D" forState:UIControlStateNormal];
    }
    else
    {
        currentCameraMode = CameraMode_FULL;
        newButtonText = @"2D"; //[bu3d setTitle:@"2D" forState:UIControlStateNormal];
    }
    
    [self.adSumMapViewController setCameraMode:currentCameraMode];
    
    return newButtonText;
}


//- (IBAction)buBack:(id)sender {
-(void)backButtonClicked
{
    [vcMain showUI:NO];
    [self.adSumMapViewController setSiteView];
}



- (void) adSumViewController:		(id) 	adSumViewController
           OnBuildingClicked:		(long) 	buildingId
{
    [self.adSumMapViewController setCurrentBuilding:buildingId];
    [vcMain showUI:YES];
}


-(void)changeFloorsButtonClicked:(UIButton*)button
{
    long buildingId = [self.adSumMapViewController getCurrentBuilding];
    NSArray *adsumFloors = [self.adSumMapViewController getBuildingFloors:buildingId];
    long currentFloorId = [self.adSumMapViewController getCurrentFloor];
    
    
    int currentFloorPositionInFloorsArray = 0;
    
    NSMutableArray *floorsArray = [NSMutableArray array];
    int pos=0;
    for (NSNumber *a_floorId in adsumFloors)
    {
        NSString *floorName = [a_floorId stringValue];
        [floorsArray addObject:floorName];
        
        if ([a_floorId longValue] == currentFloorId)
            currentFloorPositionInFloorsArray = pos;
        
        pos++;
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select a floor"
                                        rows:floorsArray
                                        initialSelection:currentFloorPositionInFloorsArray
                                        doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
                                        {
                                           // NSLog(@"Picker: %@, Index: %@, value: %@", picker, selectedIndex, selectedValue);
                                           NSString *s = (NSString*)selectedValue;
                                           long floorId = [s intValue];
                                           [self.adSumMapViewController setCurrentFloor:floorId];
                                        }
                                        cancelBlock:^(ActionSheetStringPicker *picker)
                                        {
                                            // NSLog(@"Block Picker Canceled");
                                        }
                                        origin:button];  // You can also use self.view if you don't have a sender
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentPoiId = -1;
}

-(void)viewWillLayoutSubviews
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.adSumMapViewController.view.frame = rect;
}

-(void)loadMap
{
   
    //Allocate memory to the ADSumMapViewController
    self.adSumMapViewController = [[ADSumMapViewController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    //Register your view controller as delegate to receive ADSumMapViewController events
    self.adSumMapViewController.delegate = self;
    //Setup the background color
    self.adSumMapViewController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [ UIColor whiteColor];
    //Add the ADSumMapViewController view to your ViewController view
    [self.view addSubview:self.adSumMapViewController.view];
    
    // Launch the loading of the map
    [self.adSumMapViewController updateWithExData:YES];
    if([self.adSumMapViewController isMapDataAvailable])
    {
    [self.adSumMapViewController start];  // go
    }
        [_progressCircle setHidden:NO];
    [_progressCircle startAnimating];
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
    // init
    [self.adSumMapViewController setCameraMode:CameraMode_FULL];
    
    // parent view controller
    vcMain = (MainViewController*)[self parentViewController];
    [vcMain showUI:YES];
    
    // limit camera movements : NO
    [self.adSumMapViewController limitCameraMovements:NO];
    
    // get data manager
    _dataManager = [adSumViewController getDataManager];
    
    // set up path object config
    /*AdsumCorePath *p = [adSumViewController getPathObject];
    [p setPatternOffsetWithX:0 Y:0 Z:7];
    [p setMarkerSizeWithX:8 Y:8];
    [p setMarkerMode: ROTATE_TO_CAMERA];
    [p setSpace:5];*/
    
    // data for search box
    _pois = [_dataManager getAllADSPois];
    
    // other data (pour test)
    //NSArray<ADSCategory*> *categories = [dataManager getAllADSCategories];
    //NSArray<ADSMedia*> *medias = [dataManager getAllADSMedias];
    
      
    // done
    [vcMain mapIsReady:YES];
    [_progressCircle stopAnimating];
    [_progressCircle setHidden:YES];
}

-(void)drawPathFrom:(long)fromPoiId to:(long)toPoiId
{
    [self.adSumMapViewController drawPathFrom:fromPoiId to:toPoiId];
}

- (void)adSumViewController:(id)adSumViewController OnPOIClicked:(NSArray *)poiIDs placeId:(long)placeId
{
    if ([poiIDs count]>0)
    {
        _currentPoiId = [[poiIDs firstObject] longValue];
    }
    
    //Unlight all the POIs previously highlighted
    [self.adSumMapViewController unLightAll];
    //Center the camera on the place the user clicked
    [self.adSumMapViewController centerOnPlace:placeId];
    //HighLight the first POI linked to the place the user clicked
    [self.adSumMapViewController highLightPlace:placeId color:[UIColor greenColor]];
    
    ADSPoi *poi = [_dataManager getADSPoiFromId:_currentPoiId];
    if (poi!=nil)
        [vcMain setSearchBarText:[poi name]];
}

-(void)centerOnPlace:(NSNumber*)placeId
{
    // Unlight all the POIs previously highlighted
    [self.adSumMapViewController unLightAll];
    
    // Center the camera on the place
    [self.adSumMapViewController centerOnPlace:[placeId longValue]];
    
    // change floor if needed
    long floorId = [self.adSumMapViewController getPlaceFloor:[placeId longValue]];
    if (floorId!=[self.adSumMapViewController getCurrentFloor])
    {
        [self.adSumMapViewController setCurrentFloor:floorId];
    }
    
    // HighLight the first POI linked to the place
    [self.adSumMapViewController highLightPlace:[placeId longValue] color:[UIColor greenColor]];
}

@end
