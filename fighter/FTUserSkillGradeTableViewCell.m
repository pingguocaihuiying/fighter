//
//  FTUserSkillGradeTableViewCell.m
//  fighter
//
//  Created by 李懿哲 on 10/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTUserSkillGradeTableViewCell.h"
#import "FTUserSkillScore.h"

@implementation FTUserSkillGradeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _bottomLine.backgroundColor = Cell_Space_Color;
//    _bottomLine.backgroundColor = [UIColor redColor];
    _editableGradeLabel.textColor = Custom_Red;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithBean:(FTBaseBean *)bean{
    FTUserSkillScore *skillScoreBean = (FTUserSkillScore *)bean;
    _skillLabel.text = skillScoreBean.skill;
    _editableGradeLabel.text = [self getStrWithScoreIncrease:skillScoreBean.increase];//等级：差、一般、好、很好
    
    _gradeLabel.text = [NSString stringWithFormat:@"%.0f", skillScoreBean.score];//分数
    
}

- (NSString *)getStrWithScoreIncrease:(float)increase{
    NSString *result = @"";
    
    if (increase == 0) {
        result = @"一般";
    } else if (increase == -1) {
        result = @"差";
    }else if (increase == 1) {
        result = @"好";
    } else if (increase == 2) {
        result = @"很好";
    }
    
    return result;
}

@end
