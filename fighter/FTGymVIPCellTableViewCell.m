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
    // Initialization codeself.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
