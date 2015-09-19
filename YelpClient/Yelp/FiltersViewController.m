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

@property (nonatomic, readonly) NSDictionary *filters;
@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self styleNavigationBar];
    }
    return self;
}

#pragma private methods


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
    
    [_delegate filtersViewController:self didChangeFilters:_filters];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
