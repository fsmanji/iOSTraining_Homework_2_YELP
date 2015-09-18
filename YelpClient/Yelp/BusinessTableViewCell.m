//
//  BusinessTableViewCell.m
//  Yelp
//
//  Created by Cristan Zhang on 9/17/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "BusinessTableViewCell.h"

@implementation BusinessTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //below is lower level method for setting background of custom views
    //self.layer.backgroundColor = [[UIColor blueColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    
}

@end
