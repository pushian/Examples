//
//  SearchFeatureTableViewController.m
//  AdsumDemo
//
//  Created by Reynes Martial on 15/02/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import "SearchFeatureTableViewController.h"
#import "ViewController.h"

@interface SearchFeatureTableViewController ()


@end



@implementation SearchFeatureTableViewController


NSArray<ADSPoi*> *poisFull;
NSArray<ADSPoi*> *pois;
NSString *currentSearchText;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentSearchText = @"";
    
    poisFull = [_dataManager getAllADSPois];
    pois = [NSArray<ADSPoi*> arrayWithArray:poisFull];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    //searchBarView.autoresizingMask = 0;
    searchBar.delegate = self;
    //[searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBar;
    [searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pois count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ri" forIndexPath:indexPath];
    
    cell.textLabel.text = pois[indexPath.row].name;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADSPoi *poi = pois[indexPath.row];
    
    NSArray<NSNumber*> *places = poi.placesIds;
    if ([places count]>0)
    {
        // center view on selected place
        [_vc centerOnPlace:places[0]];
        
        // set name in searchbox
        [_mvc setSearchBarText:[poi name]];
        
        // close search view
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        // note: ceci ne peut plus arriver (les POI sans place ne sont pas proposés dans la recherche)
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not a place"
                                                        message:@"No place associated with this POI"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    currentSearchText = [[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    
    if ([currentSearchText length]==0)
        pois = [NSArray<ADSPoi*> arrayWithArray:poisFull];
    else
    {
        NSMutableArray *ma = [[NSMutableArray alloc] init];
        for (int i=0; i<[poisFull count]; i++)
        {
            ADSPoi *p = poisFull[i];
            if ([[p.name lowercaseString] rangeOfString:currentSearchText].location != NSNotFound)
            {
                NSArray<NSNumber*> *places = p.placesIds;
                if ([places count]>0)
                {
                    [ma addObject:p];
                }
            }
        }
        pois = ma;
    }
    
   
    
    
    [self.tableView reloadData];
}


@end
