//
//  MainViewController.m
//  AdsumDemo
//
//  Created by Reynes Martial on 25/01/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "DrawPathViewController.h"
#import "SearchFeatureTableViewController.h"




@interface MainViewController ()
//@property (weak, nonatomic) IBOutlet UIButton *buSearch;
//@property (weak, nonatomic) IBOutlet UIButton *buFloors;
//@property (weak, nonatomic) IBOutlet UIButton *bu3d;
//@property (weak, nonatomic) IBOutlet UIButton *buBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buFloors;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bu3d;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buDrawPath;
@property (weak, nonatomic) IBOutlet UITextField *tfSearch;

@end

ViewController *vcAdsum;
bool mapIsReady=false;

@implementation MainViewController

-(void) copyDataDirectory:(NSString *)theDirectory {
    
    // copy files
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentDBFolderPath = [documentsDirectory stringByAppendingPathComponent:theDirectory];
    NSString *resourceDBFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:theDirectory];
    
    // erase all previous files
    BOOL success = [fileManager removeItemAtPath:documentDBFolderPath error:&error];
    if (!success || error) {
        // it failed.
        NSLog(@"copyDataDirectory : delete directory failed! %@", documentDBFolderPath);
    }
    
    // directory
    if (![fileManager fileExistsAtPath:documentDBFolderPath]) {
        //Create Directory!
        [fileManager createDirectoryAtPath:documentDBFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
    } else {
        NSLog(@"copyDataDirectory : Directory exists! %@", documentDBFolderPath);
    }
    
    // copy all files
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:resourceDBFolderPath error:&error];
    for (NSString *s in fileList) {
        NSString *newFilePath = [documentDBFolderPath stringByAppendingPathComponent:s];
        NSString *oldFilePath = [resourceDBFolderPath stringByAppendingPathComponent:s];
        if (![fileManager fileExistsAtPath:newFilePath]) {
            //File does not exist, copy it
            [fileManager copyItemAtPath:oldFilePath toPath:newFilePath error:&error];
        } else {
            NSLog(@"copyDataDirectory : File exists: %@", newFilePath);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self copyDataDirectory:@"files"];
    
    id children = [self childViewControllers];
    vcAdsum = (ViewController*)[children lastObject];
    
   
    [vcAdsum loadMap];
    
    // search bar
    /*
    searchController = [[UISearchController alloc] initWithSearchResultsController:self];
    // Use the current view controller to update the search results.
    //searchController.searchResultsUpdater = self;
    //searchController.delegate = self;
    // Install the search bar as the table header.
    self.navigationItem.titleView = searchController.searchBar;
    searchController.searchBar.delegate = self;
    searchController.searchBar.showsCancelButton = NO;
    // It is usually good to set the presentation context.
    self.definesPresentationContext = YES;
    // searchController.active = YES;*/
    _buDrawPath.enabled=NO;
    
    //if (b==YES)
    //  searchController.active = YES;
    
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


- (IBAction)tfSearchClicked:(id)sender {
   
}
- (IBAction)tfSearchEditingDidBegin:(id)sender {
     [self performSegueWithIdentifier:@"segueSearch" sender:self];
}

-(void)showUI:(BOOL)b
{
 //   [_searchBox setHidden:NO]; // toujours visible
    
   // [_bu3d setHidden:NO];  // toujours visible
  //  [_buFloors setHidden:!b];
   // [_buBack setHidden:NO]; // toujours visible
}

/*
-(void)didPresentSearchController:(UISearchController *)searchController
{
    
}*/

//helper method
/*
- (void)updateFilteredContentWithSearchText:(NSString*)searchText
{
    
    
    [self.specialtySearchResultsTVC.filteredSpecialties removeAllObjects];
    for (Specialty *specialty in self.specialties)
    {
        NSRange nameRange = [specialty.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound)
        {
            [self.specialtySearchResultsTVC.filteredSpecialties addObject:specialty];
        }
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //make sure model has only results that correspond to the search
    [self updateFilteredContentWithSearchText:[self.searchController.searchBar text]];
    //update the table now that the model has been updated
    [self.specialtySearchResultsTVC.tableView reloadData];
}*/

/*
-(void)presentSearchController:(UISearchController *)searchController
{
    return;
}
*/

/*
- (void)didPresentSearchController:(UISearchController *)searchController
{
    searchController.searchBar.showsCancelButton = NO;
    [searchController.searchBar setShowsCancelButton:NO animated:NO];
}*/

/*
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _buDrawPath.enabled=NO;
    searchController.searchBar.text = @"";
}*/

/*
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchController.active = NO;
    [self performSegueWithIdentifier:@"segueSearch" sender:self];
    return NO;
}*/

//UISearchController *searchController;



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)setSearchBarText:(NSString*)text
{
    _buDrawPath.enabled=YES;
    _tfSearch.text = text;
   // searchController.searchBar.text = text;
    
  //  searchController.searchBar.showsCancelButton = NO;
   // [searchController.searchBar setShowsCancelButton:NO animated:NO];
}



// mktodo: cliquer sur "x" de la searchbar ouvre la recherche (pas ok) puis rend la map toute noire quand on revient


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([[segue identifier] isEqualToString:@"segueDrawPath"])
    {
        // Get reference to the destination view controller
        DrawPathViewController *dvc = (DrawPathViewController*)[segue destinationViewController];
        
        if ([dvc isKindOfClass:[DrawPathViewController class]]) {
            dvc.mvc = self;
            dvc.vc = vcAdsum;
            dvc.dataManager = [vcAdsum dataManager];
        }
    }
    if ([[segue identifier] isEqualToString:@"segueSearch"])
    {
        // Get reference to the destination view controller
        SearchFeatureTableViewController *vc = (SearchFeatureTableViewController*)[segue destinationViewController];
        
        vc.mvc = self;
        vc.vc = vcAdsum;
        vc.dataManager = [vcAdsum dataManager];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
