//
//  FTTraineeSkillCell.m
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeSkillCell.h"

@implementation FTTraineeSkillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.skillLabelWidthConstraint.constant = self.skillLabelWidthConstraint.constant *SCALE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
