//
//  MainViewController.h
//  AdsumReader
//
//  Created by Reynes Martial on 25/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPGTextField.h"

@interface MainViewController : UIViewController<MPGTextFieldDelegate, UITextFieldDelegate>

-(void)showUI:(BOOL)b;
-(void)initSearchBox;
-(void)mapIsReady;
@property (weak, nonatomic) IBOutlet MPGTextField *searchBox;

- (void)textField:(MPGTextField *)textField didEndEditingWithSelection:(NSDictionary *)result;
- (BOOL)textFieldShouldSelect:(MPGTextField *)textField;


@end
