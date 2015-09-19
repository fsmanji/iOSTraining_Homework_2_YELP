//
//  SwitchCell.m
//  Yelp
//
//  Created by Cristan Zhang on 9/18/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell ()

@property (nonatomic, weak) id<SwitchCellDelegate> delegate;
@end

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
}


- (IBAction)onSwitchToggled:(UISwitch *)sender {
    
    [_delegate switchCell:self onValueChanged:sender.on];
}

@end
