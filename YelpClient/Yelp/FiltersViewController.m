//
//  FiltersViewController.m
//  Yelp
//
//  Created by Cristan Zhang on 9/18/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "FiltersViewController.h"
#include "SwitchCell.h"

@interface FiltersViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, readonly) NSDictionary *filters;
@property NSArray* categories;
@property NSArray* sortByFilters;
@property NSArray* radiusFilters;
@property NSArray* sections;

@property NSMutableSet *selectedCategories;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectedCategories = [[NSMutableSet alloc] init];
        _sortByFilters = @[@"Best Match", @"Distance", @"Highest Rated"];
        _radiusFilters = @[@0.2, @1, @5, @10];
        
        _sections = @[@"Deals only",@"Sort", @"Distance", @"Category"];
        
        [self styleNavigationBar];
        [self loadDictionaryJsonFile];
        
    }
    return self;
}

#pragma private methods BEGIN


- (void)configTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    NSString *nibName = [SwitchCell description];
    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:nil]
         forCellReuseIdentifier:nibName];
}

- (void)styleNavigationBar {
    //color the navigation bar
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
    
    // add right button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(onSearchClicked:)];

    // all these methods cannot change titleview's color except for the private method setTitle.
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    [self setTitle:@"Filters"];
}

- (void)setTitle:(NSString *)title
{
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        //titleView.font = [UIFont boldSystemFontOfSize:20.0];
        //titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;

    }
    titleView.text = title;
    [titleView sizeToFit];
}


- (void)onSearchClicked:(id)sender {
    if(_selectedCategories.count > 0) {
        
        NSMutableArray * alias = [NSMutableArray array];
        for(NSDictionary * category in _selectedCategories) {
            [alias addObject:category[@"alias"]];
        }
        NSString *filterString = [alias componentsJoinedByString:@","];

        [_delegate filtersViewController:self didChangeFilters:filterString];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadDictionaryJsonFile {
    NSString *fileName = @"categories.json";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    //création d'un string avec le contenu du JSON
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];

    NSError *jsonError;
    _categories = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
}

#pragma private methods END


#pragma Tableview datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger ret = 1;
    switch (section) {
        case 0:
            ret = 0;
            break;
        case 1:
            ret = _sortByFilters.count;
            break;
        case 2:
            ret = _radiusFilters.count;
            break;
        case 3:
            ret = _categories.count;
            break;
        default:
            break;
    }
    
    return ret;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [headerView setBackgroundColor:[UIColor brownColor]];

    // Add a UILabel for the username here
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    nameLabel.text = _sections[section];
    [headerView addSubview:nameLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 3) {
    
        NSString *cellID = [SwitchCell description];
    
        SwitchCell *cell = (SwitchCell *)[_tableView dequeueReusableCellWithIdentifier:cellID];

        [self configureCell:cell atIndexPath:indexPath];
    
        return cell;
    } else {
         UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        
        cell.textLabel.text = @"xx";
        return cell;
    }
}

- (void)configureCell:(SwitchCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.delegate = self;
    cell.titleLabel.text = _categories[indexPath.row][@"title"];
    cell.toggleSwitch.on = [_selectedCategories containsObject:_categories[indexPath.row]];
}


#pragma tableview delegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)switchCell:(SwitchCell *)switchCell onValueChanged:(BOOL)value {
    NSIndexPath* indexPath = [_tableView indexPathForCell:switchCell];
    NSInteger row = indexPath.row;
    if(value) {
        [_selectedCategories addObject:self.categories[row]];
    }else {
        [_selectedCategories removeObject:self.categories[row]];
    }
}

@end
