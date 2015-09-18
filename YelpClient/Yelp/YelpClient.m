//
//  YelpClient.m
//  Yelp
//
//  Created by Cristan Zhang on 9/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//


#import "YelpClient.h"
#import "YelpCredentials.h"
#import "Business.h"

@implementation YelpClient

+(id) defaultClient {
    static YelpClient *defaultClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultClient = [[self alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
    });
    return defaultClient;
}

- (id)init {
    if (self = [super init]) {
        //intialize
    }
    return self;
}


- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}

- (void)searchWithTerm:(NSString *)term successCallback:(void(^)(NSArray *))successCallback {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSDictionary *parameters = @{@"term": term,
                                 @"location": @"San Francisco",
                                 @"cll": @"37.7833, 122.4167"};
    
    NSLog(@"Search with parameters: %@", parameters);

    NSMutableArray *list = [[NSMutableArray alloc] init];
    [self GET:@"search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSArray *results = responseObject[@"businesses"];
          if (results) {
              
              for (NSDictionary *result in results) {
                  Business *business = [[Business alloc] init];
                  [business initWithDictionary:result];
                  [list addObject:business];
                  NSLog(@"Business: %@", business);
              }
              successCallback(list);
              NSLog(@"JSON: %@", responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Failure while trying to fetch repos");
          successCallback(list);
      }];
}

@end
