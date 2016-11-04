//
//  FTPublicHistoryCourseTableViewCell.m
//  fighter
//
//  Created by 李懿哲 on 03/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTPublicHistoryCourseTableViewCell.h"

@implementation FTPublicHistoryCourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _orderCountLabel.textColor = [UIColor colorWithHex:0x22b33c];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setWithCourseHistoryBean:(FTCourseHistoryBean *)courseHistoryBean{
    _courseNameLabel.text = courseHistoryBean.name;
    _timeSectionLabel.text = courseHistoryBean.timeSection;
    
    
    _orderCountLabel.text = [NSString stringWithFormat:@"%ld/%ld", courseHistoryBean.hasOrderCount, courseHistoryBean.topLimit];//预约人数、人数上限
    if (courseHistoryBean.hasOrderCount >= courseHistoryBean.topLimit) {//如果满员，显示红色
        _orderCountLabel.textColor = [UIColor colorWithHex:0xbe1e1e];
    } else {//否则，显示绿色
        _orderCountLabel.textColor = [UIColor colorWithHex:0x24b33c];
    }
    
    
    
    //是否有未评分学员
    if (courseHistoryBean.hasGradeCount < courseHistoryBean.attendCount) {//已评分人数 < 签到人数，有未评分
//        _gradeInfoLabel.textColor = [UIColor colorWithHex:0xbe1e1e];
        _gradeInfoLabel.textColor = [UIColor redColor];
        _gradeInfoLabel.text = @"有未评分学员";
    } else if (courseHistoryBean.hasGradeCount == courseHistoryBean.attendCount){//已评分人数 = 签到人数，都已经评分
        _gradeInfoLabel.textColor = [UIColor colorWithHex:0x24b33c];
        _gradeInfoLabel.text = @"均已评分";
    }
    
}
@end
