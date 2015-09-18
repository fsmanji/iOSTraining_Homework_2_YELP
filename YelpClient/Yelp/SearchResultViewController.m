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

@interface SearchResultViewController ()
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
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self styleNavigationBar];
    
    [self configureTableView];
}

- (void)configureTableView {
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView setEstimatedRowHeight:96];
    [_tableView setRowHeight:UITableViewAutomaticDimension];
    
    //add a PTR control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
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
    int searchbarW = rect.size.width - 60;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, searchbarW, 40)];
    //searchBar.backgroundImage = [[[UIImage alloc] init] autorelease];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    [_searchBar setPlaceholder:@"Restaurants"];
    _searchBar.delegate = self;
    
    
}

- (void)openFilterPage: (id) sender {
    
}

- (void)onRefresh:(id)sender {
    [_searchResult removeAllObjects];
    [self doSearch:_lastSearchStr];
}

- (void)doSearch:(NSString *)term {
    _lastSearchStr = term;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.client searchWithTerm:term completionHandler:^(NSArray *businesses, NSError *error) {
        if([businesses count] > 0) {
            [_searchResult addObjectsFromArray:businesses];
            [self.tableView reloadData];
        } else if(error != nil) {
            [UIAlertView showAlert:self with:@"Search Yelp Failed!" withMessage:error.description];
        }
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

#pragma tableview delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma search delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self doSearch:_searchBar.text];
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
