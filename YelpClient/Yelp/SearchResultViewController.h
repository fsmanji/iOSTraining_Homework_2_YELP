//
//  SearchResultViewController.h
//  YelpClient
//
//  Created by Cristan Zhang on 9/17/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltersViewController.h"

@interface SearchResultViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, FiltersDelegate>

@end
