//
//  FTGymCommentTableViewCell.m
//  fighter
//
//  Created by kang on 16/9/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentTableViewCell.h"

@implementation FTGymCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // Initialization code
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.CollectionHeightConstraint.constant = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
