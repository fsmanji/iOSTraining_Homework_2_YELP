//
//  SearchResultViewController.m
//  YelpClient
//
//  Created by Cristan Zhang on 9/17/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "SearchResultViewController.h"
#import "YelpAPI.h"
#import "BusinessTableViewCell.h"
#import "Business.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIAlertView+YELP.h"
#import "FiltersViewController.h"

@interface SearchResultViewController () <FiltersDelegate>

@property (nonatomic, strong) YelpAPI *client;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl* refreshControl;

@property NSMutableArray *searchResult;
@property NSString *lastSearchStr;

@end

@implementation SearchResultViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [YelpAPI defaultClient];
        self.searchResult = [NSMutableArray array];
        _lastSearchStr = @"Restaurants";
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self styleNavigationBar];
    
    [self configureTableView];
    
    [self onRefresh:nil];
}


- (void)openFilterPage: (id) sender {
    FiltersViewController* filtersPage = [[FiltersViewController alloc] init];
    filtersPage.delegate = self;
    [self.navigationController pushViewController:filtersPage animated:YES];
}

- (void)onRefresh:(id)sender {
    [_searchResult removeAllObjects];
    [self doSearch:_lastSearchStr withFilters:nil];
}

#pragma private methods

- (void)configureTableView {
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView setEstimatedRowHeight:96];
    [_tableView setRowHeight:UITableViewAutomaticDimension];
    
    //add a PTR control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    //
    UINib *nib = [UINib nibWithNibName:@"BusinessTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"BusinessTableViewCell"];
    
}

- (void)styleNavigationBar {
    //1. color the navigation bar: this uses
    UIColor * const navBarBgColor = [UIColor colorWithRed:89/255.0f green:174/255.0f blue:235/255.0f alpha:1.0f];
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    //ios 7+
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        self.navigationController.navigationBar.barTintColor = navBarBgColor;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }else{
        //ios 6 and older
        self.navigationController.navigationBar.tintColor = navBarBgColor;
    }
    
    
    //3. add left button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(openFilterPage:)];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    ;
    
    //2. add search bar
    CGRect rect=[[UIScreen mainScreen] bounds];
    int searchbarW = rect.size.width - 80;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, searchbarW, 40)];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    [_searchBar setPlaceholder:@"Restaurants"];
    _searchBar.delegate = self;
    
    
}


- (void)doSearch:(NSString *)term withFilters:(NSString *)filters{
    _lastSearchStr = term;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.client searchWithTerm:term andFilters:filters completionHandler:^(NSArray *businesses, NSError *error) {
       
        if(error != nil) {
            [UIAlertView showAlert:self with:@"Search Yelp Failed!" withMessage:error.description];
        }

        [_searchResult addObjectsFromArray:businesses];

        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void)filtersViewController:(FiltersViewController *)sender didChangeFilters:(NSString *)filters {
    [_searchResult removeAllObjects];
    
    [self doSearch:_lastSearchStr withFilters:filters];
}

#pragma Tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_searchResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"BusinessTableViewCell";
    
    BusinessTableViewCell *cell = (BusinessTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BusinessTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(BusinessTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    Business * business = _searchResult[row];
    cell.nameLabel.text = business.name;
    cell.reviewsLabel.text = business.reviews;
    cell.addrLabel.text = business.address;
    cell.categoryLabel.text = [[business.categories valueForKey:@"description"] componentsJoinedByString:@","];
    [cell.avatarView setImageWithURL:[NSURL URLWithString:business.photoUrl]];
    [cell.ratingImageView setImageWithURL:[NSURL URLWithString:business.ratingImgUrl]];
}


#pragma tableview delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma search delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchResult removeAllObjects];
    [self doSearch:_searchBar.text withFilters:nil];
    _searchBar.text = @"";
    //searchbar needs explicity call to resign first responder
    [_searchBar resignFirstResponder];
    [self.view endEditing:YES];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    //This will automatically update the table cells with new width after screen rotated.
    [_tableView reloadRowsAtIndexPaths:[_tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

@end
