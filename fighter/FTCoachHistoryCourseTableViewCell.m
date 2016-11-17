//
//  FTCoachHistoryCourseTableViewCell.m
//  fighter
//
//  Created by 李懿哲 on 27/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCoachHistoryCourseTableViewCell.h"

@interface FTCoachHistoryCourseTableViewCell()
@property (strong, nonatomic) IBOutlet UIView *dividingLineView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *bottomDividingLine;

@end

@implementation FTCoachHistoryCourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _dividingLineView.backgroundColor = Cell_Space_Color;
    _bgView.backgroundColor = [UIColor colorWithHex:0x191919];
    _bottomDividingLine.backgroundColor = Cell_Space_Color;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithCourseHistoryBean:(FTHistoryCourseBean *)courseHistoryBean{
    _dateLabel.text = courseHistoryBean.dateString;
    _timeSectionLabel.text = courseHistoryBean.timeSection;
    _nameLabel.text = courseHistoryBean.createName;
    
    
    if (courseHistoryBean.attendCount == 0) {//旷课
        _gradeImageView.image = [UIImage imageNamed:@"学员状态-旷课"];
    } else if(courseHistoryBean.hasGradeCount < courseHistoryBean.attendCount){//未评分
        _gradeImageView.image = [UIImage imageNamed:@"学员状态-未评分"];
    }else if(courseHistoryBean.hasGradeCount == courseHistoryBean.attendCount){//已评分
        _gradeImageView.image = [UIImage imageNamed:@"学员状态-已评分"];
    }else if(courseHistoryBean.hasGradeCount > courseHistoryBean.attendCount){//已评分
        _gradeImageView.image = [UIImage imageNamed:@"学员状态-已评分"];
    }
    
}

@end
