//
//  FirstPageViewController.h
//  AdsumReader
//
//  Created by Reynes Martial on 29/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pods/QRCodeReaderViewController/QRCodeReaderViewController/QRCodeReaderViewController.h"
#import "Pods/QRCodeReaderViewController/QRCodeReaderViewController/QRCodeReaderDelegate.h"

@interface FirstPageViewController : UIViewController <QRCodeReaderDelegate>

@end
