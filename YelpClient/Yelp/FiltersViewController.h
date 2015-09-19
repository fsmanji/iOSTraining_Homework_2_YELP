//
//  FiltersViewController.h
//  Yelp
//
//  Created by Cristan Zhang on 9/18/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersViewController;
@protocol FiltersDelegate <NSObject>

- (void)filtersViewController:(FiltersViewController *)sender didChangeFilters:(NSDictionary *)filters;

@end

@interface FiltersViewController : UIViewController

@property (nonatomic, weak) id<FiltersDelegate> delegate;


@end
