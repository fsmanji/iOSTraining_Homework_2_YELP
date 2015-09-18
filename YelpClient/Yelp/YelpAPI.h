//
//  YelpAPI.h
//  Yelp
//
//  Created by Cristan Zhang on 9/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"

@interface YelpAPI : BDBOAuth1RequestOperationManager

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret;

- (void)searchWithTerm:(NSString *)term completionHandler:(void(^)(NSArray *businesses, NSError *error))handler;


+(id) defaultClient;

@end
