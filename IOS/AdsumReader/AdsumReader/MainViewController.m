//
//  MainViewController.m
//  AdsumReader
//
//  Created by Reynes Martial on 25/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buSearch;
@property (weak, nonatomic) IBOutlet UIButton *buFloors;
@property (weak, nonatomic) IBOutlet UIButton *bu3d;
@property (weak, nonatomic) IBOutlet UIButton *buBack;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;

@end

ViewController *vcAdsum;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    vcAdsum = (ViewController*)[[self childViewControllers] lastObject];
    
    
    // apply custom button style
    [MainViewController applyCustomButtonStyle:_bu3d];
   // [MainViewController applyCustomButtonStyle:_buFloors];
   // [MainViewController applyCustomButtonStyle:_buSearch];
   // [MainViewController applyCustomButtonStyle:_buBack];
    
    // hide all UI at start
    [_bu3d setHidden:YES];
    [_buFloors setHidden:YES];
    [_buSearch setHidden:YES];
    [_buBack setHidden:YES];
    [_tfSearch setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buSearch:(id)sender {
    // deprecated: çà n'est pas un bouton maintenant (juste une image: mktodo: cleaner)
    
}
- (IBAction)buFloors:(id)sender {
    [vcAdsum changeFloorsButtonClicked:sender];
}

- (IBAction)bu3d:(id)sender {
    NSString *newButtonText = [vcAdsum switch2D3D];
    [_bu3d setTitle:newButtonText forState:UIControlStateNormal];
}

- (IBAction)buBack:(id)sender {
    [vcAdsum backButtonClicked];
    
}


-(void)showUI:(BOOL)b
{
    [_tfSearch setHidden:NO]; // toujours visible
    [_buSearch setHidden:NO]; // toujours visible
    [_bu3d setHidden:NO];  // toujours visible
    [_buFloors setHidden:!b];
    [_buBack setHidden:!b];
}


+ (void)applyCustomButtonStyle:(UIButton*)bu
{
    // marche moyen selon les cas, pas très beau
 
    /*
    bu.layer.borderWidth=1.0f;
    bu.layer.borderColor=[[UIColor blackColor] CGColor];
    bu.layer.cornerRadius = 10;
    bu.titleLabel.font = [UIFont systemFontOfSize:25];
    bu.titleLabel.backgroundColor = [UIColor whiteColor];
    bu.backgroundColor = [UIColor whiteColor];
    
    
    //NSString *title = [bu titleForState:UIControlStateNormal];
    //NSMutableString *ms = [NSMutableString stringWithString:title];
    //[ms insertString:@" " atIndex:0];
    //[ms appendString:@" "];
    //[bu setTitle:ms forState:UIControlStateNormal];

    
    // shadow
    bu.layer.shadowColor = [UIColor grayColor].CGColor;
    bu.layer.shadowOpacity = 0.8;
    bu.layer.shadowRadius = 2;
    bu.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);*/
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
