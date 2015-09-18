//
//  BusinessUnit.m
//  Yelp
//
//  Created by Cristan Zhang on 9/17/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "Business.h"

@implementation Business

- (void) initWithDictionary:(NSDictionary *)dictionary {
    self.name = dictionary[@"name"];
    self.photoUrl = dictionary[@"image_url"];
    self.address = dictionary[@"location"][@"display_address"][0];
    self.rating = [dictionary[@"rating"] integerValue];
    self.ratingImgUrl = dictionary[@"rating_img_url"];
    self.distanceMeters = [dictionary[@"distance"] integerValue];
    
    self.reviews = [dictionary[@"review_count"] integerValue];
    NSMutableArray* list = [NSMutableArray array];
    NSArray* categories = dictionary[@"categories"];
    for (NSArray* category in categories) {
        [list addObject:category[0]];
    }
    _categories = [list mutableCopy];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name=%@\n\tlocation=%@\n\trating=%li\n\tcategories=%@\n\tdistance=%li", _name, _address, _rating, _categories, _distanceMeters/1000];
}
@end
