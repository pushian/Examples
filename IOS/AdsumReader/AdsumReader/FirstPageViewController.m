//
//  FirstPageViewController.m
//  AdsumReader
//
//  Created by Reynes Martial on 29/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import "FirstPageViewController.h"
#import "MainViewController.h"

@interface FirstPageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buLoadSavedMap;

@end

@implementation FirstPageViewController

QRCodeReaderViewController *vcQrCodeReader;
QRCodeReader *reader=nil;
NSString *currentConfigXml;
bool forceUpdate=false;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *xml = [prefs stringForKey:@"configXml"];
    
    if (xml==nil)
    {
        [_buLoadSavedMap setEnabled:NO];
    }
    else
        currentConfigXml = xml;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)initQrCodeReaderIfNeeded
{
    if (reader!=nil) return;
    
    // check if the device supports the reader library
    if ([QRCodeReader isAvailable]==false)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                        message:@"QR Code reading is not available for your device. Please contact Adactive for help"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Create the reader object
    reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // Instantiate the view controller
    vcQrCodeReader = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
    
    // Set the presentation style
    vcQrCodeReader.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // Define the delegate receiver
    vcQrCodeReader.delegate = self;
}



- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        // note: le fichier xml se trouve dans "result"
        currentConfigXml = result;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:currentConfigXml forKey:@"configXml"];
        
        // on change de map, donc il faudra faire un force update
        forceUpdate=true;
        
        // we launch the loading of the new map on the main thread
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            [self performSegueWithIdentifier:@"segueGo" sender:self];
        }];
    }];
}



- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Get reference to the destination view controller
    UINavigationController *nc = [segue destinationViewController];
    MainViewController *mvc = [[nc childViewControllers] firstObject];

    mvc.forceUpdate = forceUpdate;
}

- (IBAction)buLoadSavedMap:(id)sender
{
    [self performSegueWithIdentifier:@"segueGo" sender:self];
}

- (IBAction)buLoadNewMap:(id)sender
{
    [self initQrCodeReaderIfNeeded];
    [self presentViewController:vcQrCodeReader animated:YES completion:NULL];
}

@end
