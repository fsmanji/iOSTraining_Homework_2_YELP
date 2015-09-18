//
//  BusinessUnit.h
//  Yelp
//
//  Created by Cristan Zhang on 9/17/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property NSString *name;
@property NSString *address;
@property NSString *photoUrl;
@property NSString *ratingImgUrl;
@property NSInteger rating;
@property NSArray* categories;
@property NSInteger distanceMeters;
@property NSString* reviews;

- (void) initWithDictionary:(NSDictionary *)dictionary;

@end
