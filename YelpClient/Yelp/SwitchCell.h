//
//  SwitchCell.h
//  Yelp
//
//  Created by Cristan Zhang on 9/18/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;
@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *)switchCell onValueChanged:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;

@property (nonatomic, weak) id<SwitchCellDelegate> delegate;
@end
