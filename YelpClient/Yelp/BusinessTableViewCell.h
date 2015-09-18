//
//  BusinessTableViewCell.h
//  Yelp
//
//  Created by Cristan Zhang on 9/17/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;




@end
