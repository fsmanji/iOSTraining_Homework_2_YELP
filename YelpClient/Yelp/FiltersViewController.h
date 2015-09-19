//
//  FiltersViewController.h
//  Yelp
//
//  Created by Cristan Zhang on 9/18/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchCell.h"

@class FiltersViewController;

@protocol FiltersDelegate <NSObject>

- (void)filtersViewController:(FiltersViewController *)sender didChangeFilters:(NSString *)filters;

@end

@interface FiltersViewController : UIViewController <UITableViewDataSource, SwitchCellDelegate>

@property (nonatomic, weak) id<FiltersDelegate> delegate;


@end
