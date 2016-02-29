//
//  MainViewController.h
//  AdsumDemo
//
//  Created by Reynes Martial on 25/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MPGTextField.h"


@interface MainViewController : UIViewController // <UISearchBarDelegate>

-(void)showUI:(BOOL)b;
-(void)initSearchBox;
-(void)mapIsReady:(BOOL)b;
//@property (weak, nonatomic) IBOutlet MPGTextField *searchBox;
@property BOOL forceUpdate; 

-(void)setSearchBarText:(NSString*)text;
//- (void)textField:(MPGTextField *)textField didEndEditingWithSelection:(NSDictionary *)result;
//- (BOOL)textFieldShouldSelect:(MPGTextField *)textField;


@end
