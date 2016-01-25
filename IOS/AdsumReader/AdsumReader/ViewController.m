//
//  ViewController.m
//  AdsumReader
//
//  Created by Reynes Martial on 20/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import "ViewController.h"
#import "Pods/ActionSheetPicker-3.0/Pickers/ActionSheetPicker.h"

@interface ViewController ()

@end

// mktodo :mettre progress circle au démarrage
// mktodo: faire ce qu'il manque par rapport à la version android

CameraMode currentCameraMode = FULL;
UIButton *bu3d, *buChangeFloors, *buBack;

@implementation ViewController

- (IBAction)bu3d:(id)sender {
    
    
    if (currentCameraMode==FULL)
    {
        currentCameraMode = ORTHO;
        [bu3d setTitle:@"3D" forState:UIControlStateNormal];
    }
    else
    {
        currentCameraMode = FULL;
        [bu3d setTitle:@"2D" forState:UIControlStateNormal];
    }
    
    [self.adSumMapViewController setCameraMode:currentCameraMode];
}

- (IBAction)buBack:(id)sender {
    [self showButtons:false];
    [self.adSumMapViewController setSiteView];
}



- (void) adSumViewController:		(id) 	adSumViewController
           OnBuildingClicked:		(long) 	buildingId
{
    [self.adSumMapViewController setCurrentBuilding:buildingId];
    [self showButtons:true];
}

-(void)showButtons:(bool)b
{
    [bu3d setHidden:!b];
    [buChangeFloors setHidden:!b];
    [buBack setHidden:!b];
}

- (IBAction)buChangeFloors:(id)sender {
    
    
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
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           // NSLog(@"Picker: %@, Index: %@, value: %@",
                                           //     picker, selectedIndex, selectedValue);
                                           NSString *s = (NSString*)selectedValue;
                                           long floorId = [s intValue];
                                           [self.adSumMapViewController setCurrentFloor:floorId];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    // You can also use self.view if you don't have a sender
    
    // mktodo: ok d'utiliser getBuildingFloors ou bien faudrait utiliser getSortedFloors ? à réfléchir et discuter avec l'équipe
    //long buildingId = [self.adSumMapViewController getCurrentBuilding];
    //NSArray *floors = [self.adSumMapViewController getBuildingFloors:buildingId];
    //long floorId = [self.adSumMapViewController getCurrentFloor];
    
    
    // mktodo: si on fait les boutons flottants comme sur android le code sera plus simple que là
    // mktodo : si on reste comme çà : faut gérer le enabled/disabled des boutons up et down
    // mktodo : virer ce code
    /* bool getNext=NO;
     for (NSNumber *a_floorId in floors) {
     
     if (getNext==YES)
     {
     floorId = [a_floorId longValue];
     break;
     }
     if ([a_floorId longValue] == floorId)
     getNext=YES;
     }*/
    
    // UIButton * bu = (UIButton*)sender;
    // long floorId = [bu.titleLabel.text intValue];
    //[self.adSumMapViewController setCurrentFloor:floorId];
}





- (void)viewDidLoad {
    [super viewDidLoad];


    //Allocate memory to the ADSumMapViewController
    self.adSumMapViewController = [[ADSumMapViewController alloc] init];
    //Setup the size of the ADSumMapViewController display
    self.adSumMapViewController.AdactiveParentRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //Register your view controller as delegate to receive ADSumMapViewController events
    self.adSumMapViewController.delegate = self;
    //Setup the background color
    self.adSumMapViewController.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [ UIColor whiteColor];
    //Add the ADSumMapViewController view to your ViewController view
    [self.view addSubview:self.adSumMapViewController.view];
    //Launch the downloading or update of the map data
    [self.adSumMapViewController update];
    
    // go
    [_progressCircle startAnimating];
}

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
    //Customize the color of the inactive places to show the user those places don't behave like the others
    [self.adSumMapViewController customizeInactivePlaces:[UIColor redColor]];
    //Setup the type of camera you want (here 3D)
    [self.adSumMapViewController setCameraMode:FULL];
    
    [self.adSumMapViewController setCurrentFloor:0];
    
    // inutile maintenant, virer (mktodo)
    // petite bidouille pour que la vue 3D ne s'affiche pas par dessus les boutons de l'UI
    // mktodo: faire un meilleur système (mettre la vue 3D dans une vue enfant?)
    //self.view.layer.zPosition = -1; // note: ceci ne marche pas pour placer la vue map "en dessous" du reste
    //_buUpFloor.layer.zPosition = 100;
    
    [self initFloorsButtons];
    
    
    // init button 2D/3D
    bu3d = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    bu3d.frame = CGRectMake(20, 50, 150, 30);
    [bu3d setTitle:@"2D" forState:UIControlStateNormal];
    [bu3d addTarget:self action:@selector(bu3d:) forControlEvents:UIControlEventTouchUpInside];
    [ViewController applyCustomButtonStyle:bu3d];
    [self.view addSubview:bu3d];
    
    // init change floor button
    buChangeFloors = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    buChangeFloors.frame = CGRectMake(20, 100, 150, 30);
    [buChangeFloors setTitle:@"Change floor" forState:UIControlStateNormal];
    [buChangeFloors addTarget:self action:@selector(buChangeFloors:) forControlEvents:UIControlEventTouchUpInside];
    [ViewController applyCustomButtonStyle:buChangeFloors];
    [self.view addSubview:buChangeFloors];
    
    // init button "back"
    buBack = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    buBack.frame = CGRectMake(20, 150, 150, 30);
    [buBack setTitle:@"Back" forState:UIControlStateNormal];
    [buBack addTarget:self action:@selector(buBack:) forControlEvents:UIControlEventTouchUpInside];
    [ViewController applyCustomButtonStyle:buBack];
    [self.view addSubview:buBack];
    
    // done
    [_progressCircle stopAnimating];
    [_progressCircle setHidden:YES];
}

// mktodo: mettre çà ailleurs ou différemment
+ (void)applyCustomButtonStyle:(UIButton*)bu
{
    bu.layer.borderWidth=1.0f;
    bu.layer.borderColor=[[UIColor blackColor] CGColor];
    bu.layer.cornerRadius = 10;
    bu.titleLabel.font = [UIFont systemFontOfSize:20];
    bu.titleLabel.backgroundColor = [UIColor whiteColor];
    bu.backgroundColor = [UIColor whiteColor];
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
