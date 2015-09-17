//
//  SearchResultViewController.m
//  YelpClient
//
//  Created by Cristan Zhang on 9/17/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "SearchResultViewController.h"
#import "YelpClient.h"

@interface SearchResultViewController ()
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchResultViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [YelpClient defaultClient];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self styleNavigationBar];
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
    
    
    //2. add search bar
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    //searchBar.backgroundImage = [[[UIImage alloc] init] autorelease];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    [_searchBar setPlaceholder:@"Restaurants"];
    _searchBar.delegate = self;
    
    //3. add left button
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(openFilterPage:)];
    self.navigationItem.leftBarButtonItem = item;
    //self.navigationItem.leftBarButtonItem.title = @"Filter";
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    
}

- (void)openFilterPage: (id) sender {
    
}

- (void)doSearch:(NSString *)term {
    [self.client searchWithTerm:term success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSLog(@"response: %@", response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@", [error description]);
    }];
}


#pragma Tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return nil;
}

#pragma tableview delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma search delegate
/*- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self doSearch:searchText];
    [self.view endEditing:YES];
}*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self doSearch:_searchBar.text];
    _searchBar.text = @"";
    //searchbar needs explicity call to resign first responder
    [_searchBar resignFirstResponder];
    [self.view endEditing:YES];
}


@end
