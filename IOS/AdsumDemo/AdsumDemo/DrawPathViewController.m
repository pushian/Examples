//
//  DrawPathViewController.m
//  AdsumDemo
//
//  Created by Reynes Martial on 15/02/2016.
//  Copyright © 2016 adactive. All rights reserved.
//

#import "DrawPathViewController.h"

@interface DrawPathViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *sbFrom;
@property (weak, nonatomic) IBOutlet UISearchBar *sbTo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray<ADSPoi*> *poisFull;
@property NSArray<ADSPoi*> *pois;


@end

@implementation DrawPathViewController

NSString *currentSearchTextFrom;
NSString *currentSearchTextTo;
UISearchBar *sbCurrent;
ADSPoi *poiFrom, *poiTo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _poisFull = [_dataManager getAllADSPois];
    _pois = [NSArray<ADSPoi*> arrayWithArray:_poisFull];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    _sbFrom.delegate = self;
    _sbTo.delegate = self;
    
    [_sbFrom setBackgroundImage:[[UIImage alloc]init]]; // remove weird black border around searchbox
    [_sbTo setBackgroundImage:[[UIImage alloc]init]]; // remove weird black border around searchbox
    
    [_sbFrom becomeFirstResponder];
    
    // si un poi est sélectionné sur la map quand on ouvre "drawpath" : from doit etre préselectionné (c'est dans le cahier des charges)
    if (_vc.currentPoiId!=-1)
    {
        ADSPoi *poi = [_dataManager getADSPoiFromId:_vc.currentPoiId];
        poiFrom = poi;
        _sbFrom.text = [poi name];
    }
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
    return [_pois count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ri" forIndexPath:indexPath];
    
    cell.textLabel.text = _pois[indexPath.row].name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADSPoi *poi = _pois[indexPath.row];
    
    NSArray<NSNumber*> *places = poi.placesIds;
    if ([places count]>0)
    {
        if (sbCurrent==_sbFrom)
        {
            [_sbTo becomeFirstResponder];
            poiFrom = poi;
        }
        else
        {
            poiTo = poi;
            [_vc drawPathFrom:[poiFrom.uid longValue] to:[poiTo.uid longValue]];
            
            // close view
            [self.navigationController popViewControllerAnimated:YES];
        }
      
    }
    else
    {
        // mktodo: on doit gérer çà comment? ces items ne devraient pas ne pas etre visible comme resultat de la recherche ?
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not a place"
                                                        message:@"No place associated with this POI"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}



- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    sbCurrent = searchBar;
    currentSearchTextFrom = [[[searchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];

    [self refreshFilter];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    sbCurrent = searchBar;
    
    currentSearchTextFrom = [[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    
    [self refreshFilter];
}

-(void)refreshFilter
{
    if ([currentSearchTextFrom length]==0)
        _pois = [NSArray<ADSPoi*> arrayWithArray:_poisFull];
    else
    {
        NSMutableArray *ma = [[NSMutableArray alloc] init];
        for (int i=0; i<[_poisFull count]; i++)
        {
            ADSPoi *p = _poisFull[i];
            if ([[p.name lowercaseString] rangeOfString:currentSearchTextFrom].location != NSNotFound)
            {
                [ma addObject:p];
            }
        }
        _pois = ma;
    }

    [self.tableView reloadData];
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
