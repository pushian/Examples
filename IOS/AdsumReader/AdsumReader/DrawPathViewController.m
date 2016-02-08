//
//  DrawPathViewController.m
//  AdsumReader
//
//  Created by Reynes Martial on 29/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import "DrawPathViewController.h"
#import "MainViewController.h"
#import "ViewController.h"

@interface DrawPathViewController ()
@property (weak, nonatomic) IBOutlet MPGTextField *tfFrom;
@property (weak, nonatomic) IBOutlet MPGTextField *tfTo;

@end



@implementation DrawPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set size of view in popover
    CGSize size = CGSizeMake(400, 200);
    self.preferredContentSize = size;
    
    // init text fields
    _tfFrom.delegate = self;
    _tfTo.delegate = self;
    
    // mktodo: si un poi est sélectionné sur la map quand on ouvre "drawpath" : from doit etre préselectionné (c'est dans le cahier des charges)
    
    if (_vc.currentPoiId!=-1)
    {
        ADSPoi *poi = [_dataManager getADSPoiFromId:_vc.currentPoiId];
        poiFrom = poi;
        _tfFrom.text = [poi name];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)buDisplayPath:(id)sender
{
    if (poiFrom==nil || poiTo==nil) return;
    
    // mktodo: draw the path between "from" and "to" -> marche pas?
    [self.vc.adSumMapViewController drawPathFrom:[poiFrom.uid longValue] to:[poiTo.uid longValue]];
    
    // highlight "from" and "to"
   [self.vc.adSumMapViewController unLightAll];
   [self.vc.adSumMapViewController highLightPOI:[poiFrom.uid longValue] color:[UIColor greenColor]];
   [self.vc.adSumMapViewController highLightPOI:[poiTo.uid longValue] color:[UIColor greenColor]];
    // mktodo: çà en highligthe qu'un seul...
    // mktodo: faut higlighter poi ou place ? android utilise poi
    
    // close this viewcontroller
    [self dismissViewControllerAnimated:YES completion:Nil];
}



-(BOOL)textFieldShouldSelect:(MPGTextField *)textField
{
    return YES;
}

ADSPoi *poiFrom, *poiTo;

-(void)textField:(MPGTextField *)textField didEndEditingWithSelection:(NSDictionary *)result
{
    ADSPoi *poi = (ADSPoi*)[result valueForKey:@"CustomObject"];
    
    if (textField==_tfFrom)
    {
        poiFrom = poi;
        [_tfTo becomeFirstResponder];
    }
    if (textField==_tfTo)
        poiTo = poi;
}

-(NSArray *)dataForPopoverInTextField:(MPGTextField *)textField
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    for (ADSPoi *poi in _vc.pois)
    {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        [d setValue:poi.name forKey:@"DisplayText"];
        [d setValue:poi.className forKey:@"DisplaySubText"];
        [d setValue:poi forKey:@"CustomObject"];
        
        [data addObject:d];
    }
    
    return data;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
