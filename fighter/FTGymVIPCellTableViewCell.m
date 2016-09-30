//
//  FTGymVIPCellTableViewCell.m
//  fighter
//
//  Created by kang on 2016/9/28.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymVIPCellTableViewCell.h"

@implementation FTGymVIPCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setBalanceLabelPosition];
}

-(void) setBalanceLabelPosition {

    if (SCALE < 1) {
        self.balanceTextLabel.text = @"余额：";
        self.yuanLabel.hidden = YES;
        
        self.courseDateLeadConstraint.constant = 10;
        self.orderDateLeadConstraint.constant = 10;
    }
}

@end
