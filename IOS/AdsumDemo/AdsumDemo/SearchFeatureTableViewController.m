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


//UISearchController *searchController;
NSArray<ADSPoi*> *pois;
NSString *currentSearchText;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    /*
    searchController = [[UISearchController alloc] initWithSearchResultsController:self];
    // Use the current view controller to update the search results.
    searchController.searchResultsUpdater = self;
    // Install the search bar as the table header.
    self.navigationItem.titleView = searchController.searchBar;
    // It is usually good to set the presentation context.
    self.definesPresentationContext = YES;
    */
    
    currentSearchText = @"";
    
    pois = [_dataManager getAllADSPois];
    
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
//#warning Incomplete implementation, return the number of sections
    return 1;
}

int gg=3;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    if ([currentSearchText length]==0)
        return [pois count];
    
    int n=0;
    for (int i=0; i<[pois count]; i++)
    {
        ADSPoi *p = pois[i];
        if ([[p.name lowercaseString] rangeOfString:currentSearchText].location != NSNotFound) {
            n++;
        }
    }
    return n;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ri" forIndexPath:indexPath];
    
    if ([currentSearchText length]==0)
        cell.textLabel.text = pois[indexPath.row].name;
    else
    {
        int n=0;
        for (int i=0; i<[pois count]; i++)
        {
            ADSPoi *p = pois[i];
            if ([[p.name lowercaseString] rangeOfString:currentSearchText].location != NSNotFound)
            {
                if (n==indexPath.row)
                {
                    cell.textLabel.text = pois[i].name;
                    break;
                }
            
                n++;
            }
        }
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //NSLog(@"%@",searchText);
    
    currentSearchText = [[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    
    
    /*NSMutableArray *data = [[NSMutableArray alloc] init];
    
    
    for (ADSPoi *poi in pois)
    {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        [d setValue:poi.name forKey:@"DisplayText"];
        [d setValue:poi.className forKey:@"DisplaySubText"]; // optionnel
        [d setValue:poi forKey:@"CustomObject"];
        
        [data addObject:d];
    }
    
    return data;*/
    
    
    [self.tableView reloadData];
}

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
    //[self updateFilteredContentWithSearchText:[searchController.searchBar text]];
    gg=1;
    //update the table now that the model has been updated
    [self.tableView reloadData];
}*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
