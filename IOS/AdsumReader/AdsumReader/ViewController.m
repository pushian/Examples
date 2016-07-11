//
//  ViewController.m
//  AdsumReader
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

-(void)createConfigXML:(NSString *)xmlContent{
    NSFileManager*  fileManager = [NSFileManager defaultManager];
    NSURL * documentsURL =[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    
    if (documentsURL != nil) {
        NSURL * filesURL = [documentsURL URLByAppendingPathComponent:@"files"];
        NSString * path = filesURL.path;
        if(path!=nil){
            @try {
                [fileManager createDirectoryAtURL:filesURL withIntermediateDirectories:NO attributes:nil error:nil];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.reason);
            }
         
            NSData *databuffer;
            databuffer = [xmlContent dataUsingEncoding:NSUTF8StringEncoding];
            
            NSString * filename = @"config.xml";
            
            NSURL * toUrl = [filesURL URLByAppendingPathComponent:filename];
            
            @try {
                [fileManager createFileAtPath:[toUrl relativePath] contents:databuffer attributes:nil];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.reason);
            }
            
            
        }
    }
    
}

-(void)loadMap:(NSString*)newXml forceUpdate:(BOOL)forceUpdate
{
    
    [self createConfigXML:newXml];
    
    //Allocate memory to the ADSumMapViewController
    self.adSumMapViewController = [[ADSumMapViewController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    //Register your view controller as delegate to receive ADSumMapViewController events
    self.adSumMapViewController.delegate = self;
    //Setup the background color
    self.adSumMapViewController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [ UIColor whiteColor];
    //Add the ADSumMapViewController view to your ViewController view
    [self.view addSubview:self.adSumMapViewController.view];
    
    //Launch the downloading or update of the map data
    if (forceUpdate)
        [self.adSumMapViewController forceUpdateWithExData:YES];
    else
        [self.adSumMapViewController updateWithExData:YES];
    
    // go
    [_progressCircle setHidden:NO];
    [_progressCircle startAnimating];
}

/*
 -(void)loadNewMap:(NSString *)xml
 {
 //
 //if(!FilesUtils::Instance()->copyFile(std::string(path)+"/"+ADSUM_CONFIG, dirFiles.string()+"/"+"config.xml")){
 //    std::cout<< "ADSUM_ERROR Missing"<< ADSUM_CONFIG <<" file in your app bundle" <<std::endl;
 
 [self.adSumMapViewController updateConfigXmlFile:(NSString*)xml];
 
 [vcMain mapIsReady:NO];
 [self loadMap:YES];
 }*/

/*
 -(void)viewWillLayoutSubviews
 {
 CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
 
 AdsumCoreView *acv = [self.adSumMapViewController getAdsumCoreView];
 
 acv.frame = rect;
 
 
 //self.adSumMapViewController.AdactiveParentRect = rect;
 // [self.adSumMapViewController
 // [self.adSumMapViewController update];
 
 // AdsumCoreView *acv = (AdsumCoreView *)self.adSumMapViewController.;
 
 //acv=acv;
 //[self.adSumMapViewController. AdsumCoreView setupView];
 
 //[acv resizeViewportWithWidth:self.view.frame.size.width height:self.view.frame.size.height];
 }*/

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

- (void)initFloorsButtons
{
    /* deprecated
     long buildingId = [self.adSumMapViewController getCurrentBuilding];
     NSArray *floors = [self.adSumMapViewController getBuildingFloors:buildingId];
     //long floorId = [self.adSumMapViewController getCurrentFloor];
     
     int y = 200;
     for (NSNumber *a_floorId in floors)
     {
     NSString *floorName = [a_floorId stringValue];
     
     UIButton *buTest = [UIButton buttonWithType: UIButtonTypeRoundedRect];
     buTest.frame = CGRectMake(20, y, 100, 18);
     [buTest setTitle:floorName forState:UIControlStateNormal];
     [buTest addTarget:self action:@selector(buChangeFloor:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:buTest];
     
     y+=30;
     }
     */
}

- (void)mapDidFinishLoading:(id)adSumViewController
{
    // init
    [self.adSumMapViewController setCameraMode:CameraMode_FULL];
    [self initFloorsButtons];
    
    // parent view controller
    vcMain = (MainViewController*)[self parentViewController];
    [vcMain showUI:YES];
    
    // get data manager
    _dataManager = [adSumViewController getDataManager];
    
    // data for search box
    _pois = [_dataManager getAllADSPois];
    
    // other data (pour test)
    //NSArray<ADSCategory*> *categories = [dataManager getAllADSCategories];
    //NSArray<ADSMedia*> *medias = [dataManager getAllADSMedias];
    
    // init search box
    [vcMain initSearchBox];
    
    // done
    [vcMain mapIsReady:YES];
    [_progressCircle stopAnimating];
    [_progressCircle setHidden:YES];
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
}

-(void)centerOnPlace:(NSNumber*)placeId
{
    //Unlight all the POIs previously highlighted
    [self.adSumMapViewController unLightAll];
    //Center the camera on the place
    [self.adSumMapViewController centerOnPlace:[placeId longValue]];
    //HighLight the first POI linked to the place
    [self.adSumMapViewController highLightPlace:[placeId longValue] color:[UIColor greenColor]];
}

@end
