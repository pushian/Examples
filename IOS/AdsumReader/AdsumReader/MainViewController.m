//
//  MainViewController.m
//  AdsumReader
//
//  Created by Reynes Martial on 25/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "DrawPathViewController.h"




@interface MainViewController ()
//@property (weak, nonatomic) IBOutlet UIButton *buSearch;
//@property (weak, nonatomic) IBOutlet UIButton *buFloors;
//@property (weak, nonatomic) IBOutlet UIButton *bu3d;
//@property (weak, nonatomic) IBOutlet UIButton *buBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buFloors;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bu3d;

@end

ViewController *vcAdsum;
bool mapIsReady=false;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    vcAdsum = (ViewController*)[[self childViewControllers] lastObject];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *xml = [prefs stringForKey:@"configXml"];
    [vcAdsum loadMap:xml forceUpdate:_forceUpdate];
    
    // apply custom button style
   // [MainViewController applyCustomButtonStyle:_bu3d];
   // [MainViewController applyCustomButtonStyle:_buFloors];
   // [MainViewController applyCustomButtonStyle:_buSearch];
   // [MainViewController applyCustomButtonStyle:_buBack];
    
    // hide all UI at start
   // [_bu3d setHidden:YES];
    //[_buFloors  setHidden:YES];
    //[_buSearch setHidden:YES];
    //[_buBack setHidden:YES];
    //[_searchBox setHidden:YES];
    
    // hide "floors" button
    /*[self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationItem.rightBarButtonItem setImage:nil];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)mapIsReady:(BOOL)b
{
    mapIsReady = b;

    
}

/*
- (IBAction)buQrCode:(id)sender
{
    if (!mapIsReady) return;
    [self initQrCodeReaderIfNeeded];
    [self presentViewController:vcQrCodeReader animated:YES completion:NULL];
}*/




- (IBAction)buFloors:(id)sender {
    if (!mapIsReady) return;
    [vcAdsum changeFloorsButtonClicked:sender];
}

- (IBAction)bu3d:(id)sender {
    if (!mapIsReady) return;
    NSString *newButtonText = [vcAdsum switch2D3D];
    [_bu3d setTitle:newButtonText];
}


- (IBAction)buBack:(id)sender {
    if (!mapIsReady) return;
    [vcAdsum backButtonClicked];
}



-(void)showUI:(BOOL)b
{
 //   [_searchBox setHidden:NO]; // toujours visible
    
   // [_bu3d setHidden:NO];  // toujours visible
  //  [_buFloors setHidden:!b];
   // [_buBack setHidden:NO]; // toujours visible
}



-(void)initSearchBox
{
    self.searchBox.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textFieldShouldSelect:(MPGTextField *)textField
{
    return YES;
}

-(void)textField:(MPGTextField *)textField didEndEditingWithSelection:(NSDictionary *)result
{
    ADSPoi *poi = (ADSPoi*)[result valueForKey:@"CustomObject"];
    NSArray<NSNumber*> *places = poi.placesIds;
    if ([places count]>0)
        [vcAdsum centerOnPlace:places[0]]; // mktodo: plusieurs places possible?
    
    self.searchBox.text=@"";
}

-(NSArray *)dataForPopoverInTextField:(MPGTextField *)textField
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    for (ADSPoi *poi in vcAdsum.pois)
    {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        [d setValue:poi.name forKey:@"DisplayText"];
        [d setValue:poi.className forKey:@"DisplaySubText"]; // optionnel
        [d setValue:poi forKey:@"CustomObject"];
        
        [data addObject:d];
    }
    
    return data;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"segueDrawPath"])
    {
        // Get reference to the destination view controller
        DrawPathViewController *vc = [segue destinationViewController];
        
        vc.mvc = self;
        vc.vc = vcAdsum;
        vc.dataManager = [vcAdsum dataManager];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
