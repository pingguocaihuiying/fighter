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
    self.bottomLine.backgroundColor = Cell_Space_Color;
    
    self.ratingBar.fullSelectedImage = [UIImage imageNamed:@"火苗-红"];
    self.ratingBar.unSelectedImage = [UIImage imageNamed:@"火苗-灰"];
    
    self.ratingBar.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
    [self.ratingBar displayRating:5.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (NSInteger) levelOfGrade:(NSInteger) grade {

    NSInteger level = 0;
    
    if (grade <20) {
        level = 0;
    }else if (level < 40) {
        level = 1;
    }else if (level < 60) {
        level = 2;
    }else if (level < 80) {
        level = 3;
    }else if (level < 100) {
        level = 4;
    }
    
    return level;
}




@end
